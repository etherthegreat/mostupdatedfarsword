extends Node2D

class_name spell

var spellType: String
var spellLevel: int
#var countryID: country
var experience: int #spells gain experience when used.  experience levels up a character

var spellUnlockCost: int
var spellCastCost: int
var spellCastCostPerMonth: int

var spellLongDescription: String  = "This spell has not been assigned a long description"
var spellShortDescription: String ="This spell has not been assigned a short description"
var spellSprite: Texture

var militarySpell: bool


func newGameSpellAssignment():
	#var discount: int
	#discount = countryID.spellCostDiscount
	if spellType == "Plentify":
		militarySpell = false
		spellSprite = load("res://art assets/Placeholder Art/UI Art/resources/Plentify.png")
		if spellLevel == 1:
			spellCastCostPerMonth = 4
			spellCastCost = (50)
		elif spellLevel == 2:
			spellCastCostPerMonth = 6
			spellCastCost = (70)
		elif spellLevel == 3:
			spellCastCostPerMonth = 8
			spellCastCost = (90)
	pass
