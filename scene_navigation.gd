extends Control
## SceneNavigation — in-context scene choice overlay.
##
## Add as a child of the active event_scene when an explicit/sensual/kinky_lewd
## button is pressed. Emits scene_choice_made("full"|"intimate"|"skip") and
## frees itself. Streaming mode auto-selects "intimate" without showing UI.
##
## Labels are Pax Americana defaults. Set label_* before _ready() to override.

signal scene_choice_made(choice: String)

var streaming_mode: bool  = false
var label_full:     String = "Stay"
var label_intimate: String = "By morning"
var label_skip:     String = "Continue"

const _C_BG      := Color(0.027, 0.027, 0.063, 0.90)  # #070710 90 %
const _C_PANEL   := Color(0.06,  0.04,  0.13,  1.0)
const _C_GOLD    := Color(0.788, 0.659, 0.298, 1.0)   # #C9A84C
const _C_TEAL    := Color(0.039, 0.486, 0.431, 1.0)   # #0A7C6E
const _C_DIM     := Color(0.35,  0.30,  0.44,  1.0)
const _C_BORDER  := Color(0.22,  0.16,  0.35,  0.55)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 10

	if streaming_mode:
		call_deferred("_emit_choice", "intimate")
		return
	_build_ui()


func _emit_choice(choice: String) -> void:
	scene_choice_made.emit(choice)
	queue_free()


func _build_ui() -> void:
	# ── dark veil behind the panel ────────────────────────────────────────────
	var veil := ColorRect.new()
	veil.color = _C_BG
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(veil)

	# ── CenterContainer so the panel sits in the middle of the screen ─────────
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(center)

	# ── outer margin for breathing room ───────────────────────────────────────
	var outer := MarginContainer.new()
	for side in ["margin_top", "margin_bottom", "margin_left", "margin_right"]:
		outer.add_theme_constant_override(side, 36)
	outer.mouse_filter = Control.MOUSE_FILTER_PASS
	center.add_child(outer)

	# ── panel background ───────────────────────────────────────────────────────
	var panel_bg := StyleBoxFlat.new()
	panel_bg.bg_color = _C_PANEL
	panel_bg.set_corner_radius_all(6)
	panel_bg.border_width_left   = 1
	panel_bg.border_width_right  = 1
	panel_bg.border_width_top    = 1
	panel_bg.border_width_bottom = 1
	panel_bg.border_color        = _C_GOLD

	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", panel_bg)
	panel.custom_minimum_size = Vector2(320, 0)
	outer.add_child(panel)

	# ── inner VBox ────────────────────────────────────────────────────────────
	var pad := MarginContainer.new()
	for side in ["margin_top", "margin_bottom", "margin_left", "margin_right"]:
		pad.add_theme_constant_override(side, 28)
	panel.add_child(pad)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	pad.add_child(vbox)

	# Top rule
	vbox.add_child(_make_rule_label())

	# Three choice buttons
	var choices := [
		{"label": label_full,     "choice": "full",     "color": _C_GOLD},
		{"label": label_intimate, "choice": "intimate", "color": _C_TEAL},
		{"label": label_skip,     "choice": "skip",     "color": _C_DIM},
	]
	for c in choices:
		vbox.add_child(_make_choice_button(c["label"], c["choice"], c["color"]))

	# Bottom rule
	vbox.add_child(_make_rule_label())


func _make_rule_label() -> Label:
	var lbl := Label.new()
	lbl.text = "── ─ ──"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_color_override("font_color", _C_TEAL)
	return lbl


func _make_choice_button(text: String, choice: String, color: Color) -> Button:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(_C_PANEL.r * 1.3, _C_PANEL.g * 1.3, _C_PANEL.b * 1.3, 1.0)
	normal.set_corner_radius_all(4)
	normal.border_width_left   = 1
	normal.border_width_right  = 1
	normal.border_width_top    = 1
	normal.border_width_bottom = 1
	normal.border_color        = _C_BORDER

	var hover := StyleBoxFlat.new()
	hover.bg_color = color.darkened(0.55)
	hover.set_corner_radius_all(4)
	hover.border_width_left   = 1
	hover.border_width_right  = 1
	hover.border_width_top    = 1
	hover.border_width_bottom = 1
	hover.border_color        = color

	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(264, 44)
	btn.add_theme_color_override("font_color",          color)
	btn.add_theme_color_override("font_hover_color",    color)
	btn.add_theme_color_override("font_pressed_color",  color)
	btn.add_theme_stylebox_override("normal",  normal)
	btn.add_theme_stylebox_override("hover",   hover)
	btn.add_theme_stylebox_override("pressed", hover)
	btn.pressed.connect(_emit_choice.bind(choice))
	return btn
