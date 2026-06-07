extends Control

class_name Tool

var toolName: String
var toolImage: Texture

var toolFoodCost: int
var toolWoodCost: int
var toolGoldCost: int
var toolMetalCost: int
var toolMagicCost: int
var toolScienceCost: int
var toolFaithCost: int
var toolMandateCost: int
var toolHarmonyCost: int
var toolManpowerCost: int
var toolInfluenceCost: int
var toolWeaponsCost: int

var toolMilMod: MilMod

var milModScene = load("res://mil_mod.tscn")

func buildSelf(Name):
	toolName = Name
	match toolName:
		"Dictionary":
			toolImage = load("res://art assets/Placeholder Art/UI Art/resources/Science.png")
			var newMilMod = milModScene.instantiate()
			newMilMod.buildSelf("Translator")
			toolMilMod = newMilMod
		"Seed Bag":
			toolImage = load("res://art assets/Placeholder Art/UI Art/resources/food.png")
			var newMilMod = milModScene.instantiate()
			newMilMod.buildSelf("Seeder")
			toolMilMod = newMilMod
		"Wooden Tools":
			toolImage = load("res://art assets/Placeholder Art/UI Art/resources/wood.png")
			var newMilMod = milModScene.instantiate()
			newMilMod.buildSelf("Wooden Tools")
			toolMilMod = newMilMod
		"Metal Tools":
			toolImage = load("res://art assets/Placeholder Art/UI Art/resources/Metal.png")
			var newMilMod = milModScene.instantiate()
			newMilMod.buildSelf("Metal Tools")
			toolMilMod = newMilMod
		"Steel Tools":
			toolImage = load("res://art assets/Placeholder Art/UI Art/resources/weapons.png")
			var newMilMod = milModScene.instantiate()
			newMilMod.buildSelf("Steel Tools")
			toolMilMod = newMilMod
		"Pickaxe":
			toolImage = load("res://art assets/Placeholder Art/UI Art/resources/Metal.png")
			var newMilMod = milModScene.instantiate()
			newMilMod.buildSelf("Pickaxe")
			toolMilMod = newMilMod
	pass
