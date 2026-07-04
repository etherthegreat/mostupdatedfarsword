extends Control

class_name EventButtonControl

var _btn_data: Dictionary = {}

signal button_chosen(btn_data: Dictionary)

func setup(btn_data: Dictionary) -> void:
	_btn_data = btn_data
	var b: Button = $EventButton
	b.text = btn_data.get("button_text", "Choose")
	b.tooltip_text = _describe_effect(btn_data)
	# No focus outline (it was highlighting the first button on open).
	b.focus_mode = Control.FOCUS_NONE
	# Wrap long labels and clip so nothing spills past the button art.
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	b.clip_text = true
	# Shrink the font for longer labels so they stay on the button.
	var n: int = b.text.length()
	var fs: int = 27
	if n > 30:
		fs = 18
	elif n > 22:
		fs = 21
	elif n > 16:
		fs = 24
	b.add_theme_font_size_override("font_size", fs)

func _describe_effect(d: Dictionary) -> String:
	# Explicit hover text wins; otherwise auto-describe the mechanical outcome.
	var explicit: String = str(d.get("button_tooltip", "")).strip_edges()
	if explicit != "":
		return explicit
	var ot: String = str(d.get("outcome_type", ""))
	var ov: String = str(d.get("outcome_value", ""))
	match ot:
		"resource_bundle":
			var parts: Array = []
			for pair in ov.