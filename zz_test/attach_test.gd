extends Node
# Liberation economy: movement by unit type, multi-tile march, attaching Minutemen.
var world
var pc
func _settle() -> void:
	for i in 260: await get_tree().process_frame

func _kinds(a) -> String:
	var s := []
	for u in a.unitsList:
		s.append("S" if u.unitWeapon.is_saber() else ("A" if u.unitWeapon.is_artillery() else "M"))
	return "".join(s)

func _ready() -> void:
	world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 10: await get_tree().process_frame
	pc = world.get_node("PathControl")
	pc.war_active = true
	var ok := true
	var p = world.playerCountryNode
	var expect := {"MM": 2, "SS": 3, "AM": 1, "MA": 1, "MS": 2, "SM": 2, "AA": 1, "SA": 2, "AS": 2}
	var seen := {}
	for a in p.countryArmyList:
		var k := _kinds(a)
		seen[k] = "%d/%d" % [a.currentMovementPoints, a.maxMovementPoints]
		if a.commanderHome != null or a.isContract:
			if a.maxMovementPoints != expect[k] or a.currentMovementPoints < expect[k]:
				ok = false; print("AT FAIL moves ", a.ArmyName, " ", k, " ", a.currentMovementPoints, "/", a.maxMovementPoints)
	print("AT movement by make-up (now/max): ", seen)

	# reach + a real multi-tile march with the fastest company
	var runner = null
	var start = null
	var reach: Dictionary = {}
	var far = null
	for a in p.countryArmyList:
		if a.maxMovementPoints != 3: continue
		var st = a.inTile.tileSpawnPoint
		var rc: Dictionary = pc.reachable_from(st, a)
		for ppb in rc["cost"]:
			if rc["cost"][ppb] >= 2 and ppb.ppbTile.tileOwner == "USA" and not ppb.occupied and ppb.ppbTile.redcoat_line_army("USA") == null:
				if far == null or rc["cost"][ppb] > reach["cost"][far]:
					far = ppb; runner = a; start = st; reach = rc
	var by_cost := {}
	for ppb in reach["cost"]: by_cost[reach["cost"][ppb]] = by_cost.get(reach["cost"][ppb], 0) + 1
	print("AT ", runner.ArmyName, " at ", runner.inTile.tileName, " reach by cost ", by_cost, " neighbours ", start.neighborPathPoints.size())
	ok = ok and far != null and reach["cost"].size() > 0
	if far != null:
		var c: int = reach["cost"][far]
		var route: Array = pc.route_to(start, far, runner)
		var names := []
		for r in route: names.append(r.ppbTile.tileName)
		pc.selectedAPF = start.stationedAPF
		pc._highlightMovableTiles(start)
		var lit: int = pc._highlightedTiles.size()
		var moved: bool = pc.tryMoveSelectedAPFToTile(far.ppbTile)
		await _settle()
		print("AT march cost ", c, " via ", names, " highlighted=", lit, " moved=", moved, " now at ", runner.inTile.tileName, " moves left ", runner.currentMovementPoints, " old tile cleared=", start.stationedArmy == null and not start.occupied, " new tile holds it=", far.stationedArmy == runner)
		ok = ok and moved and runner.inTile == far.ppbTile and runner.currentMovementPoints == 3 - c and start.stationedArmy == null and far.stationedArmy == runner and lit == reach["cost"].size()
		# one tile too far is refused
		var too_far = null
		for t in world.get_node("TileController").get_children():
			if t.tileSpawnPoint != null and not pc.reachable_from(far, runner)["cost"].has(t.tileSpawnPoint) and t != runner.inTile: too_far = t; break
		ok = ok and not pc.tryMoveSelectedAPFToTile(too_far)
	pc.deselectAll()

	# hire straight into a commander army standing on its ground
	var host = null
	for n in world._commander_homes:
		var h = world._commander_homes[n]
		if h["granted"] and h["army"] != runner and h["army"].inTile == h["tile"]:
			host = h["army"]; break
	var vf = host.inTile
	p.TotalManpower = 5000
	var mv0: int = host.maxMovementPoints
	var why: String = world.contract_block_reason(vf)
	var hired: bool = world.hire_contract(vf, "musket", "saber")
	var mods := []
	for mm in host.attachedUnits[0].militaryModifierList: mods.append(mm.milModType)
	var cmd := []
	for mm in host.commander.govMilModsLvl1: cmd.append(mm.milModType)
	var has_all := true
	for m in cmd:
		if not mods.has(m): has_all = false
	print("AT hire into host: why='", why, "' ok=", hired, " units=", _kinds(host), " attached=", host.attachedUnits.size(), " turns=", host.attachedTurnsLeft, " moves max ", mv0, "->", host.maxMovementPoints, " commander traits ", cmd, " on attached unit=", has_all, " men=", host.maxManpower)
	ok = ok and hired and host.unitsList.size() == 4 and host.attachedTurnsLeft == 5 and host.maxMovementPoints == mv0 and has_all
	ok = ok and world.contract_block_reason(vf).begins_with("Its company is still serving")
	var badge = vf.tileSpawnPoint.stationedAPF.badge
	badge.update_from(host)
	print("AT badge chip on host=", badge.contract)

	# detach
	var n0: int = p.countryArmyList.size()
	var det: bool = world.detach_company(host)
	var co = p.countryArmyList.back()
	print("AT detach ok=", det, " host units=", _kinds(host), " company ", co.ArmyName, " at ", co.inTile.tileName, " units=", _kinds(co), " turns=", co.contractTurnsLeft, " moves=", co.currentMovementPoints, " ground=", co.contractTile.tileName)
	ok = ok and det and host.unitsList.size() == 2 and host.attachedTurnsLeft == -1 and co.isContract and co.unitsList.size() == 2 and co.currentMovementPoints == 0 and p.countryArmyList.size() == n0 + 1
	for i in 5: await get_tree().process_frame

	# company walks back in and attaches
	co.onTurnEnd(); host.onTurnEnd()
	var co_ppb = co.inTile.tileSpawnPoint
	pc.selectedAPF = co_ppb.stationedAPF
	var m1: bool = pc.tryMoveSelectedAPFToTile(vf)
	for i in 10: await get_tree().process_frame
	print("AT walk-in attach moved=", m1, " host units=", _kinds(host), " turns=", host.attachedTurnsLeft, " company tile cleared=", co_ppb.stationedArmy == null and not co_ppb.occupied, " armies=", p.countryArmyList.size())
	ok = ok and m1 and host.unitsList.size() == 4 and co_ppb.stationedArmy == null and p.countryArmyList.size() == n0

	# commander picks a company up by marching onto it
	world.detach_company(host)
	var co2 = p.countryArmyList.back()
	for i in 5: await get_tree().process_frame
	host.onTurnEnd()
	var target = co2.inTile
	pc.selectedAPF = vf.tileSpawnPoint.stationedAPF
	var m2: bool = pc.tryMoveSelectedAPFToTile(target)
	await _settle()
	print("AT pick-up moved=", m2, " host at ", host.inTile.tileName, " units=", _kinds(host), " old tile empty=", vf.tileSpawnPoint.stationedArmy == null, " armies=", p.countryArmyList.size())
	ok = ok and m2 and host.inTile == target and host.unitsList.size() == 4 and p.countryArmyList.size() == n0
	pc.deselectAll()

	# contract runs out while attached
	var seq := []
	for i in 5:
		world._tick_contracts(); seq.append(host.attachedTurnsLeft)
	for i in 5: await get_tree().process_frame
	print("AT attached countdown ", seq, " host units=", _kinds(host), " alive=", world._army_alive(host))
	ok = ok and host.unitsList.size() == 2 and host.attachedTurnsLeft == -1 and world._army_alive(host)

	var ec = world.get_node("CanvasLayer/EventControl/EventContainer")
	for t in 3:
		for c in ec.get_children(): c.queue_free()
		world._skip_ai_playback = true
		await world._on_next_turn_pressed()
		for i in 10: await get_tree().process_frame
	print("AT turn ", world.currentWorldTurn, " tiles=", p.OwnedTileList.size())
	print("AT RESULT ", "PASS" if ok else "FAIL")
	get_tree().quit(0 if ok else 1)
