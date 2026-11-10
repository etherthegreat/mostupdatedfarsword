extends Node
# Liberation economy step 4: construction sites, workers, FBPs, capture, state bonus; AI movement.
func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 10: await get_tree().process_frame
	var ok := true
	var p = world.playerCountryNode
	var pc = world.get_node("PathControl")
	var sites: Dictionary = world._construction_sites
	var held := 0
	for n in sites:
		var s = sites[n]; var w = s["worker"]
		print("WT site %-14s %s owner=%s workshop=L%d worker=%s" % [s["tile"].tileName, s["tile"].tileContinent, s["tile"].tileOwner, s["tile"].get_building_level("workshop"), ("fbp %d at %s on map=%s" % [w.fbp, world.worker_tile(w).tileName, str(world._worker_cpf(w) != null)]) if w != null else "none"])
		if w != null:
			held += 1
			if w.fbp != 1 or world._worker_cpf(w) == null: ok = false
	var cards: int = world.get_node("CanvasLayer/CivilianControl/Civilian Container").get_child_count()
	print("WT sites=", sites.size(), " held=", held, " civilian cards=", cards, " workers paid for=", p.activeCivilianCount)
	ok = ok and sites.size() == 12 and held == 4 and cards == 4 and p.activeCivilianCount == 4

	var hb = sites[12]["tile"]; var w0 = sites[12]["worker"]
	p.TotalDollars = 3000
	var d0: int = int(p.TotalDollars)
	var costs := []
	costs.append(world.building_upgrade_cost(hb, "Mine"))
	var u1: bool = world.worker_upgrade(w0, hb, "Mine")
	var mine_node = null
	for b in hb.tileBuildingsList:
		if b.buildingType == "Mine": mine_node = b
	costs.append(world.building_upgrade_cost(hb, "Workshop")); var u2: bool = world.worker_upgrade(w0, hb, "Workshop")
	costs.append(world.building_upgrade_cost(hb, "Workshop")); var u3: bool = world.worker_upgrade(w0, hb, "Workshop")
	costs.append(world.building_upgrade_cost(hb, "Workshop"))
	print("WT upgrades ok=", [u1, u2, u3], " costs=", costs, " dollars ", d0, " -> ", int(p.TotalDollars), " mine L", hb.get_building_level("mine"), "/node L", mine_node.buildingLevel, " workshop L", hb.get_building_level("workshop"), " fbp=", w0.fbp)
	ok = ok and u1 and u2 and u3 and costs == [200, 600, 1200, -1] and int(p.TotalDollars) == d0 - 2000 and hb.get_building_level("mine") == 2 and mine_node.buildingLevel == 2 and w0.fbp == 3
	var addable: Array = world.worker_addable(hb)
	var a1: bool = world.worker_add_building(w0, hb, "Farm")
	var a2: bool = world.worker_add_building(w0, hb, "Barracks")
	var a3: bool = world.worker_add_building(w0, hb, "Workshop")
	var a4: bool = world.worker_add_building(w0, hb, "Farm")
	print("WT add Farm=", a1, " Barracks=", a2, " Workshop=", a3, " Farm again=", a4, " fbp=", w0.fbp, " farm L", hb.get_building_level("farm"), " buildings=", hb.buildings, " addable had ", addable.size())
	ok = ok and a1 and not a2 and not a3 and not a4 and w0.fbp == 2 and hb.get_building_level("farm") == 1 and not addable.has("Barracks") and not addable.has("Workshop")
	w0.fbp = 0
	ok = ok and not world.worker_add_building(w0, hb, "Market")
	w0.fbp = 2

	# panels
	world.updateCivFunc(w0, hb.tileSpawnPoint)
	await get_tree().process_frame
	var bl = world._workerPanel.find_child("Buildings", true, false)
	var ad = world._workerPanel.find_child("Add", true, false)
	print("WT worker panel: buildings=", bl.get_child_count(), " add buttons=", ad.get_child_count(), " '", world._workerPanel.find_child("Budget", true, false).text, "'")
	ok = ok and bl.get_child_count() == hb.tileBuildingsList.size()
	world._on_civilian_button_pressed()
	await get_tree().process_frame
	print("WT sites panel rows=", world._sitesPanel.find_child("Rows", true, false).get_child_count())
	ok = ok and world._sitesPanel.find_child("Rows", true, false).get_child_count() == 12
	world._close_sites_panel()

	# a worker stays on liberated ground
	var cpf = world._worker_cpf(w0)
	var uk_nb = null; var us_nb = null
	for nb in cpf.currentPathPoint.neighborPathPoints:
		if nb.ppbTile.tileOwner == "UK": uk_nb = nb
		elif nb.ppbTile.tileOwner == "USA": us_nb = nb
	pc.selectedAPF = null; pc.selectedCPF = cpf
	var ap0: int = w0.currentActionPoints
	if uk_nb != null:
		pc.calculateArmyMovement(uk_nb, [], uk_nb.ppbTile)
		print("WT move onto British ground refused=", w0.currentActionPoints == ap0)
		ok = ok and w0.currentActionPoints == ap0
	pc.deselectAll()

	# capture and release
	world.tileSiegeWon(hb, "USA", "UK")
	var cap: bool = w0.captured
	var blocked: String = world.worker_block_reason(w0, hb)
	world.tileSiegeWon(hb, "UK", "USA")
	print("WT captured=", cap, " while held: '", blocked, "' freed=", not w0.captured)
	ok = ok and cap and blocked != "" and not w0.captured

	# liberating a site behind the lines frees its worker
	var rich = sites[51]["tile"]
	world.tileSiegeWon(rich, "UK", "USA")
	var rw = sites[51]["worker"]
	print("WT Richmond liberated: worker=", rw != null, " fbp=", rw.fbp if rw != null else -1, " workers=", world.all_workers().size())
	ok = ok and rw != null and rw.fbp == 1 and world.all_workers().size() == 5

	# whole state liberated: +1 for workers standing in it, once
	var aw = sites[38]["worker"]; var f0: int = aw.fbp; var flipped := 0
	for t in world.get_node("TileController").get_children():
		if t.tileContinent == "MD" and t.tileOwner != "USA":
			world.tileSiegeWon(t, t.tileOwner, "USA"); flipped += 1
	var f1: int = aw.fbp
	var md = sites[38]["tile"]
	world.tileSiegeWon(md, "USA", "UK"); world.tileSiegeWon(md, "UK", "USA")
	print("WT Maryland: flipped ", flipped, " tiles, Annapolis worker fbp ", f0, " -> ", f1, " after losing and retaking: ", aw.fbp)
	ok = ok and flipped > 0 and f1 == f0 + 1 and aw.fbp == f1

	# British and Canadian armies move by the same numbers
	var mv := {}
	for c in world.aliveCountriesList:
		if c.Player: continue
		for a in c.countryArmyList:
			var k := ""
			for u in a.unitsList: k += "S" if u.unitWeapon.is_saber() else ("A" if u.unitWeapon.is_artillery() else "M")
			mv[c.CID + " " + k] = a.base_movement_points()
	print("WT AI movement by make-up: ", mv)
	var ec = world.get_node("CanvasLayer/EventControl/EventContainer")
	for t in 6:
		for c in ec.get_children(): c.queue_free()
		world._skip_ai_playback = true
		await world._on_next_turn_pressed()
		for i in 10: await get_tree().process_frame
		var uk = world._country_by_cid("UK")
		print("WT turn ", world.currentWorldTurn, " US tiles=", p.OwnedTileList.size(), " UK armies=", uk.countryArmyList.size(), " workers=", world.all_workers().size(), " captured=", world.all_workers().filter(func(x): return x.captured).size(), " $", int(p.TotalDollars))
	print("WT RESULT ", "PASS" if ok else "FAIL")
	get_tree().quit(0 if ok else 1)
