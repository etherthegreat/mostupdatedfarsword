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
	var raw_attack = float(attacker.armyPunch)

	# Apply saber charge cost preview (attacker loses some manpower charging)
	var attacker_charge_loss: float = 0.0
	for unit in attacker.unitsList:
		if unit.unitWeapon != null and unit.unitWeapon.is_saber():
			attacker_charge_loss += float(unit.unitCurrentManpower) * unit.unitWeapon.chargeManpowerCost

	# Defender's melee block reduces incoming damage (armyBlock is sum of unit blocks 0-1)
	# Normalize: if 3 units each have 0.15 block, total = 0.45, meaning 45% reduction
	var block_ratio = clamp(defender.armyBlock / max(1.0, float(defender.unitsList.size())), 0.0, 0.9)
	var net_to_defender = raw_attack * (1.0 - block_ratio)

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

	# Defender's ranged block
	var ranged_block_ratio = clamp(defender.armyDefence / max(1.0, float(defender.unitsList.size())), 0.0, 0.9)
	var net_ranged = effective_launch * (1.0 - ranged_block_ratio)

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

	emit_signal("deleteBattles")


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

func _count_artillery(army: Army) -> int:
	var count: int = 0
	for unit in army.unitsList:
		if unit.unitWeapon != null and unit.unitWeapon.is_artillery():
			count += 1
	return count

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
