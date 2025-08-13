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
	if weaponType == "Atlatl":
		weaponOffensiveIncrease += 2
		weaponDefensiveIncrease += 1
		ranged = true
		pierce = true
		weaponImage = load("res://art assets/Placeholder Art/atlatl.png")
		return
	if weaponType == "Club":
		weaponOffensiveIncrease += 2
		weaponDefensiveIncrease += 2
		melee = true
		weaponImage= load("res://art assets/Placeholder Art/club.png")
		return
	if weaponType == "Spear":
		weaponOffensiveIncrease += 3
		weaponDefensiveIncrease += 3
		slash = true
		melee = true
		weaponImage = load("res://art assets/Placeholder Art/sword.png")
		return
