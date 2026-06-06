extends Node2D
class_name Armor

# NOTE: "Armor" kept as class name for compatibility
# In Uprisings this represents the unit's uniform and equipment

var armorType: String
var armorClass: String        # "Uniform" or "Legacy"
var armorWeaponsPerLevel: int
var armorMeleeBlock: int      # % damage reduction vs melee (0-100)
var armorRangedBlock: int     # % damage reduction vs ranged
var armorSpellBlock: int      # % damage reduction vs magic/special
var armorImage: Texture2D
var armorMilMods: Array = []

var milModScene = load("res://mil_mod.tscn")

func updateSelf(newType: String) -> void:
	armorType = newType
	for MilMod in armorMilMods:
		MilMod.queue_free()
	armorMilMods.clear()

	armorMeleeBlock  = 0
	armorRangedBlock = 0
	armorSpellBlock  = 0
	armorClass       = "Legacy"

	match armorType:

		# ============================================================
		# UNIFORMS — Uprisings era clothing and equipment
		# Block values represent training, equipment quality, formation
		# ============================================================

		"Continental":
			# Standard Continental Army uniform
			# Balanced — drilled infantry, good all-round
			armorClass       = "Uniform"
			armorMeleeBlock  = 15
			armorRangedBlock = 20
			armorSpellBlock  = 10
			armorWeaponsPerLevel = 10
			armorImage = load("res://art assets/finishedAssets/Weapons/Scale.png") if ResourceLoader.exists("res://art assets/finishedAssets/Weapons/Scale.png") else null
			addWeaponMod("DrillFormation")  # bonus when adjacent to other Continental units

		"Redcoat":
			# British regular army — disciplined, strong in line formation
			armorClass       = "Uniform"
			armorMeleeBlock  = 20
			armorRangedBlock = 15
			armorSpellBlock  = 10
			armorWeaponsPerLevel = 10
			armorImage = load("res://art assets/finishedAssets/Weapons/Plate.png") if ResourceLoader.exists("res://art assets/finishedAssets/Weapons/Plate.png") else null
			addWeaponMod("LineFormation")   # bonus to ranged when in line

		"Militia":
			# Colonial militia — minimal training, mixed equipment
			# Cheap, plentiful, not very effective
			armorClass       = "Uniform"
			armorMeleeBlock  = 10
			armorRangedBlock = 10
			armorSpellBlock  = 5
			armorWeaponsPerLevel = 5
			armorImage = load("res://art assets/finishedAssets/Weapons/Padded.png") if ResourceLoader.exists("res://art assets/finishedAssets/Weapons/Padded.png") else null

		"Light Infantry":
			# Skirmishers, rangers — mobile, good ranged defense
			# Think: Morgan's Riflemen, Green Mountain Boys
			armorClass       = "Uniform"
			armorMeleeBlock  = 10
			armorRangedBlock = 30
			armorSpellBlock  = 10
			armorWeaponsPerLevel = 15
			armorImage = load("res://art assets/finishedAssets/Weapons/Scout.png") if ResourceLoader.exists("res://art assets/finishedAssets/Weapons/Scout.png") else null
			addWeaponMod("Skirmish")  # can move and fire in same turn

		"Heavy Infantry":
			# Elite assault troops — strong melee, poor vs ranged
			# Think: grenadiers, assault columns
			armorClass       = "Uniform"
			armorMeleeBlock  = 35
			armorRangedBlock = 10
			armorSpellBlock  = 10
			armorWeaponsPerLevel = 8
			armorImage = load("res://art assets/finishedAssets/Weapons/Plate.png") if ResourceLoader.exists("res://art assets/finishedAssets/Weapons/Plate.png") else null
			addWeaponMod("ShockTroop")   # bonus damage on first melee attack

		"Cavalry":
			# Mounted troops — mobile, strong melee charge, weak vs ranged
			# Best paired with Saber weapons
			armorClass       = "Uniform"
			armorMeleeBlock  = 25
			armorRangedBlock = 5
			armorSpellBlock  = 15
			armorWeaponsPerLevel = 5
			armorImage = load("res://art assets/finishedAssets/Weapons/Chain.png") if ResourceLoader.exists("res://art assets/finishedAssets/Weapons/Chain.png") else null
			addWeaponMod("MountedCharge")  # amplifies saber charge damage
			addWeaponMod("CavalryMorale")

		"Artillery Corps":
			# Gun crews — specialist artillery operators
			# Very weak defensively, meant to stay behind lines
			armorClass       = "Uniform"
			armorMeleeBlock  = 5
			armorRangedBlock = 5
			armorSpellBlock  = 20   # royal magic countered by scientific discipline
			armorWeaponsPerLevel = 20  # heavy equipment maintenance
			armorImage = load("res://art assets/finishedAssets/Weapons/Cast.png") if ResourceLoader.exists("res://art assets/finishedAssets/Weapons/Cast.png") else null
			addWeaponMod("GunCrewEfficiency")  # reduces artillery reload by 1

		"Minuteman":
			# The classic Uprisings unit — farmer-soldiers
			# Quick to mobilize, decent all-round for their cost
			armorClass       = "Uniform"
			armorMeleeBlock  = 12
			armorRangedBlock = 18
			armorSpellBlock  = 8
			armorWeaponsPerLevel = 8
			armorImage = load("res://art assets/finishedAssets/Weapons/Padded.png") if ResourceLoader.exists("res://art assets/finishedAssets/Weapons/Padded.png") else null
			addWeaponMod("MinutemanSpirit")  # bonus morale in home territory


		# ============================================================
		# LEGACY ARMORS — kept for DODK compatibility
		# ============================================================
		"Canine":
			armorMeleeBlock = 15; armorRangedBlock = 5; armorSpellBlock = 30
			armorWeaponsPerLevel = 1
			armorImage = load("res://art assets/finishedAssets/Weapons/atlatl.png")
		"Cast":
			armorMeleeBlock = 15; armorRangedBlock = 10; armorSpellBlock = 25
			armorWeaponsPerLevel = 20
			armorImage = load("res://art assets/finishedAssets/Weapons/Club.png")
		"Chain":
			armorMeleeBlock = 5; armorRangedBlock = 40; armorSpellBlock = 5
			armorWeaponsPerLevel = 15
			armorImage = load("res://art assets/finishedAssets/Weapons/Double_Axe.png")
			addWeaponMod("Chain")
		"Archer":
			armorRangedBlock = 50; armorWeaponsPerLevel = 1
			armorImage = load("res://art assets/finishedAssets/Weapons/Flail.png")
		"Plate":
			armorMeleeBlock = 50; armorWeaponsPerLevel = 1
			armorImage = load("res://art assets/finishedAssets/Weapons/Longsword.png")
		"Padded":
			armorMeleeBlock = 10; armorRangedBlock = 30; armorSpellBlock = 10
			armorWeaponsPerLevel = 1
			armorImage = load("res://art assets/finishedAssets/Weapons/Mace.png")
		"Scout":
			armorMeleeBlock = 16; armorRangedBlock = 16; armorSpellBlock = 16
			armorWeaponsPerLevel = 90
			armorImage = load("res://art assets/finishedAssets/Weapons/Machete.png")
		"Scale":
			armorMeleeBlock = 28; armorRangedBlock = 8; armorSpellBlock = 14
			armorWeaponsPerLevel = 6
			armorImage = load("res://art assets/finishedAssets/Weapons/Macuahuitl.png")
		"Shell":
			armorSpellBlock = 50; armorWeaponsPerLevel = 2
			armorImage = load("res://art assets/finishedAssets/Weapons/Pike.png")
			addWeaponMod("Shell")
		"Point":
			armorMeleeBlock = 25; armorRangedBlock = 25; armorWeaponsPerLevel = 55
			armorImage = load("res://art assets/finishedAssets/Weapons/Shortsword.png")
		"Feline":
			armorMeleeBlock = 15; armorRangedBlock = 5; armorSpellBlock = 30
			armorWeaponsPerLevel = 1
			armorImage = load("res://art assets/finishedAssets/Weapons/Single_Axe.png")
		"Otter":
			armorMeleeBlock = 15; armorRangedBlock = 5; armorSpellBlock = 30
			armorWeaponsPerLevel = 1
			armorImage = load("res://art assets/finishedAssets/Weapons/Spear.png")


func addWeaponMod(modType: String) -> void:
	var newMilMod = milModScene.instantiate()
	newMilMod.buildSelf(modType)
	armorMilMods.append(newMilMod)

func is_uniform() -> bool:
	return armorClass == "Uniform"

func get_melee_block_decimal() -> float:
	return armorMeleeBlock * 0.01

func get_ranged_block_decimal() -> float:
	return armorRangedBlock * 0.01

func get_spell_block_decimal() -> float:
	return armorSpellBlock * 0.01
