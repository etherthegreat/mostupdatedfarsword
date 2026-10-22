extends Node2D

class_name ore

#ore determines shield, weight, and 

var oreType: String
var oreImage: Texture

var oreMaxShield: int

var oreMilMods: Array = []

const milModScene = preload("res://mil_mod.tscn")

func updateSelf(newOreType):
	if oreMilMods != null:
		for MilMod in oreMilMods:
			MilMod.queue_free()
			oreMilMods.erase(MilMod)
	oreType = newOreType 
	match oreType:
		"Copper":
			oreImage = load("res://art assets/finishedAssets/ores/Copper.PNG")
			oreMaxShield = 20 #base
			addMilMod("Copper")
		"Iron":
			oreImage = load("res://art assets/finishedAssets/ores/Iron.PNG")
			oreMaxShield = 26
			addMilMod("Iron")
		"Wood":
			oreImage = load("res://art assets/finishedAssets/ores/Wood.PNG")
			oreMaxShield = 9
			addMilMod("Wood")
		"Gold":
			oreImage = load("res://art assets/finishedAssets/ores/Gold.PNG")
			oreMaxShield = 12
			addMilMod("Gold")
		"Floodstone":
			oreImage = load("res://art assets/finishedAssets/ores/Floodstone.PNG")
			oreMaxShield = 23
		"Slime":
			oreImage = load("res://art assets/finishedAssets/ores/Emerald.PNG")
			oreMaxShield = 15
		"Ivoroid":
			oreImage = load("res://art assets/finishedAssets/ores/Ivoroid.PNG")
			oreMaxShield = 34
		"Marble":
			oreImage = load("res://art assets/finishedAssets/ores/Marble.PNG")
			oreMaxShield = 38
		"Moonbone":
			oreImage = load("res://art assets/finishedAssets/ores/Moonbone.PNG")
			oreMaxShield = 42
		"Zylfire":
			oreImage = load("res://art assets/finishedAssets/ores/Zylfire.PNG")
			oreMaxShield = 10

func addMilMod(type):
	var newMilMod = milModScene.instantiate()
	newMilMod.buildSelf(type)
	oreMilMods.append(newMilMod)
