extends Control
class_name Unit

var playerCountry: country

var unitType: String
var unitLevel: int

var unitDefensiveScore: float    # melee block as decimal (0.0-1.0)
var unitOffensiveScore: float    # melee attack
var unitRangedOffence: float     # ranged attack
var unitRangedDefence: float     # ranged block as decimal
var unitMagicDefence: float      # spell block as decimal

var weaponOffence: float
var weaponDefence: float
var weaponRangedOffence: float
var weaponRangedDefence: float
var weaponSpellDefence: float
var weaponMaxShield: float

var oreMaxShield: float

var armorMeleeBlock: float
var armorRangedBlock: float
var armorSpellBlock: float

var unitOre: ore
var unitWeapon: Weapon
var weaponString: String
var unitArmor: Armor

var unitImage: Texture2D

var unitMaxManpower: int
var unitCurrentManpower: int

var unitMaxWeapons: int
var unitCurrentWeapons: int

var unitShield: int
var unitMaxShield: int

# ============================================================
# NEW: Reload system
# ============================================================
var reloadCounter: int = 0  # counts down to 0 before unit can fire ranged
							 # 0 = ready to fire

var militaryModifierList: Array = []

var currentTerrain: String = ""   # set from inTile.terrain before calculateMilMods()
var currentStorm: String = ""     # set from inTile.stormType when inTile.stormActive

const milModScene = preload("res://mil_mod.tscn")
const weaponScene = preload("res://weapon.tscn")
const oreScene    = preload("res://ore.tscn")
const armorScene  = preload("res://armor.tscn")

signal getUnitInfo
signal updateArmy


func buildSelf(parentCountry, Type, Level, WeaponType, OreType, ArmorType, CurMan, CurWeapons) -> void:
	playerCountry = parentCountry
	unitType      = Type
	unitLevel     = Level

	var newWeapon = weaponScene.instantiate()
	unitWeapon    = newWeapon
	changeWeapon(WeaponType)

	var newOre = oreScene.instantiate()
	unitOre    = newOre
	changeOre(OreType)

	var newArmor = armorScene.instantiate()
	unitArmor    = newArmor
	changeArmor(ArmorType)

	unitCurrentManpower = CurMan
	unitCurrentWeapons  = CurWeapons
	reloadCounter       = 0  # start ready to fire
	getUnitAttributes()


func getUnitAttributes() -> void:
	# Reset all scores before recalculating
	unitOffensiveScore = 0
	unitDefensiveScore = 0
	unitRangedOffence  = 0
	unitRangedDefence  = 0
	unitMagicDefence   = 0
	unitMaxShield      = 0
	unitMaxManpower    = (100 * unitLevel)
	unitMaxWeapons     = (100 * unitLevel)

	for MilMod in militaryModifierList:
		removeMilMod(MilMod)

	emit_signal("getUnitInfo", unitType, self)
	calculateWeaponsOresArmor()
	calculateGrossValues()

	# FIX: Initialize shield to max after calculating max
	# Shield starts full and depletes in combat
	if unitShield == 0 or unitShield > unitMaxShield:
		unitShield = unitMaxShield


func calculateWeaponsOresArmor() -> void:
	weaponOffence      = unitWeapon.weaponOffensiveIncrease
	weaponDefence      = unitWeapon.weaponDefensiveIncrease
	weaponRangedOffence= unitWeapon.rangedOffensiveIncrease
	weaponRangedDefence= unitWeapon.rangedDefensiveIncrease

	for MilMod in unitWeapon.weaponMilMods:
		addMilMod(MilMod)

	oreMaxShield = unitOre.oreMaxShield
	for MilMod in unitOre.oreMilMods:
		addMilMod(MilMod)

	# Use helper methods from updated armor.gd for decimal conversion
	armorMeleeBlock  = unitArmor.get_melee_block_decimal()
	armorRangedBlock = unitArmor.get_ranged_block_decimal()
	armorSpellBlock  = unitArmor.get_spell_block_decimal()

	for MilMod in unitArmor.armorMilMods:
		addMilMod(MilMod)


func calculateGrossValues() -> void:
	var manPowerEffect: float    = float(unitCurrentManpower) / float(max(1, unitMaxManpower))
	var weaponsPowerEffect: float= float(unitCurrentWeapons)  / float(max(1, unitMaxWeapons))

	# For artillery, weapons power matters more (need ammo to be effective)
	var effectMultiplier: float
	if unitWeapon.is_artillery():
		effectMultiplier = weaponsPowerEffect
	else:
		effectMultiplier = (manPowerEffect + weaponsPowerEffect) / 2.0

	# Apply melee penalty for muskets
	var meleePenalty = unitWeapon.get_melee_penalty()

	unitOffensiveScore += ((unitLevel * weaponOffence * meleePenalty) * effectMultiplier)
	unitRangedOffence  += ((unitLevel * weaponRangedOffence) * effectMultiplier)
	unitMaxShield      += (unitLevel * oreMaxShield)
	unitDefensiveScore += armorMeleeBlock   # already decimal 0.0-1.0
	unitRangedDefence  += armorRangedBlock
	unitMagicDefence   += armorSpellBlock


func calculateMilMods() -> void:
	if militaryModifierList == null:
		return
	for MilMod in militaryModifierList:
		if not MilMod.disabled:
			match MilMod.milModType:
				"AtlatlPierce":
					unitRangedOffence *= 1.05
				"ClubBleed":
					unitOffensiveScore *= 1.05
				"Copper":
					unitMagicDefence += (0.02 * unitLevel)
				"Gold":
					unitMagicDefence += (0.04 * unitLevel)
				"Scale":
					unitMaxShield += (unitLevel * 7)
				"Chain":
					unitRangedOffence += unitLevel
				"Cast":
					unitOffensiveScore += unitLevel
				"SaberCharge":
					pass  # handled in battle.gd
				"Bayonet":
					pass  # handled in unit can_melee()
				"CannonBlast":
					pass  # handled in battle.gd
				"MountedCharge":
					if unitWeapon.is_saber():
						unitOffensiveScore *= 1.2
				"GunCrewEfficiency":
					pass  # handled in battle.gd
				"ShockTroop":
					pass  # handled in battle.gd
				"DrillFormation":
					pass  # handled at army level
				"LineFormation":
					pass  # handled at army level
				# ── Tier 1 mods ──────────────────────────────────────────────
				"Woodsman":
					if currentTerrain == "Woods":
						unitOffensiveScore += (2 * unitLevel)
						unitDefensiveScore += (2 * unitLevel)
				"Swamp Legs":
					if currentTerrain == "Wetlands":
						unitOffensiveScore += (2 * unitLevel)
						unitDefensiveScore += (2 * unitLevel)
				"Hill Runner":
					if currentTerrain == "Foothills":
						unitOffensiveScore += (2 * unitLevel)
						unitDefensiveScore += (2 * unitLevel)
				"Street Tough":
					if currentTerrain == "Metro" or currentTerrain == "Suburbs":
						unitOffensiveScore += (2 * unitLevel)
				"Farmhand":
					if currentTerrain == "Farmlands":
						unitOffensiveScore += (1 * unitLevel)
				"Saber Drill":
					unitOffensiveScore += (3 * unitLevel)
				"Marksman":
					unitRangedOffence += (2 * unitLevel)
				"Steady Line":
					unitDefensiveScore += (3 * unitLevel)
				"Quick Reload":
					pass  # handled in start_reload()
				"Powder & Shot":
					unitRangedOffence += (3 * unitLevel)
				"Fortified Position":
					pass  # handled at army level (needs building check)
				"Coastal Watch":
					pass  # handled at army level (needs neighbor check)
				# ── Tier 2 mods ──────────────────────────────────────────────
				"Marine":
					pass  # handled in battle.gd (_army_marine_bonus)
				"Guerrilla Tactics":
					if currentTerrain == "Woods" or currentTerrain == "Wetlands":
						unitOffensiveScore += (4 * unitLevel)
						unitDefensiveScore += (4 * unitLevel)
				"Double Shot":
					pass  # handled in battle.gd
				"Iron Bayonet":
					pass  # handled in battle.gd first-round check
				"Sharpshooter":
					unitRangedOffence += (2 * unitLevel)  # base bonus; penetration handled in battle.gd
				"Corrupted Ground":
					pass  # handled in tile/world logic
				"Rallying Voice":
					pass  # handled in army morale logic
				"Night Raider":
					pass  # handled at army movement level
				"Flanking Drill":
					pass  # handled in battle.gd contested-tile check
				"Vanguard":
					pass  # handled in battle.gd first-engagement check
				"Siege Line":
					pass  # handled in battle.gd siege calculation
				"Cleaner":
					pass  # handled in tile/world logic
				# ── Tier 3 mods ──────────────────────────────────────────────
				"Entrenched":
					pass  # handled at army level (stationary turn counter)
				"Continental Line":
					unitOffensiveScore += (2 * unitLevel)
					unitDefensiveScore += (2 * unitLevel)
				"Last Stand":
					if float(unitCurrentManpower) / float(max(1, unitMaxManpower)) < 0.25:
						unitOffensiveScore += (6 * unitLevel)
				"Terror":
					pass  # handled in battle.gd morale drain
				"Iron Wall":
					pass  # handled at army level (home-tile check)
				"Rampart":
					pass  # handled at army level (fortress-tile check)
				"Naval Supremacy":
					pass  # handled at army level
				"Ghost March":
					pass  # handled at army movement level
				"Undaunted":
					pass  # handled in army death logic
				"Double Cannonade":
					pass  # handled in battle.gd
				"Liberator's Will":
					pass  # handled in world.gd conquest logic
				"The Long March":
					pass  # handled in army movement logic
				# ── Storm counter mods ────────────────────────────────────────
				"Fog-Born":
					if currentStorm == "Fog":
						unitOffensiveScore += (5 * unitLevel)
				"Storm Rider":
					pass  # movement exemption handled at army level
				"Thunder Proof":
					pass  # morale immunity handled at army level
				"Blizzard March":
					pass  # movement/supply exemption handled at army level
				"Hurricane Eyes":
					if currentStorm == "Hurricane":
						unitOffensiveScore += (5 * unitLevel)
				"Tornado Dancer":
					pass  # scatter immunity handled at army level
				"Nor'easter Veteran":
					if currentStorm == "Nor'easter":
						unitDefensiveScore += (3 * unitLevel)
				"Rain Reader":
					if currentStorm == "Thunderstorm":
						unitRangedOffence += (3 * unitLevel)
				"White Out Walker":
					if currentStorm == "Blizzard":
						unitOffensiveScore += (3 * unitLevel)
				"Storm Chaser":
					pass  # movement bonus handled at army level
				"Lightning Rod":
					pass  # artillery accuracy exemption handled in battle.gd
				"Eye of the Storm":
					if currentStorm != "":
						unitOffensiveScore += (4 * unitLevel)
						unitDefensiveScore += (4 * unitLevel)
				# ── Cultural mods ─────────────────────────────────────────────
				"Country Musician":
					if currentTerrain == "Farmlands":
						unitOffensiveScore += (2 * unitLevel)
				"Backcountry Rider":
					if currentTerrain == "Woods":
						unitOffensiveScore += (4 * unitLevel)
				"Frontier Marksman":
					if currentTerrain == "Foothills":
						unitRangedOffence += (4 * unitLevel)
				"Everglades Tracker":
					if currentTerrain == "Wetlands":
						unitOffensiveScore += (4 * unitLevel)
						unitDefensiveScore += (4 * unitLevel)
				"Bayou Warrior":
					if currentTerrain == "Wetlands":
						unitOffensiveScore += (5 * unitLevel)
				"Virginia Gentry":
					unitRangedDefence += (3 * unitLevel)
				"Minuteman's Pride":
					pass  # first-3-round bonus handled in battle.gd
				"Quaker Steel":
					unitDefensiveScore += (2 * unitLevel)
					unitOffensiveScore -= (1 * unitLevel)
				"Georgia Peach":
					unitRangedOffence += (1 * unitLevel)
				"Harbor Watch":
					pass  # near-naval bonus handled at army level
				"Chesapeake Sailor":
					unitOffensiveScore += (2 * unitLevel)
				"River Runner":
					pass  # movement + near-water bonus handled at army level
				# ── Mythic weapon mods ────────────────────────────────────────
				"BatSweep":
					unitOffensiveScore *= 1.10
				"TridentPierce":
					unitRangedOffence += (2 * unitLevel)
				"MythicAtlatl":
					unitRangedOffence += (2 * unitLevel)
				"SharpShot":
					unitRangedOffence += (4 * unitLevel)
				"PirateVolley":
					pass  # double-fire handled in battle.gd
				"CylinderFire":
					pass  # reload logic handled in start_reload()
				"RocketBarrage":
					unitRangedOffence += (5 * unitLevel)
				"TrebuchetLaunch":
					pass  # siege bonus handled in battle.gd
				"AerialBombing":
					unitRangedOffence += (3 * unitLevel)
				# ── Uniform mods ──────────────────────────────────────────────
				"QuickDraw":
					pass  # first-shot bonus handled in battle.gd
				"HardeeDisc":
					pass  # formation bonus handled at army level


# ============================================================
# RELOAD HELPERS
# ============================================================

func can_fire_ranged() -> bool:
	# Returns true if this unit is ready to fire
	# Artillery and muskets need to reload between shots
	if unitWeapon == null:
		return false
	if not unitWeapon.can_melee() or unitWeapon.is_musket() or unitWeapon.is_artillery():
		return reloadCounter <= 0
	return false  # sabers can't fire ranged at all

func can_charge_melee() -> bool:
	# Sabers can always charge, muskets can melee with bayonet
	# Artillery cannot melee
	if unitWeapon == null:
		return false
	return unitWeapon.can_melee()

func tick_reload() -> void:
	# Call each combat round for units that are reloading
	if reloadCounter > 0:
		reloadCounter -= 1

func start_reload() -> void:
	# Called after unit fires ranged attack
	reloadCounter = unitWeapon.reloadTurns
	# GunCrewEfficiency reduces reload by 1 (min 0)
	for MilMod in militaryModifierList:
		if MilMod.milModType == "GunCrewEfficiency":
			reloadCounter = max(0, reloadCounter - 1)
			break

func is_reloading() -> bool:
	return reloadCounter > 0

func get_effective_ranged_offence() -> float:
	# Returns 0 if reloading, full value if ready
	if is_reloading():
		return 0.0
	return unitRangedOffence

func get_weapons_cost_for_attack() -> int:
	# How many weapons does a ranged attack cost?
	if unitWeapon == null:
		return 0
	return unitWeapon.weaponsPerLevel * unitLevel


# ============================================================
# COMBAT: takeLosses — FIXED
# ============================================================

func takeLosses(type: String, amount: float) -> void:
	match type:
		"melee":
			# FIX: was += (adding health), now -= (subtracting)
			var blocked = amount * unitDefensiveScore
			var net_damage = max(0.0, amount - blocked)

			# Shield absorbs first
			if unitShield > 0:
				var shield_absorbed = min(unitShield, int(net_damage))
				unitShield -= shield_absorbed
				net_damage -= shield_absorbed

			unitCurrentManpower -= int(net_damage)

		"ranged":
			var blocked = amount * unitRangedDefence
			var net_damage = max(0.0, amount - blocked)

			if unitShield > 0:
				var shield_absorbed = min(unitShield, int(net_damage))
				unitShield -= shield_absorbed
				net_damage -= shield_absorbed

			unitCurrentManpower -= int(net_damage)

		"magic":
			var blocked = amount * unitMagicDefence
			var net_damage = max(0.0, amount - blocked)
			unitCurrentManpower -= int(net_damage)

	# Clamp manpower — can't go below 0
	unitCurrentManpower = max(0, unitCurrentManpower)


# ============================================================
# COMBAT: Saber charge — costs manpower but always available
# ============================================================

func apply_charge_cost() -> void:
	# Called when a saber unit charges in melee
	if unitWeapon != null and unitWeapon.is_saber():
		var cost = int(unitCurrentManpower * unitWeapon.chargeManpowerCost)
		unitCurrentManpower = max(1, unitCurrentManpower - cost)


# ============================================================
# HELPERS
# ============================================================

func is_alive() -> bool:
	return unitCurrentManpower > 0

func is_retreating() -> bool:
	# Unit should retreat when below 25% manpower
	return float(unitCurrentManpower) / float(max(1, unitMaxManpower)) < 0.25

func get_combat_effectiveness() -> float:
	# 0.0 to 1.0 — how effective is this unit right now?
	var man_ratio  = float(unitCurrentManpower) / float(max(1, unitMaxManpower))
	var weap_ratio = float(unitCurrentWeapons)  / float(max(1, unitMaxWeapons))
	if unitWeapon.is_saber():
		return man_ratio
	return (man_ratio + weap_ratio) / 2.0

func restore_shield() -> void:
	# Called at start of new engagement or after rest
	unitShield = unitMaxShield

func refillManpower(RR: int) -> void:
	unitCurrentManpower = min(unitMaxManpower, unitCurrentManpower + RR)


# ============================================================
# MIL MOD MANAGEMENT
# ============================================================

func addMilMod(mM) -> void:
	var newMilMod = milModScene.instantiate()
	newMilMod.buildSelf(mM.milModType)
	militaryModifierList.append(newMilMod)

func removeMilMod(milMod) -> void:
	if militaryModifierList.has(milMod):
		milMod.queue_free()
		militaryModifierList.erase(milMod)

func disableMilModType(Type: String) -> void:
	for MilMod in militaryModifierList:
		MilMod.disableMilModType(Type)

func enableMilModType(Type: String) -> void:
	for MilMod in militaryModifierList:
		MilMod.enableMilModType(Type)

func changeWeapon(Type: String) -> void:
	unitWeapon.updateSelf(Type)
	weaponString = Type

func changeArmor(Type: String) -> void:
	unitArmor.updateSelf(Type)

func changeOre(Type: String) -> void:
	unitOre.updateSelf(Type)
