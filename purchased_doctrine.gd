extends Control

class_name purchasedDoctrine

var title: String
var img: Texture
var desc: String
var doctrineType: bool
var borderIMG

func buildSelf(Name, Sprite, Description, type, border):
	title = Name
	img = Sprite
	$Panel/Sprite2D.texture = Sprite
	desc = Description
	doctrineType = type
	borderIMG = border
	$Panel/SpriteBorder.texture = borderIMG
	pass



signal purchasedDoctrineHover
func _on_area_2d_mouse_entered() -> void:
	emit_signal("purchasedDoctrineHover", title, img, desc, borderIMG)
	pass # Replace with function body.

signal pdExited
func _on_area_2d_mouse_exited() -> void:
	emit_signal("pdExited")
	pass # Replace with function body.
