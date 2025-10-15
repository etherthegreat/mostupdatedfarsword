extends Control


class_name OreButton

var oreName: String
var oreImage: Texture

func buildSelf(type, image):
	oreName = type
	oreImage = image
	$Button.icon = oreImage
	pass


signal giveOreName

func emitOreChangeSignal():
	emit_signal("giveOreName", oreName)
	pass


func _on_button_pressed() -> void:
	emitOreChangeSignal()
	pass # Replace with function body.
