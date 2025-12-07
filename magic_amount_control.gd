extends Control

class_name MagicAmountControl


@export var schoolTypeEXP: String
var schoolType: String

@export var spellUnlocksEXP: Array = []
var spellUnlocks: Array = []

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
var amountPerTurn: int

func buildSelf():
	schoolType = schoolTypeEXP
	print( "RETURN DEBUG12,", schoolType)
	match schoolType:
		"druid":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1255.PNG")
			$spellSchool.text = "Druidism"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/druid big.png")
		"elementalist":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1257.PNG")
			$spellSchool.text = "Elementalism"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/elementalistbig.png")
		"diviner":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1260.PNG")
			$spellSchool.text = "Divination"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png")
		"alchemist":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1256.PNG")
			$spellSchool.text = "Alchemy"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/alchemy big.png")
		"summoner":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1259.PNG")
			$spellSchool.text = "Summoning"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/summoner big.png")
		"illusionist":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1258.PNG")
			$spellSchool.text = "Illusion"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/illusion big.png")
	if spellUnlocksEXP != null:
		for NodePath in spellUnlocksEXP:
			spellUnlocks.append(get_node(NodePath))
	for spellBranchUnlock in spellUnlocks:
		spellBranchUnlock.returnTranslatedInfo.connect(giveTranslatedInfo)
		spellBranchUnlock.buildSelf()

	pass


signal askSpellBranchInfo
func giveTranslatedInfo(type, spellBranch):
	emit_signal("askSpellBranchInfo", type, spellBranch)
	#print("RETURN DEBUG")
	pass

func update(playerCountryNode, magicDic):
	schoolType = schoolTypeEXP
	#amountPerTurn = playerCountryNode.
	cost = playerCountryNode.spellBaseCost
	costModifier = playerCountryNode.spellCostModifier
	discountModifier = playerCountryNode.spellDiscountModifier
	match schoolType:
		"druid":
			amount = playerCountryNode.druPoints
			druLevel = playerCountryNode.druLevel
			calculateLevelUp(druLevel)
			amountPerTurn = magicDic.DRU
		"elementalist":
			amount = playerCountryNode.elePoints
			eleLevel = playerCountryNode.eleLevel
			calculateLevelUp(eleLevel)
			amountPerTurn = magicDic.ELE
		"diviner":
			amount = playerCountryNode.divPoints
			druLevel = playerCountryNode.divLevel
			calculateLevelUp(divLevel)
			amountPerTurn = magicDic.DIV
		"alchemist":
			amount = playerCountryNode.alcPoints
			druLevel = playerCountryNode.alcLevel
			calculateLevelUp(alcLevel)
			amountPerTurn = magicDic.ALC
		"summoner":
			amount = playerCountryNode.sumPoints
			druLevel = playerCountryNode.sumLevel
			calculateLevelUp(sumLevel)
			amountPerTurn = magicDic.SUM
		"illusionist":
			amount = playerCountryNode.illPoints
			druLevel = playerCountryNode.illLevel
			calculateLevelUp(illLevel)
			amountPerTurn = magicDic.ILL
	$ProgressBar.value = amount
	$AmountLabel.text = str(amount)
	for spellBranchUnlock in spellUnlocks:
		spellBranchUnlock.update(amount, amountPerTurn)
		pass
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
