extends CanvasLayer
# ═════════════════════════════════════════════════════════════════════════════
# STANDING PANEL — 2026-10-26
# Opened from the run clock. Where this run stands RIGHT NOW, scored with the same
# maths as the end screen (world.live_run_report → run_score.gd):
#   • Ualani reacting to your grade (art slot, see UALANI_DIR below)
#   • the grade ladder S A B C D F (+ the secret L, hidden until you're on it)
#   • the four score rows, what the election would give you today, the next grade
# Click outside, press Esc, or hit Back to Map to close. The game does not pause.
# ═════════════════════════════════════════════════════════════════════════════

const RS := preload("res://Game Scenes and Scripts/run_score.gd")
const SS := preload("res://Game Scenes and Scripts/score_screen.gd")

# Ualani reaction art — one folder per grade, a PNG sequence that loops:
#   res://art assets/finishedAssets/score/ualani/S/ualani_S_000.png, _001 …
#   … A/  B/  C/  D/  F/  L/
# Any file names work (they play in alphabetical order). A single PNG = a still.
# A missing folder shows a labelled placeholder so the slot is easy to find.
const UALANI_DIR := "res://art assets/finishedAssets/score/ualani/"
const UALANI_FPS := 12.0
const UALANI_BOX := Vector2(380, 500)

const BG := Color(0.07, 0.09, 0.16, 0.97)
const BORDER := Color(0.85, 0.62, 0.18, 1.0)
const GOLD := Color(1.0, 0.82, 0.32)
const DIM := Color(0.72, 0.80, 0.95)
const PALE := Color(0.60, 0.66, 0.78)
const GOOD := Color(0.55, 0.92, 0.55)
const BAD := Color(1.0, 0.45, 0.42)

var report: Dictionary = {}
var records: Dictionary = {}
var _font: Font
var _bold: FontVariation
var _root: Control
var _frames: Array = []
var _rect: TextureRect
var _ft := 0.0
var _fi := 0


func _init() -> void:
	layer = 58


func show_report(rep: Dictionary, recs: Dictionary = {}) -> void:
	report = rep
	records = recs
	var th := ThemeDB.get_project_theme()
	_font = th.default_font if th != null and th.default_font != null else ThemeDB.fallback_font
	_bold = FontVariation.new()
	_bold.base_font = _font
	_bold.variation_embolden = 0.9
	_build()
	_root.modulate.a = 0.0
	create_tween().tween_property(_root, "modulate:a", 1.0, 0.15)


# ── Build ────────────────────────────────────────────────────────────────────
func _build() -> void:
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			close())
	add_child(_root)
	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.03, 0.07, 0.72)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(1220, 0)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP   # clicks inside don't close
	var sb := StyleBoxFlat.new()
	sb.bg_color = BG
	sb.border_color = BORDER
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(12)
	sb.shadow_color = Color(0, 0, 0, 0.6)
	sb.shadow_size = 24
	for side in ["left", "right"]:
		sb.set("content_margin_" + side, 34)
	sb.content_margin_top = 26
	sb.content_margin_bottom = 26
	panel.add_theme_stylebox_override("panel", sb)
	center.add_child(panel)

	var cols := HBoxContainer.new()
	cols.add_theme_constant_override("separation", 34)
	panel.add_child(cols)
	cols.add_child(_ualani_box())

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cols.add_child(v)

	var g := str(report.grade)
	var gc: Color = SS.GRADE_COLORS.get(g, DIM)
	var turn := int(report.get("turn", 1))
	var last := int(report.get("last_turn", 100))
	var left := int(report.get("turns_left", last - turn))
	v.add_child(_label("YOUR STANDING   ·   TURN %d OF %d   ·   %d LEFT" % [turn, last, left], 16, PALE, true))

	# big grade + title + score
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 22)
	v.add_child(head)
	head.add_child(_label(g, 96, gc, true))
	var hv := VBoxContainer.new()
	hv.alignment = BoxContainer.ALIGNMENT_CENTER
	head.add_child(hv)
	hv.add_child(_label(str(report.title).to_upper(), 30, gc, true))
	hv.add_child(_label("%d / 100 points" % int(report.score), 20, Color.WHITE, true))
	hv.add_child(_label(_next_grade_line(), 16, DIM))

	v.add_child(_ladder(g))
	v.add_child(_rule())

	# if the election were today
	var won: bool = bool(report.get("won", false))
	var okey := "win" if won else str(report.get("end_type", ""))
	var today := _label("If the election were today:  " + RS._outcome_word(okey), 18, GOOD if won else BAD, true)
	v.add_child(today)
	if not won and RS.grade_for(float(report.score), true)[0] != RS.grade_for(float(report.score), false)[0]:
		v.add_child(_label("Your points already earn %s — but until the Crown is gone, the best you can take home is %s." \
			% [RS.grade_for(float(report.score), true)[0], RS.LOSS_CAP], 15, GOLD))

	for r in report.rows:
		v.add_child(_row(r))
	v.add_child(_rule())
	var tip := _label(str(report.get("tip", "")).replace("Next run: ", "Right now: "), 16, GOLD)
	tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(tip)

	var foot := HBoxContainer.new()
	v.add_child(foot)
	var best := _label(_best_text(), 15, PALE)
	best.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	foot.add_child(best)
	var b := Button.new()
	b.text = "Back to Map"
	b.custom_minimum_size = Vector2(170, 40)
	b.add_theme_font_override("font", _bold)
	b.add_theme_font_size_override("font_size", 17)
	b.pressed.connect(close)
	foot.add_child(b)


func _ladder(current: String) -> Control:
	# S A B C D F and the secret slot. L is shown only when you're standing on it.
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 8)
	var steps: Array = []
	for gr in RS.GRADES:
		steps.append({"letter": str(gr[1]), "min": "%d+" % int(gr[0])})
	steps.append({"letter": "L" if current == "L" else "?", "min": "???", "secret": true})
	for st in steps:
		var on: bool = st.letter == current
		var col: Color = SS.GRADE_COLORS.get(st.letter, PALE)
		var cell := PanelContainer.new()
		cell.custom_minimum_size = Vector2(86, 74) if on else Vector2(70, 62)
		cell.size_flags_vertical = Control.SIZE_SHRINK_END
		var s := StyleBoxFlat.new()
		s.set_corner_radius_all(8)
		s.set_border_width_all(3 if on else 1)
		s.border_color = col if on else Color(col, 0.35)
		s.bg_color = col.darkened(0.6) if on else Color(0.10, 0.12, 0.20)
		cell.add_theme_stylebox_override("panel", s)
		cell.tooltip_text = "Lose the war holding not one tile of your own." if st.get("secret", false) and current == "L" \
			else ("A secret grade." if st.get("secret", false) else "%s — %s points" % [st.letter, st.min])
		var cv := VBoxContainer.new()
		cv.alignment = BoxContainer.ALIGNMENT_CENTER
		cell.add_child(cv)
		var l := _label(st.letter, 34 if on else 26, col if on else Color(col, 0.55), true)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cv.add_child(l)
		var m := _label("YOU" if on else st.min, 12, Color.WHITE if on else PALE, on)
		m.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cv.add_child(m)
		h.add_child(cell)
	return h


func _row(r: Dictionary) -> Control:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 12)
	var name := _label(str(r.label), 16, DIM, true)
	name.custom_minimum_size = Vector2(180, 0)
	h.add_child(name)
	var bar := ProgressBar.new()
	bar.show_percentage = false
	bar.max_value = float(r.max)
	bar.value = float(r.pts)
	bar.custom_minimum_size = Vector2(240, 16)
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(1, 1, 1, 0.1)
	bg.set_corner_radius_all(4)
	var fg := StyleBoxFlat.new()
	fg.bg_color = BORDER
	fg.set_corner_radius_all(4)
	bar.add_theme_stylebox_override("background", bg)
	bar.add_theme_stylebox_override("fill", fg)
	h.add_child(bar)
	var pts := _label("%d / %d" % [roundi(float(r.pts)), int(r.max)], 16, Color.WHITE, true)
	pts.custom_minimum_size = Vector2(70, 0)
	h.add_child(pts)
	h.add_child(_label(str(r.detail), 14, PALE))
	return h


func _next_grade_line() -> String:
	var sc := float(report.score)
	if str(report.grade) == "L":
		return "Hold one tile of your own and the ladder comes back."
	for i in range(RS.GRADES.size() - 1, -1, -1):
		var gr = RS.GRADES[i]
		if float(gr[0]) > sc:
			if not bool(report.get("won", false)) and RS.grade_rank(str(gr[1])) > RS.grade_rank(RS.LOSS_CAP):
				return "Next: win the war to climb past %s." % RS.LOSS_CAP
			return "+%d points to reach %s" % [ceili(float(gr[0]) - sc), gr[1]]
	return "Top of the ladder. Keep it."


func _best_text() -> String:
	var bs := int(records.get("best_score", -1))
	if bs < 0:
		return "First run — no best yet."
	return "Best run: %s  ·  %d points" % [str(records.get("best_grade", "?")), bs]


# ── Ualani reaction slot ────────────────────────────────────────────────────
func _ualani_box() -> Control:
	var box := PanelContainer.new()
	box.custom_minimum_size = UALANI_BOX
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.04, 0.05, 0.10)
	s.border_color = Color(BORDER, 0.6)
	s.set_border_width_all(2)
	s.set_corner_radius_all(10)
	box.add_theme_stylebox_override("panel", s)
	var g := str(report.grade)
	_frames = _load_frames(UALANI_DIR + g + "/")
	if _frames.is_empty():
		var l := _label("Ualani reacts to %s\n\nart goes in\nscore/ualani/%s/" % [g, g], 20, Color(SS.GRADE_COLORS.get(g, DIM), 0.7), true)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		box.add_child(l)
	else:
		_rect = TextureRect.new()
		_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		_rect.texture = _frames[0]
		box.add_child(_rect)
	return box


func _load_frames(dir: String) -> Array:
	# Works in exported builds too: only *.png.import remain there.
	var d := DirAccess.open(dir)
	if d == null:
		return []
	var names := {}
	for f in d.get_files():
		var n := f.trim_suffix(".import").trim_suffix(".remap")
		if n.get_extension().to_lower() in ["png", "webp", "jpg"]:
			names[n] = true
	var keys: Array = names.keys()
	keys.sort()
	var out: Array = []
	for k in keys:
		var tex = load(dir + str(k))
		if tex is Texture2D:
			out.append(tex)
	return out


func _process(delta: float) -> void:
	if _rect == null or _frames.size() < 2:
		return
	_ft += delta
	if _ft >= 1.0 / UALANI_FPS:
		_ft = 0.0
		_fi = (_fi + 1) % _frames.size()
		_rect.texture = _frames[_fi]


func _unhandled_input(e: InputEvent) -> void:
	if e is InputEventKey and e.pressed and e.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	queue_free()


# ── helpers ─────────────────────────────────────────────────────────────────
func _label(txt: String, fs: int, col: Color, bold: bool = false) -> Label:
	var l := Label.new()
	l.text = txt
	l.add_theme_font_override("font", _bold if bold else _font)
	l.add_theme_font_size_override("font_size", fs)
	l.add_theme_color_override("font_color", col)
	l.mouse_filter = Control.MOUSE_FILTER_PASS
	return l


func _rule() -> Control:
	var c := ColorRect.new()
	c.color = Color(BORDER, 0.35)
	c.custom_minimum_size = Vector2(0, 2)
	return c
