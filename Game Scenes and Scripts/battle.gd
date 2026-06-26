extends Control
class_name Battle

var attacker: Army
var defender: Army
var battleType: String

# Manpower tracking — work in floats for precision, display as int
var defenderCurrentManpower: float
var defenderMaxManpower: float
var attackerCurrentManpower: float
var attackerMaxManpower: float

# Shield tracking
var defenderCurrentShield: float
var attackerCurrentShield: float

# Projected after-battle values
var projectedDefenderManpower: float
var projectedAttackerManpower: float
var projectedDefenderShield: float
var projectedAttackerShield: float

# Calculated damage amounts
var defenderManpowerLoss: int = 0
var attackerManpowerLoss: int = 0
var defenderShieldLoss: int = 0
var attackerShieldLoss: int = 0

# Weapon availability flags
var attackerCanMelee: bool = true
var attackerCanRanged: bool = false
var defenderCanCounter: bool = true


func buildSelf(type: String, army1: Army, army2: Army) -> void:
	battleType  = type
	attacker    = army1
	defender    = army2

	# Snapshot current state
	defenderCurrentManpower = float(defender.manpowerInArmy)
	defenderMaxManpower     = float(max(1, defender.maxManpower))
	attackerCurrentManpower = float(attacker.manpowerInArmy)
	attackerMaxManpower     = float(max(1, attacker.maxManpower))
	defenderCurrentShield   = float(defender.armyShield)
	attackerCurrentShield   = float(attacker.armyShield)

	# Determine what each army can do
	attackerCanMelee  = _army_can_melee(attacker)
	attackerCanRanged = _army_can_ranged(attacker)
	defenderCanCounter= _army_can_melee(defender) or _army_can_ranged(defender)

	# Calculate projected damage immediately for display
	_calculate_projected_damage()
	_update_display()


func _army_can_melee(army: Army) -> bool:
	# Army can melee if any unit has a melee-capable weapon
	for unit in army.unitsList:
		if unit.can_charge_melee():
			return true
	return false


func _army_can_ranged(army: Army) -> bool:
	# Army can fire ranged if any unit is ready to fire
	for unit in army.unitsList:
		if unit.can_fire_ranged():
			return true
	return false


func _calculate_projected_damage() -> void:
	match battleType:
		"melee":
			_calculate_melee_damage()
		"ranged":
			_calculate_ranged_damage()


func _calculate_melee_damage() -> void:
	# ── Attacker hits defender ──────────────────────────────
	# Raw melee damage from attacker's punch score
	var raw_attack = float(attacker.armyPunch) + _army_naval_supremacy_bonus(attacker)

	# Apply saber charge cost preview (attacker loses some manpower charging)
	var attacker_charge_loss: float = 0.0
	for unit in attacker.unitsList:
		if unit.unitWeapon != null and unit.unitWeapon.is_saber():
			attacker_charge_loss += float(unit.unitCurrentManpower) * unit.unitWeapon.chargeManpowerCost

	# ── First-engagement bonuses ────────────────────────────
	var n = attacker.attacksFromCurrentTile
	if n <= 1:
		# Iron Bayonet: +2/level on the very first charge
		raw_attack += _first_engage_bonus(attacker, "Iron Bayonet", 2.0)
		# Vanguard: +1/level on first engagement
		raw_attack += _first_engage_bonus(attacker, "Vanguard", 1.0)
	if n <= 3:
		# Minuteman's Pride: +4/level on first three engagements
		raw_attack += _first_engage_bonus(attacker, "Minuteman's Pride", 4.0)

	# ── SaberCharge: bonus vs unloaded (reloading) defenders ──
	if _army_has_siege_mod(attacker, "SaberCharge"):
		var defender_reloading = false
		for unit in defender.unitsList:
			if unit.is_reloading():
				defender_reloading = true
				break
		if defender_reloading:
			raw_attack *= 3.0 if _army_has_tempering(attacker) else 2.0

	# Defender's melee block reduces incoming damage (armyBlock is sum of unit blocks 0-1)
	# Normalize: if 3 units each have 0.15 block, total = 0.45, meaning 45% reduction
	var block_ratio = clamp(defender.armyBlock / max(1.0, float(defender.unitsList.size())), 0.0, 0.9)
	var net_to_defender = raw_attack * (1.0 - block_ratio)

	# ── CannonBlast: artillery units take 25% more from melee ──
	if _army_has_siege_mod(defender, "CannonBlast"):
		net_to_defender *= 1.25

	# Shield absorbs before manpower
	defenderShieldLoss = int(min(defenderCurrentShield, net_to_defender))
	var past_shield_damage = net_to_defender - float(defenderShieldLoss)
	defenderManpowerLoss = int(past_shield_damage)

	# ── Defender counter-attacks ────────────────────────────
	# Defender hits back simultaneously (melee is mutual)
	var counter_attack = float(defender.armyPunch)
	var attacker_block_ratio = clamp(attacker.armyBlock / max(1.0, float(attacker.unitsList.size())), 0.0, 0.9)
	var net_to_attacker = (counter_attack * (1.0 - attacker_block_ratio)) + attacker_charge_loss

	attackerShieldLoss = int(min(attackerCurrentShield, net_to_attacker))
	var past_attacker_shield = net_to_attacker - float(attackerShieldLoss)
	attackerManpowerLoss = int(past_attacker_shield)

	# ── Projected values ────────────────────────────────────
	projectedDefenderManpower = max(0.0, defenderCurrentManpower - float(defenderManpowerLoss))
	projectedAttackerManpower = max(0.0, attackerCurrentManpower - float(attackerManpowerLoss))
	projectedDefenderShield   = max(0.0, defenderCurrentShield   - float(defenderShieldLoss))
	projectedAttackerShield   = max(0.0, attackerCurrentShield   - float(attackerShieldLoss))


func _calculate_ranged_damage() -> void:
	# ── Attacker fires ranged ───────────────────────────────
	# Only units that are ready to fire contribute
	var effective_launch: float = 0.0
	for unit in attacker.unitsList:
		effective_launch += unit.get_effective_ranged_offence()

	# ── QuickDraw: +3/level on first ranged engagement ──────
	if attacker.attacksFromCurrentTile <= 1:
		effective_launch += _first_engage_bonus(attacker, "QuickDraw", 3.0)

	# Defender's ranged block
	var ranged_block_ratio = clamp(defender.armyDefence / max(1.0, float(defender.unitsList.size())), 0.0, 0.9)
	var net_ranged = effective_launch * (1.0 - ranged_block_ratio)

	# ── CannonBlast: bonus vs unshielded (×3, ×5 w/ Tempering); no penalty vs shield ──
	if _army_has_siege_mod(attacker, "CannonBlast"):
		if defenderCurrentShield <= 0:
			net_ranged *= 5.0 if _army_has_tempering(attacker) else 3.0

	defenderShieldLoss   = int(min(defenderCurrentShield, net_ranged))
	var past_shield      = net_ranged - float(defenderShieldLoss)
	defenderManpowerLoss = int(past_shield)

	# ── Ranged counter-attack ───────────────────────────────
	# Defender can return fire if they have ready ranged units
	# Artillery cannot counter-attack with melee at all
	var counter_ranged: float = 0.0
	for unit in defender.unitsList:
		counter_ranged += unit.get_effective_ranged_offence()

	if counter_ranged > 0.0:
		var attacker_ranged_block = clamp(attacker.armyDefence / max(1.0, float(attacker.unitsList.size())), 0.0, 0.9)
		var net_counter = counter_ranged * (1.0 - attacker_ranged_block)
		attackerShieldLoss   = int(min(attackerCurrentShield, net_counter))
		var past_atk_shield  = net_counter - float(attackerShieldLoss)
		attackerManpowerLoss = int(past_atk_shield)
	else:
		attackerShieldLoss   = 0
		attackerManpowerLoss = 0

	# ── Double Shot / Double Cannonade second volley ────────────────────────
	if _army_has_siege_mod(attacker, "Double Shot") or _army_has_siege_mod(attacker, "Double Cannonade"):
		var second_multiplier: float = 0.5  # Double Shot fires at half power
		var second_bonus: float = 0.0
		if _army_has_siege_mod(attacker, "Double Cannonade"):
			second_multiplier = 1.0
			second_bonus = float(_count_artillery(attacker)) * 3.0
		var second_launch: float = 0.0
		for unit in attacker.unitsList:
			if unit.unitWeapon != null and unit.unitWeapon.is_artillery():
				second_launch += unit.get_effective_ranged_offence() * second_multiplier
		second_launch += second_bonus
		if second_launch > 0.0:
			var second_net: float = second_launch * (1.0 - ranged_block_ratio)
			var remaining_shield: float = max(0.0, defenderCurrentShield - float(defenderShieldLoss))
			var second_shield_hit: int = int(min(remaining_shield, second_net))
			defenderShieldLoss   += second_shield_hit
			defenderManpowerLoss += int(second_net - float(second_shield_hit))

	# ── Projected values ────────────────────────────────────
	projectedDefenderManpower = max(0.0, defenderCurrentManpower - float(defenderManpowerLoss))
	projectedAttackerManpower = max(0.0, attackerCurrentManpower - float(attackerManpowerLoss))
	projectedDefenderShield   = max(0.0, defenderCurrentShield   - float(defenderShieldLoss))
	projectedAttackerShield   = max(0.0, attackerCurrentShield   - float(attackerShieldLoss))


func _update_display() -> void:
	# Update the battle UI with current and projected values
	var def_current_pct  = (defenderCurrentManpower  / defenderMaxManpower) * 100.0
	var def_projected_pct= (projectedDefenderManpower / defenderMaxManpower) * 100.0
	var atk_current_pct  = (attackerCurrentManpower   / attackerMaxManpower) * 100.0
	var atk_projected_pct= (projectedAttackerManpower  / attackerMaxManpower) * 100.0

	$EnemyManLosses.value  = def_current_pct
	$EnemyManLosses2.value = def_projected_pct

	# Display stats
	match battleType:
		"melee":
			$Label4.text = str(attacker.armyShield)
			$Label5.text = str(attacker.armyPunch)
			$Label6.text = str(int(attacker.armyBlock * 100), "%")
			$Label7.text = str(defender.armyShield)
			$Label8.text = str(int(defender.armyBlock * 100), "%")
			$Label9.text = str(defender.armyPunch)
		"ranged":
			$Label4.text = str(attacker.armyShield)
			$Label5.text = str(attacker.armyLaunch)
			$Label6.text = str(int(attacker.armyDefence * 100), "%")
			$Label7.text = str(defender.armyShield)
			$Label8.text = str(int(defender.armyDefence * 100), "%")
			$Label9.text = str(defender.armyLaunch)

	# Show reload status if relevant
	if battleType == "ranged":
		var reloading_count = 0
		for unit in attacker.unitsList:
			if unit.is_reloading():
				reloading_count += 1
		if reloading_count > 0:
			$Label5.text += str(" (", reloading_count, " reloading)")


# ============================================================
# APPLY RESULTS — called when player clicks Attack button
# ============================================================

signal sendAttackerResults
signal sendDefenderResults
signal deleteBattles

func applyBattleResults() -> void:
	# Send actual calculated losses to both armies
	emit_signal("sendDefenderResults", battleType, defenderManpowerLoss)
	emit_signal("sendAttackerResults", battleType, attackerManpowerLoss)

	# Handle reload for ranged attacks
	if battleType == "ranged":
		_apply_reload_to_attacker()

	# Apply saber charge manpower cost
	if battleType == "melee":
		_apply_charge_costs()

	_apply_combat_status_effects()

	# Field Research (ARC_03 lvl 2): science = 20% of damage dealt
	if attacker != null and defenderManpowerLoss > 0 and attacker.parentCountry != null:
		if attacker._army_has_active_mod("Field Research"):
			attacker.parentCountry.TotalScience += max(1, int(float(defenderManpowerLoss) * 0.2))

	# Commander XP
	var defender_killed: bool = (defender != null and
			defender.manpowerInArmy - defenderManpowerLoss <= 0)
	var attacker_killed: bool = (attacker != null and
			attacker.manpowerInArmy - attackerManpowerLoss <= 0)
	if attacker != null and attacker.commander != null:
		attacker.commander.xp += _calc_combat_xp(
				defenderManpowerLoss, attackerManpowerLoss, defender_killed)
	if defender != null and defender.commander != null:
		if battleType == "ranged":
			if not defender_killed:
				defender.commander.xp += 15.0
		else:
			defender.commander.xp += _calc_combat_xp(
					attackerManpowerLoss, defenderManpowerLoss, attacker_killed)

	emit_signal("deleteBattles")


func _calc_combat_xp(dealt: int, received: int, enemy_killed: bool) -> float:
	var ratio: float = float(dealt) / max(1.0, float(received))
	var base: float
	if ratio >= 1.5:
		base = 30.0
	elif ratio >= 1.25:
		base = 20.0
	else:
		base = 10.0
	if enemy_killed:
		base += 10.0
	return base


func _apply_reload_to_attacker() -> void:
	# Tell attacker units that fired to start reloading
	for unit in attacker.unitsList:
		if not unit.is_reloading() and (unit.unitWeapon.is_musket() or unit.unitWeapon.is_artillery()):
			unit.start_reload()
		else:
			unit.tick_reload()


func _apply_charge_costs() -> void:
	# Saber charge costs manpower even when attacking
	for unit in attacker.unitsList:
		if unit.unitWeapon != null and unit.unitWeapon.is_saber():
			unit.apply_charge_cost()


func _army_has_siege_mod(army: Army, mod_name: String) -> bool:
	for unit in army.unitsList:
		for mm in unit.militaryModifierList:
			if mm.milModType == mod_name and not mm.disabled:
				return true
	return false

func _army_has_tempering(army: Army) -> bool:
	if army.parentCountry == null:
		return false
	for tech in army.parentCountry.unlockedTechnologies:
		if tech.techName == "Tempuring":
			return true
	return false

func _first_engage_bonus(army: Army, mod_name: String, bonus_per_level: float) -> float:
	var bonus: float = 0.0
	for unit in army.unitsList:
		for mm in unit.militaryModifierList:
			if mm.milModType == mod_name and not mm.disabled:
				bonus += bonus_per_level * float(unit.unitLevel)
				break
	return bonus

func _count_artillery(army: Army) -> int:
	var count: int = 0
	for unit in army.unitsList:
		if unit.unitWeapon != null and unit.unitWeapon.is_artillery():
			count += 1
	return count

func _army_naval_supremacy_bonus(army: Army) -> float:
	# "Naval Supremacy" mod: +5 melee damage per unit level when attacking from a naval PPB
	if army.inTile == null:
		return 0.0
	var bonus: float = 0.0
	for unit in army.unitsList:
		for mm in unit.militaryModifierList:
			if mm.milModType == "Naval Supremacy" and not mm.disabled:
				bonus += 5.0 * float(unit.unitLevel)
				break
	return bonus

func _apply_combat_status_effects() -> void:
	# Rout check: >40% manpower lost in one battle
	if defenderCurrentManpower > 0:
		if float(defenderManpowerLoss) / defenderCurrentManpower >= 0.4:
			defender.apply_status("Routed", 2)
	if attackerCurrentManpower > 0:
		if float(attackerManpowerLoss) / attackerCurrentManpower >= 0.4:
			attacker.apply_status("Routed", 2)

	# Protector buffs that retaliate against attackers
	if defender._has_status("Bell Witch's Harassment"):
		attacker.apply_status("Demoralized", 2)
	if defender._has_status("Headless Terror"):
		attacker.apply_status("Terrified", 2)
	if defender._has_status("Le Gougou's Terror"):
		attacker.apply_status("Terrified", 3)

	# Weapon-based status effects applied to the defender
	for unit in attacker.unitsList:
		if unit.unitWeapon == null:
			continue
		match unit.unitWeapon.weaponType:
			"Baseball Bat":
				defender.apply_status("Shaken", 1)
			"Trident":
				defender.apply_status("Terrified", 2)
			"Mythic Atlatl":
				defender.apply_status("Stunned", 1)
			"Sharps Carbine":
				defender.apply_status("Blinded", 1)
			"Blackbeard's Pistols":
				defender.apply_status("Terrified", 2)
			"Colt Revolver":
				defender.apply_status("Shaken", 1)
			"Early Rockets":
				defender.apply_status("Burning", 2)
				defender.apply_status("Suppressed", 1)
			"Trebuchet":
				if battleType == "ranged":
					defender.apply_status("Stunned", 1)
			"Wright Flyer":
				defender.apply_status("Suppressed", 1)

func _on_attack_button_pressed() -> void:
	applyBattleResults()


# ============================================================
# ARMY HELPERS — added to army.gd
# ============================================================
# Add these functions to army.gd alongside existing calculateDefenderResults:

# func calculateDefenderResults(type, manpowerLossAmount):
#     var damagePerUnit = manpowerLossAmount / max(1, unitCount)
#     for Unit in unitsList:
#         Unit.takeLosses(type, float(damagePerUnit))
#     surveySelf()
#     if manpowerInArmy <= 0:
#         deleteMode = true
#     elif float(manpowerInArmy) / float(maxManpower) < 0.25:
#         inRetreat = true   # RETREAT TRIGGER

# func calculateAttackerResults(type, manpowerLossAmount):
#     # Mirror of calculateDefenderResults — attacker takes counter damage
#     var damagePerUnit = manpowerLossAmount / max(1, unitCount)
#     for Unit in unitsList:
#         Unit.takeLosses(type, float(damagePerUnit))
#     surveySelf()
#     if manpowerInArmy <= 0:
#         deleteMode = true
#     elif float(manpowerInArmy) / float(maxManpower) < 0.25:
#         inRetreat = true

# In army.gd calculateBattle(), add alongside existing sendDefenderResults connect:
#     newBattle.sendAttackerResults.connect(calculateAttackerResults)
