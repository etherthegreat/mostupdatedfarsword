extends Control

var armyPathFollowScene = preload("res://army_path_follow.tscn")

var listOfUpdatingArmyPaths: Array

var selectedAPF: armyPathFollow

var raisedPlayerAPFs: Array = []

func raisePlayerArmy(Army, country, Tile, pathPointToSend):
	var newAPF = armyPathFollowScene.instantiate()
	pathPointToSend.add_child(newAPF)
	raisedPlayerAPFs.append(newAPF)
	newAPF.apfSelected.connect(displayapfInfo)
	newAPF.movingArmy.connect(movingArmy)
	newAPF.armyArrived.connect(armyArrived)
	newAPF.armyTraveling.connect(updateTravelingArmy)
	newAPF.onRaise(Army, country, pathPointToSend)
	showPathPoints()
	pass

func updateTravelingArmy():
	
	pass

func movingArmy():
	#use these to disable features while the army is traveling
	$ArmyPanel/ArmyButtonsContainer.visible = false
	pass

func armyArrived(pathOfArmy):
	#use this to resume 
	$ArmyPanel/ArmyButtonsContainer.visible = true
	removeFromUpdateArmyPaths(pathOfArmy)
	pass

signal activateArmyControlMode
func displayapfInfo(thisArmy, apf, currentTile, thisCountry):
	updateArmyPanel(thisArmy)
	selectedAPF = apf
	emit_signal("activateArmyControlMode")
	pass

func updateArmyPanel(Army):
	$ArmyPanel/ArmyNameLabel.text = Army.ArmyName
	$ArmyPanel/AttackLabel.text = str(Army.armyAttackScore)
	$ArmyPanel/DefenseLabel.text = str(Army.armyDefenseScore)
	$ArmyPanel/RangedAttackLabel.text = str(Army.armyRangedAttack)
	$ArmyPanel/RangedDefenseLabel.text = str(Army.armyRangedDefense)
	$ArmyPanel/ManpowerLabel.text = str(Army.manpowerInArmy, " / ", Army.maxManpower)
	$ArmyPanel/ShieldLabel.text = str(Army.armyShield, " / ", Army.armyMaxShield)
	$ArmyPanel/LeaderSprite.texture = Army.commander.governorTexture
	$ArmyPanel/LeaderName.text = str(Army.commander.governorType)
	
	if $ArmyPanel.visible == false:
		$ArmyPanel.visible = true
	else:
		$ArmyPanel.visible = false
	pass

#"apfSelected", thisArmy, self, currentTile, thisCountry, currentPath, progress_ratio

func connectPathPoints():
	for pathPointButton in $PathPointsControl.get_children():
		pathPointButton.pathPointClicked.connect(calculateArmyMovement)
		pathPointButton.buildSelf()
	pass

func showPathPoints():
	for pathPointButton in $PathPointsControl.get_children():
		if pathPointButton.visible == false:
			pathPointButton.visible = true
	pass


func removeFromUpdateArmyPaths(path):
	listOfUpdatingArmyPaths.remove_at(path)
	pass

func _process(delta: float) -> void:
	if listOfUpdatingArmyPaths != null:
		for PathFollow2D in listOfUpdatingArmyPaths:
			var armyPathFollowRatio: armyPathFollow
			armyPathFollowRatio = PathFollow2D.get_children()
			PathFollow2D.progress_ratio = armyPathFollowRatio.progressRate
	pass

#incoming pathPointButtonSelf is different from the selectedAPF.  if we give the selectedAPF it's own
#pathPointButton, we could compare them.
func calculateArmyMovement(pathPointButtonSelf, neighborPathPoints, endNodePaths, startNodePaths):
	var startingPoint = selectedAPF.currentPathPoint
	var endPoint = pathPointButtonSelf
	print("DEBUG Calculate")
	for Path2D in endPoint.endNodePaths: 
		if startingPoint.startNodePaths.has(Path2D):
			var pathFollow = PathFollow2D.new()
			pathFollow = Path2D.get_children()
			moveArmy(pathFollow, "start", endPoint)
		else:
			if startingPoint.endNodePaths.has(Path2D):
				var pathFollow = PathFollow2D.new()
				pathFollow = Path2D.get_children()
				moveArmy(pathFollow, "end", endPoint)
	pass

func moveArmy(pf, key, endPoint):
	match key:
		"start":
			pf.add_child(selectedAPF)
			selectedAPF.move("start", endPoint)
			listOfUpdatingArmyPaths.append(pf)
		"end":
			pf.add_child(selectedAPF)
			selectedAPF.move("end", endPoint)
			listOfUpdatingArmyPaths.append(pf)
	pass

func moveAndShowInfoPanel(key):
	match key:
		"Move":
			$ArmyPanel/ActionInfoPanelControl.position.x = 11
			$ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Move the unit to one of the surrounding tiles.  Cannot move into tiles occupied by other units."
		"Wait":
			$ArmyPanel/ActionInfoPanelControl.position.x = 60
			$ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Holds the unit in place for one turn. +10% Army Defence and Ranged Defence this turn."
		"Hold":
			$ArmyPanel/ActionInfoPanelControl.position.x = 107
			$ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Hold this unit in place indefinitely. +10% Army Defence and Ranged Defence."
		"Melee":
			$ArmyPanel/ActionInfoPanelControl.position.x = 154
			$ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Attack an enemy using this army's melee strength.  Lose manpower depending on Enemy defence and shield stats."
		"Ranged":
			$ArmyPanel/ActionInfoPanelControl.position.x = 205
			$ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Attack an enemy using this army's ranged strength.  Lose weapons depending on your Ore, weapon type, and level."
		"Reinforce":
			$ArmyPanel/ActionInfoPanelControl.position.x = 252
			$ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Reinforce your army's manpower reserves.  Costs gold, food, and manpower."
		"Weapons":
			$ArmyPanel/ActionInfoPanelControl.position.x = 300
			$ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Reinforce your army's weapons reserves.  Costs gold and weapons."
		"Shield":
			$ArmyPanel/ActionInfoPanelControl.position.x = 300
			$ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Restore your shield score at the cost of gold, wood, and metal."
		"Powers":
			$ArmyPanel/ActionInfoPanelControl.position.x = 300
			$ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Open a list of all your unlocked spells, powers, and abilities available for this unit."
	$ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = key
	$ArmyPanel/ActionInfoPanelControl.visible = true
	
	pass

func _on_move_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Move")
	pass # Replace with function body.

func _on_move_button_mouse_exited() -> void:
	$ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

func _on_wait_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Wait")
	pass # Replace with function body.

func _on_wait_button_mouse_exited() -> void:
	$ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

func _on_hold_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Hold")
	pass # Replace with function body.

func _on_hold_button_mouse_exited() -> void:
	$ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

func _on_melee_attack_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Melee")
	pass # Replace with function body.

func _on_melee_attack_button_mouse_exited() -> void:
	$ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

func _on_ranged_attack_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Ranged")
	pass # Replace with function body.

func _on_ranged_attack_button_mouse_exited() -> void:
	$ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

func _on_reinforce_manpower_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Reinforce")
	pass # Replace with function body.

func _on_reinforce_manpower_button_mouse_exited() -> void:
	$ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

func _on_reinforce_weapons_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Weapons")
	pass # Replace with function body.

func _on_reinforce_weapons_button_mouse_exited() -> void:
	$ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

func _on_reinforce_shield_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Shield")
	pass # Replace with function body.

func _on_reinforce_shield_button_mouse_exited() -> void:
	$ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

func _on_spells_and_powers_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Powers")
	pass # Replace with function body.

func _on_spells_and_powers_button_mouse_exited() -> void:
	$ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.
