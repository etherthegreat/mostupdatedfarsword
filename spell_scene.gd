extends Sprite2D


class_name spellArt

#var ownerCountry: String
#var baseSpell: spell

#var spellCost: int
func _ready() -> void:
	scale = Vector2(0.23,0.23)
	pass
#func buildSpellScene(name, level, owner):
	#if name == "Plentify":
		#$Sprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Plentify.png")
		#spellCost = (20 + (level*20))
	#pass



#func _on_button_pressed() -> void:
	#if baseSpell.militarySpell == false:
		#if baseSpell.spellName == "Plentify":
			#playerCountry.TotalMagic -= spellCost
	#pass # Replace with function body.
