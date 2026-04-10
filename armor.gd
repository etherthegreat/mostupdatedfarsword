extends Node2D


class_name Armor

var armorType: String

var armorWeaponsPerLevel: int

var armorMeleeBlock: int
var armorRangedBlock: int
var armorSpellBlock: int
var weaponImage: Texture2D

var armorMilMods: Array = []

func updateSelf(newType):
	if armorMilMods != null:
		for MilMod in armorMilMods:
			MilMod.queue_free()
			armorMilMods.erase(MilMod)
	armorMeleeBlock = 0
	armorRangedBlock = 0
	armorSpellBlock = 0
	match armorType:
		"Canine":
			armorMeleeBlock = 15
			armorRangedBlock = 5
			armorSpellBlock = 30
			armorWeaponsPerLevel = 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/atlatl.png")
		"Cast":
			armorMeleeBlock = 15
			armorRangedBlock = 10
			armorSpellBlock = 25
			armorWeaponsPerLevel = 20
			weaponImage= load("res://art assets/finishedAssets/Weapons/Club.png")
		"Chain":
			armorMeleeBlock = 5
			armorRangedBlock = 40
			armorSpellBlock = 5
			armorWeaponsPerLevel = 15
			weaponImage = load("res://art assets/finishedAssets/Weapons/Double_Axe.png")
			addWeaponMod("Chain")
		"Archer":
			armorRangedBlock = 50
			armorWeaponsPerLevel = 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Flail.png")
		"Plate":
			armorMeleeBlock = 50
			armorWeaponsPerLevel = 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Longsword.png")
		"Padded":
			armorMeleeBlock = 10
			armorRangedBlock = 30
			armorSpellBlock = 10
			armorWeaponsPerLevel = 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Mace.png")
		"Scout":
			armorMeleeBlock = 16
			armorRangedBlock = 16
			armorSpellBlock = 16
			armorWeaponsPerLevel = 90
			weaponImage = load("res://art assets/finishedAssets/Weapons/Machete.png")
		"Scale":
			armorMeleeBlock = 28
			armorRangedBlock = 8
			armorSpellBlock = 14
			armorWeaponsPerLevel = 6
			weaponImage = load("res://art assets/finishedAssets/Weapons/Macuahuitl.png")
		"Shell":
			armorSpellBlock = 50
			armorWeaponsPerLevel = 2
			weaponImage = load("res://art assets/finishedAssets/Weapons/Pike.png")
			addWeaponMod("Shell")
		"Point":
			armorMeleeBlock = 25
			armorRangedBlock = 25
			armorWeaponsPerLevel = 55
			weaponImage = load("res://art assets/finishedAssets/Weapons/Shortsword.png")
		"Feline":
			armorMeleeBlock = 15
			armorRangedBlock = 5
			armorSpellBlock = 30
			armorWeaponsPerLevel = 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Single_Axe.png")
		"Otter":
			armorMeleeBlock = 15
			armorRangedBlock = 5
			armorSpellBlock = 30
			armorWeaponsPerLevel = 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Spear.png")
var milModScene = load("res://mil_mod.tscn")

func addWeaponMod(modType):
	milModScene.instantiate()
	milModScene.buildSelf(modType)
	armorMilMods.append(milModScene)
