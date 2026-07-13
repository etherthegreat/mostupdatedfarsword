extends Node2D

class_name tileEcoModifier

var modName: String

var modType: String #used to determine which calculations this mod should be noticed by, Gold, Food, Wood, Magic, etc.
var modDescription: String #used to display what the mod does to the tile through the ui
var number #not sure if this will be used ever, but putting it here in case
var modSprite: Texture

func buildTileEcoMod():
	match modName:
		"TotalCorruption":
			modType = "CORRUPTION"
			modDescription = "The Demon King's orruption is absolute here - Only the undead can occupy this horrid place."
			modSprite = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionTotal.png")
			number = 80
		"HeavyCorruption":
			modType = "CORRUPTION"
			modDescription = "The Demon King's corruption is prevalent here - Miasma stinks the air."
			modSprite = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionHeavy.png")
			number = 60
		"ModerateCorruption":
			modType = "CORRUPTION"
			modDescription = "The Demon King's corruption has infiltrated this land - Sickness and famine have become commonplace."
			modSprite = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionModerate.png")
			number = 40
		"LightCorruption":
			modType = "CORRUPTION"
			modDescription = "The Demon King's corruption influences this land - Birds no longer sing here."
			modSprite = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionLight.png")
			number = 20
		"NoCorruption":
			modType = "CORRUPTION"
			modDescription = "The Demon's Corruption has no influence in this land - Grandpas can smile here."
			modSprite = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionNo.png")
			number = 0
		"FreshWater":
			modType = "TERRAIN"
			modDescription = "This tile has access to fresh water.  Crops love it here."
			modSprite = load("res://art assets/ModifierIcons/TileEcoModifiers/FreshWater.png")
			number = 0
		"CoastalWater":
			modType = "TERRAIN"
			modDescription = "This tile receives moderate rainfall from sea clouds."
			modSprite = load ("res://art assets/Placeholder Art/UI Art/resources/blue water.png")
			number = 0
		"Dry":
			modType = "TERRAIN"
			modDescription = "This tile has no easy access to fresh water."
			modSprite = load ("res://art assets/Placeholder Art/UI Art/resources/black circle.png")
			number = 0
		"Rainforest":
			modType = "TERRAIN"
			modDescription = "Heavy rains hydrate a dense ecosystem rich with biodiversity."
			modSprite = load("res://art assets/Placeholder Art/UI Art/resources/Green Circle.png")
			number = 0
		"Grassland":
			modType = "TERRAIN"
			modDescription = "Fertile plains ripe for agriculture, capable of feeding many mouths."
			modSprite = load("res://art assets/Placeholder Art/UI Art/resources/Yellow Circle.png")
			number = 0
		"Summer":
			modType = "TERRAIN"
			modDescription = "Summer sun warms the air."
			modSprite = load("res://art assets/Placeholder Art/UI Art/resources/Orange Circle.png")
			number = 0
		"MysteriousShipRaids":
			modType = "DOLLAR_PENALTY"
			modDescription = "An unmanned warship is raiding coastal trade. All buildings lose $2 per turn until the disturbance is resolved."
			modSprite = load("res://art assets/Placeholder Art/UI Art/resources/blue water.png")
			number = -2
