extends Control

class_name Battle

var attacker: Army
var defender: Army

var defenderManpower: int
var attackerManpower: int

func buildSelf(type, army1, army2):
	attacker = army1
	defender = army2
	defenderManpower = defender.manpowerInArmy
	#$EnemyManLosses.Value = ((defender.manpowerInArmy/defender.maxManpower)*100)
	attackerManpower = attacker.manpowerInArmy
	match type:
		"melee":
			$Label4.text = str(attacker.armyShield)
			$Label5.text = str(attacker.armyPunch)
			$Label6.text = str(attacker.armyBlock)
			$Label7.text = str(defender.armyShield)
			$Label8.text = str(defender.armyBlock)
			$Label9.text = str(defender.armyPunch)
			defenderManpower -= (attacker.armyPunch - (attacker.armyPunch * defender.armyBlock))
			#$EnemyManLosses2.Value = ((defenderManpower/defender.maxManpower)*100)
			pass
		"ranged":
			pass
	pass

signal sendAttackerResults
signal sendDefenderResults
signal deleteBattles
func applyBattleResults():
	var defendingManpowerLoss: int
	defendingManpowerLoss = defender.manpowerInArmy - defenderManpower
	emit_signal("sendAttackerResults")
	emit_signal("sendDefenderResults", defendingManpowerLoss)
	emit_signal("deleteBattles")
	pass

func _on_attack_button_pressed() -> void:
	applyBattleResults()
	pass # Replace with function body.
