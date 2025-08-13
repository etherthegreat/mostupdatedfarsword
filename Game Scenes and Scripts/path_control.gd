extends Control

var armyPathFollowScene = preload("res://army_path_follow.tscn")

var selectedAPF: armyPathFollow

var raisedPlayerAPFs: Array = []

func raisePlayerArmy(Army, country, Tile, pathToSend, pathNumberToSend):
	var newAPF = armyPathFollowScene.instantiate()
	pathToSend.add_child(newAPF)
	raisedPlayerAPFs.append(newAPF)
	newAPF.apfSelected.connect(displayapfInfo)
	newAPF.onRaise(Army, country, Tile, pathToSend, pathNumberToSend)
	showPathPoints()
	pass

signal activateArmyControlMode
func displayapfInfo(thisArmy, apf, currentTile, thisCountry, currentPath, progress_ratio):
	updateArmyPanel(thisArmy)
	selectedAPF = apf
	emit_signal("activateArmyControlMode")
	pass

func updateArmyPanel(Army):
	$ArmyPanel/ArmyNameLabel.text = Army.ArmyName
	$ArmyPanel/AttackLabel.text = str(Army.armyAttackScore)
	$ArmyPanel/DefenseLabel.text = str(Army.armyDefenseScore)
	if $ArmyPanel.visible == false:
		$ArmyPanel.visible = true
	else:
		$ArmyPanel.visible = false
	pass

#"apfSelected", thisArmy, self, currentTile, thisCountry, currentPath, progress_ratio

func connectPathPoints():
	for pathPointButton in $PathPointsControl.get_children():
		pathPointButton.pathPointClicked.connect(calcuateArmyMovement)
	pass

func showPathPoints():
	for pathPointButton in $PathPointsControl.get_children():
		if pathPointButton.visible == false:
			pathPointButton.visible = true
	
	pass

func calcuateArmyMovement(realPath, realPathNumber):
	if selectedAPF.currentPath == realPath:
		selectedAPF.destinationNumber = realPathNumber
	else:
		selectedAPF.comparePath2Ds(realPath, realPathNumber)
	pass
