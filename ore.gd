extends Node2D

class_name ore

var oreType: String
var oreImage: Texture

func buildSelf():
	match oreType:
		"Copper":
			oreImage = load("res://art assets/finishedAssets/ores/Copper.PNG")
		"Iron":
			oreImage = load("res://art assets/finishedAssets/ores/Iron.PNG")
		"Wood":
			oreImage = load("res://art assets/finishedAssets/ores/Wood.PNG")
		"Gold":
			oreImage = load("res://art assets/finishedAssets/ores/Gold.PNG")
		"Floodstone":
			oreImage = load("res://art assets/finishedAssets/ores/Floodstone.PNG")
		"Gems":
			oreImage = load("res://art assets/finishedAssets/ores/Emerald.PNG")
		"Ivoroid":
			oreImage = load("res://art assets/finishedAssets/ores/Ivoroid.PNG")
		"Marble":
			oreImage = load("res://art assets/finishedAssets/ores/Marble.PNG")
		"Moonbone":
			oreImage = load("res://art assets/finishedAssets/ores/Moonbone.PNG")
		"Zylfire":
			oreImage = load("res://art assets/finishedAssets/ores/Zylfire.PNG")
