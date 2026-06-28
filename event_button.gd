extends Control

class_name EventButtonControl

var _btn_data: Dictionary = {}

signal button_chosen(btn_data: Dictionary)

func setup(btn_data: Dictionary) -> void:
	_btn_data = btn_data
	$EventButton.text = btn_data.get("button_text", "Choose")
	$EventButton.tooltip_text = _describe_effect(btn_data)

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
			for pair in ov.split(","):
				var kv = pair.split(":")
				if kv.size() == 2:
					parts.append("+" + kv[1].strip_edges() + " " + kv[0].strip_edges().capitalize())
			return " · ".join(parts)
		"resource_change":
			return "+" + str(d.get("outcome_amount", "")) + " " + ov.capitalize()
		"add_mil_mod":
			return "Gain: " + ov.capitalize()
		"morale_boost":
			return "Boosts national morale"
		_:
			return ""

func _on_event_button_pressed() -> void:
	emit_signal("button_chosen", _btn_data)
