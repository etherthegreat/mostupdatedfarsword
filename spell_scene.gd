extends Control

class_name spellArt

var thisSpell: spell
var baseCost: int
var description: String
var spellName: String
var player: country
var spellTexture: Texture

func buildSpell(sName, cost, playerCountryNode, spell):
	spellName = sName
	baseCost = cost
	player = playerCountryNode
	thisSpell = spell
	spellTexture = spell.spellSprite
	$SpellButton.icon = spellTexture
	match spellName:
		"Plentify":
			description = "Increase the rate which plants and animals reproduce, allowing our farmers to produce more resources!"
	pass

signal spellButtonPressed
func _on_spell_button_pressed() -> void:
	var costToSend: int
	costToSend = (baseCost - (baseCost * (player.spellDiscountModifier * .01)) + (baseCost * (player.spellCostModifier * .01)))
	emit_signal("spellButtonPressed", thisSpell, costToSend)
	pass # Replace with function body.


func _on_spell_button_mouse_entered() -> void:
	print("mouse detected")
	$DescriptionPanel/SpellNameLabel.text = spellName
	$DescriptionPanel/DescriptionLabel.text = description
	var costForDisplay: int
	costForDisplay = (baseCost - (baseCost * (player.spellDiscountModifier * .01)) + (baseCost * (player.spellCostModifier * .01)))
	$DescriptionPanel/SpellCostLabel.text = str(baseCost)
	$DescriptionPanel.visible = true
	pass # Replace with function body.


func _on_spell_button_mouse_exited() -> void:
	$DescriptionPanel.visible = false
	pass # Replace with function body.
