extends Control

class_name MagicAmountControl


@export var schoolTypeEXP: String
var schoolType: String

@export var spellUnlocksEXP: Array = []
var spellUnlocks: Array = []

var amount: int

var manifestLevel: int
var cryptidLevel: int
var libertyLevel: int
var stormLevel: int
var ironLevel: int
var spectralLevel: int

var cost: int
var costModifier: int
var discountModifier: int
var finalCost: int
var amountPerTurn: int

func buildSelf():
	schoolType = schoolTypeEXP
	print("RETURN DEBUG12,", schoolType)
	match schoolType:
		"storm", "druid":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1255.PNG")
			$spellSchool.text = "Stormcraft"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/druid big.png")
		"iron", "elementalist":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1257.PNG")
			$spellSchool.text = "Ironclad Arts"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/elementalistbig.png")
		"liberty", "diviner":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1260.PNG")
			$spellSchool.text = "Liberty Rites"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png")
		"manifest", "alchemist":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1256.PNG")
			$spellSchool.text = "Manifest Doctrine"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/alchemy big.png")
		"cryptid", "summoner":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1259.PNG")
			$spellSchool.text = "Cryptidology"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/summoner big.png")
		"spectral", "illusionist":
			$SchoolTreeSprite.texture = load("res://art assets/finishedAssets/spellschools/IMG_1258.PNG")
			$spellSchool.text = "Spectrology"
			$MagicSprite2D.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/illusion big.png")
	if spellUnlocksEXP != null:
		for NodePath in spellUnlocksEXP:
			spellUnlocks.append(get_node(NodePath))
	for spellBranchUnlock in spellUnlocks:
		spellBranchUnlock.returnTranslatedInfo.connect(giveTranslatedInfo)
		spellBranchUnlock.buildSelf()



signal askSpellBranchInfo
func giveTranslatedInfo(type, spellBranch):
	emit_signal("askSpellBranchInfo", type, spellBranch)
	#print("RETURN DEBUG")

func update(playerCountryNode, magicDic):
	schoolType = schoolTypeEXP
	#amountPerTurn = playerCountryNode.
	cost = playerCountryNode.spellBaseCost
	costModifier = playerCountryNode.spellCostModifier
	discountModifier = playerCountryNode.spellDiscountModifier
	match schoolType:
		"storm", "druid":
			amount = playerCountryNode.stormPoints
			stormLevel = playerCountryNode.stormLevel
			calculateLevelUp(stormLevel)
			amountPerTurn = magicDic.get("STORM", magicDic.get("DRU", 0))
		"iron", "elementalist":
			amount = playerCountryNode.ironPoints
			ironLevel = playerCountryNode.ironLevel
			calculateLevelUp(ironLevel)
			amountPerTurn = magicDic.get("IRON", magicDic.get("ELE", 0))
		"liberty", "diviner":
			amount = playerCountryNode.libertyPoints
			libertyLevel = playerCountryNode.libertyLevel
			calculateLevelUp(libertyLevel)
			amountPerTurn = magicDic.get("LIBERTY", magicDic.get("DIV", 0))
		"manifest", "alchemist":
			amount = playerCountryNode.manifestPoints
			manifestLevel = playerCountryNode.manifestLevel
			calculateLevelUp(manifestLevel)
			amountPerTurn = magicDic.get("MANIFEST", magicDic.get("ALC", 0))
		"cryptid", "summoner":
			amount = playerCountryNode.cryptidPoints
			cryptidLevel = playerCountryNode.cryptidLevel
			calculateLevelUp(cryptidLevel)
			amountPerTurn = magicDic.get("CRYPTID", magicDic.get("SUM", 0))
		"spectral", "illusionist":
			amount = playerCountryNode.spectralPoints
			spectralLevel = playerCountryNode.spectralLevel
			calculateLevelUp(spectralLevel)
			amountPerTurn = magicDic.get("SPECTRAL", magicDic.get("ILL", 0))
	$ProgressBar.value = amount
	$AmountLabel.text = str(amount)
	for spellBranchUnlock in spellUnlocks:
		spellBranchUnlock.update(amount, amountPerTurn)

signal spellSchoolLevelUp


func calculateLevelUp(schoolLevel):
	if schoolLevel == 0:
		finalCost = (15 - (15 * (discountModifier * .01)) + (15 * (costModifier * .01)))
	else:
		cost = ((cost * schoolLevel)+15)
		finalCost = (cost - (cost * (discountModifier * .01)) + (cost * (costModifier * .01)))
	if amount >= finalCost:
		print("big big big big", schoolType)
		emit_signal("spellSchoolLevelUp", schoolType, schoolLevel)
