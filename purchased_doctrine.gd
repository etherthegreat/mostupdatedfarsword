extends Control

class_name purchasedDoctrine

var title: String
var img: Texture
var desc: String

func buildSelf(Name, Sprite, Description):
	title = Name
	img = Sprite
	$Panel/Sprite2D.texture = Sprite
	desc = Description
	pass



signal purchasedDoctrineHover
func _on_area_2d_mouse_entered() -> void:
	emit_signal("purchasedDoctrineHover", title, img, desc)
	pass # Replace with function body.

signal pdExited
func _on_area_2d_mouse_exited() -> void:
	emit_signal("pdExited")
	pass # Replace with function body.
