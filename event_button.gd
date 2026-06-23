extends Control

class_name EventButtonControl

var _btn_data: Dictionary = {}

signal button_chosen(btn_data: Dictionary)

func setup(btn_data: Dictionary) -> void:
	_btn_data = btn_data
	$EventButton.text = btn_data.get("button_text", "Choose")

func _on_event_button_pressed() -> void:
	emit_signal("button_chosen", _btn_data)
