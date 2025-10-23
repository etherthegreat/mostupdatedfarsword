extends Control

class_name kit

var kitType: String
var kitImage: Texture

var kitFoodCost: int
var kitWoodCost: int
var kitGoldCost: int
var kitMetalCost: int
var kitMagicCost: int
var kitScienceCost: int
var kitFaithCost: int
var kitMandateCost: int
var kitHarmonyCost: int
var kitManpowerCost: int
var kitInfluenceCost: int
var kitWeaponsCost: int

var kitMilMod: MilMod

var milModScene = load("res://mil_mod.tscn")

func buildSelf(type):
	kitType = type
	match kitType:
		"Constructor":
			kitImage = load("res://art assets/Placeholder Art/UI Art/Workshop.png")
		"Adventurer":
			kitImage = load("res://art assets/Placeholder Art/UI Art/forge.png")
		"Scholar":
			kitImage = load("res://art assets/Placeholder Art/UI Art/library.png")
		"Entertainer":
			kitImage = load("res://art assets/Placeholder Art/UI Art/Faire.png")
		"Harvester":
			kitImage = load("res://art assets/Placeholder Art/UI Art/camp.png")
		"Prospector":
			kitImage = load("res://art assets/Placeholder Art/UI Art/mine.png")
		"Druid":
			kitImage = load("res://art assets/Placeholder Art/UI Art/Bath.png")
		"Homesteader":
			kitImage = load("res://art assets/Placeholder Art/UI Art/temple.png")
	var newMilMod = milModScene.instantiate()
	newMilMod.buildSelf(kitType)
	kitMilMod = newMilMod
	pass
