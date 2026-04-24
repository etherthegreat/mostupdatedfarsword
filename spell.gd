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
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 15
		"Healing Winds":
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 20
		"Raise Spring":
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 100
	pass
