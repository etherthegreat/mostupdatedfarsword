extends Control

var armyPathFollowScene = preload("res://army_path_follow.tscn")
var playerCountry
var playerTiles: Array
var updatingArmyPathFollow: PathFollow2D
var _travelingFollower = null   # APF/CPF currently animating along the path (selection-independent)

var selectedAPF: armyPathFollow
var war_active: bool = false   # false = pre-war ceasefire; player can't strike/enter UK
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
	# Fix 2026-10-27: a moved army used to stay registered on the tile it LEFT and never
	# updated inTile, so the UK AI (country._tile_occupant needs inTile == tile) saw
	# phantoms behind the line and walked into the real army's tile, deleting it unfought.
	for oldPPB in $PathPointsControl.get_children():
		if oldPPB != newPathPointButton and oldPPB.stationedArmy == theArmy:
			oldPPB.stationedArmy = null
			if oldPPB.stationedAPF == apf:
				oldPPB.stationedAPF = null
			oldPPB.occupied = false
			if oldPPB.ppbTile != null and oldPPB.ppbTile.stationedArmy == theArmy:
				oldPPB.ppbTile.stationedArmy = null
	if is_instance_valid(theArmy) and newPathPointButton.ppbTile != null:
		theArmy.inTile = newPathPointButton.ppbTile
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
	if apf == selectedAPF:
		_highlightMovableTiles(newPathPointButton)   # show what is still in reach
	# Instant capture on entry — walking into a tile flips it to your country
	# (British strongpoints start a one-turn siege instead; see tile.captureInstant).
	if newPathPointButton.ppbTile != null:
		var _t = newPathPointButton.ppbTile
		_t.captureInstant(theArmy)
		if is_instance_valid(theArmy) and theArmy.parentCountry != null and theArmy.parentCountry.CID != "UK":
			if _t.siegeArmy == theArmy:
				emit_signal("movement_blocked", "Siege begun at " + _t.tileName + " — hold it one full turn to take it (Under siege 0/" + str(_t.SIEGE_TURNS_NEEDED) + ")")
			# Zone of control: stepping next to a Redcoat army ends the march.
			if _t.redcoat_line_army(theArmy.parentCountry.CID) != null and theArmy.currentMovementPoints > 0:
				theArmy.currentMovementPoints = 0
				emit_signal("movement_blocked", "Redcoat line — movement stops")


# ── DEPTH PASS 2026-10-31 ────────────────────────────────────────────────────
func zoc_block_reason(army, dest_tile) -> String:
	# Why `army` may not step into `dest_tile` (empty string = it may).
	if army == null or dest_tile == null or army.parentCountry == null:
		return ""
	var cid: String = army.parentCountry.CID
	if cid == "UK" or dest_tile.tileOwner != "UK":
		return ""
	if dest_tile.redcoat_line_army(cid) != null:
		return "Redcoat line — a British army covers " + dest_tile.tileName + ". Break it first."
	return ""

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

func _army_firing_range(army) -> int:
	# Longest ranged reach among the army's units (2 for Mortar/Rocket artillery, else 1).
	var r := 1
	if army == null:
		return r
	for u in army.unitsList:
		if u != null and u.unitWeapon != null and u.unitWeapon.weaponRange > r:
			r = u.unitWeapon.weaponRange
	return r


func _in_firing_range(targetPPB) -> bool:
	if selectedAPF == null or targetPPB == null or selectedAPF.currentPathPoint == null:
		return false
	var origin = selectedAPF.currentPathPoint
	if targetPPB in origin.neighborPathPoints:
		return true
	if _army_firing_range(selectedAPF.thisArmy) >= 2:
		for n in origin.neighborPathPoints:
			if n != null and targetPPB in n.neighborPathPoints:
				return true
	return false


func _on_apf_right_clicked(clickedArmy, apf, currentTile, clickedCountry, currentPathPoint):
	# Right-click an enemy APF to attack it (must neighbor the selected army).
	if selectedAPF == null or clickedArmy == null or not clickedArmy.enemy:
		return
	if not war_active and clickedArmy.parentCountry != null and clickedArmy.parentCountry.CID == "UK":
		emit_signal("movement_blocked", "The war hasn't begun — you can't strike the British yet.")
		return
	var targetPPB = apf.currentPathPoint
	if _in_firing_range(targetPPB):
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
	if not _in_firing_range(targetPPB):
		return
	var bt: Dictionary = compute_battle(selectedAPF.thisArmy, defArmy)
	_show_battle_preview(apf, int(bt["def_loss"]), int(bt["atk_loss"]), bt)

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

func _show_battle_preview(apf, def_loss: int, atk_loss: int, bt: Dictionary = {}) -> void:
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
	if bt.get("hold_fired", false):
		txt += "\nTheir line fires first: -%d, you hit at %d%%" % [int(bt.get("hold_loss", 0)), roundi(float(bt.get("attack_scale", 1.0)) * 100.0)]
	if not defArmy.is_covered():
		txt += "\nEnemy EXPOSED: their block is halved"
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
		# Left-click an enemy / allied APF -> its army card, read-only. Attacks are RIGHT-click.
		var w = get_parent()
		if w != null and w.has_method("_show_army_info"):
			w._show_army_info(thisArmy)

# Called from world.gd tileClicked() when an APF is selected.
# Returns true if the click was consumed (movement or attack initiated).
func tryMoveSelectedAPFToTile(tile: Tile) -> bool:
	if selectedAPF == null:
		return false
	if not war_active and tile.tileOwner == "UK":
		emit_signal("movement_blocked", "The war hasn't begun — you can't enter British territory yet.")
		return false
	var targetPPB = tile.tileSpawnPoint
	if targetPPB == null:
		return false
	# Any tile the army can reach with the movement it has left (see reachable_from).
	# Never onto an enemy army: attacks are right-click on the enemy token.
	if route_to(selectedAPF.currentPathPoint, targetPPB, selectedAPF.thisArmy).is_empty():
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
	# An army lights up every tile it can reach this turn, not just its neighbours.
	if selectedAPF != null and is_instance_valid(selectedAPF) and selectedAPF.currentPathPoint == pathPoint \
			and selectedAPF.thisArmy != null and is_instance_valid(selectedAPF.thisArmy):
		for ppb in reachable_from(pathPoint, selectedAPF.thisArmy)["cost"]:
			if is_instance_valid(ppb) and ppb.ppbTile != null:
				ppb.ppbTile.setMovableHighlight(true)
				_highlightedTiles.append(ppb.ppbTile)
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
	_tick_badges(_delta)
	# Animate the path follower from whatever is currently traveling (selection-independent).
	if updatingArmyPathFollow != null and is_instance_valid(_travelingFollower):
		var pr: float = _travelingFollower.progressRate
		if pr != 1.0 and pr != 0.0:
			updatingArmyPathFollow.progress_ratio = pr

var startingPoint: pathPointButton
func calculateArmyMovement(endPathPoint: pathPointButton, _neighborPathPoints, _ppbTile):
	var waypoints: Array = [endPathPoint]
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
		var dest_tile: Tile = endPathPoint.ppbTile
		if dest_tile != null and army != null:
			# The march: every tile from here to the destination, paid for out of the
			# army's movement points. Empty = the destination can't be reached this turn.
			var route: Array = route_to(startingPoint, endPathPoint, army)
			if route.is_empty():
				var _block: String = zoc_block_reason(army, dest_tile)
				if _block == "":
					_block = "Not enough movement points" if army.currentMovementPoints <= 0 else "Out of reach this turn"
				emit_signal("movement_blocked", _block)
				return
			var cost: int = 0
			for step in route:
				cost += _step_cost(army, step.ppbTile)
			if army.has_artillery():
				if not army.artillery_can_move():
					emit_signal("movement_blocked", "The cannon crew is out of actions this turn")
					return
				army.spend_artillery_move_ap()
			var partner = _attach_partner(army, endPathPoint)
			army.currentMovementPoints -= cost
			army.movedThisTurn = true
			army.attacksFromCurrentTile = 0
			army.cancelGuard()
			for _fu in army.unitsList:
				if _fu.unitStance == "fortify":   # marching breaks the dig-in
					_fu.unitStance = "fire" if not _fu.unitWeapon.is_saber() else "charge"
					_fu.fortifyRefundAP = 0
			if army.attackedThisTurn:
				army.apply_status("Retreat", 2)
			_clearMovableHighlights()
			if partner != null:
				var w = get_parent()
				if army.isContract:
					# The company walks in and joins the commander where he stands.
					w.attach_company(partner, army)
					deselectAll()
					return
				# The commander picks the company up, then marches onto its tile.
				w.attach_company(army, partner)
			waypoints = route
	elif selectedCPF != null:
		startingPoint = selectedCPF.currentPathPoint
		# Action point gate — civilians spend 1 point per tile moved
		if selectedCPF.thisCivilian != null:
			var _civ = selectedCPF.thisCivilian
			if _civ.isWorker:
				# Workers stay on liberated ground, one to a tile.
				if _civ.captured:
					emit_signal("movement_blocked", "This worker is held by the British.")
					return
				if endPathPoint.ppbTile == null or selectedCPF.thisCountry == null or endPathPoint.ppbTile.tileOwner != selectedCPF.thisCountry.CID:
					emit_signal("movement_blocked", "Workers only travel on liberated ground.")
					return
				for other in raisedPlayerCPFs:
					if is_instance_valid(other) and other != selectedCPF and other.currentPathPoint == endPathPoint:
						emit_signal("movement_blocked", "Another worker is already there.")
						return
			if selectedCPF.thisCivilian.currentActionPoints <= 0:
				emit_signal("movement_blocked", "Out of moves this turn — this civilian can move again next turn.")
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
	for wp in waypoints:
		curve.add_point(wp.position)
	moveArmy($PathsControl/Path/PathFollow/Control, "start", endPathPoint)

# ── MULTI-TILE MARCH (liberation economy) ────────────────────────────────────
# An army may go to any tile it can pay for with the movement it has left. It can only
# march THROUGH friendly, empty ground that no Redcoat army covers; the last step may be
# anything a single step could always do (enemy ground, a siege, a tile on the Redcoat line).
func _step_cost(army, tile) -> int:
	if army.parentCountry != null and army.parentCountry.CID == "USA":
		return 1   # USA reclamation: every move costs a flat 1 point
	return tile.get_move_cost(army)


# A friendly army on that point which `army` may join (company -> commander) or pick up
# (commander -> company), or null.
func _attach_partner(army, ppb):
	var other = ppb.stationedArmy
	if other == null or not is_instance_valid(other) or other == army or other.deleteMode or other.manpowerInArmy <= 0:
		return null
	if other.parentCountry != army.parentCountry:
		return null
	if (army.isContract and other.can_host_company()) or (other.isContract and army.can_host_company()):
		return other
	return null


# The live army standing on a path point, or null. A worker on the tile does not count:
# a tile holds one army and one civilian.
func _army_on(ppb):
	var a = ppb.stationedArmy
	if a == null or not is_instance_valid(a) or a.deleteMode or a.manpowerInArmy <= 0:
		return null
	return a


func _can_end_on(army, ppb) -> bool:
	var t = ppb.ppbTile
	if t == null:
		return false
	if not war_active and t.tileOwner == "UK":
		return false
	if zoc_block_reason(army, t) != "":
		return false
	if _army_on(ppb) != null:
		return _attach_partner(army, ppb) != null
	return true


func _can_pass_through(army, ppb) -> bool:
	var t = ppb.ppbTile
	if t == null or _army_on(ppb) != null or army.parentCountry == null:
		return false
	var cid: String = army.parentCountry.CID
	return t.tileOwner == cid and t.redcoat_line_army(cid) == null


# {"cost": {ppb: movement spent to end there}, "prev": {ppb: the point before it}}
func reachable_from(startPPB, army) -> Dictionary:
	var finals: Dictionary = {}
	var prev: Dictionary = {}
	if startPPB == null or army == null or not is_instance_valid(army) or army.parentCountry == null:
		return {"cost": finals, "prev": prev}
	var budget: int = int(army.currentMovementPoints)
	var best: Dictionary = {startPPB: 0}
	var frontier: Array = [startPPB]
	while not frontier.is_empty():
		var bi: int = 0
		for i in frontier.size():
			if best[frontier[i]] < best[frontier[bi]]:
				bi = i
		var cur = frontier.pop_at(bi)
		if cur != startPPB and not _can_pass_through(army, cur):
			continue
		for nb in cur.neighborPathPoints:
			if not is_instance_valid(nb) or nb == startPPB or nb.ppbTile == null:
				continue
			var c: int = int(best[cur]) + _step_cost(army, nb.ppbTile)
			if c > budget or (best.has(nb) and int(best[nb]) <= c):
				continue
			var can_end: bool = _can_end_on(army, nb)
			if not can_end and not _can_pass_through(army, nb):
				continue
			best[nb] = c
			prev[nb] = cur
			if can_end:
				finals[nb] = c
			frontier.append(nb)
	return {"cost": finals, "prev": prev}


# The points to walk, in order, ending on endPPB. Empty when it can't be reached this turn.
func route_to(startPPB, endPPB, army) -> Array:
	var r: Dictionary = reachable_from(startPPB, army)
	if not r["cost"].has(endPPB):
		return []
	var route: Array = []
	var cur = endPPB
	while cur != startPPB and cur != null:
		route.push_front(cur)
		cur = r["prev"].get(cur)
	return route


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
		if atk.movedThisTurn and not atk._army_has_active_mod("Night Raider"):
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

const FLANK_ALLY_BONUS: float = 1.0   # each adjacent US army adds this many base-damage multiples


func _flank_ally_count(target_tile, attacker) -> int:
	if target_tile == null:
		return 0
	var n: int = 0
	for nb in target_tile.TileNeighbors:
		if nb == null:
			continue
		var a = nb.stationedArmy
		if a == null and nb.tileSpawnPoint != null:
			a = nb.tileSpawnPoint.stationedArmy
		if a != null and a != attacker and is_instance_valid(a) and not a.deleteMode \
				and a.parentCountry != null and a.parentCountry.CID == "USA":
			n += 1
	return n


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
	var pierce: int = int(_bt.get("shield_pierce", 0))
	if attacker.is_flanking():
		# Half base alone, +1x base per US army neighbouring the target (encirclement payoff).
		var mult: float = 0.5 + float(_flank_ally_count(targetPPB.ppbTile, attacker)) * FLANK_ALLY_BONUS
		def_loss = int(def_loss * mult)
		pierce = int(pierce * mult)
	if _bt.get("hold_fired", false):
		defender.consume_hold_volley()   # their braced line fired first; now it reloads
	defender.calculateDefenderResults("melee", def_loss, true, pierce)
	attacker.calculateDefenderResults("melee", atk_loss, true)
	attacker.spend_attack_ap()
	attacker.start_fired_reloads()
	var _gone: bool = (not is_instance_valid(defender) or defender.manpowerInArmy <= 0)
	attacker.on_attack_resolved(defender, def_loss, _gone)
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


# ═════════════════════════════════════════════════════════════════════════════
# ARMY BADGES — GUI pass 2026-10-26 (see army_badge.gd)
#  • verdicts: while one of your armies is selected, every enemy badge on screen is
#    coloured by the real battle maths run both ways (▲ win / = close / ▼ lose)
#  • declutter: badges that would overlap on screen collapse to compact STR chips;
#    the selected, hovered and stronger armies keep their full plaque
# ═════════════════════════════════════════════════════════════════════════════
const BADGE_PASS_SEC := 0.12
const VERDICT_PASS_SEC := 0.6
const VERDICT_WIN := 1.3       # deal/take ratio for ▲
const VERDICT_LOSE := 0.77     # …and for ▼
var _badgeT := 0.0
var _verdictT := 0.0
var _verdictFor = null

func _tick_badges(delta: float) -> void:
	_badgeT += delta
	if _badgeT >= BADGE_PASS_SEC:
		_badgeT = 0.0
		_declutter_badges()
	_verdictT += delta
	var sel = selectedAPF if (selectedAPF != null and is_instance_valid(selectedAPF)) else null
	if sel != null:
		if _verdictFor != sel or _verdictT >= VERDICT_PASS_SEC:
			_verdictT = 0.0
			_verdictFor = sel
			_refresh_verdicts(sel)
	elif _verdictFor != null:
		_verdictFor = null
		for apf in raisedPlayerAPFs:
			if is_instance_valid(apf) and apf.badge != null:
				apf.badge.set_verdict(-1)

func _badge_screen_rect(apf) -> Rect2:
	var b = apf.badge
	var r: Rect2 = b.rect_local()
	var xf: Transform2D = get_viewport().get_canvas_transform() * b.get_global_transform()
	var p0: Vector2 = xf * r.position
	var p1: Vector2 = xf * r.end
	return Rect2(p0, p1 - p0).abs()

func _token_screen_rect(apf) -> Rect2:
	# the diamond: centre ~(2, 30) in token space, half-diagonal ~36
	var xf: Transform2D = get_viewport().get_canvas_transform() * apf.get_global_transform()
	var c: Vector2 = xf * Vector2(2, 30)
	var h: float = (xf.basis_xform(Vector2(30, 0))).length()
	return Rect2(c - Vector2(h, h), Vector2(h, h) * 2.0)

func _on_screen(apf) -> bool:
	var vr := get_viewport().get_visible_rect().grow(60)
	return vr.has_point(get_viewport().get_canvas_transform() * apf.global_position)

func _refresh_verdicts(sel) -> void:
	var mine = sel.thisArmy
	if mine == null or not is_instance_valid(mine):
		return
	for apf in raisedPlayerAPFs:
		if not is_instance_valid(apf) or apf.badge == null or apf == sel:
			continue
		var them = apf.thisArmy
		if them == null or not is_instance_valid(them) or not them.enemy or not _on_screen(apf):
			apf.badge.set_verdict(-1)
			continue
		apf.badge.set_verdict(_verdict(mine, them))

func _verdict(mine, them) -> int:
	# One attack each way with the game's own formula (fresh actions; holders counted as
	# attackers for the threat side). deal/take are fractions of each side's shield+manpower.
	var a: Dictionary = mine.compute_battle_against(them, false)
	var b: Dictionary = them.compute_battle_against(mine, false, true)
	var their_hp: float = maxf(1.0, float(them.manpowerInArmy + them.armyShield))
	var my_hp: float = maxf(1.0, float(mine.manpowerInArmy + mine.armyShield))
	var deal: float = float(a["def_loss"]) / their_hp
	var take: float = float(b["def_loss"] + a["atk_loss"]) / my_hp
	if deal >= 1.0 and take < 1.0:
		return 2
	if take >= 1.0 and deal < 1.0:
		return 0
	var ratio: float = (deal + 0.02) / (take + 0.02)
	if ratio >= VERDICT_WIN:
		return 2
	if ratio <= VERDICT_LOSE:
		return 0
	return 1

func _declutter_badges() -> void:
	var items: Array = []
	for apf in raisedPlayerAPFs:
		if not is_instance_valid(apf) or apf.badge == null or not apf.visible:
			continue
		var pri: float = float(apf.badge.strength)
		if apf == selectedAPF:
			pri += 1e9
		if apf._hover_scale > 1.01:
			pri += 1e10
		if apf.thisArmy != null and is_instance_valid(apf.thisArmy) and not apf.thisArmy.enemy:
			pri += 1e6
		items.append([pri, apf])
	items.sort_custom(func(x, y): return x[0] > y[0])
	# every token's diamond is an obstacle too, so a plaque never hides another army
	var diamonds: Dictionary = {}
	for it in items:
		diamonds[it[1]] = _token_screen_rect(it[1])
	var placed: Array = []
	for it in items:
		var apf = it[1]
		apf.badge.compact = false
		var r: Rect2 = _badge_screen_rect(apf)
		var hit := false
		for q in placed:
			if r.intersects(q):
				hit = true
				break
		var vip: bool = apf == selectedAPF or apf._hover_scale > 1.01
		if not hit and not vip:
			for other in diamonds:
				if other != apf and r.intersects(diamonds[other]):
					hit = true
					break
		if hit and apf._hover_scale <= 1.01:
			apf.badge.compact = true
			r = _badge_screen_rect(apf)
		placed.append(r)
