extends Control
## Run this scene on its own (F6) to see the three fonts at the game's sizes.

const SAMPLE := "Lincoln's Ghost & the Republic — don't wait. Café (50%) 1861"

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.12, 0.12, 0.14)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var box := VBoxContainer.new()
	box.position = Vector2(24, 16)
	add_child(box)
	for s in [9, 11, 13, 16, 18, 24, 28]:
		var l := Label.new()
		l.add_theme_font_size_override("font_size", s)
		l.text = "body %d   %s" % [s, SAMPLE]
		box.add_child(l)
	for v in [[&"PaxHeader", 20], [&"PaxHeader", 30], [&"PaxTitle", 30], [&"PaxTitle", 45]]:
		var l := Label.new()
		l.theme_type_variation = v[0]
		l.add_theme_font_size_override("font_size", v[1])
		l.text = "%s %d   %s" % [v[0], v[1], SAMPLE]
		box.add_child(l)
	var b := Button.new()
	b.text = "Header button"
	b.theme_type_variation = &"PaxHeaderButton"
	b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	box.add_child(b)
	var r := RichTextLabel.new()
	r.bbcode_enabled = true
	r.fit_content = true
	r.custom_minimum_size = Vector2(1800, 0)
	r.text = "Rich text: normal, [b]bold (auto-thickened)[/b], [i]italic (same as normal for now)[/i], [color=yellow]colour[/color]."
	box.add_child(r)
