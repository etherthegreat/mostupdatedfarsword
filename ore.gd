extends Node2D

class_name ore

var oreType: String
var oreImage: Texture

func buildSelf():
	if oreType == "Copper":
		oreImage = load("res://art assets/finishedAssets/ores/copper60.png")
	if oreType == "Iron":
		oreImage = load("res://art assets/finishedAssets/ores/iron 60 (1).png")
	if oreType == "Wood":
		oreImage = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png")
	if oreType == "Gold":
		oreImage = load("res://art assets/finishedAssets/ores/gold 60.png")
	if oreType == "Floodstone":
		oreImage = load("res://art assets/finishedAssets/ores/floodstone 60.png")
