extends Control

var armyPathFollowScene = preload("res://army_path_follow.tscn")
var playerCountry
var playerTiles: Array
var updatingArmyPathFollow: PathFollow2D
var _travelingFollower = null   # APF/CPF currently animating along the path (selection-independent)

var selectedAPF: armyPathFollow
var _highlightedTiles: Array = []
var selectedCPF: civilianPathFollow

var raisedPlayerAPFs: Array = []
var raisedPlayerCPFs: Array = []

var melee_mode: bool = false   # true after player presses melee — next PPB click is an attack

signal playerBattleResolved(tile, atk_loss, def_loss)

func raisePlayerArmy(Army, country, Tile, pathPointToSend):
	var newAPF = armyPathFollowScene.instantiate()
	pathPointToSend.add_child(newAPF)
	raisedPlayerAPFs.append(newAPF)
	pathPointToSend.occupied = true
	pathPointToSend.stationedArmy = Army
	newAPF.apfSelected.connect(displayapfInfo)
	newAPF.apfRightClicked.connect(_on_apf_right_clicked)
	newAPF.apfHovered.connect(_on_apf_hovered)
	newAPF.armyArrived.connect(armyArrivedFunc)
	newAPF.siegeChange.connect(updateTileSiege)
	newAPF.armyTraveling.connect(updateTravelingArmy)
	newAPF.attackMidpoint.connect(_on_attack_midpoint)
	newAPF.attackRetreated.connect(_on_attack_retreated)
	newAPF.onRaise(Army, country, pathPointToSend)
	showPathPoints(pathPointToSend)
	pathPointToSend.stationedAPF = newAPF

func raiseComputerArmy(Army, country, Tile, pathPointToSend):
	var newAPF = armyPathFollowScene.instantiate()
	pathPointToSend.add_child(newAPF)
	raisedPlayerAPFs.append(newAPF)
	pathPointToSend.occupied = true
	pathPointToSend.stationedArmy = Army
	newAPF.apfSelected.connect(displayapfInfo)
	newAPF.apfRightClicked.connect(_on_apf_right_clicked)
	newAPF.apfHovered.connect(_on_apf_hovered)
	newAPF.armyArrived.connect(armyArrivedFunc)
	newAPF.siegeChange.connect(updateTileSiege)
	newAPF.armyTraveling.connect(updateTravelingArmy)
	newAPF.attackMidpoint.connect(_on_attack_midpoint)
	newAPF.attackRetreated.connect(_on_attack_retreated)
	newAPF.onRaise(Army, country, pathPointToSend)
	showPathPoints(pathPointToSend)
	pathPointToSend.stationedAPF = newAPF


var civilianPathFollowScene = load("res://civilian_path_follow.tscn")

func raisePlayerCiv(civ, country, Tile):
	var newCPF = civilianPathFollowScene.instantiate()
	civ.stationNode.add_child(newCPF)
	raisedPlayerCPFs.append(newCPF)
	civ.stationNode.occupied = true
	newCPF.cpfSelected.connect(displaycpfInfo)
	newCPF.civilianArrived.connect(civilianArrivedFunc)
	newCPF.tileChanging.connect(newTileDevelopment)
	newCPF.spyActionPerformed.connect(_on_spy_action_performed)
	newCPF.onRaise(civ, country, civ.stationNode)
	showPathPoints(civ.stationNode)

func updateTravelingArmy(_progressRate, _currentPath, _Army):
	# Visual feedback during travel is handled by army_path_follow._process().
	pass


func armyArrivedFunc(pathOfArmy, newPathPointButton, theArmy, apf, contain):
	#use this to resume 
	removeFromUpdateArmyPaths()
	_travelingFollower = null
	for pathPointButton in $PathPointsControl.get_children():
		if pathPointButton == newPathPointButton:
			contain.remove_child(apf)
			pathPointButton.add_child(theArmy)
			pathPointButton.stationedArmy = theArmy
			pathPointButton.add_child(apf)
			apf.z_as_relative = true
			apf.z_index = 15
			newPathPointButton.occupied = true
			updateArmyPanel(theArmy, newPathPointButton)
	emit_signal("updatePathPoints", true)
	newPathPointButton.stationedAPF = apf
	# Instant capture on entry — walking into a tile flips it to your country.
	if newPathPointButton.ppbTile != null:
		newPathPointButton.ppbTile.captureInstant(theArmy)

func civilianArrivedFunc(pathOfCivilian, newPathPointButton, theCivilian, cpf, contain):
	#use this to resume 
	removeFromUpdateArmyPaths()
	_travelingFollower = null
	for pathPointButton in $PathPointsControl.get_children():
		if pathPointButton == newPathPointButton:
			contain.remove_child(cpf)
			#pathPointButton.add_child(theCivilian)
			pathPointButton.add_child(cpf)
			updateCivilianPanel(theCivilian, newPathPointButton)
			#pathPointButton.stationedCivilians.append(cpf)
			newPathPointButton.occupied = true
			#updateArmyPanel(theArmy, newPathPointButton)
	_highlightMovableTiles(newPathPointButton)

signal movement_blocked(reason: String)
signal spyWinRecorded
signal activateArmyControlMode
func deselectAll() -> void:
	_hide_battle_preview()
	selectedAPF = null
	selectedCPF = null
	hidePathPoints()
	_clearMovableHighlights()
	melee_mode = false
	emit_signal("updatePathPoints", false)

func _on_apf_right_clicked(clickedArmy, apf, currentTile, clickedCountry, currentPathPoint):
	# Right-click an enemy APF to attack it (must neighbor the selected army).
	if selectedAPF == null or clickedArmy == null or not clickedArmy.enemy:
		return
	var targetPPB = apf.currentPathPoint
	if targetPPB != null and targetPPB in selectedAPF.currentPathPoint.neighborPathPoints:
		_initiate_attack(targetPPB)


func compute_battle(attacker: Army, defender: Army) -> Dictionary:
	# One formula for player, AI, and the preview — lives on the Army class now.
	return attacker.compute_battle_against(defender)


var _preview_panel: PanelContainer = null
var _preview_label: Label = null

func _on_apf_hovered(apf, entered: bool) -> void:
	# Hover a neighboring enemy APF (army selected) to preview the exact battle outcome.
	if not entered:
		_hide_battle_preview()
		return
	if selectedAPF == null or apf == selectedAPF or not is_instance_valid(apf):
		return
	var defArmy = apf.thisArmy
	if defArmy == null or not is_instance_valid(defArmy) or not defArmy.enemy:
		return
	var targetPPB = apf.currentPathPoint
	if targetPPB == null or targetPPB not in selectedAPF.currentPathPoint.neighborPathPoints:
		return
	var bt: Dictionary = compute_battle(selectedAPF.thisArmy, defArmy)
	_show_battle_preview(apf, int(bt["def_loss"]), int(bt["atk_loss"]))

func _ensure_preview_panel() -> void:
	if is_instance_valid(_preview_panel):
		return
	var cl = get_parent().get_node_or_null("CanvasLayer")
	if cl == null:
		return
	_preview_panel = PanelContainer.new()
	_preview_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview_panel.z_index = 150
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.05, 0.05, 0.08, 0.92)
	sb.set_border_width_all(1)
	sb.border_color = Color(0.85, 0.72, 0.3, 0.9)
	sb.set_corner_radius_all(4)
	sb.content_margin_left = 8
	sb.content_margin_right = 8
	sb.content_margin_top = 6
	sb.content_margin_bottom = 6
	_preview_panel.add_theme_stylebox_override("panel", sb)
	_preview_label = Label.new()
	_preview_label.add_theme_font_size_override("font_size", 13)
	_preview_label.add_theme_color_override("font_color", Color(1, 1, 1))
	_preview_panel.add_child(_preview_label)
	cl.add_child(_preview_panel)
	_preview_panel.visible = false

func _show_battle_preview(apf, def_loss: int, atk_loss: int) -> void:
	_ensure_preview_panel()
	if not is_instance_valid(_preview_panel):
		return
	var atkArmy = selectedAPF.thisArmy
	var defArmy = apf.thisArmy
	var enemy_after: int = max(0, defArmy.manpowerInArmy - def_loss)
	var you_after: int = max(0, atkArmy.manpowerInArmy - atk_loss)
	var txt := "-- Attack Preview --\n"
	txt += "Deal %d  (enemy %d/%d)\n" % [def_loss, enemy_after, defArmy.maxManpower]
	txt += "Take %d  (you %d/%d)" % [atk_loss, you_after, atkArmy.maxManpower]
	if enemy_after <= 0:
		txt += "\n>> Destroys the enemy!"
	elif you_after <= 0:
		txt += "\n!! You would be wiped !!"
	_preview_label.text = txt
	_preview_panel.visible = true
	var screen_pos: Vector2 = get_viewport().get_canvas_transform() * apf.global_position
	_preview_panel.position = screen_pos + Vector2(34.0, -46.0)

func _hide_battle_preview() -> void:
	if is_instance_valid(_preview_panel):
		_preview_panel.visible = false


func displayapfInfo(thisArmy, apf, currentTile, thisCountry, currentPathPoint):
	if thisCountry == playerCountry:
		updateArmyPanel(thisArmy, currentPathPoint)
		selectedAPF = apf
		selectedCPF = null
		_highlightMovableTiles(currentPathPoint)
		emit_signal("activateArmyControlMode")
		emit_signal("updatePathPoints", true)
	else:
		# Left-click a British APF -> its info panel (to be built). Attacks are RIGHT-click.
		pass

# Called from world.gd tileClicked() when an APF is selected.
# Returns true if the click was consumed (movement or attack initiated).
func tryMoveSelectedAPFToTile(tile: Tile) -> bool:
	if selectedAPF == null:
		return false
	var targetPPB = tile.tileSpawnPoint
	if targetPPB == null:
		return false
	if targetPPB not in selectedAPF.currentPathPoint.neighborPathPoints:
		return false
	# Move only — never onto an occupied tile. Attacks are right-click on the enemy APF.
	if targetPPB.occupied:
		return false
	calculateArmyMovement(targetPPB, targetPPB.neighborPathPoints, tile)
	return true

func displaycpfInfo(thisCiv, cpf, currentTile, thisCountry, currentPathPoint):
	if thisCountry == playerCountry:
		updateCivilianPanel(thisCiv, currentPathPoint)
		showPathPoints(currentPathPoint)
		selectedCPF = cpf
		selectedAPF = null
		emit_signal("activateArmyControlMode")

signal updateArmy
func updateArmyPanel(Army, pathPoint):
	emit_signal("updateArmy", Army, pathPoint)
#	$ArmyPanel/LeaderSprite.texture = Army.commander.governorTexture
#	$ArmyPanel/LeaderName.text = str(Army.commander.governorType)
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
		if not pathPointButton.pathPointClicked.is_connected(calculateArmyMovement):
			pathPointButton.pathPointClicked.connect(calculateArmyMovement)
		pathPointButton.buildSelf()
var visibleTiles: Array

signal updatePathPoints

func showPathPoints(pathPoint):
	emit_signal("updatePathPoints", true)
	visibleTiles.clear()
	for pathPointButton in $PathPointsControl.get_children():
		pathPointButton.setMarkerVisible(false)
		#if playerTiles.has(pathPointButton.ppbTile):
			#pathPointButton.setMarkerVisible(true)
	for pathPointButton in visibleTiles:
		pathPointButton.setMarkerVisible(true)
	if pathPoint.neighborPathPoints.size()== 0:
		return
	else:
		for pathPointButton in pathPoint.neighborPathPoints:
			if is_instance_valid(pathPointButton):
				pathPointButton.setMarkerVisible(true)
#		pathPointButton.enemyCheck()
	pathPoint.setMarkerVisible(true)
	#for pathPointButton in $PathPointsControl.get_children():
		#if pathPointButton.visible != true:
			#pathPointButton.hideTile()
		#else:
			#pathPointButton.revealTile()

func hidePathPoints():
	emit_signal("updatePathPoints", false)
	for pathPointButton in $PathPointsControl.get_children():
		pathPointButton.setMarkerVisible(false)


func _highlightMovableTiles(pathPoint) -> void:
	_clearMovableHighlights()
	if pathPoint == null:
		return
	for ppb in pathPoint.neighborPathPoints:
		if is_instance_valid(ppb) and ppb.ppbTile != null:
			ppb.ppbTile.setMovableHighlight(true)
			_highlightedTiles.append(ppb.ppbTile)


func _clearMovableHighlights() -> void:
	for t in _highlightedTiles:
		if is_instance_valid(t):
			t.setMovableHighlight(false)
	_highlightedTiles.clear()

func removeFromUpdateArmyPaths():
	updatingArmyPathFollow = null

func _process(_delta: float) -> void:
	# Animate the path follower from whatever is currently traveling (selection-independent).
	if updatingArmyPathFollow != null and is_instance_valid(_travelingFollower):
		var pr: float = _travelingFollower.progressRate
		if pr != 1.0 and pr != 0.0:
			updatingArmyPathFollow.progress_ratio = pr

var startingPoint: pathPointButton
func calculateArmyMovement(endPathPoint: pathPointButton, _neighborPathPoints, _ppbTile):
	if selectedAPF != null:
		# Melee attack: route to attack animation instead of normal movement
		if melee_mode and endPathPoint.stationedArmy != null and endPathPoint.stationedArmy.enemy:
			melee_mode = false
			_initiate_attack(endPathPoint)
			return
		melee_mode = false
		startingPoint = selectedAPF.currentPathPoint
		var army: Army = selectedAPF.thisArmy
		# Sabotage blocks all movement for the affected turn
		if army != null and army.sabotaged:
			return
		# Movement point gate — terrain cost consumed from army's pool
		var dest_tile: Tile = endPathPoint.ppbTile
		if dest_tile != null and army != null:
			var cost: int = dest_tile.get_move_cost(army)
			if army.currentMovementPoints < cost:
				emit_signal("movement_blocked", "Not enough movement points")
				return
			army.currentMovementPoints -= cost
			army.movedThisTurn = true
			army.attacksFromCurrentTile = 0
			army.cancelGuard()
			if army.attackedThisTurn:
				army.apply_status("Retreat", 2)
			_clearMovableHighlights()
	elif selectedCPF != null:
		startingPoint = selectedCPF.currentPathPoint
		# Action point gate — civilians spend 1 point per tile moved
		if selectedCPF.thisCivilian != null:
			if selectedCPF.thisCivilian.currentActionPoints <= 0:
				return
			selectedCPF.thisCivilian.currentActionPoints -= 1
	# Reset leftover editor transforms so the curve lines up with the real tile positions.
	$PathsControl/Path.position = Vector2.ZERO
	$PathsControl/Path.rotation = 0.0
	$PathsControl/Path.scale = Vector2.ONE
	$PathsControl/Path/PathFollow.rotation = 0.0
	$PathsControl/Path/PathFollow.rotates = false
	var curve: Curve2D = $PathsControl/Path.curve
	curve.clear_points()
	curve.add_point(startingPoint.position)
	curve.add_point(endPathPoint.position)
	moveArmy($PathsControl/Path/PathFollow/Control, "start", endPathPoint)

# ── ATTACK ANIMATION ─────────────────────────────────────────────────────────

func _initiate_attack(targetPPB: pathPointButton) -> void:
	_hide_battle_preview()
	if selectedAPF == null:
		return
	var atk: Army = selectedAPF.thisArmy
	if atk != null:
		if atk.attackBlocked:
			emit_signal("movement_blocked", "In Retreat — this army can't attack this turn.")
			return
		atk.attackedThisTurn = true
		if atk.movedThisTurn:
			atk.apply_status("Exhausted", 1)
			atk.cancelHold()
			atk.surveySelf()
	var curve: Curve2D = $PathsControl/Path.curve
	curve.clear_points()
	curve.add_point(selectedAPF.currentPathPoint.position)
	curve.add_point(targetPPB.position)
	var pathFollow: PathFollow2D = $PathsControl/Path/PathFollow
	var container: Control = $PathsControl/Path/PathFollow/Control
	updatingArmyPathFollow = pathFollow
	var apfParent = selectedAPF.get_parent()
	apfParent.call_deferred("remove_child", selectedAPF)
	container.call_deferred("add_child", selectedAPF)
	selectedAPF.z_as_relative = false
	selectedAPF.z_index = 100
	selectedAPF.beginAttack(targetPPB, $PathsControl/Path)

func _on_attack_midpoint(apf: armyPathFollow) -> void:
	var targetPPB: pathPointButton = apf.destinationPathPoint
	if targetPPB == null or not is_instance_valid(targetPPB):
		apf.resolveAttack(false)
		return
	var attacker: Army = apf.thisArmy
	var defender: Army = targetPPB.stationedArmy
	if defender == null or not is_instance_valid(defender) or not defender.enemy:
		apf.resolveAttack(false)
		return
	# Fire = ranged, Charge = melee. Shared with the hover preview via compute_battle().
	var _bt: Dictionary = compute_battle(attacker, defender)
	var def_loss: int = _bt["def_loss"]
	var atk_loss: int = _bt["atk_loss"]
	defender.calculateDefenderResults("melee", def_loss)
	attacker.calculateDefenderResults("melee", atk_loss)
	attacker.spend_attack_ap()
	# Also update siege on the target tile
	targetPPB.siegeTile(attacker)
	# Emit for floating damage numbers
	var tile = targetPPB.ppbTile
	emit_signal("playerBattleResolved", tile, atk_loss, def_loss)
	# Conquered if defender is gone
	var conquered: bool = (not is_instance_valid(defender) or defender.manpowerInArmy <= 0)
	if conquered:
		# Clear the defender's PPB before the attacker arrives
		if targetPPB.stationedAPF != null and is_instance_valid(targetPPB.stationedAPF):
			targetPPB.stationedAPF.thisArmy.deleteMode = true
		targetPPB.stationedAPF = null
		targetPPB.stationedArmy = null
		targetPPB.occupied = false
	var should_advance: bool = conquered and attacker.all_units_charging()
	apf.resolveAttack(should_advance)

func _on_attack_retreated(apf: armyPathFollow, returnPoint: pathPointButton) -> void:
	removeFromUpdateArmyPaths()
	var container = apf.get_parent()
	container.call_deferred("remove_child", apf)
	returnPoint.call_deferred("add_child", apf)
	apf.z_as_relative = true
	apf.z_index = 15
	emit_signal("updatePathPoints", true)

func moveArmy(newContainer, String, endPoint):
	if selectedAPF!= null:
		match String:
			"start":
				var apfParent = selectedAPF.get_parent()
				updatingArmyPathFollow = newContainer.get_parent()
				var path = updatingArmyPathFollow.get_parent()
				apfParent.call_deferred("remove_child",selectedAPF)
				newContainer.call_deferred("add_child", selectedAPF)
				_travelingFollower = selectedAPF
				selectedAPF.z_as_relative = false
				selectedAPF.z_index = 100
				selectedAPF.move("start", endPoint, path)
				updatingArmyPathFollow = newContainer.get_parent()
	else:
		match String:
			"start":
				var cpfParent = selectedCPF.get_parent()
				updatingArmyPathFollow = newContainer.get_parent()
				var path = updatingArmyPathFollow.get_parent()
				cpfParent.call_deferred("remove_child",selectedCPF)
				newContainer.call_deferred("add_child", selectedCPF)
				_travelingFollower = selectedCPF
				selectedCPF.move("start", endPoint, path)
				updatingArmyPathFollow = newContainer.get_parent()
signal showArmyInfo
func moveAndShowInfoPanel(key):
	emit_signal("showArmyInfo", key)

signal tileDevelopment
func newTileDevelopment(tileToDev, devType, devCivilian):
	emit_signal("tileDevelopment", tileToDev, devType, devCivilian)

func agricultureTile():
	if selectedCPF != null:
		selectedCPF.agricultureMode()
		selectedCPF = null

func resourceTile():
	if selectedCPF != null:
		selectedCPF.resourceMode()
		selectedCPF = null

func urbanTile():
	if selectedCPF != null:
		selectedCPF.urbanMode()
		selectedCPF = null

func eliteTile():
	if selectedCPF != null:
		selectedCPF.eliteMode()
		selectedCPF = null

func militaryTile():
	if selectedCPF != null:
		selectedCPF.militaryMode()
		selectedCPF = null

func colonizeTile():
	if selectedCPF != null:
		selectedCPF.colonizeMode()
		selectedCPF = null

func fightCorruptionTile():
	if selectedCPF != null:
		selectedCPF.corruptionMode()
		selectedCPF = null

func discoverNearby():
	if selectedCPF != null:
		selectedCPF.discoveryMode()
		selectedCPF = null

func makeAllContainersPassable():
	for Path2D in $PathsControl.get_children():
		for PathFollow2D in Path2D.get_children():
			for Container in PathFollow2D.get_children():
				Container.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_move_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Move")

func _on_move_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")

func _on_wait_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Wait")

func _on_wait_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")

func _on_hold_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Hold")

func _on_hold_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")

func _on_melee_attack_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Melee")

func _on_melee_attack_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")

func _on_ranged_attack_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Ranged")

func _on_ranged_attack_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")

func _on_reinforce_manpower_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Reinforce")

func _on_reinforce_manpower_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")

func _on_reinforce_weapons_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Weapons")

func _on_reinforce_weapons_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")

func _on_reinforce_shield_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Shield")

func _on_reinforce_shield_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")

func _on_spells_and_powers_button_mouse_entered() -> void:
	moveAndShowInfoPanel("Powers")

func _on_spells_and_powers_button_mouse_exited() -> void:
	moveAndShowInfoPanel("Close")

signal meleeButtonPressed
func _on_melee_attack_button_pressed() -> void:
	if selectedAPF != null:
		var army: Army = selectedAPF.thisArmy
		if army != null and army.attackBlocked:
			return
		melee_mode = true
		emit_signal("meleeButtonPressed", selectedAPF, army)

signal rangedButtonPressed
func _on_ranged_attack_button_pressed():
	if selectedAPF != null:
		emit_signal("rangedButtonPressed", selectedAPF, selectedAPF.thisArmy)

func spellSelectionMode(spell, cost, player):
	for pathPointButton in $PathPointsControl.get_children():
		if pathPointButton.occupied == true and is_instance_valid(pathPointButton.stationedAPF):
			pathPointButton.stationedAPF.prepareMilSpell(spell)

func updateTileSiege(army, pathPoint):
	for pathPointButton in $PathPointsControl.get_children():
		if pathPointButton == pathPoint:
			pathPointButton.siegeTile(army)


func _on_build_road_pressed() -> void:
	if selectedCPF != null:
		selectedCPF.roadMode()
		selectedCPF = null

# ── SPY ACTIONS (Codebook tool) ───────────────────────────────────────────────
# Wire SabotageButton, ContactTurncoatsButton, ReconnaissanceButton pressed
# signals in the scene editor to these methods.

func sabotageTile() -> void:
	if selectedCPF != null:
		selectedCPF.sabotageMode()
		selectedCPF = null

func contactTurncoatsTile() -> void:
	if selectedCPF != null:
		selectedCPF.contactTurncoatsMode()
		selectedCPF = null

func reconTile() -> void:
	if selectedCPF != null:
		selectedCPF.reconMode()
		selectedCPF = null

func _on_spy_action_performed(action_type: String, tile, civilian) -> void:
	if tile == null:
		return
	var target_army: Army = tile.stationedArmy
	if target_army == null or not target_army.enemy:
		raisedPlayerCPFs.erase(civilian)
		return
	match action_type:
		"Sabotage":
			target_army.sabotaged = true
			target_army.sabotageTimer = 1
		"ContactTurncoats":
			var siphon = int(target_army.manpowerInArmy * 0.20)
			target_army.manpowerInArmy -= siphon
			if playerCountry != null:
				playerCountry.TotalManpower += siphon
		"Reconnaissance":
			target_army.reconDebuffed = true
			target_army.reconDebuffTimer = 3
	emit_signal("spyWinRecorded")
	# Remove the now-consumed CPF from the tracking list
	raisedPlayerCPFs.erase(civilian)

# ── TURN END ─────────────────────────────────────────────────────────────────
# Call this from country.gd payUnitMaintenance() or world.gd turn-end handler
# alongside Army.onTurnEnd() so civilians reset their action points each turn.
func onTurnEnd() -> void:
	for cpf in raisedPlayerCPFs:
		if is_instance_valid(cpf) and cpf.thisCivilian != null:
			cpf.thisCivilian.onTurnEnd()
