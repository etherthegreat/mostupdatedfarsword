extends Control

class_name MagicAmountControl

@export var schoolTypeEXP: String
var schoolType: String

var amount: int

func update(playerCountryNode):
	schoolType = schoolTypeEXP
	match schoolType:
		"druid":
			$spellSchool.text = "Druidism"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/druid big.png")
			amount = playerCountryNode.druPoints
		"elementalist":
			$spellSchool.text = "Elementalism"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/elementalistbig.png")
			amount = playerCountryNode.elePoints
		"diviner":
			$spellSchool.text = "Divination"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png")
			amount = playerCountryNode.divPoints
		"alchemist":
			$spellSchool.text = "Alchemy"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/alchemy big.png")
			amount = playerCountryNode.alcPoints
		"summoner":
			$spellSchool.text = "Summoning"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/summoner big.png")
			amount = playerCountryNode.sumPoints
		"illusionist":
			$spellSchool.text = "Illusion"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/illusion big.png")
			amount = playerCountryNode.illPoints
	$AmountLabel.text = str(amount)
	pass
