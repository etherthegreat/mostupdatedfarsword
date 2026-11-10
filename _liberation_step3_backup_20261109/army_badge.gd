extends Node2D
# ═════════════════════════════════════════════════════════════════════════════
# ARMY BADGE — GUI pass 2026-10-26
# The plaque under every army token, replacing the two loose bars + "104/104"
# numbers. Read left to right:
#
#   [▲ 140 | ● ○ » ◆]      STR = how hard this army can hit (all units, best weapon
#   [▬▬▬▬▬▬▬▬▬▬▬▬▬▬]         each, health and beliefs included). Same scale for
#                            everyone, so 140 vs 90 means what it looks like.
#   ▲ green / = gold / ▼ red  appears on ENEMY badges while you have an army
#                            selected: the real battle maths, run both ways.
#   pips                      one per unit: what that unit will do / is ready for.
#   bar                       manpower (cream) with the shield riding on top (blue).
#   border                    blue = COVERED (someone holds loaded or fortifies),
#                            red  = EXPOSED (nobody can answer a charge).
#
# army_path_follow.gd owns one of these. path_control.gd sets the verdict and
# collapses badges to compact chips when they'd overlap on screen.
# ═════════════════════════════════════════════════════════════════════════════

const H_FULL := 46.0
const H_COMPACT := 30.0
const FS_FULL := 26
const FS_COMPACT := 21
const PIP_STEP := 18.0
const PAD := 9.0

const BG := Color(0.06, 0.07, 0.12, 0.93)
const COVERED := Color(0.45, 0.70, 1.0)
const EXPOSED := Color(1.0, 0.62, 0.12)     # hazard orange — not red, red is the Crown
const NEUTRAL_EDGE := Color(0.85, 0.62, 0.18)
const MANPOWER := Color(0.93, 0.88, 0.74)
const SHIELD := Color(0.35, 0.62, 1.0)
const VERDICT_COLORS := [Color(1.0, 0.38, 0.35), Color(1.0, 0.82, 0.32), Color(0.45, 0.95, 0.45)]
const VERDICT_NONE := -1

# Unit states → pip art. Add new actions here (logistics, entrench …) and they show up.
#   shape: ball / ring / chevron / shield / wall / blade / cross   col: pip colour
const PIP_STYLES := {
	"loaded":   {"shape": "ball",    "col": Color(1.0, 0.82, 0.32), "tip": "Loaded — will fire"},
	"reload":   {"shape": "ring",    "col": Color(0.62, 0.66, 0.75), "tip": "Reloading"},
	"charge":   {"shape": "chevron", "col": Color(1.0, 0.42, 0.36), "tip": "Bayonet charge"},
	"hold":     {"shape": "shield",  "col": Color(0.45, 0.70, 1.0),  "tip": "Holding — fires first if attacked"},
	"hold_empty": {"shape": "shield_empty", "col": Color(0.45, 0.70, 1.0), "tip": "Holding, guns empty"},
	"fortify":  {"shape": "wall",    "col": Color(0.82, 0.62, 0.40), "tip": "Fortified — melee defence"},
	"blade":    {"shape": "blade",   "col": Color(0.85, 0.85, 0.90), "tip": "Blades — melee only"},
	"dead":     {"shape": "cross",   "col": Color(0.45, 0.45, 0.50), "tip": "Broken"},
}
const MAX_PIPS := 4

var strength := 0
var verdict := VERDICT_NONE
var pips: Array = []          # [{kind, spent}]
var hp := 1.0                 # manpower fraction
var shield := 0.0             # shield fraction (0 when the army has no shield)
var covered := false
var compact := false:
	set(v):
		if v != compact:
			compact = v
			queue_redraw()
var _sig := ""
var _font: Font


func _ready() -> void:
	var base := ThemeDB.fallback_font
	var th := ThemeDB.get_project_theme()
	if th != null and th.default_font != null:
		base = th.default_font
	var fv := FontVariation.new()
	fv.base_font = base
	fv.variation_embolden = 0.8
	_font = fv


# ── Data ─────────────────────────────────────────────────────────────────────
static func unit_state(u) -> String:
	if u == null or u.unitCurrentManpower <= 0:
		return "dead"
	var st: String = str(u.unitStance)
	match st:
		"hold":
			return "hold_empty" if u.is_reloading() else "hold"
		"charge", "flank":
			return "charge"
		"fortify":
			return "fortify"
	if u.unitWeapon != null and not u.unitWeapon.is_musket() and not u.unitWeapon.is_artillery() \
			and u.unitWeapon.has_method("is_saber") and u.unitWeapon.is_saber():
		return "blade"
	return "reload" if u.is_reloading() else "loaded"


static func army_strength(army) -> int:
	# Best hit each living unit can deliver (volley or bayonet), summed. Stance-free on
	# purpose, so the number is stable and comparable; the pips show readiness.
	var total := 0.0
	for u in army.unitsList:
		if u == null or u.unitCurrentManpower <= 0:
			continue
		var best: float = float(u.unitRangedOffence)
		if u.can_charge_melee():
			best = maxf(best, float(u.unitOffensiveScore) * 1.8)
		var best_r: float = float(u.unitRangedOffence) * army.ranged_mult()
		var best_m: float = float(u.unitOffensiveScore) * 1.8 * army.melee_mult() if u.can_charge_melee() else 0.0
		best = maxf(best_r, best_m)
		total += best * army._belief_atk_mult(u)
	return roundi(total)


func update_from(army) -> void:
	if army == null or not is_instance_valid(army):
		return
	var p: Array = []
	var cov: bool = army.is_covered()
	for u in army.unitsList:
		var k := unit_state(u)
		p.append({"kind": k, "spent": u != null and u.unitCurrentAP <= 0})
	var mp: float = float(army.manpowerInArmy) / maxf(1.0, float(army.maxManpower))
	var sh: float = float(army.armyShield) / float(army.armyMaxShield) if army.armyMaxShield > 0 else 0.0
	var s := army_strength(army)
	var sig := "%d|%s|%.3f|%.3f|%s" % [s, str(p), mp, sh, cov]
	if sig == _sig:
		return
	_sig = sig
	strength = s
	pips = p
	hp = clampf(mp, 0.0, 1.0)
	shield = clampf(sh, 0.0, 1.0)
	covered = cov
	queue_redraw()


func set_verdict(v: int) -> void:
	if v != verdict:
		verdict = v
		queue_redraw()


func _str_w(fs: int) -> float:
	if _font == null:
		return fs * 2.0
	return _font.get_string_size(str(strength), HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x


func _glyph_w() -> float:
	return 15.0 if verdict >= 0 else 0.0


func rect_local() -> Rect2:
	# Width follows the content, so big numbers never run into the pips.
	var w: float
	var h: float
	if compact:
		h = H_COMPACT
		w = PAD * 2.0 + _glyph_w() + _str_w(FS_COMPACT) + 8.0
	else:
		h = H_FULL
		var np := mini(pips.size(), MAX_PIPS)
		w = PAD * 2.0 + 10.0 + _glyph_w() + _str_w(FS_FULL) + 10.0 + np * PIP_STEP + (16.0 if pips.size() > MAX_PIPS else 0.0)
	return Rect2(-w * 0.5, 0, w, h)


func tooltip_text() -> String:
	var lines := PackedStringArray(["STR %d — best hit of every unit combined" % strength])
	lines.append("COVERED — someone answers a charge" if covered else "EXPOSED — nobody can answer a charge")
	for i in pips.size():
		var st: Dictionary = PIP_STYLES.get(pips[i].kind, {})
		lines.append("Unit %d: %s%s" % [i + 1, str(st.get("tip", pips[i].kind)), "  (no actions left)" if pips[i].spent else ""])
	return "\n".join(lines)


# ── Draw ─────────────────────────────────────────────────────────────────────
func _draw() -> void:
	if _font == null:
		return
	var r := rect_local()
	var edge: Color = COVERED if covered else EXPOSED
	var sb := StyleBoxFlat.new()
	sb.bg_color = BG
	sb.set_corner_radius_all(8)
	sb.set_border_width_all(3)
	sb.border_color = edge
	sb.shadow_color = Color(0, 0, 0, 0.45)
	sb.shadow_size = 3
	draw_style_box(sb, r)

	var vcol: Color = VERDICT_COLORS[verdict] if verdict >= 0 else Color.WHITE
	var fs := FS_COMPACT if compact else FS_FULL
	var txt := str(strength)
	var midY := r.size.y * (0.5 if compact else 0.42)
	var x := r.position.x + PAD + (0.0 if compact else 10.0)
	if verdict >= 0:
		_draw_verdict_glyph(Vector2(x + 6, midY), verdict, vcol)
		x += _glyph_w()
	_text(Vector2(x, midY + fs * 0.36), txt, fs, vcol)
	x += _str_w(fs) + 10.0
	if compact:
		_bar(Rect2(r.position.x + 6, r.end.y - 7, r.size.x - 12, 3))
		return
	# covered / exposed emblem riding the left edge (shape, not just colour)
	_draw_emblem(Vector2(r.position.x + 2, midY), covered, edge)
	# pips, left to right in unit order
	for i in mini(pips.size(), MAX_PIPS):
		_draw_pip(Vector2(x + 6, midY), pips[i])
		x += PIP_STEP
	if pips.size() > MAX_PIPS:
		_text(Vector2(x - 2, midY + 5), "+%d" % (pips.size() - MAX_PIPS), 14, Color(1, 1, 1, 0.85))
	# bottom: manpower + shield
	_bar(Rect2(r.position.x + 8, r.end.y - 11, r.size.x - 16, 6))


func _draw_emblem(c: Vector2, is_covered: bool, col: Color) -> void:
	var pts := PackedVector2Array([c + Vector2(-8, -9), c + Vector2(8, -9), c + Vector2(8, 1), c + Vector2(0, 10), c + Vector2(-8, 1)])
	draw_colored_polygon(pts, Color(0.05, 0.06, 0.1))
	if is_covered:
		var inner := PackedVector2Array()
		for p in pts:
			inner.append(c + (p - c) * 0.72)
		draw_colored_polygon(inner, col)
	else:
		# broken shield: outline with a crack through it
		var ring := pts.duplicate()
		ring.append(pts[0])
		draw_polyline(ring, col, 2.0, true)
		draw_polyline(PackedVector2Array([c + Vector2(-1, -9), c + Vector2(2, -3), c + Vector2(-2, 1), c + Vector2(1, 7)]), col, 2.0, true)


func _text(pos: Vector2, s: String, fs: int, col: Color) -> void:
	draw_string_outline(_font, pos, s, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 4, Color(0, 0, 0, 0.9))
	draw_string(_font, pos, s, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)


func _bar(b: Rect2) -> void:
	draw_rect(b, Color(0, 0, 0, 0.7))
	var mcol: Color = MANPOWER if hp > 0.34 else MANPOWER.lerp(EXPOSED, 0.6)   # reddens when nearly broken
	draw_rect(Rect2(b.position, Vector2(b.size.x * hp, b.size.y)), mcol)
	if shield > 0.0:
		var sh := Rect2(b.position, Vector2(b.size.x * shield, maxf(2.0, b.size.y * 0.45)))
		draw_rect(sh, SHIELD)


func _draw_verdict_glyph(c: Vector2, v: int, col: Color) -> void:
	# shape as well as colour, so it reads without colour vision
	match v:
		2:
			draw_colored_polygon(PackedVector2Array([c + Vector2(-5, 4), c + Vector2(5, 4), c + Vector2(0, -5)]), col)
		0:
			draw_colored_polygon(PackedVector2Array([c + Vector2(-5, -4), c + Vector2(5, -4), c + Vector2(0, 5)]), col)
		_:
			draw_rect(Rect2(c + Vector2(-5, -4), Vector2(10, 2.5)), col)
			draw_rect(Rect2(c + Vector2(-5, 1.5), Vector2(10, 2.5)), col)


func _draw_pip(c: Vector2, pip: Dictionary) -> void:
	draw_pip_on(self, c, pip)


# Static so the army card can draw the very same pips in its own rows.
static func draw_pip_on(ci: CanvasItem, c: Vector2, pip: Dictionary) -> void:
	var st: Dictionary = PIP_STYLES.get(pip.kind, {"shape": "ball", "col": Color.WHITE})
	var col: Color = st.col
	if pip.get("spent", false):
		col = col.darkened(0.45)
	match str(st.shape):
		"ball":
			ci.draw_circle(c, 6.0, col)
			ci.draw_circle(c + Vector2(-1.5, -1.5), 1.6, Color(1, 1, 1, 0.55))
		"ring":
			ci.draw_arc(c, 5.0, 0, TAU, 18, col, 2.4, true)
		"chevron":
			ci.draw_polyline(PackedVector2Array([c + Vector2(-5, -4), c + Vector2(-1, 0), c + Vector2(-5, 4)]), col, 2.2, true)
			ci.draw_polyline(PackedVector2Array([c + Vector2(0, -4), c + Vector2(4, 0), c + Vector2(0, 4)]), col, 2.2, true)
		"shield", "shield_empty":
			var pts := PackedVector2Array([c + Vector2(-5, -5), c + Vector2(5, -5), c + Vector2(5, 0), c + Vector2(0, 6), c + Vector2(-5, 0)])
			if st.shape == "shield":
				ci.draw_colored_polygon(pts, col)
				ci.draw_circle(c + Vector2(0, -1), 1.8, Color(1, 0.85, 0.35))
			else:
				pts.append(pts[0])
				ci.draw_polyline(pts, col, 1.6, true)
		"wall":
			ci.draw_rect(Rect2(c + Vector2(-5, -4), Vector2(10, 3.5)), col)
			ci.draw_rect(Rect2(c + Vector2(-5, 0.5), Vector2(4.5, 3.5)), col)
			ci.draw_rect(Rect2(c + Vector2(0.5, 0.5), Vector2(4.5, 3.5)), col)
		"blade":
			ci.draw_line(c + Vector2(-4, 4), c + Vector2(4, -4), col, 2.0, true)
			ci.draw_line(c + Vector2(-3, 1), c + Vector2(-1, 3), col, 2.0, true)
		"cross":
			ci.draw_line(c + Vector2(-4, -4), c + Vector2(4, 4), col, 2.0, true)
			ci.draw_line(c + Vector2(-4, 4), c + Vector2(4, -4), col, 2.0, true)
