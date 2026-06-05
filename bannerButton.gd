extends Control

class_name bannerButton

var type: String

var icon: Texture

func buildSelf(aicon):
	icon = aicon
	$Button.icon = icon
	pass

signal bannerButtonPressed
func _on_button_pressed() -> void:
	emit_signal("bannerButtonPressed", icon)
	pass # Replace with function body.
