extends Control

var armyPathFollowScene = preload("res://army_path_follow.tscn")
var playerCountry: country
var playerTiles: Array
var updatingArmyPathFollow: PathFollow2D

var selectedAPF: armyPathFollow
var selectedCPF: civilianPathFollow

var raisedPlayerAPFs: Array = []
var raisedPlayerCPFs: Array = []

func raisePlayerArmy(Army, country, Tile, pathPointToSend):
	var newAPF = armyPathFollowScene.instantiate()
	pathPointToSend.add_child(newAPF)
	raisedPlayerAPFs.append(newAPF)
	pathPointToSend.occupied = true
	newAPF.apfSelected.connect(displayapfInfo)
	newAPF.armyArrived.connect(armyArrivedFunc)
	newAPF.armyTraveling.connect(updateTravelingArmy)
	newAPF.onRaise(Army, country, pathPointToSend)
	showPathPoints(pathPointToSend)
	pass

var civilianPathFollowScene = load("res://civilian_path_follow.tscn")

func raisePlayerCiv(civ, country, Tile):
	var newCPF = civilianPathFollowScene.instantiate()
	civ.stationNode.add_child(newCPF)
	raisedPlayerCPFs.append(newCPF)
	civ.stationNode.occupied = true
	#civ.stationNode.stationedCivilians.append(newCPF)
	newCPF.cpfSelected.connect(displaycpfInfo)
	newCPF.civilianArrived.connect(civilianArrivedFunc)
	newCPF.tileChanging.connect(newTileDevelopment)
	newCPF.onRaise(civ, country, civ.stationNode)
	showPathPoints(civ.stationNode)
	pass

func updateTravelingArmy(progressRate, currentPath, Army):
	pass


func armyArrivedFunc(pathOfArmy, newPathPointButton, theArmy, apf, contain):
	#use this to resume 
	print("ARMYARRIVEDDEBUG")
	removeFromUpdateArmyPaths()
	for pathPointButton in $PathPointsControl.get_children():
		if pathPointButton == newPathPointButton:
			contain.remove_child(apf)
			pathPointButton.add_child(theArmy)
			pathPointButton.add_child(apf)
			newPathPointButton.occupied = true
			updateArmyPanel(theArmy, newPathPointButton)
	showPathPoints(newPathPointButton)
	pass

func civilianArrivedFunc(pathOfCivilian, newPathPointButton, theCivilian, cpf, contain):
	#use this to resume 
	print("CIVILIANARRIVEDDEBUG")
	removeFromUpdateArmyPaths()
	for pathPointButton in $PathPointsControl.get_children():
		if pathPointButton == newPathPointButton:
			contain.remove_child(cpf)
			#pathPointButton.add_child(theCivilian)
			pathPointButton.add_child(cpf)
			updateCivilianPanel(theCivilian, newPathPointButton)
			#pathPointButton.stationedCivilians.append(cpf)
			newPathPointButton.occupied = true
			#updateArmyPanel(theArmy, newPathPointButton)
	showPathPoints(newPathPointButton)
	pass

signal activateArmyControlMode
func displayapfInfo(thisArmy, apf, currentTile, thisCountry, currentPathPoint):
	if thisCountry == playerCountry:
		updateArmyPanel(thisArmy, currentPathPoint)
		showPathPoints(currentPathPoint)
		selectedAPF = apf
		selectedCPF = null
		emit_signal("activateArmyControlMode")
	#else:
		#display other country information in the army panel
	pass

func displaycpfInfo(thisCiv, cpf, currentTile, thisCountry, currentPathPoint):
	if thisCountry == playerCountry:
		updateCivilianPanel(thisCiv, currentPathPoint)
		showPathPoints(currentPathPoint)
		selectedCPF = cpf
		selectedAPF = null
		emit_signal("activateArmyControlMode")
	pass

signal updateArmy
func updateArmyPanel(Army, pathPoint):
	emit_signal("updateArmy", Army, pathPoint)
#	$ArmyPanel/LeaderSprite.texture = Army.commander.governorTexture
#	$ArmyPanel/LeaderName.text = str(Army.commander.governorType)
	pass
signal updateCivilian
func updateCivilianPanel(civ, pathPoint):
	emit_signal("updateCivilian", civ, pathPoint)
#"apfSelected", thisArmy, self, currentTile, thisCountry, currentPath, progress_ratio

func connectPathPoints(playerCountryNode):
	playerCountry = playerCountryNode
	playerTiles.clear()
	for Tile in playerCountryNode.OwnedTileList:
		playerTiles.append(Tile)
	for pathPointButton in $PathPointsControl.get_children():
		pathPointButton.pathPointClicked.connect(calculateArmyMovement)
		pathPointButton.buildSelf()
	pass
var visibleTiles: Array

signal updatePathPoints

func showPathPoints(pathPoint):
	emit_signal("updatePathPoints", true)
	visibleTiles.clear()
	for pathPointButton in $PathPointsControl.get_children():
		pathPointButton.visible = false
		if pathPointButton.occupied == true:
			pathPointButton.visible = true
			#visibleTiles.append(pathPointButton.neighborPathPoints)
		#if playerTiles.has(pathPointButton.ppbTile):
			#pathPointButton.visible = true
	for pathPointButton in visibleTiles:
		pathPointButton.visible = true
	for pathPointButton in pathPoint.neighborPathPoints:
		pathPointButton.visible = true
	pathPoint.visible = true
	#for pathPointButton in $PathPointsControl.get_children():
		#if pathPointButton.visible != true:
			#pathPointButton.hideTile()
		#else:
			#pathPointButton.revealTile()
	pass

func hidePathPoints():
	emit_signal("updatePathPoints", false)
	for pathPointButton in $PathPointsControl.get_children():
		pathPointButton.visible = false
	pass

func removeFromUpdateArmyPaths():
	updatingArmyPathFollow = null
	pass

func _process(delta: float) -> void:
	if updatingArmyPathFollow != null :
		if selectedAPF != null:
			if selectedAPF.progressRate != 1 && selectedAPF.progressRate !=0:
				updatingArmyPathFollow.progress_ratio = selectedAPF.progressRate
			return
		if selectedCPF !=null:
			if selectedCPF.progressRate != 1 && selectedCPF.progressRate !=0:
				updatingArmyPathFollow.progress_ratio = selectedCPF.progressRate
			return
	pass

var startingPoint: pathPointButton#come back and fix this
#incoming pathPointButtonSelf is different from the selectedAPF.  if we give the selectedAPF it's own
#pathPointButton, we could compare them.
func calculateArmyMovement(pathPointButton, endNodes, startNodes, neighborPathPoints, curTile):
	print("DEBUG Calculate", endNodes)
	if selectedAPF != null:
		startingPoint = selectedAPF.currentPathPoint
	elif selectedCPF != null:
		startingPoint = selectedCPF.currentPathPoint
	if endNodes != null:
		for Container in endNodes: 
			print(Container, "DEUBUG NODEPATH")
			if startingPoint.startNodePaths.has(Container):
				print("DEBUG startingPoint2, ")
				moveArmy(Container, "start", pathPointButton)
				#pathPointButton.occupied = false
				#print("DEBUG PathPointButton", pathPointButton.occupied)
				return
			elif startingPoint.endNodePaths.has(Container):
				print("DEBUG startingPoint2, ")
				moveArmy(Container, "end", pathPointButton)
				#pathPointButton.occupied = false
				#print("DEBUG PathPointButton", pathPointButton.occupied)
				return
			else:
				print("DEBUG ERROR1")
				#newContainer.queue_free()
	if startNodes != null:
		for Container in startNodes:
			if startingPoint.startNodePaths.has(Container):
				print("DEBUG startingPoint3, ")
				moveArmy(Container, "start", pathPointButton)
				#pathPointButton.occupied = false
				return
			elif startingPoint.endNodePaths.has(Container):
				print("DEBUG startingPoint4, ")
				#pathPointButton.occupied = false
				moveArmy(Container, "end", pathPointButton)
				return
			else:
				print("DEBUG ERROR2")
	pass

func moveArmy(newContainer, String, endPoint):
	print("DEBUGMORONWITHAWRENCH")
	if selectedAPF!= null:
		match String:
			"start":
				print("ControlDEBUG", newContainer)
				var apfParent = selectedAPF.get_parent()
				updatingArmyPathFollow = newContainer.get_parent()
				var path = updatingArmyPathFollow.get_parent()
				apfParent.call_deferred("remove_child",selectedAPF)
				newContainer.call_deferred("add_child", selectedAPF)
				selectedAPF.move("start", endPoint, path)
				updatingArmyPathFollow = newContainer.get_parent()
			"end":
				var apfParent = selectedAPF.get_parent()
				updatingArmyPathFollow = newContainer.get_parent()
				var path = updatingArmyPathFollow.get_parent()
				apfParent.call_deferred("remove_child",selectedAPF)
				newContainer.call_deferred("add_child", selectedAPF)
				selectedAPF.move("end", endPoint, path)
				updatingArmyPathFollow = newContainer.get_parent()
		return
	else:
		match String:
			"start":
				print("ControlDEBUG", newContainer)
				var cpfParent = selectedCPF.get_parent()
				updatingArmyPathFollow = newContainer.get_parent()
				var path = updatingArmyPathFollow.get_parent()
				cpfParent.call_deferred("remove_child",selectedCPF)
				newContainer.call_deferred("add_child", selectedCPF)
				selectedCPF.move("start", endPoint, path)
				updatingArmyPathFollow = newContainer.get_parent()
			"end":
				var cpfParent = selectedCPF.get_parent()
				updatingArmyPathFollow = newContainer.get_parent()
				var path = updatingArmyPathFollow.get_parent()
				cpfParent.call_deferred("remove_child",selectedCPF)
				#cpfParent.stationedCivilians.remove_at(selectedCPF)
				newContainer.call_deferred("add_child", selectedCPF)
				selectedCPF.move("end", endPoint, path)
				updatingArmyPathFollow = newContainer.get_parent()
	pass
signal showArmyInfo
func moveAndShowInfoPanel(key):
	emit_signal("showArmyInfo", key)
	pass

signal tileDevelopment
func newTileDevelopment(tileToDev, devType, devCivilian):
	emit_signal("tileDevelopment", tileToDev, devType, devCivilian)
	pass

func agricultureTile():
	if selectedCPF != null:
		selectedCPF.agricultureMode()
		selectedCPF = null
	pass

func resourceTile():
	if selectedCPF != null:
		selectedCPF.resourceMode()
		selectedCPF = null
	pass

func urbanTile():
	if selectedCPF != null:
		selectedCPF.urbanMode()
		selectedCPF = null
	pass

func eliteTile():
	if selectedCPF != null:
		selectedCPF.eliteMode()
		selectedCPF = null
	pass

func militaryTile():
	if selectedCPF != null:
		selectedCPF.militaryMode()
		selectedCPF = null
	pass

func colonizeTile():
	if selectedCPF != null:
		selectedCPF.colonizeMode()
		selectedCPF = null
	pass

func fightCorruptionTile():
	if selectedCPF != null:
		selectedCPF.corruptionMode()
		selectedCPF = null
	pass

func discoverNearby():
	if selectedCPF != null:
		selectedCPF.discoveryMode()
		selectedCPF = null
	pass

func makeAllContainersPassable():
	for Path2D in $PathsControl.get_children():
		for PathFollow2D in Path2D.get_children():
			for Container in PathFollow2D.get_children():
				Container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass


func _on_move_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Move")
	pass # Replace with function body.

func _on_move_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")
	pass # Replace with function body.

func _on_wait_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Wait")
	pass # Replace with function body.

func _on_wait_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")
	pass # Replace with function body.

func _on_hold_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Hold")
	pass # Replace with function body.

func _on_hold_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")
	pass # Replace with function body.

func _on_melee_attack_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Melee")
	pass # Replace with function body.

func _on_melee_attack_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")
	pass # Replace with function body.

func _on_ranged_attack_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Ranged")
	pass # Replace with function body.

func _on_ranged_attack_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")
	pass # Replace with function body.

func _on_reinforce_manpower_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Reinforce")
	pass # Replace with function body.

func _on_reinforce_manpower_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")
	pass # Replace with function body.

func _on_reinforce_weapons_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Weapons")
	pass # Replace with function body.

func _on_reinforce_weapons_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")
	pass # Replace with function body.

func _on_reinforce_shield_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Shield")
	pass # Replace with function body.

func _on_reinforce_shield_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")
	pass # Replace with function body.

func _on_spells_and_powers_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Powers")
	pass # Replace with function body.

func _on_spells_and_powers_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")
	pass # Replace with function body.

signal meleeButtonPressed
func _on_melee_attack_button_pressed() -> void:
	if selectedAPF != null:
		emit_signal("meleeButtonPressed", selectedAPF, selectedAPF.thisArmy)
	pass # Replace with function body.
