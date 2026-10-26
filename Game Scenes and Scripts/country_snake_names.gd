extends Node2D
# ═════════════════════════════════════════════════════════════════════════════
# SNAKE COUNTRY NAMES — GUI pass 2026-10-25
# Paradox/Civ-style country names that are driven by the map itself:
#   1. each country's tiles are split into connected territories (BFS over neighbours)
#   2. each territory gets a spine: a long, straight-ish route through its tile
#      centres (Dijkstra between its most extreme tiles), smoothed, then pulled
#      toward the middle of the land on either side, like a medial axis
#   3. the letters of the name are shared out over the territories in reading
#      order, in proportion to their size  (UNIT / ED ST / ATES)
#   4. letter size comes from the spine's length AND the land's width around it,
#      so a deep push makes huge letters and a pocket stays small
#   5. every letter is a node with a fixed identity ("USA#3" is always the I), so
#      when ownership changes it slides/rotates/grows to its new spot, and split
#      words fuse back together when their territories connect.
# world.gd owns one of these as "MapCountryLabels" and calls rebuild_from_world().
# ═════════════════════════════════════════════════════════════════════════════

## Custom font slot. Leave empty to use the project's default font.
## (Or call set_font(load("res://fonts/YourFont.ttf")) from world.gd.)
@export var name_font: Font = null
@export var font_color := Color(1.0, 1.0, 1.0, 0.95)
@export var outline_color := Color(0.0, 0.0, 0.0, 0.8)
## Optional per-country colours, e.g. {"USA": Color.WHITE, "UK": Color("#ffd9d9")}.
@export var country_colors: Dictionary = {}

# ── Layout tuning ────────────────────────────────────────────────────────────
const FILL := 0.86               # share of the spine the word stretches across
const THICK_K := 1.5             # font size per unit of land half-width around the spine
const MIN_FS := 18.0             # smallest letter (map units)
const MAX_FS := 560.0            # biggest letter (map units)
const MAX_TRACK := 1.2           # max extra spacing between letters, × font size
const MIN_PIECE_SHARE := 0.10    # a territory needs this share of the country's land to carry letters
const MIN_LETTERS_PER_PIECE := 2 # never strand a single letter in a pocket
const COAST_K := 1.9             # land reaches this × a tile's inner radius from its centre (coast cut-off)
const SAMPLE_STEP := 44.0        # spine resample spacing
const SCAN_STEP := 12.0          # step when measuring land width across the spine
const SCAN_MAX := 900.0
const GRID := 160.0              # spatial hash cell for nearest-tile lookups
const SPINE_RELAX := 10          # smoothing passes on the spine (more = straighter, calmer words)

# ── Animation tuning ─────────────────────────────────────────────────────────
const TWEEN_TIME := 1.25
const STAGGER := 0.04            # each letter leaves a beat after the one before → slither
const SLITHER := 0.10            # sideways bulge of a letter's path, × distance travelled

var _tiles: Dictionary = {}      # id -> {id, owner, c: Vector2, r: float, nb: Array}
var _grid: Dictionary = {}       # Vector2i cell -> Array of tile ids
var _letters: Dictionary = {}    # "CID#i" -> SnakeLetter
var _geomCache: Dictionary = {}  # tile instance id -> [centre, radius]
var _built := false
var debug_layout: Array = []     # one entry per word piece after each rebuild (probes/tests)


# ═════════════════════════════════════════════════════════════════════════════
# One letter. Draws a single glyph centred on its origin, so position/rotation/
# scale tweens are just Node2D transforms.
# ═════════════════════════════════════════════════════════════════════════════
class SnakeLetter extends Node2D:
	var ch: String = ""
	var font: Font = null
	var size_px: float = 32.0
	var fill := Color.WHITE
	var outline := Color.BLACK
	var tween: Tween = null

	func set_size_px(v: float) -> void:
		if absf(v - size_px) > 0.01:
			size_px = v
			queue_redraw()

	func _draw() -> void:
		if font == null or ch == "":
			return
		# Rasterise at a stepped size and scale the remainder: crisp at any size,
		# but the glyph cache only ever holds a handful of sizes while letters tween.
		var base := _quantize(size_px)
		var k := size_px / float(base)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(k, k))
		var w := font.get_char_size(ch.unicode_at(0), base).x
		var p := Vector2(-w * 0.5, font.get_ascent(base) * 0.36)   # capitals centred on the origin
		draw_char_outline(font, p, ch, base, maxi(2, int(base * 0.12)), outline)
		draw_char(font, p, ch, base, fill)

	static func _quantize(s: float) -> int:
		var e := roundi(log(maxf(s, 4.0)) / log(1.12))
		return maxi(4, int(round(pow(1.12, e))))


func _ready() -> void:
	z_index = 30


func _font() -> Font:
	if name_font != null:
		return name_font
	var th := ThemeDB.get_project_theme()
	if th != null and th.default_font != null:
		return th.default_font
	return ThemeDB.fallback_font


func set_font(f: Font) -> void:
	# Swap the typeface at runtime. Call rebuild_from_world() after so spacing re-measures.
	name_font = f
	for L in _letters.values():
		if is_instance_valid(L):
			L.font = _font()
			L.queue_redraw()


# ═════════════════════════════════════════════════════════════════════════════
# Entry points
# ═════════════════════════════════════════════════════════════════════════════
func rebuild_from_world(tile_controller: Node, country_controller: Node, display_names: Dictionary, animate: bool = true) -> void:
	var countries: Array = []
	for country in country_controller.get_children():
		var cid = country.get("CID")
		if cid == null or str(cid) == "":
			continue
		countries.append({"cid": str(cid), "name": str(display_names.get(str(cid), str(cid)))})
	rebuild_from(collect_tiles(tile_controller), countries, animate)


func collect_tiles(tile_controller: Node) -> Array:
	# Reads ownership fresh every call; tile geometry (centre + inner radius) is cached.
	var out: Array = []
	for t in tile_controller.get_children():
		if not (t is CanvasItem) or t.get("EXPTileNumber") == null:
			continue
		if t.get("oceanEXP") == true or t.get("ocean") == true:
			continue
		var key: int = t.get_instance_id()
		if not _geomCache.has(key):
			_geomCache[key] = _tile_geometry(t)
		var g: Array = _geomCache[key]
		var src = t.get("TileNeighbors")
		if src == null or (src as Array).is_empty():
			src = []
			var expl = t.get("TileNeighborsEXP")
			if expl != null:
				for p in expl:
					var n = t.get_node_or_null(p)
					if n != null:
						src.append(n)
		var nb: Array = []
		for n in src:
			if is_instance_valid(n) and n.get("EXPTileNumber") != null:
				nb.append(int(n.EXPTileNumber))
		out.append({"id": int(t.EXPTileNumber), "owner": str(t.get("tileOwner")), "c": g[0], "r": g[1], "nb": nb})
	return out


func _tile_geometry(t: CanvasItem) -> Array:
	# Same "most interior point" the tile-name labels use, mapped into this node's space.
	var xf: Transform2D = get_global_transform().affine_inverse() * t.get_global_transform()
	var anchor := Vector2.ZERO
	var r := 30.0
	if t.has_method("_tilePolygonLocal") and t.has_method("_labelAnchor"):
		var pts: PackedVector2Array = t._tilePolygonLocal()
		if pts.size() >= 3:
			anchor = t._labelAnchor(pts, t._tileVisualBBox())
			r = t._distToPolyEdge(pts, anchor)
	elif t.has_method("_tileVisualBBox"):
		var box: Rect2 = t._tileVisualBBox()
		anchor = box.get_center()
		r = minf(box.size.x, box.size.y) * 0.4
	return [xf * anchor, maxf(4.0, r * xf.get_scale().x)]


func ownership_signature(tile_controller: Node) -> String:
	# Cheap fingerprint of who owns what; world.gd polls this to know when to rebuild.
	var parts := PackedStringArray()
	for t in tile_controller.get_children():
		var o = t.get("tileOwner")
		parts.append("" if o == null else str(o))
	return "|".join(parts)


func rebuild_from(tiles: Array, countries: Array, animate: bool = true) -> void:
	# tiles: [{id, owner, c, r, nb}]   countries: [{cid, name}]
	_tiles.clear()
	_grid.clear()
	for t in tiles:
		_tiles[int(t.id)] = t
		var cell := Vector2i(floori(t.c.x / GRID), floori(t.c.y / GRID))
		if not _grid.has(cell):
			_grid[cell] = []
		_grid[cell].append(int(t.id))
	debug_layout.clear()
	var font := _font()
	var seen := {}
	for c in countries:
		var cid := str(c.cid)
		var places := _layout_country(cid, str(c.name).to_upper(), font)
		var col: Color = country_colors.get(cid, font_color)
		for i in places.size():
			var key := "%s#%d" % [cid, i]
			seen[key] = true
			var pl: Dictionary = places[i]
			var L: SnakeLetter = _letters.get(key)
			var fresh := false
			if L == null or not is_instance_valid(L):
				L = SnakeLetter.new()
				L.name = "L_%s_%d" % [cid, i]
				add_child(L)
				_letters[key] = L
				fresh = true
			L.ch = str(pl.ch)
			L.font = font
			L.fill = col
			L.outline = outline_color
			L.queue_redraw()
			if fresh and _built and animate:
				# A country that just appeared: letters fade in where they belong.
				L.position = pl.pos
				L.rotation = pl.rot
				L.set_size_px(pl.size)
				L.modulate.a = 0.0
			_move_letter(L, pl.pos, pl.rot, pl.size, 1.0, animate and _built, i * STAGGER)
	for key in _letters.keys():
		if not seen.has(key):
			var L: SnakeLetter = _letters[key]
			if is_instance_valid(L):
				_move_letter(L, L.position, L.rotation, L.size_px, 0.0, animate and _built, 0.0)
	_built = true


# ═════════════════════════════════════════════════════════════════════════════
# Layout
# ═════════════════════════════════════════════════════════════════════════════
func _layout_country(cid: String, name_str: String, font: Font) -> Array:
	var glyphs: Array = []
	var gapBefore: Array = []
	var pendingGap := false
	for i in name_str.length():
		var ch := name_str.substr(i, 1)
		if ch == " ":
			pendingGap = true
			continue
		gapBefore.append(pendingGap and not glyphs.is_empty())
		glyphs.append(ch)
		pendingGap = false
	if glyphs.is_empty():
		return []
	var own: Array = []
	for id in _tiles:
		if _tiles[id].owner == cid:
			own.append(id)
	if own.is_empty():
		return []

	var pieces: Array = []
	for comp in _components(own):
		pieces.append(_make_piece(comp))
	pieces.sort_custom(func(a, b): return a.weight > b.weight)
	var total := 0.0
	for p in pieces:
		total += p.weight
	var maxPieces := maxi(1, glyphs.size() / MIN_LETTERS_PER_PIECE)
	var kept: Array = [pieces[0]]
	for k in range(1, pieces.size()):
		if kept.size() >= maxPieces:
			break
		if pieces[k].weight >= total * MIN_PIECE_SHARE:
			kept.append(pieces[k])
	_sort_reading_order(kept)
	var counts := _allocate(glyphs.size(), kept)

	var out: Array = []
	var gi := 0
	for k in kept.size():
		var n: int = counts[k]
		if n <= 0:
			continue
		var sub: Array = glyphs.slice(gi, gi + n)
		var gaps: Array = gapBefore.slice(gi, gi + n)
		gaps[0] = false
		var placed := _place_on_spine(kept[k], sub, gaps, font)
		out.append_array(placed)
		debug_layout.append({
			"cid": cid, "text": "".join(PackedStringArray(sub)), "tiles": kept[k].ids.size(),
			"len": kept[k].length, "hw": kept[k].hw, "size": placed[0].size if not placed.is_empty() else 0.0,
			"spine": kept[k].spine,
		})
		gi += n
	return out


func _components(own: Array) -> Array:
	var inSet := {}
	for id in own:
		inSet[id] = true
	var seen := {}
	var comps: Array = []
	for id in own:
		if seen.has(id):
			continue
		var comp: Array = []
		var queue: Array = [id]
		seen[id] = true
		while not queue.is_empty():
			var cur = queue.pop_back()
			comp.append(cur)
			for n in _tiles[cur].nb:
				if inSet.has(n) and not seen.has(n):
					seen[n] = true
					queue.append(n)
		comps.append(comp)
	return comps


func _make_piece(comp: Array) -> Dictionary:
	var inSet := {}
	var weight := 0.0
	var centroid := Vector2.ZERO
	for id in comp:
		inSet[id] = true
		var t: Dictionary = _tiles[id]
		var w: float = t.r * t.r
		weight += w
		centroid += t.c * w
	centroid /= maxf(weight, 0.001)

	var pts := PackedVector2Array()
	var hw := 0.0
	if comp.size() == 1:
		var t: Dictionary = _tiles[comp[0]]
		pts.append(t.c - Vector2(t.r, 0.0))
		pts.append(t.c + Vector2(t.r, 0.0))
		hw = t.r
	else:
		var path := _diameter_path(comp, inSet)
		for id in path:
			pts.append(_tiles[id].c)
		# run the spine on into the end tiles instead of stopping at their centres
		var r0: float = _tiles[path[0]].r
		var r1: float = _tiles[path[path.size() - 1]].r
		pts.insert(0, pts[0] + (pts[0] - pts[1]).normalized() * r0 * 0.9)
		pts.append(pts[pts.size() - 1] + (pts[pts.size() - 1] - pts[pts.size() - 2]).normalized() * r1 * 0.9)
		pts = _chaikin(pts, 3)
		pts = _resample(pts, SAMPLE_STEP)
		var res := _recentre(pts, inSet)
		pts = _chaikin(_relax(res[0], SPINE_RELAX), 2)
		hw = res[1]
		if hw <= 0.0:
			for id in path:
				hw += _tiles[id].r
			hw /= float(path.size())

	# read left→right; a near-vertical spine reads top→bottom
	var d := pts[pts.size() - 1] - pts[0]
	if (absf(d.x) >= 0.3 * d.length() and d.x < 0.0) or (absf(d.x) < 0.3 * d.length() and d.y < 0.0):
		pts.reverse()
	return {"ids": comp, "weight": weight, "centroid": centroid, "spine": pts, "length": _poly_len(pts), "hw": hw}


func _diameter_path(comp: Array, inSet: Dictionary) -> Array:
	# Pick the spine's two ends. Pure tree diameter gives the longest route, but on an
	# L-shaped or hooked territory that route bends hard and the word reads badly. So we
	# take a handful of extreme tiles (the double-Dijkstra diameter ends plus the tiles
	# furthest out in 8 compass directions) and score every pair by
	#   straight-line span × straightness × a gentle preference for horizontal text,
	# then walk the shortest route between the winners.
	var first = _farthest(comp[0], inSet)
	var a = first[0]
	var cands: Array = [a, _farthest(a, inSet)[0]]
	for k in 8:
		var dir := Vector2.from_angle(TAU * k / 8.0)
		var best = comp[0]
		var bd := -INF
		for id in comp:
			var v: float = (_tiles[id].c as Vector2).dot(dir)
			if v > bd:
				bd = v
				best = id
		if not cands.has(best):
			cands.append(best)
	var runs := {}
	for c in cands:
		runs[c] = _dijkstra(c, inSet)
	var bestScore := -1.0
	var pa = cands[0]
	var pb = cands[1]
	for i in cands.size():
		for j in range(i + 1, cands.size()):
			var ca = cands[i]
			var cb = cands[j]
			var dist: Dictionary = runs[ca][0]
			if not dist.has(cb):
				continue
			var span: Vector2 = (_tiles[cb].c as Vector2) - (_tiles[ca].c as Vector2)
			var e := span.length()
			var g: float = maxf(dist[cb], e)
			if e <= 0.0:
				continue
			var horiz := absf(span.x) / e
			var score := e * sqrt(e / g) * (0.55 + 0.45 * horiz)
			if score > bestScore:
				bestScore = score
				pa = ca
				pb = cb
	var prev: Dictionary = runs[pa][1]
	var path: Array = [pb]
	while prev.has(path[path.size() - 1]):
		path.append(prev[path[path.size() - 1]])
	path.reverse()
	return path


func _farthest(src, inSet: Dictionary) -> Array:
	var r := _dijkstra(src, inSet)
	var dist: Dictionary = r[0]
	var far = src
	var fd := -1.0
	for k in dist:
		if dist[k] > fd:
			fd = dist[k]
			far = k
	return [far, r[1]]


func _dijkstra(src, inSet: Dictionary) -> Array:
	var dist := {src: 0.0}
	var prev := {}
	var open := {src: true}
	var done := {}
	while not open.is_empty():
		var cur = null
		var best := INF
		for k in open:
			if dist[k] < best:
				best = dist[k]
				cur = k
		open.erase(cur)
		done[cur] = true
		for n in _tiles[cur].nb:
			if not inSet.has(n) or done.has(n):
				continue
			var nd: float = dist[cur] + (_tiles[cur].c as Vector2).distance_to(_tiles[n].c)
			if not dist.has(n) or nd < dist[n]:
				dist[n] = nd
				prev[n] = cur
				open[n] = true
	return [dist, prev]


func _recentre(pts: PackedVector2Array, inSet: Dictionary) -> Array:
	# Slide each spine point to the middle of the land across it, and measure how wide
	# that land is. This is what makes the word sit down the belly of the territory.
	var out := PackedVector2Array()
	var widths: Array = []
	var n := pts.size()
	for i in n:
		var p := pts[i]
		var tan := (pts[mini(i + 1, n - 1)] - pts[maxi(i - 1, 0)]).normalized()
		if tan == Vector2.ZERO or not _is_land(p, inSet):
			out.append(p)
			continue
		var nrm := Vector2(-tan.y, tan.x)
		var a := _scan(p, nrm, inSet)
		var b := _scan(p, -nrm, inSet)
		out.append(p + nrm * (a - b) * 0.5)
		widths.append((a + b) * 0.5)
	# smooth the offsets so the spine doesn't wobble tile to tile
	var sm := PackedVector2Array(out)
	for _pass in 2:
		for i in range(1, n - 1):
			sm[i] = out[i] * 0.5 + (out[i - 1] + out[i + 1]) * 0.25
		out = PackedVector2Array(sm)
	var hw := 0.0
	if not widths.is_empty():
		# typical width along the middle of the spine (ends taper, so trim them)
		widths.sort()
		var lo := int(widths.size() * 0.25)
		var hi := maxi(lo + 1, int(widths.size() * 0.8))
		var s := 0.0
		for i in range(lo, mini(hi, widths.size())):
			s += widths[i]
		hw = s / float(mini(hi, widths.size()) - lo)
	return [out, hw]


func _scan(p: Vector2, dir: Vector2, inSet: Dictionary) -> float:
	var s := SCAN_STEP
	while s < SCAN_MAX and _is_land(p + dir * s, inSet):
		s += SCAN_STEP
	return s - SCAN_STEP * 0.5


func _is_land(q: Vector2, inSet: Dictionary) -> bool:
	# Approximate the territory as the tiles' Voronoi cells, cut off at the coast.
	var cell := Vector2i(floori(q.x / GRID), floori(q.y / GRID))
	var best := INF
	var bestId = null
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var bucket = _grid.get(cell + Vector2i(dx, dy))
			if bucket == null:
				continue
			for id in bucket:
				var d: float = q.distance_squared_to(_tiles[id].c)
				if d < best:
					best = d
					bestId = id
	if bestId == null or not inSet.has(bestId):
		return false
	return sqrt(best) < float(_tiles[bestId].r) * COAST_K


func _sort_reading_order(kept: Array) -> void:
	if kept.size() < 2:
		return
	# principal axis of the pieces' centres, pointed left→right (or top→bottom)
	var mean := Vector2.ZERO
	var wsum := 0.0
	for p in kept:
		mean += p.centroid * p.weight
		wsum += p.weight
	mean /= wsum
	var xx := 0.0
	var xy := 0.0
	var yy := 0.0
	for p in kept:
		var v: Vector2 = p.centroid - mean
		xx += v.x * v.x * p.weight
		xy += v.x * v.y * p.weight
		yy += v.y * v.y * p.weight
	var dir := Vector2.from_angle(0.5 * atan2(2.0 * xy, xx - yy))
	if absf(dir.x) >= 0.3:
		if dir.x < 0.0:
			dir = -dir
	elif dir.y < 0.0:
		dir = -dir
	kept.sort_custom(func(a, b): return (a.centroid as Vector2).dot(dir) < (b.centroid as Vector2).dot(dir))


func _allocate(n: int, kept: Array) -> Array:
	# Largest-remainder share of the letters, with a floor of MIN_LETTERS_PER_PIECE each.
	var k := kept.size()
	var counts: Array = []
	var floorEach := mini(MIN_LETTERS_PER_PIECE, n / k)
	var rest := n - floorEach * k
	var tw := 0.0
	for p in kept:
		tw += p.weight
	var rems: Array = []
	var given := 0
	for i in k:
		var q: float = rest * kept[i].weight / tw
		counts.append(floorEach + int(floor(q)))
		given += int(floor(q))
		rems.append([q - floor(q), i])
	rems.sort_custom(func(a, b): return a[0] > b[0])
	for j in rest - given:
		counts[rems[j % k][1]] += 1
	return counts


func _place_on_spine(piece: Dictionary, glyphs: Array, gaps: Array, font: Font) -> Array:
	var curve := Curve2D.new()
	curve.bake_interval = 6.0
	for p in piece.spine:
		curve.add_point(p)
	var L := curve.get_baked_length()
	var spaceW := maxf(font.get_char_size(" ".unicode_at(0), 100).x, 28.0)
	var widths: Array = []
	var sum100 := 0.0
	for i in glyphs.size():
		var w := font.get_char_size(str(glyphs[i]).unicode_at(0), 100).x
		widths.append(w)
		sum100 += w + (spaceW if gaps[i] else 0.0)
	var fsLen := 100.0 * L * FILL / maxf(sum100, 1.0)
	var fsThick: float = piece.hw * THICK_K
	var fs := clampf(minf(fsLen, fsThick), MIN_FS, MAX_FS)
	var k := fs / 100.0
	var n := glyphs.size()
	var textW := sum100 * k
	var track := 0.0
	if n > 1:
		track = clampf((L * FILL - textW) / float(n - 1), 0.0, fs * MAX_TRACK)
	var d := (L - (textW + track * (n - 1))) * 0.5
	var h := maxf(fs * 0.5, 8.0)
	var out: Array = []
	for i in n:
		if gaps[i]:
			d += spaceW * k
		var w: float = widths[i] * k
		var mid := d + w * 0.5
		var pos := _sample(curve, mid, L)
		var tan := _sample(curve, mid + h, L) - _sample(curve, mid - h, L)
		out.append({"ch": glyphs[i], "pos": pos, "rot": tan.angle() if tan.length() > 0.01 else 0.0, "size": fs})
		d += w + track
	return out


func _sample(curve: Curve2D, d: float, L: float) -> Vector2:
	# Curve2D clamps at its ends; extend straight out so overflowing words still line up.
	if d < 0.0:
		var a := curve.sample_baked(0.0, true)
		var b := curve.sample_baked(minf(8.0, L), true)
		return a + (a - b).normalized() * -d
	if d > L:
		var a := curve.sample_baked(L, true)
		var b := curve.sample_baked(maxf(L - 8.0, 0.0), true)
		return a + (a - b).normalized() * (d - L)
	return curve.sample_baked(d, true)


# ═════════════════════════════════════════════════════════════════════════════
# Animation
# ═════════════════════════════════════════════════════════════════════════════
func _move_letter(L: SnakeLetter, pos: Vector2, rot: float, size: float, alpha: float, animate: bool, delay: float) -> void:
	if L.tween != null and L.tween.is_valid():
		L.tween.kill()
	L.tween = null
	if not animate:
		L.position = pos
		L.rotation = rot
		L.set_size_px(size)
		L.modulate.a = alpha
		return
	var p0 := L.position
	var r0 := L.rotation
	var s0 := L.size_px
	var a0 := L.modulate.a
	if p0.distance_to(pos) < 0.5 and absf(angle_difference(r0, rot)) < 0.002 and absf(s0 - size) < 0.1 and absf(a0 - alpha) < 0.01:
		return
	# letters travel on a slight arc rather than a ruler line — reads as slithering
	var travel := pos - p0
	var bulge := Vector2(-travel.y, travel.x) * SLITHER * (1.0 if (L.get_index() % 2 == 0) else -1.0)
	var step := func(t: float) -> void:
		L.position = p0.lerp(pos, t) + bulge * sin(PI * t)
		L.rotation = lerp_angle(r0, rot, t)
		L.set_size_px(lerpf(s0, size, t))
		L.modulate.a = lerpf(a0, alpha, t)
	L.tween = L.create_tween()
	if delay > 0.0:
		L.tween.tween_interval(delay)
	L.tween.tween_method(step, 0.0, 1.0, TWEEN_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


# ═════════════════════════════════════════════════════════════════════════════
# Small geometry helpers
# ═════════════════════════════════════════════════════════════════════════════
func _chaikin(pts: PackedVector2Array, iters: int) -> PackedVector2Array:
	var cur := pts
	for _i in iters:
		if cur.size() < 3:
			return cur
		var nxt := PackedVector2Array()
		nxt.append(cur[0])
		for i in cur.size() - 1:
			var a := cur[i]
			var b := cur[i + 1]
			nxt.append(a.lerp(b, 0.25))
			nxt.append(a.lerp(b, 0.75))
		nxt.append(cur[cur.size() - 1])
		cur = nxt
	return cur


func _resample(pts: PackedVector2Array, step: float) -> PackedVector2Array:
	var total := _poly_len(pts)
	var n := maxi(2, int(ceil(total / step)) + 1)
	var out := PackedVector2Array()
	var seg := 0
	var segStart := 0.0
	for i in n:
		var target := total * float(i) / float(n - 1)
		while seg < pts.size() - 2 and segStart + pts[seg].distance_to(pts[seg + 1]) < target:
			segStart += pts[seg].distance_to(pts[seg + 1])
			seg += 1
		var sl := pts[seg].distance_to(pts[seg + 1])
		var t := 0.0 if sl <= 0.0 else clampf((target - segStart) / sl, 0.0, 1.0)
		out.append(pts[seg].lerp(pts[seg + 1], t))
	return out


func _relax(pts: PackedVector2Array, iters: int) -> PackedVector2Array:
	# Laplacian smoothing with pinned ends.
	var cur := PackedVector2Array(pts)
	for _i in iters:
		var nxt := PackedVector2Array(cur)
		for i in range(1, cur.size() - 1):
			nxt[i] = cur[i] * 0.5 + (cur[i - 1] + cur[i + 1]) * 0.25
		cur = nxt
	return cur


func _poly_len(pts: PackedVector2Array) -> float:
	var s := 0.0
	for i in pts.size() - 1:
		s += pts[i].distance_to(pts[i + 1])
	return s
