extends Control

class_name MagicAmountControl


@export var schoolTypeEXP: String
var schoolType: String

var amount: int

var alcLevel: int
var sumLevel: int
var divLevel: int
var druLevel: int
var eleLevel: int
var illLevel: int

var cost: int
var costModifier: int
var discountModifier: int
var finalCost: int

func update(playerCountryNode):
	schoolType = schoolTypeEXP
	cost = playerCountryNode.spellBaseCost
	costModifier = playerCountryNode.spellCostModifier
	discountModifier = playerCountryNode.spellDiscountModifier
	match schoolType:
		"druid":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1255.PNG")
			$spellSchool.text = "Druidism"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/druid big.png")
			amount = playerCountryNode.druPoints
			druLevel = playerCountryNode.druLevel
			calculateLevelUp(druLevel)
		"elementalist":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1257.PNG")
			$spellSchool.text = "Elementalism"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/elementalistbig.png")
			amount = playerCountryNode.elePoints
			eleLevel = playerCountryNode.eleLevel
			calculateLevelUp(eleLevel)
		"diviner":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1260.PNG")
			$spellSchool.text = "Divination"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png")
			amount = playerCountryNode.divPoints
			druLevel = playerCountryNode.divLevel
			calculateLevelUp(divLevel)
		"alchemist":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1256.PNG")
			$spellSchool.text = "Alchemy"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/alchemy big.png")
			amount = playerCountryNode.alcPoints
			druLevel = playerCountryNode.alcLevel
			calculateLevelUp(alcLevel)
		"summoner":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1259.PNG")
			$spellSchool.text = "Summoning"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/summoner big.png")
			amount = playerCountryNode.sumPoints
			druLevel = playerCountryNode.sumLevel
			calculateLevelUp(sumLevel)
		"illusionist":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1258.PNG")
			$spellSchool.text = "Illusion"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/illusion big.png")
			amount = playerCountryNode.illPoints
			druLevel = playerCountryNode.illLevel
			calculateLevelUp(illLevel)
	$ProgressBar.value = amount
	$AmountLabel.text = str(amount)
	pass

signal spellSchoolLevelUp


func calculateLevelUp(schoolLevel):
	if schoolLevel == 0:
		finalCost = (15 - (15 * (discountModifier * .01)) + (15 * (costModifier * .01)))
	else:
		cost = ((cost * schoolLevel)+15)
		finalCost = (cost - (cost * (discountModifier * .01)) + (cost * (costModifier * .01)))
	if amount >= finalCost:
		#send a big ole signal for an event which just says the spell has been unlocked
		print("big big big big", schoolType)
		emit_signal("spellSchoolLevelUp", schoolType, schoolLevel)
		pass
	else:
		pass
	pass
