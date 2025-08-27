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
	match spellType:
		"Plentify":
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/UI Art/resources/Plentify.png")
			spellCastCost = 15
		"Healing Winds":
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/Magic.png")
			spellCastCost = 20
	pass
