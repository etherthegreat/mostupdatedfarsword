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
			description = "By federal decree, all flora, fauna, and willing subjects of this nation are encouraged to multiply with godly enthusiasm. Our farmers shall plow deeper, our livestock shall frolic freely, and Congress shall pretend not to notice. [color=purple]Cast on Country[/color] - Boosts all resource outputs - Cost: [color=purple]15[/color]"
		"THOUGHTS & PRAYERS (FEDERAL ALLOCATION)":
			description = "Summon divine winds to scour this tile of its pestilential vapors and demonic presence. Benjamin Franklin, who has studied both electricity and gaseous emissions extensively, personally endorses this technique. [color=purple]Cast on Tile[/color] - Clears demonic miasma - Cost: [color=purple]20[/color]"
		"UNAUTHORIZED WEATHER MODIFICATION ACT":
			description = "Through mystical means technically illegal under three acts of the Continental Congress, our practitioners shall arouse the earth and raise her deepest waters to the surface. Freshwater tiles only. The earth has standards. [color=purple]Cast on Tile[/color] - Creates freshwater source - Cost: [color=purple]100[/color]"
		_:
			# Presidential Powers: fall back to the spell's own short description
			description = thisSpell.spellShortDescription

signal spellButtonPressed
func _on_spell_button_pressed() -> void:
	var costToSend: int
	costToSend = (baseCost - (baseCost * (player.spellDiscountModifier * .01)) + (baseCost * (player.spellCostModifier * .01)))
	emit_signal("spellButtonPressed", thisSpell, costToSend)


func _on_spell_button_mouse_entered() -> void:
	$DescriptionPanel/SpellNameLabel.text = spellType
	$DescriptionPanel/DescriptionLabel.text = description
	var costForDisplay: int
	costForDisplay = (baseCost - (baseCost * (player.spellDiscountModifier * .01)) + (baseCost * (player.spellCostModifier * .01)))
	$DescriptionPanel/SpellCostLabel.text = str(baseCost)
	$DescriptionPanel.visible = true


func _on_spell_button_mouse_exited() -> void:
	$DescriptionPanel.visible = false
