extends Node2D
class_name Weapon
 
var weaponType: String
var weaponClass: String       # "Saber", "Musket", "Artillery", "Legacy"
var weaponLevel: int          # 1-4 within class
var reloadTurns: int          # 0 = no reload, 1-3 = turns to wait
var weaponOffensiveIncrease: int
var weaponDefensiveIncrease: int
var rangedOffensiveIncrease: int
var rangedDefensiveIncrease: int
var weaponsPerLevel: int      # ammo consumed per attack per level
var chargeManpowerCost: float # saber charge costs this % of current manpower
var weaponImage: Texture2D
var weaponMilMods: Array = []
var milModScene = preload("res://mil_mod.tscn")
 
func updateSelf(newType: String) -> void:
	weaponType = newType
	# Clear existing mil mods
	for MilMod in weaponMilMods:
		MilMod.queue_free()
	weaponMilMods.clear()
 
	# Reset all scores
	weaponOffensiveIncrease  = 0
	weaponDefensiveIncrease  = 0
	rangedOffensiveIncrease  = 0
	rangedDefensiveIncrease  = 0
	weaponsPerLevel          = 0
	chargeManpowerCost       = 0.0
	reloadTurns              = 0
	weaponClass              = "Legacy"
	weaponLevel              = 1
 
	match weaponType:
 
		# ============================================================
		# SABERS — melee only, always available, charge costs manpower
		# Art by Sister Spacedesk
		# ============================================================
		"Cutlass":
			weaponClass              = "Saber"
			weaponLevel              = 1
			weaponOffensiveIncrease  = 3
			weaponDefensiveIncrease  = 2
			rangedOffensiveIncrease  = 0
			rangedDefensiveIncrease  = 0
			reloadTurns              = 0
			weaponsPerLevel          = 0   # no ammo
			chargeManpowerCost       = 0.10
			weaponImage = load("res://art assets/finishedAssets/Weapons/cutlass.png")
			addWeaponMod("SaberCharge")

		"Cavalry Sword":
			weaponClass              = "Saber"
			weaponLevel              = 2
			weaponOffensiveIncrease  = 5
			weaponDefensiveIncrease  = 3
			reloadTurns              = 0
			weaponsPerLevel          = 0
			chargeManpowerCost       = 0.10
			weaponImage = load("res://art assets/finishedAssets/Weapons/cavalry_sword.png")
			addWeaponMod("SaberCharge")
			addWeaponMod("CavalryMorale")  # bonus vs infantry morale

		"Officer Sword":
			weaponClass              = "Saber"
			weaponLevel              = 3
			weaponOffensiveIncrease  = 7
			weaponDefensiveIncrease  = 4
			reloadTurns              = 0
			weaponsPerLevel          = 0
			chargeManpowerCost       = 0.10
			weaponImage = load("res://art assets/finishedAssets/Weapons/officer_sword.png")
			addWeaponMod("SaberCharge")

		"Marine Mameluke":
			weaponClass              = "Saber"
			weaponLevel              = 4
			weaponOffensiveIncrease  = 9
			weaponDefensiveIncrease  = 5
			reloadTurns              = 0
			weaponsPerLevel          = 0
			chargeManpowerCost       = 0.10
			weaponImage = load("res://art assets/finishedAssets/Weapons/marine_mameluke.png")
			addWeaponMod("SaberCharge")
			addWeaponMod("HeavyCharge")  # extra punch damage on charge
 
 
		# ============================================================
		# MUSKETS — ranged primary, bayonet gives limited melee
		# consumes weapons on ranged attack, has reload delay
		# Sprites (Flintlock/Brown_Bess/Percussion_Cap/Lever_Repeater) by Sister Spacedesk
		# ============================================================
		"Flintlock":
			weaponClass              = "Musket"
			weaponLevel              = 1
			weaponOffensiveIncrease  = 1   # bayonet melee
			weaponDefensiveIncrease  = 1   # butt of rifle
			rangedOffensiveIncrease  = 4
			rangedDefensiveIncrease  = 1
			reloadTurns              = 2
			weaponsPerLevel          = 1
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Flintlock.png")
			addWeaponMod("Bayonet")
 
		"Brown Bess":
			weaponClass              = "Musket"
			weaponLevel              = 2
			weaponOffensiveIncrease  = 2
			weaponDefensiveIncrease  = 1
			rangedOffensiveIncrease  = 6
			rangedDefensiveIncrease  = 1
			reloadTurns              = 2
			weaponsPerLevel          = 1
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Brown_Bess.png")
			addWeaponMod("Bayonet")
			addWeaponMod("VolleyFire")  # bonus when multiple musket units fire
 
		"Percussion Cap":
			weaponClass              = "Musket"
			weaponLevel              = 3
			weaponOffensiveIncrease  = 2
			weaponDefensiveIncrease  = 2
			rangedOffensiveIncrease  = 8
			rangedDefensiveIncrease  = 2
			reloadTurns              = 1   # faster reload
			weaponsPerLevel          = 1
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Percussion_Cap.png")
			addWeaponMod("Bayonet")
 
		"Lever Repeater":
			weaponClass              = "Musket"
			weaponLevel              = 4
			weaponOffensiveIncrease  = 3
			weaponDefensiveIncrease  = 2
			rangedOffensiveIncrease  = 10
			rangedDefensiveIncrease  = 2
			reloadTurns              = 0   # no reload — fires every turn
			weaponsPerLevel          = 2   # burns more ammo
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Lever_Repeater.png")
			addWeaponMod("Bayonet")
			addWeaponMod("RapidFire")
 
 
		# ============================================================
		# ARTILLERY — devastating ranged, zero melee, slow reload
		# no melee offensive or defensive at all
		# ============================================================
		"Falconet":
			weaponClass              = "Artillery"
			weaponLevel              = 1
			weaponOffensiveIncrease  = 0   # no melee
			weaponDefensiveIncrease  = 0   # no melee defence
			rangedOffensiveIncrease  = 12
			rangedDefensiveIncrease  = 0
			reloadTurns              = 3
			weaponsPerLevel          = 3   # heavy ammo cost
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Club.png")
			addWeaponMod("CannonBlast")
 
		"Field Gun":
			weaponClass              = "Artillery"
			weaponLevel              = 2
			weaponOffensiveIncrease  = 0
			weaponDefensiveIncrease  = 0
			rangedOffensiveIncrease  = 18
			rangedDefensiveIncrease  = 0
			reloadTurns              = 3
			weaponsPerLevel          = 3
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Club.png")
			addWeaponMod("CannonBlast")
			addWeaponMod("AreaDamage")  # hits multiple units
 
		"Howitzer":
			weaponClass              = "Artillery"
			weaponLevel              = 3
			weaponOffensiveIncrease  = 0
			weaponDefensiveIncrease  = 0
			rangedOffensiveIncrease  = 25
			rangedDefensiveIncrease  = 0
			reloadTurns              = 2
			weaponsPerLevel          = 4
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Club.png")
			addWeaponMod("CannonBlast")
			addWeaponMod("AreaDamage")
 
		"Mortar":
			weaponClass              = "Artillery"
			weaponLevel              = 4
			weaponOffensiveIncrease  = 0
			weaponDefensiveIncrease  = 0
			rangedOffensiveIncrease  = 35
			rangedDefensiveIncrease  = 0
			reloadTurns              = 2
			weaponsPerLevel          = 5
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Club.png")
			addWeaponMod("CannonBlast")
			addWeaponMod("AreaDamage")
			addWeaponMod("Siege")  # bonus vs fortified tiles
 
 
		# ============================================================
		# LEGACY WEAPONS — kept for DODK compatibility
		# ============================================================
		"Atlatl":
			weaponClass = "Legacy"
			rangedOffensiveIncrease += 2
			rangedDefensiveIncrease += 2
			weaponImage = load("res://art assets/finishedAssets/Weapons/atlatl.png")
			addWeaponMod("AtlatlPierce")
		"Club":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 2
			weaponDefensiveIncrease += 2
			weaponImage = load("res://art assets/finishedAssets/Weapons/Club.png")
			addWeaponMod("ClubBleed")
		"Double Axe":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 4
			weaponImage = load("res://art assets/finishedAssets/Weapons/Double_Axe.png")
		"Flail":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 1
			weaponDefensiveIncrease += 2
			rangedDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Flail.png")
		"Longsword":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 3
			rangedDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Longsword.png")
		"Mace":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 2
			weaponDefensiveIncrease += 1
			rangedDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Mace.png")
		"Machete":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 2
			rangedDefensiveIncrease += 2
			weaponImage = load("res://art assets/finishedAssets/Weapons/Machete.png")
		"Macuahuitl":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 3
			weaponDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Macuahuitl.png")
		"Pike":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 1
			weaponDefensiveIncrease += 3
			weaponImage = load("res://art assets/finishedAssets/Weapons/Pike.png")
		"Shortsword":
			weaponClass = "Legacy"
			weaponDefensiveIncrease += 2
			rangedDefensiveIncrease += 2
			weaponImage = load("res://art assets/finishedAssets/Weapons/Shortsword.png")
		"Tomahawk":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 1
			rangedOffensiveIncrease += 3
			weaponImage = load("res://art assets/finishedAssets/Weapons/Single_Axe.png")
		"Spear":
			weaponClass = "Legacy"
			weaponOffensiveIncrease += 1
			weaponDefensiveIncrease += 1
			rangedOffensiveIncrease += 1
			rangedDefensiveIncrease += 1
			weaponImage = load("res://art assets/finishedAssets/Weapons/Spear.png")


		# ============================================================
		# MYTHIC WEAPONS — Easter egg items, unlocked through events only
		# Cannot be built or purchased — must be found or granted via events
		# ============================================================
		"Baseball Bat":
			weaponClass              = "Mythic"
			weaponLevel              = 1
			weaponOffensiveIncrease  = 6
			weaponDefensiveIncrease  = 3
			rangedOffensiveIncrease  = 0
			rangedDefensiveIncrease  = 0
			reloadTurns              = 0
			weaponsPerLevel          = 0
			chargeManpowerCost       = 0.05
			weaponImage = load("res://art assets/finishedAssets/Weapons/Club.png")
			addWeaponMod("BatSweep")

		"Trident":
			weaponClass              = "Mythic"
			weaponLevel              = 2
			weaponOffensiveIncrease  = 8
			weaponDefensiveIncrease  = 5
			rangedOffensiveIncrease  = 4
			rangedDefensiveIncrease  = 0
			reloadTurns              = 1
			weaponsPerLevel          = 1
			chargeManpowerCost       = 0.05
			weaponImage = load("res://art assets/finishedAssets/Weapons/Spear.png")
			addWeaponMod("TridentPierce")

		"Mythic Atlatl":
			weaponClass              = "Mythic"
			weaponLevel              = 2
			weaponOffensiveIncrease  = 3
			weaponDefensiveIncrease  = 2
			rangedOffensiveIncrease  = 10
			rangedDefensiveIncrease  = 3
			reloadTurns              = 1
			weaponsPerLevel          = 1
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/atlatl.png")
			addWeaponMod("MythicAtlatl")

		"Sharps Carbine":
			weaponClass              = "Mythic"
			weaponLevel              = 3
			weaponOffensiveIncrease  = 2
			weaponDefensiveIncrease  = 2
			rangedOffensiveIncrease  = 14
			rangedDefensiveIncrease  = 2
			reloadTurns              = 1
			weaponsPerLevel          = 1
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Spear.png")
			addWeaponMod("SharpShot")

		"Blackbeard's Pistols":
			weaponClass              = "Mythic"
			weaponLevel              = 2
			weaponOffensiveIncrease  = 5
			weaponDefensiveIncrease  = 2
			rangedOffensiveIncrease  = 8
			rangedDefensiveIncrease  = 0
			reloadTurns              = 2
			weaponsPerLevel          = 2
			chargeManpowerCost       = 0.05
			weaponImage = load("res://art assets/finishedAssets/Weapons/Spear.png")
			addWeaponMod("PirateVolley")

		"Colt Revolver":
			weaponClass              = "Mythic"
			weaponLevel              = 3
			weaponOffensiveIncrease  = 3
			weaponDefensiveIncrease  = 2
			rangedOffensiveIncrease  = 12
			rangedDefensiveIncrease  = 1
			reloadTurns              = 0
			weaponsPerLevel          = 1
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Spear.png")
			addWeaponMod("CylinderFire")

		"Rocket Artillery":
			weaponClass              = "Mythic"
			weaponLevel              = 4
			weaponOffensiveIncrease  = 0
			weaponDefensiveIncrease  = 0
			rangedOffensiveIncrease  = 45
			rangedDefensiveIncrease  = 0
			reloadTurns              = 3
			weaponsPerLevel          = 6
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Club.png")
			addWeaponMod("RocketBarrage")

		"Trebuchet":
			weaponClass              = "Mythic"
			weaponLevel              = 3
			weaponOffensiveIncrease  = 0
			weaponDefensiveIncrease  = 2
			rangedOffensiveIncrease  = 30
			rangedDefensiveIncrease  = 0
			reloadTurns              = 4
			weaponsPerLevel          = 4
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Club.png")
			addWeaponMod("TrebuchetLaunch")

		"Wright Flyer":
			weaponClass              = "Mythic"
			weaponLevel              = 4
			weaponOffensiveIncrease  = 0
			weaponDefensiveIncrease  = 5
			rangedOffensiveIncrease  = 20
			rangedDefensiveIncrease  = 10
			reloadTurns              = 2
			weaponsPerLevel          = 3
			chargeManpowerCost       = 0.0
			weaponImage = load("res://art assets/finishedAssets/Weapons/Spear.png")
			addWeaponMod("AerialBombing")
 
 
func addWeaponMod(modType: String) -> void:
	var newMilMod = milModScene.instantiate()
	newMilMod.buildSelf(modType)
	weaponMilMods.append(newMilMod)
 
func is_saber() -> bool:
	return weaponClass == "Saber"
 
func is_musket() -> bool:
	return weaponClass == "Musket"
 
func is_artillery() -> bool:
	return weaponClass == "Artillery"

func is_mythic() -> bool:
	return weaponClass == "Mythic"

func can_melee() -> bool:
	if weaponClass == "Artillery":
		return false
	if weaponType == "Rocket Artillery" or weaponType == "Wright Flyer":
		return false
	return true
 
func get_melee_penalty() -> float:
	# Muskets are less effective in melee than sabers
	if weaponClass == "Musket":
		return 0.5  # half effectiveness in melee
	return 1.0
