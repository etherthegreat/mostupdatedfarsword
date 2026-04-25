extends Control

class_name Battle

var attacker: Army
var defender: Army

var battleType: String

var defenderManpower: float
var defenderMaxManpower: float
var defenderCurrentManPercent: float
var estimateBattleLosses: float
var attackerManpower: float

func buildSelf(type, army1, army2):
	battleType = type
	attacker = army1
	defender = army2
	defenderManpower = defender.manpowerInArmy
	defenderMaxManpower = defender.maxManpower
	defenderCurrentManPercent = ((defenderManpower/defenderMaxManpower))
	$EnemyManLosses.value = (defenderCurrentManPercent * 100)
	attackerManpower = attacker.manpowerInArmy
	print(defenderCurrentManPercent, "enemymanlosses", defenderManpower, defenderMaxManpower, attacker.armyPunch)
	match type:
		"melee":
			$Label4.text = str(attacker.armyShield)
			$Label5.text = str(attacker.armyPunch)
			$Label6.text = str(attacker.armyBlock)
			$Label7.text = str(defender.armyShield)
			$Label8.text = str(defender.armyBlock)
			$Label9.text = str(defender.armyPunch)
			defenderManpower += (attacker.armyPunch) #- (attacker.armyPunch * defender.armyBlock))
			estimateBattleLosses = (defenderManpower/defenderMaxManpower)
			$EnemyManLosses2.value = (estimateBattleLosses * 100)
			print(defenderCurrentManPercent, estimateBattleLosses, "enemymanlosses", defenderManpower, defenderMaxManpower)
			pass
		"ranged":
			$Label4.text = str(attacker.armyShield)
			$Label5.text = str(attacker.armyLaunch)
			$Label6.text = str(attacker.armyDefence)
			$Label7.text = str(defender.armyShield)
			$Label8.text = str(defender.armyDefence)
			$Label9.text = str(defender.armyLaunch)
			defenderManpower += (attacker.armyLaunch)
			estimateBattleLosses = (defenderManpower/defenderMaxManpower)
			$EnemyManLosses2.value = (estimateBattleLosses * 100)
			pass
	pass

signal sendAttackerResults
signal sendDefenderResults
signal deleteBattles
func applyBattleResults():
	var defendingManpowerLoss: int
	defendingManpowerLoss = defender.manpowerInArmy - defenderManpower
	emit_signal("sendAttackerResults")
	emit_signal("sendDefenderResults", battleType, defendingManpowerLoss)
	emit_signal("deleteBattles")
	pass

func _on_attack_button_pressed() -> void:
	applyBattleResults()
	pass # Replace with function body.
