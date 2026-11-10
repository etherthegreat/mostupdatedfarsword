extends CanvasLayer
# ═════════════════════════════════════════════════════════════════════════════
# SCORE SCREEN — GUI pass 2026-10-26
# The arcade end-of-run card: outcome, your nation's name as the map left it
# (broken pieces and all), how much of it you rebuilt, a points tally, a stamped
# letter grade, your best run, and PLAY AGAIN.
# Built entirely in code. world.gd creates one in _show_run_score() and passes the
# report from run_score.gd. Click or press any key to skip the count-up.
# ═════════════════════════════════════════════════════════════════════════════

signal play_again
signal main_menu

const RS := preload("res://Game Scenes and Scripts/run_score.gd")

const BG := Color(0.07, 0.09, 0.16, 0.97)
const BORDER := Color(0.85, 0.62, 0.18, 1.0)
const GOLD := Color(1.0, 0.82, 0.32)
const DIM := Color(0.72, 0.80, 0.95)
const PALE := Color(0.60, 0.66, 0.78)
const GOOD := Color(0.55, 0.92, 0.55)
const BAD := Color(1.0, 0.45, 0.42)
const CRACK := Color(0.85, 0.22, 0.22)
const GRADE_COLORS := {
	"S": Color(1.0, 0.93, 0.62), "A": Color(1.0, 0.80, 0.30), "B": Color(0.70, 0.82, 1.0),
	"C": Color(0.86, 0.62, 0.40), "D": Color(0.85, 0.45, 0.38), "F": Color(0.92, 0.25, 0.25),
}
# Headline per ending. Falls back to VICTORY / DEFEAT.
const HEADLINES := {
	"stalemate": "DEMILITARIZED ZONES", "endlessBattle": "EVERY STATE A BATTLEFIELD",
	"britishWhiteHouse": "A PREDATOR IN THE WHITE HOUSE", "DCdown": "DC DOWN",
	"funeral": "DEATH OF THE PRESIDENT",
}
const NAMES := {"USA": "United States", "CA": "Canada"}

var report: Dictionary = {}
var records: Dictionary = {}
var _tweens: Array = []
var _animating := false
var _font: Font
var _bold: FontVariation
var _root: Control
var _panel: PanelContainer
var _strip: NameStrip
var _meter: NameMeter
var _stamp: GradeStamp
var _pctLabel: Label
var _totalLabel: Label
var _rowNodes: Array = []
var _bestLabel: Label
var _newBest: Label
var _tipLabel: Label
var _buttons: HBoxContainer
var _playBtn: Button


# ═════════════════════════════════════════════════════════════════════════════
# The broken name. pieces = [{text, main}] in reading order; letters reveal one by
# one; the biggest territory's piece burns gold, the rest sit crooked and pale
# with a crack between them.
# ═════════════════════════════════════════════════════════════════════════════
class NameStrip extends Control:
	var pieces: Array = []
	var font: Font
	var reveal := 0.0:
		set(v):
			reveal = v
			queue_redraw()
	var glow := 0.0:
		set(v):
			glow = v
			queue_redraw()

	func letter_count() -> int:
		var n := 0
		for p in pieces:
			n += str(p.text).replace(" ", "").length()
		return n

	func _draw() -> void:
		if font == null or pieces.is_empty():
			return
		var gapCh := 1.5
		var units := 0.0
		for p in pieces:
			units += str(p.text).length()
		units += gapCh * (pieces.size() - 1)
		var fs := clampi(int(size.x / maxf(1.0, units) * 1.45), 24, 132)
		var adv := func(ch: String) -> float: return font.get_char_size(ch.unicode_at(0), fs).x
		var widths: Array = []
		var total := 0.0
		for p in pieces:
			var w := 0.0
			for ch in str(p.text):
				w += adv.call(ch) * 1.06
			widths.append(w)
			total += w
		var gapPx: float = adv.call("M") * gapCh
		total += gapPx * (pieces.size() - 1)
		var x := (size.x - total) * 0.5
		var base := size.y * 0.5 + fs * 0.34
		var li := 0
		var broken := pieces.size() > 1
		for k in pieces.size():
			var p: Dictionary = pieces[k]
			var main: bool = p.get("main", false)
			# border-gore jitter: deterministic per piece so it doesn't swim
			var rot := 0.0 if not broken else (0.035 if k % 2 == 0 else -0.05) * (0.4 if main else 1.0)
			var dy := 0.0 if not broken else (-9.0 if k % 2 == 0 else 11.0) * (0.3 if main else 1.0)
			var col: Color = GOLD if main else PALE
			var pivot := Vector2(x + float(widths[k]) * 0.5, base + dy)
			var cx: float = -float(widths[k]) * 0.5
			for ch in str(p.text):
				var w: float = adv.call(ch) * 1.06
				if ch != " ":
					var a := clampf(reveal - li, 0.0, 1.0)
					if a > 0.0:
						var s := lerpf(1.7, 1.0, ease(a, 0.4))
						var lp := Vector2(cx + w * 0.5, 0.0)
						draw_set_transform(pivot + lp.rotated(rot), rot, Vector2(s, s))
						var o := Vector2(-w * 0.5 / 1.06, 0.0)
						if main and glow > 0.0:
							draw_char_outline(font, o, ch, fs, int(fs * 0.22), Color(GOLD, 0.25 * glow * a))
						draw_char_outline(font, o, ch, fs, maxi(3, int(fs * 0.09)), Color(0, 0, 0, 0.85 * a))
						draw_char(font, o, ch, fs, Color(col, a))
					li += 1
				cx += w
			x += widths[k]
			if k < pieces.size() - 1:
				_draw_crack(Vector2(x + gapPx * 0.5, size.y * 0.5), fs, clampf(reveal - li + 0.5, 0.0, 1.0))
				x += gapPx
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

	func _draw_crack(c: Vector2, fs: int, a: float) -> void:
		if a <= 0.0:
			return
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		var h := fs * 0.62
		var pts := PackedVector2Array()
		var zig := [0.0, 0.35, -0.30, 0.40, -0.25, 0.30, 0.0]
		for i in zig.size():
			var t := float(i) / (zig.size() - 1)
			pts.append(c + Vector2(zig[i] * fs * 0.22, lerpf(-h, h, t) * a))
		draw_polyline(pts, Color(0, 0, 0, 0.6 * a), 7.0)
		draw_polyline(pts, Color(CRACK, a), 3.0)


# ═════════════════════════════════════════════════════════════════════════════
# NAME REBUILT meter: fill = now, with START and PEAK notches.
# ═════════════════════════════════════════════════════════════════════════════
class NameMeter extends Control:
	var font: Font
	var start_pct := 0.0
	var peak_pct := 0.0
	var final_pct := 0.0
	var fill := 0.0:
		set(v):
			fill = v
			queue_redraw()

	func _draw() -> void:
		var bar := Rect2(0, 6, size.x, size.y - 30)
		_round(bar, Color(0.02, 0.03, 0.06, 0.9))
		if fill > 0.001:
			var f := Rect2(bar.position, Vector2(bar.size.x * fill, bar.size.y))
			_round(f, GOLD.darkened(0.15))
			_round(Rect2(f.position, Vector2(f.size.x, f.size.y * 0.42)), Color(1, 1, 1, 0.16))
		draw_rect(bar, Color(BORDER, 0.8), false, 2.0)
		_notch(bar, start_pct, "START %d%%" % roundi(start_pct * 100), DIM)
		if peak_pct > final_pct + 0.015:
			_notch(bar, peak_pct, "PEAK %d%%" % roundi(peak_pct * 100), GOOD)

	func _notch(bar: Rect2, p: float, txt: String, col: Color) -> void:
		var x := bar.position.x + bar.size.x * clampf(p, 0.0, 1.0)
		draw_line(Vector2(x, bar.position.y - 4), Vector2(x, bar.end.y + 4), col, 3.0)
		if font != null:
			var w := font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x
			var tx := clampf(x - w * 0.5, 0.0, size.x - w)
			draw_string(font, Vector2(tx, bar.end.y + 21), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 15, col)

	func _round(r: Rect2, c: Color) -> void:
		var sb := StyleBoxFlat.new()
		sb.bg_color = c
		sb.set_corner_radius_all(int(minf(6.0, r.size.x * 0.5)))
		draw_style_box(sb, r)


# ═════════════════════════════════════════════════════════════════════════════
# The grade, stamped like a seal.
# ═════════════════════════════════════════════════════════════════════════════
class GradeStamp extends Control:
	var font: Font
	var letter := "F"
	var col := Color.WHITE

	func _draw() -> void:
		var c := size * 0.5
		var r := minf(size.x, size.y) * 0.46
		draw_circle(c, r, Color(0.03, 0.04, 0.08, 0.95))
		draw_arc(c, r, 0, TAU, 72, col, 6.0, true)
		draw_arc(c, r * 0.86, 0, TAU, 72, Color(col, 0.45), 2.0, true)
		# little stars around the ring
		for i in 13:
			var a := -PI * 0.5 + TAU * i / 13.0
			draw_circle(c + Vector2.from_angle(a) * r * 0.93, 2.5, Color(col, 0.7))
		if font != null:
			var fs := int(r * 1.35)
			var w := font.get_string_size(letter, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			var p := Vector2(c.x - w * 0.5, c.y + fs * 0.36)
			draw_string_outline(font, p, letter, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 10, Color(0, 0, 0, 0.9))
			draw_string(font, p, letter, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)


# ═════════════════════════════════════════════════════════════════════════════
func _init() -> void:
	layer = 60
	process_mode = Node.PROCESS_MODE_ALWAYS


func show_report(rep: Dictionary, recs: Dictionary = {}) -> void:
	report = rep
	records = recs
	_font = _base_font()
	_bold = FontVariation.new()
	_bold.base_font = _font
	_bold.variation_embolden = 0.9
	_build()
	_animate()


func _base_font() -> Font:
	var th := ThemeDB.get_project_theme()
	if th != null and th.default_font != null:
		return th.default_font
	return ThemeDB.fallback_font


# ── Build ────────────────────────────────────────────────────────────────────
func _build() -> void:
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.gui_input.connect(_on_root_input)
	add_child(_root)
	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.03, 0.07, 0.80)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dim.name = "Dim"
	_root.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(center)
	_panel = PanelContainer.new()
	_panel.custom_minimum_size = Vector2(1240, 0)
	var sb := StyleBoxFlat.new()
	sb.bg_color = BG
	sb.border_color = BORDER
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(12)
	sb.shadow_color = Color(0, 0, 0, 0.6)
	sb.shadow_size = 24
	sb.content_margin_left = 44
	sb.content_margin_right = 44
	sb.content_margin_top = 30
	sb.content_margin_bottom = 30
	_panel.add_theme_stylebox_override("panel", sb)
	_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	center.add_child(_panel)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	_panel.add_child(v)

	# header line
	var head := HBoxContainer.new()
	v.add_child(head)
	var bits := PackedStringArray(["RUN COMPLETE", "TURN %d" % int(report.get("turn", 100))])
	if str(report.get("date", "")) != "":
		bits.append(str(report.date).to_upper())
	head.add_child(_label("  ·  ".join(bits), 17, DIM, true))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(sp)
	if records.has("runs"):
		head.add_child(_label("RUN #%d" % int(records.runs), 17, DIM, true))

	# outcome
	var won: bool = report.get("won", false)
	var headline: String = "VICTORY" if won else str(HEADLINES.get(str(report.get("end_type", "")), "DEFEAT"))
	var t := _label(headline, 50, GOLD if won else BAD, true)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(t)
	if str(report.get("reason", "")) != "":
		var r := _label(str(report.reason), 21, DIM)
		r.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(r)

	# the name, as the map left it
	_strip = NameStrip.new()
	_strip.font = _bold
	_strip.pieces = _strip_pieces()
	_strip.custom_minimum_size = Vector2(0, 150)
	v.add_child(_strip)

	# meter
	var mrow := HBoxContainer.new()
	mrow.add_theme_constant_override("separation", 22)
	v.add_child(mrow)
	var mcol := VBoxContainer.new()
	mcol.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mcol.add_theme_constant_override("separation", 2)
	mrow.add_child(mcol)
	var now: Dictionary = report.get("now", {})
	# pieces that carry letters (what the map shows) vs pockets too small to carry any
	var shownN: int = _strip.pieces.size()
	var stranded: int = maxi(0, int(now.get("pieces", 1)) - shownN)
	var sub := "NAME REBUILT"
	if shownN > 1:
		sub += "   ·   BROKEN IN %d" % shownN
	if stranded > 0:
		sub += "   ·   %d STRANDED POCKET%s" % [stranded, "" if stranded == 1 else "S"]
	mcol.add_child(_label(sub, 19, GOLD, true))
	_meter = NameMeter.new()
	_meter.font = _font
	_meter.custom_minimum_size = Vector2(0, 58)
	_meter.start_pct = float(report.get("start", {}).get("name_pct", 0.0))
	_meter.peak_pct = float(report.get("peak_pct", 0.0))
	_meter.final_pct = float(now.get("name_pct", 0.0))
	mcol.add_child(_meter)
	_pctLabel = _label("0%", 64, GOLD, true)
	_pctLabel.custom_minimum_size = Vector2(190, 0)
	_pctLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	mrow.add_child(_pctLabel)

	v.add_child(_rule())

	# tally + stamp
	var body := HBoxContainer.new()
	body.add_theme_constant_override("separation", 40)
	v.add_child(body)
	var rows := VBoxContainer.new()
	rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rows.add_theme_constant_override("separation", 8)
	body.add_child(rows)
	for row in report.get("rows", []):
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 16)
		var l := _label(str(row.label), 21, GOLD, true)
		l.custom_minimum_size = Vector2(210, 0)
		h.add_child(l)
		var d := _label(str(row.detail), 18, DIM)
		d.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		d.clip_text = true
		h.add_child(d)
		var p := _label("0 / %d" % int(row.max), 22, Color.WHITE, true)
		p.custom_minimum_size = Vector2(110, 0)
		p.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		h.add_child(p)
		h.modulate.a = 0.0
		rows.add_child(h)
		_rowNodes.append({"node": h, "pts": p, "row": row})
	rows.add_child(_rule())
	var tot := HBoxContainer.new()
	tot.add_child(_label("SCORE", 26, GOLD, true))
	var sp2 := Control.new()
	sp2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tot.add_child(sp2)
	_totalLabel = _label("0", 44, Color.WHITE, true)
	tot.add_child(_totalLabel)
	rows.add_child(tot)

	var scol := VBoxContainer.new()
	scol.add_theme_constant_override("separation", 4)
	body.add_child(scol)
	_stamp = GradeStamp.new()
	_stamp.font = _bold
	_stamp.letter = str(report.get("grade", "F"))
	_stamp.col = GRADE_COLORS.get(_stamp.letter, Color.WHITE)
	_stamp.custom_minimum_size = Vector2(250, 250)
	_stamp.pivot_offset = Vector2(125, 125)
	_stamp.modulate.a = 0.0
	scol.add_child(_stamp)
	var gt := _label(str(report.get("title", "")).to_upper(), 20, _stamp.col, true)
	gt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	gt.custom_minimum_size = Vector2(250, 0)
	gt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	gt.name = "GradeTitle"
	gt.modulate.a = 0.0
	scol.add_child(gt)

	v.add_child(_rule())

	# records + tip
	var foot := HBoxContainer.new()
	foot.add_theme_constant_override("separation", 18)
	v.add_child(foot)
	_bestLabel = _label(_best_text(), 18, DIM, true)
	foot.add_child(_bestLabel)
	_newBest = _label("NEW BEST!", 20, GOOD, true)
	_newBest.visible = false
	foot.add_child(_newBest)
	_tipLabel = _label(str(report.get("tip", "")), 19, Color(1, 1, 1, 0.92))
	_tipLabel.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(_tipLabel)

	_buttons = HBoxContainer.new()
	_buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	_buttons.add_theme_constant_override("separation", 24)
	v.add_child(_buttons)
	_playBtn = _button("PLAY AGAIN", true)
	_playBtn.pressed.connect(_on_play_again)
	_buttons.add_child(_playBtn)
	var mm := _button("MAIN MENU", false)
	mm.pressed.connect(_on_main_menu)
	_buttons.add_child(mm)
	_buttons.modulate.a = 0.0
	for tip_or_best in [_bestLabel, _tipLabel]:
		tip_or_best.modulate.a = 0.0


func _strip_pieces() -> Array:
	# report.name_pieces: [{count, tiles}] in reading order (from the snake layout).
	# Rebuild each piece's text from the real name so spaces land where they belong.
	var name_str := str(NAMES.get(str(report.get("cid", "USA")), "United States")).to_upper()
	var src: Array = report.get("name_pieces", [])
	if src.is_empty():
		src = _pieces_from_sizes(name_str.replace(" ", "").length())
	if src.is_empty():
		return [{"text": name_str, "main": true}]
	var best := 0
	for i in src.size():
		if int(src[i].tiles) > int(src[best].tiles):
			best = i
	var out: Array = []
	var ci := 0
	for i in src.size():
		var need := int(src[i].count)
		var txt := ""
		while ci < name_str.length() and need > 0:
			var ch := name_str.substr(ci, 1)
			ci += 1
			if ch == " ":
				if txt != "":
					txt += " "
				continue
			txt += ch
			need -= 1
		out.append({"text": txt.strip_edges(), "main": i == best})
	return out


func _pieces_from_sizes(letters: int) -> Array:
	# Fallback when the map's snake layout isn't available: share the letters over
	# the territories by size, like the snake does (tiny pockets carry none).
	var sizes: Array = report.get("now", {}).get("sizes", [])
	var total := 0
	for s in sizes:
		total += int(s)
	var kept: Array = []
	for s in sizes:
		if kept.size() < letters / 2 and (kept.is_empty() or int(s) >= total * 0.10):
			kept.append(int(s))
	if kept.size() <= 1:
		return []
	var sumk := 0
	for s in kept:
		sumk += s
	var out: Array = []
	var left := letters
	for i in kept.size():
		var n: int = left if i == kept.size() - 1 else maxi(2, roundi(letters * float(kept[i]) / sumk))
		n = mini(n, left - 2 * (kept.size() - 1 - i))
		out.append({"count": n, "tiles": kept[i]})
		left -= n
	return out


func _best_text() -> String:
	if records.is_empty():
		return ""
	if records.get("first", false):
		return "FIRST RUN — this is the score to beat"
	return "BEST  %s · %d      BEST NAME  %d%%" % [
		str(records.best_grade), int(records.best_score), roundi(float(records.best_name) * 100)]


func _label(txt: String, fs: int, col: Color, bold: bool = false) -> Label:
	var l := Label.new()
	l.text = txt
	l.add_theme_font_override("font", _bold if bold else _font)
	l.add_theme_font_size_override("font_size", fs)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	l.add_theme_constant_override("outline_size", 4 if fs >= 30 else 0)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


func _rule() -> Control:
	var r := ColorRect.new()
	r.color = Color(BORDER, 0.35)
	r.custom_minimum_size = Vector2(0, 2)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


func _button(txt: String, primary: bool) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(260, 60)
	b.add_theme_font_override("font", _bold)
	b.add_theme_font_size_override("font_size", 24)
	for st in ["normal", "hover", "pressed", "focus"]:
		var s := StyleBoxFlat.new()
		s.set_corner_radius_all(8)
		s.set_border_width_all(2)
		s.border_color = BORDER
		if primary:
			s.bg_color = GOLD.darkened(0.1) if st != "hover" else GOLD.lightened(0.1)
		else:
			s.bg_color = Color(0.12, 0.15, 0.25) if st != "hover" else Color(0.18, 0.22, 0.35)
		if st == "pressed":
			s.bg_color = s.bg_color.darkened(0.2)
		if st == "focus":
			s.draw_center = false
			s.border_color = Color.WHITE
			s.set_border_width_all(3)
		b.add_theme_stylebox_override(st, s)
	var fc := Color(0.08, 0.06, 0.02) if primary else Color.WHITE
	for k in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		b.add_theme_color_override(k, fc)
	return b


# ── Animation ────────────────────────────────────────────────────────────────
func _tw() -> Tween:
	var t := create_tween()
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_tweens.append(t)
	return t


func _animate() -> void:
	_animating = true
	var dim: ColorRect = _root.get_node("Dim")
	dim.modulate.a = 0.0
	_panel.modulate.a = 0.0
	var t0 := _tw()
	t0.tween_property(dim, "modulate:a", 1.0, 0.5)
	t0.parallel().tween_property(_panel, "modulate:a", 1.0, 0.45)

	# 1. the name spells itself out, letter by letter
	var n := _strip.letter_count()
	var t1 := _tw()
	t1.tween_interval(0.5)
	t1.tween_property(_strip, "reveal", float(n) + 1.0, 0.09 * n + 0.3)
	if _strip.pieces.size() == 1 and float(report.get("now", {}).get("name_pct", 0.0)) >= 0.999:
		t1.tween_property(_strip, "glow", 1.0, 0.35)

	# 2. meter + percent roll up
	# (starts from where the run began, so a lost run visibly drains)
	var pct := float(report.get("now", {}).get("name_pct", 0.0))
	var from_pct := _meter.start_pct
	_meter.fill = from_pct
	_pctLabel.text = "%d%%" % roundi(from_pct * 100)
	var at := 0.5 + 0.09 * n + 0.4
	var t2 := _tw()
	t2.tween_interval(at)
	t2.tween_property(_meter, "fill", pct, 1.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t2.parallel().tween_method(func(x: float): _pctLabel.text = "%d%%" % roundi(x * 100), from_pct, pct, 1.1)
	at += 1.2

	# 3. tally rows, then the total
	var running := 0.0
	for rn in _rowNodes:
		var row: Dictionary = rn.row
		var from := running
		running += float(row.pts)
		var tr := _tw()
		tr.tween_interval(at)
		tr.tween_property(rn.node, "modulate:a", 1.0, 0.18)
		tr.parallel().tween_method(func(x: float): rn.pts.text = "%d / %d" % [roundi(x), int(row.max)], 0.0, float(row.pts), 0.45)
		tr.parallel().tween_method(func(x: float): _totalLabel.text = str(roundi(x)), from, running, 0.45)
		at += 0.5
	var ttot := _tw()
	ttot.tween_interval(at)
	ttot.tween_method(func(_x: float): _totalLabel.text = str(int(report.get("score", 0))), 0.0, 1.0, 0.01)
	_totalLabel.pivot_offset = Vector2(40, 30)
	ttot.tween_property(_totalLabel, "scale", Vector2(1.25, 1.25), 0.08)
	ttot.tween_property(_totalLabel, "scale", Vector2.ONE, 0.18)
	at += 0.3

	# 4. the stamp slams down
	_stamp.scale = Vector2(2.4, 2.4)
	_stamp.rotation = -0.35
	var ts := _tw()
	ts.tween_interval(at)
	ts.tween_property(_stamp, "modulate:a", 1.0, 0.05)
	ts.parallel().tween_property(_stamp, "scale", Vector2.ONE, 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	ts.parallel().tween_property(_stamp, "rotation", -0.10, 0.28)
	ts.tween_callback(_shake)
	ts.tween_property(_stamp.get_parent().get_node("GradeTitle"), "modulate:a", 1.0, 0.25)
	at += 0.6
	# AudioManager.play_sfx("grade_stamp")   # ← sound hook when there is one

	# 5. records, tip, buttons
	var tf := _tw()
	tf.tween_interval(at)
	tf.tween_property(_bestLabel, "modulate:a", 1.0, 0.25)
	tf.parallel().tween_property(_tipLabel, "modulate:a", 1.0, 0.25)
	tf.tween_property(_buttons, "modulate:a", 1.0, 0.25)
	tf.tween_callback(_finish)


func _shake() -> void:
	var base := _panel.position
	var t := _tw()
	for off in [Vector2(9, -5), Vector2(-7, 6), Vector2(4, -3), Vector2.ZERO]:
		t.tween_property(_panel, "position", base + off, 0.035)


func _finish() -> void:
	if not _animating:
		return
	_animating = false
	if records.get("new_best", false):
		_newBest.visible = true
		var t := create_tween().set_loops()
		t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		t.tween_property(_newBest, "modulate:a", 0.35, 0.45)
		t.tween_property(_newBest, "modulate:a", 1.0, 0.45)
	_playBtn.grab_focus()


func skip() -> void:
	# Jump every tween to its end state.
	if not _animating:
		return
	for t in _tweens:
		if is_instance_valid(t) and t.is_valid():
			t.custom_step(60.0)
	_finish()


func _on_root_input(e: InputEvent) -> void:
	if _animating and e is InputEventMouseButton and e.pressed:
		skip()


func _unhandled_input(e: InputEvent) -> void:
	if _animating and (e is InputEventKey and e.pressed):
		skip()
		get_viewport().set_input_as_handled()


func _on_play_again() -> void:
	if play_again.get_connections().is_empty():
		get_tree().reload_current_scene()
	else:
		play_again.emit()


func _on_main_menu() -> void:
	if main_menu.get_connections().is_empty():
		get_tree().change_scene_to_file("res://Menu Scenes and Scripts/main_menu.tscn")
	else:
		main_menu.emit()
