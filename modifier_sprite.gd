extends Sprite2D
class_name ModifierSprite
#this is basically just a sprite that if you hover over it will display the modifier description.

var modifierNumber
var modifierName: String

func _ready() -> void:
	scale = Vector2(0.13,0.13)
	#$Panel.visible = false


func buildModifier(tileEcoModifier):
	modifierName = tileEcoModifier.modName
	self.texture = tileEcoModifier.modSprite

func _on_area_2d_mouse_entered() -> void:
	if modifierName == "Summer":
		$Panel/Label.text = str("Summer:  This holiday is warm!")
		$Panel.visible = true


func _on_area_2d_mouse_exited() -> void:
	$Panel.visible = false
