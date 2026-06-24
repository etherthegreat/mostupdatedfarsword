extends Control


class_name OreButton

var oreName: String
var oreImage: Texture

func buildSelf(type, image):
	oreName = type
	oreImage = image
	$Button.icon = oreImage


signal giveOreName

func emitOreChangeSignal():
	emit_signal("giveOreName", oreName)


func _on_button_pressed() -> void:
	emitOreChangeSignal()
