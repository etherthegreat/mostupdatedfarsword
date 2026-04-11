extends Node2D


class_name Weapon

var weaponType: String

var weaponOffensiveIncrease: int
var weaponDefensiveIncrease: int
var rangedOffensiveIncrease: int
var rangedDefensiveIncrease: int
var weaponImage: Texture2D

var weaponsPerLevel: int #how many weapons are used per level 

var weaponMilMods: Array

var milModScene = load("res://mil_mod.tscn")

func updateSelf(newType):
	if weaponMilMods != null:
		for MilMod in weaponMilMods:
			MilMod.queue_free()
			weaponMilMods.erase(MilMod)
	weaponOffensiveIncrease = 0
	weaponDefensiveIncrease = 0
	rangedOffensiveIncrease = 0
	rangedDefensiveIncrease = 0
	match weaponType:
		"Atlatl":
			rangedOffensiveIncrease += 2
			rangedDefensiveIncrease += 2
			weaponImage = load("res://art assets/finishedAssets/Weapons/atlatl.png")
			addWeaponMod("AtlatlPierce")
		"Club":
			weaponOffensiveIncrease += 2
			weaponDefensiveIncrease += 2
			weaponImage= load("res://art assets/finishedAssets/Weapons/Club.png")
			addWeaponMod("ClubBleed")
		"Double Axe":
			weaponOffensiveIncrease += 4
			weaponImage = load("res://art assets/finishedAssets/Weapons/Double_Axe.png")
		"Flail":
			weaponOffensiveIncrease += 1
			weaponDefensiveIncrease += 2
			rangedDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Flail.png")
		"Longsword":
			weaponOffensiveIncrease += 3
			rangedDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Longsword.png")
		"Mace":
			weaponOffensiveIncrease += 2
			weaponDefensiveIncrease += 1
			rangedDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Mace.png")
		"Machete":
			weaponOffensiveIncrease += 2
			rangedDefensiveIncrease += 2
			weaponImage = load("res://art assets/finishedAssets/Weapons/Machete.png")
		"Macuahuitl":
			weaponOffensiveIncrease += 3
			weaponDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Macuahuitl.png")
		"Pike":
			weaponOffensiveIncrease += 1
			weaponDefensiveIncrease += 3
			weaponImage = load("res://art assets/finishedAssets/Weapons/Pike.png")
		"Shortsword":
			weaponDefensiveIncrease += 2
			rangedDefensiveIncrease += 2
			weaponImage = load("res://art assets/finishedAssets/Weapons/Shortsword.png")
		"Tomahawk":
			weaponOffensiveIncrease += 1
			rangedOffensiveIncrease += 3
			weaponImage = load("res://art assets/finishedAssets/Weapons/Single_Axe.png")
		"Spear":
			weaponOffensiveIncrease += 1
			weaponDefensiveIncrease += 1
			rangedOffensiveIncrease += 1
			rangedDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Spear.png")
	pass

func addWeaponMod(modType):
	milModScene.instantiate()
	milModScene.buildSelf(modType)
	weaponMilMods.append(milModScene)
