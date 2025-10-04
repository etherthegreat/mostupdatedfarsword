extends Control

class_name spellUnlock

@export var spellUnlockTypeEXP: String
var spellUnlockType: String
var spellSchoolType: String

var player: country

var enabledBool: bool

var disabledSprite: Texture
var enabledSprite: Texture

func buildSelf(playerCountryNode):
	match spellUnlockType:
		"Plentify":
			disabledSprite = load("res://art assets/Placeholder Art/Spells/Plentify - disabled.png")
			enabledSprite = load("res://art assets/Placeholder Art/UI Art/resources/Plentify.png")
			spellSchoolType = "ele"
		"Healing Winds":
			disabledSprite = load("res://art assets/Placeholder Art/Spells/healingwinds - disabled.png")
			enabledSprite = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/Magic.png")
			spellSchoolType = "ele"
		"Raise Spring":
			disabledSprite = load("res://art assets/Placeholder Art/Spells/RaiseSpring - disbled.png")
			enabledSprite = load("res://art assets/ModifierIcons/TileEcoModifiers/FreshWater.png")
			spellSchoolType = "ele"
	for spell in playerCountryNode.unlockedSpells:
		if spell.spellType == spellUnlockType:
			unlockSpell(spellUnlockType)
		else:
			enabledBool = false
			$SpellUnlockSprite.texture = disabledSprite
	pass

func unlockSpell(spellType):
	$SpellUnlockSprite.texture = enabledSprite
	enabledBool = true
	pass

func _on_area_2d_mouse_entered() -> void:
	if enabledBool == true:
		pass
	else:
		calculateUnlockTime()
	pass # Replace with function body.



func calculateUnlockTime():
	#match spellSchoolType:
		#"ele":
			#for building in player.countryBuildingList:
				#if building.buildingType == Tower:
					if building.magicOutput == elePoints:
			#match spellUnlockType:
				#"Plentify":
					
	pass
