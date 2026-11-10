extends Node
# Liberation economy step 3: Minutemen contracts.
func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 10: await get_tree().process_frame
	var ok := true
	var p = world.playerCountryNode
	var by_region := {}; var lefts := []
	for a in p.countryArmyList:
		if not a.isContract: continue
		var r: String = world._home_region_of(a.inTile)
		by_region[r] = by_region.get(r, 0) + 1
		lefts.append(a.contractTurnsLeft)
		var ws := []
		for u in a.unitsList: ws.append(u.unitWeapon.weaponType)
		print("CT start %-26s %s %-12s turns=%d units=%s leader=%s ground=%s" % [a.ArmyName, a.inTile.tileContinent, r, a.contractTurnsLeft, str(ws), str(a.commander), str(a.inTile.is_muster_point())])
		if a.commander != null or a.unitsList.size() != 2: ok = false
	lefts.sort()
	print("CT starting companies by region ", by_region, " turns ", lefts, " armies total ", p.countryArmyList.size(), " upkeep $", p.lastUpkeepDollars)
	ok = ok and lefts.size() == 12 and by_region.get("South", 0) == 2 and by_region.get("Mid-Atlantic", 0) == 6 and by_region.get("North", 0) == 4 and lefts[0] == 4 and lefts[11] == 8

	# real turns: the starting companies go home on schedule (battle losses aside)
	var ec = world.get_node("CanvasLayer/EventControl/EventContainer")
	for t in 9:
		for c in ec.get_children(): c.queue_free()
		world._skip_ai_playback = true
		await world._on_next_turn_pressed()
		for i in 10: await get_tree().process_frame
		var alive := 0; var mx := 0
		for a in p.countryArmyList:
			if is_instance_valid(a) and a.isContract and not a.deleteMode:
				alive += 1; mx = maxi(mx, a.contractTurnsLeft)
		print("CT turn ", world.currentWorldTurn, " companies=", alive, " longest left=", mx, " tiles=", p.OwnedTileList.size(), " Mp=", p.TotalManpower, " $", int(p.TotalDollars))
		if world.currentWorldTurn == 9 and alive != 0: ok = false
		if world.currentWorldTurn == 4 and mx != 5: ok = false
	p.TotalManpower = 5000
	var grounds: Array = world.hiring_grounds()
	var free = null
	for t in grounds:
		print("CT ground %-14s %s cost=%d why='%s'" % [t.tileName, t.tileContinent, world.contract_cost(t), world.contract_block_reason(t)])
		if free == null and world.contract_block_reason(t) == "": free = t
	p.TotalManpower = 5000
	var n0: int = p.countryArmyList.size()
	var costs := []
	for k in 3:
		var before: int = p.TotalManpower
		var hired: bool = world.hire_contract(free, "musket", "arty" if k == 0 else "saber")
		var co = world._contract_company_of(free)
		costs.append(before - p.TotalManpower)
		var ws := []
		for u in co.unitsList: ws.append(u.unitWeapon.weaponType)
		print("CT hire ", k + 1, " ok=", hired, " cost=", before - p.TotalManpower, " units=", ws, " turns=", co.contractTurnsLeft, " second hire now: '", world.contract_block_reason(free), "'")
		ok = ok and hired and not world.hire_contract(free, "musket", "musket")
		if k == 0:
			# no recruits for a company
			co.unitsList[0].unitCurrentManpower = 40
			co.updateArmyUI()
			var m0: int = co.manpowerInArmy
			co.onTurnEnd()
			print("CT no recruits: ", m0, " -> ", co.manpowerInArmy)
			ok = ok and co.manpowerInArmy == m0
		var seq := []
		for i in 5:
			world._tick_contracts()
			seq.append(co.contractTurnsLeft if is_instance_valid(co) and not co.deleteMode else -1)
		for i in 3: await get_tree().process_frame
		print("CT countdown ", seq, " still serving=", world._contract_company_of(free) != null, " tile free=", world._tile_free_for_army(free))
		ok = ok and world._contract_company_of(free) == null
	print("CT costs ", costs, " after three: '", world.contract_block_reason(free), "' cost=", world.contract_cost(free))
	ok = ok and costs == [500, 750, 1000] and world.contract_cost(free) == -1

	world._open_contract_panel()
	await get_tree().process_frame
	var rows = world._contractPanel.find_child("Rows", true, false)
	print("CT panel rows=", rows.get_child_count(), " grounds=", grounds.size(), " budget='", world._contractPanel.find_child("Budget", true, false).text, "'")
	ok = ok and rows.get_child_count() == grounds.size()
	world._contract_pick("left", "saber")
	world._close_contract_panel()

	print("CT RESULT ", "PASS" if ok else "FAIL")
	get_tree().quit(0 if ok else 1)
