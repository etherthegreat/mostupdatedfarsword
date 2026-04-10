extends Node2D

class_name ore

#ore determines shield, weight, and 

var oreType: String
var oreImage: Texture

var oreMaxShield: int

var oreMilMods: Array = []

const milModScene = preload("res://mil_mod.tscn")

func buildSelf(newOreType):
	if oreMilMods != null:
		for MilMod in oreMilMods:
			MilMod.queue_free()
			oreMilMods.erase(MilMod)
	oreType = newOreType 
	match oreType:
		"Copper":
			oreImage = load("res://art assets/finishedAssets/ores/Copper.PNG")
			oreMaxShield = 100 #base
			addMilMod("Copper")
		"Iron":
			oreImage = load("res://art assets/finishedAssets/ores/Iron.PNG")
			oreMaxShield = 130
			addMilMod("Iron")
		"Wood":
			oreImage = load("res://art assets/finishedAssets/ores/Wood.PNG")
			oreMaxShield = 45
			addMilMod("Wood")
		"Gold":
			oreImage = load("res://art assets/finishedAssets/ores/Gold.PNG")
			oreMaxShield = 60
			addMilMod("Gold")
		"Floodstone":
			oreImage = load("res://art assets/finishedAssets/ores/Floodstone.PNG")
			oreMaxShield = 115
		"Slime":
			oreImage = load("res://art assets/finishedAssets/ores/Emerald.PNG")
			oreMaxShield = 75
		"Ivoroid":
			oreImage = load("res://art assets/finishedAssets/ores/Ivoroid.PNG")
			oreMaxShield = 170
		"Marble":
			oreImage = load("res://art assets/finishedAssets/ores/Marble.PNG")
			oreMaxShield = 190
		"Moonbone":
			oreImage = load("res://art assets/finishedAssets/ores/Moonbone.PNG")
			oreMaxShield = 210
		"Zylfire":
			oreImage = load("res://art assets/finishedAssets/ores/Zylfire.PNG")
			oreMaxShield = 50

func addMilMod(type):
	var newMilMod = milModScene.instantiate()
	newMilMod.buildSelf(type)
	oreMilMods.append(newMilMod)
