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
		"MANIFEST DESTINY SUBSIDY PROGRAM":
			disabledSprite = load("res://art assets/Placeholder Art/Spells/Plentify - disabled.png")
			enabledSprite = load("res://art assets/Placeholder Art/UI Art/resources/Plentify.png")
			spellSchoolType = "iron"
		"THOUGHTS & PRAYERS (FEDERAL ALLOCATION)":
			disabledSprite = load("res://art assets/Placeholder Art/Spells/healingwinds - disabled.png")
			enabledSprite = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/Magic.png")
			spellSchoolType = "iron"
		"UNAUTHORIZED WEATHER MODIFICATION ACT":
			disabledSprite = load("res://art assets/Placeholder Art/Spells/RaiseSpring - disbled.png")
			enabledSprite = load("res://art assets/ModifierIcons/TileEcoModifiers/FreshWater.png")
			spellSchoolType = "iron"
	for spell in playerCountryNode.unlockedSpells:
		if spell.spellType == spellUnlockType:
			unlockSpell(spellUnlockType)
		else:
			enabledBool = false
			$SpellUnlockSprite.texture = disabledSprite

func unlockSpell(spellType):
	$SpellUnlockSprite.texture = enabledSprite
	enabledBool = true

func _on_area_2d_mouse_entered() -> void:
	if enabledBool == true:
		pass
	else:
		calculateUnlockTime()



func calculateUnlockTime():
	#match spellSchoolType:
		#"ele":
			#for building in player.countryBuildingList:
				#if building.buildingType == Tower:
					#if building.magicOutput == elePoints:
			#match spellUnlockType:
				#"Plentify":
					
	pass
