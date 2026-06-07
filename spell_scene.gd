extends Control

class_name spellArt

var thisSpell: spell
var baseCost: int
var description: String
var spellType: String
var player: country
var spellTexture: Texture

func buildSpell(sName, cost, playerCountryNode, spell):
	spellType = sName
	baseCost = cost
	player = playerCountryNode
	thisSpell = spell
	spellTexture = spell.spellSprite
	$SpellButton.icon = spellTexture
	match spellType:
		"MANIFEST DESTINY SUBSIDY PROGRAM":
			description = "Increase the rate which plants and animals reproduce, allowing our farmers to produce more resources!"
		"THOUGHTS & PRAYERS (FEDERAL ALLOCATION)":
			description = "Send mighty gusts to clear out Demonic miasma from this tile."
		"UNAUTHORIZED WEATHER MODIFICATION ACT":
			description = "Raise the water table and coax a spring from the earth. Freshwater tiles only."
		_:
			# Presidential Powers: fall back to the spell's own short description
			description = thisSpell.spellShortDescription
	pass

signal spellButtonPressed
func _on_spell_button_pressed() -> void:
	var costToSend: int
	costToSend = (baseCost - (baseCost * (player.spellDiscountModifier * .01)) + (baseCost * (player.spellCostModifier * .01)))
	emit_signal("spellButtonPressed", thisSpell, costToSend)
	pass # Replace with function body.


func _on_spell_button_mouse_entered() -> void:
	print("mouse detected")
	$DescriptionPanel/SpellNameLabel.text = spellType
	$DescriptionPanel/DescriptionLabel.text = description
	var costForDisplay: int
	costForDisplay = (baseCost - (baseCost * (player.spellDiscountModifier * .01)) + (baseCost * (player.spellCostModifier * .01)))
	$DescriptionPanel/SpellCostLabel.text = str(baseCost)
	$DescriptionPanel.visible = true
	pass # Replace with function body.


func _on_spell_button_mouse_exited() -> void:
	$DescriptionPanel.visible = false
	pass # Replace with function body.
