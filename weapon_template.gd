extends Node2D

class_name WeaponTemplate

var weaponType: String

var weaponOffensiveIncrease: int
var weaponDefensiveIncrease: int

var bleed: bool = false
var charge: bool = false
var slash: bool = false
var pierce: bool = false
var ranged: bool = false
var melee: bool = false

var weaponImage: Texture2D

func buildSelf():
	weaponOffensiveIncrease = 0
	weaponDefensiveIncrease = 0
	match weaponType:
		# ── SABRE ────────────────────────────────────────────────────────────
		"Cutlass":
			weaponOffensiveIncrease = 2
			weaponDefensiveIncrease = 1
			melee = true
			slash = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/cutlass.png")
		"Cavalry Sword":
			weaponOffensiveIncrease = 3
			weaponDefensiveIncrease = 2
			melee = true
			slash = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/cavalry_sword.png")
		"Officer Sword":
			weaponOffensiveIncrease = 4
			weaponDefensiveIncrease = 3
			melee = true
			slash = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/officer_sword.png")
		"Marine Mameluke":
			weaponOffensiveIncrease = 5
			weaponDefensiveIncrease = 3
			melee = true
			slash = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/marine_mameluke.png")
		# ── RIFLES ───────────────────────────────────────────────────────────
		"Flintlock":
			weaponOffensiveIncrease = 2
			weaponDefensiveIncrease = 1
			ranged = true
			pierce = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/Flintlock.png")
		"Brown Bess":
			weaponOffensiveIncrease = 3
			weaponDefensiveIncrease = 1
			ranged = true
			pierce = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/Brown_Bess.png")
		"Percussion Cap":
			weaponOffensiveIncrease = 4
			weaponDefensiveIncrease = 1
			ranged = true
			pierce = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/Percussion_Cap.png")
		"Breechloader":
			weaponOffensiveIncrease = 4
			weaponDefensiveIncrease = 2
			ranged = true
			pierce = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/Percussion_Cap.png")
		"Lever Repeater":
			weaponOffensiveIncrease = 5
			weaponDefensiveIncrease = 2
			ranged = true
			pierce = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/Lever_Repeater.png")
		# ── ARTILLERY ────────────────────────────────────────────────────────
		"Field Cannon":
			weaponOffensiveIncrease = 3
			weaponDefensiveIncrease = 1
			ranged = true
			pierce = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/Howitzer.png")
		"Howitzer":
			weaponOffensiveIncrease = 4
			weaponDefensiveIncrease = 1
			ranged = true
			pierce = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/Howitzer.png")
		"Mortar":
			weaponOffensiveIncrease = 5
			weaponDefensiveIncrease = 1
			ranged = true
			pierce = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/Mortar.png")
		"Early Rockets":
			weaponOffensiveIncrease = 6
			weaponDefensiveIncrease = 1
			ranged = true
			pierce = true
			weaponImage = load("res://art assets/finishedAssets/Weapons/Early_Rockets.png")
