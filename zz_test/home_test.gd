extends Node
# Liberation economy step 2: commander homes, granted armies, displacement, War Room lines.
func _labels(n: Node, out: Array) -> void:
	if n is Label: out.append(n.text)
	for c in n.get_children(): _labels(c, out)

func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 10: await get_tree().process_frame
	var ok := true
	var homes: Dictionary = world._commander_homes
	var reg := {}; var states := {}; var types := {}; var archs := {}
	for n in homes:
		var h = homes[n]; var t = h["tile"]
		var r: String = world._home_region_of(t)
		reg[r] = reg.get(r, 0) + 1
		states[t.tileContinent] = states.get(t.tileContinent, 0) + 1
		types[h["army_type"]] = types.get(h["army_type"], 0) + 1
		archs[h["arch"]["id"]] = archs.get(h["arch"]["id"], 0) + 1
		if int(t.buildings.get("barracks", 0)) < 1: ok = false; print("HT FAIL no barracks ", t.tileName)
		print("HT home %-14s %s %-9s %-6s %-26s %s" % [t.tileName, t.tileContinent, t.terrain, h["army_type"], h["arch"]["name"], "GRANTED" if h["granted"] else t.tileOwner])
	print("HT count=", homes.size(), " regions=", reg, " states=", states, " types=", types, " distinct archetypes=", archs.size())
	ok = ok and homes.size() == 25
	var granted := 0
	for n in homes:
		var h = homes[n]
		if not h["granted"]: continue
		granted += 1
		var a = h["army"]
		if a == null: ok = false; print("HT FAIL no army at ", h["tile"].tileName); continue
		var ws := []
		for u in a.unitsList: ws.append(u.unitWeapon.weaponType if u.unitWeapon != null and u.unitWeapon.get("weaponType") != null else "?")
		print("HT stats %-8s atk=%d (melee %d ranged %d) def=%d shield=%d men=%d" % [h["army_type"], int(a.armyPunch + a.armyLaunch), int(a.armyPunch), int(a.armyLaunch), int(a.armyDefence), int(a.armyMaxShield), a.maxManpower])
		print("HT start army: ", a.ArmyName, " led by ", a.commander.governorType if a.commander != null else "NOBODY", " units=", ws, " men=", a.manpowerInArmy, "/", a.maxManpower, " at ", a.inTile.tileName, " type=", h["army_type"], " mods1=", a.commanderModifiers1.size())
		ok = ok and a.commander == h["gov"] and a.unitsList.size() == 2 and h["tile"].tileGovernor == h["gov"]
	for tp in ["Minutemen", "Dragoons", "Artillery Battery"]:
		var free: Array = world._free_muster_tiles()
		world._raise_archetype_army(free[0], tp)
		var ma = world.playerCountryNode.countryArmyList.back()
		print("HT stats militia %-18s atk=%d (melee %d ranged %d) def=%d shield=%d men=%d leader=%s" % [tp, int(ma.armyPunch + ma.armyLaunch), int(ma.armyPunch), int(ma.armyLaunch), int(ma.armyDefence), int(ma.armyMaxShield), ma.maxManpower, str(ma.commander)])
	print("HT granted=", granted, " player armies=", world.playerCountryNode.countryArmyList.size(), " governors=", world.playerCountryNode.unlockedGovernors.size())
	ok = ok and granted == 4

	# liberate a home behind the lines
	var target = null
	for n in homes:
		if not homes[n]["granted"]: target = homes[n]; break
	var tt = target["tile"]
	var n0: int = world.playerCountryNode.countryArmyList.size()
	world.tileSiegeWon(tt, "UK", "USA")
	print("HT liberated ", tt.tileName, " granted=", target["granted"], " gov=", target["gov"].governorType if target["gov"] != null else "none", " pending=", world._pending_commander_armies)
	world._retry_pending_commander_armies()
	var la = target["army"]
	print("HT after muster: army=", la.ArmyName if la != null else "NONE", " at ", la.inTile.tileName if la != null else "-", " armies ", n0, " -> ", world.playerCountryNode.countryArmyList.size())
	ok = ok and target["granted"] and la != null and world.playerCountryNode.countryArmyList.size() == n0 + 1

	# displacement on a starting home (hook only, so the army stays alive)
	var vf = homes[1]; var va = vf["army"]
	for u in va.unitsList: u.unitCurrentManpower = int(u.unitMaxManpower * 0.6)
	va.updateArmyUI()
	var m0: int = va.manpowerInArmy
	world._on_commander_home_changed(vf["tile"], "USA", "UK")
	var seq := [m0]
	for i in 12:
		va.onTurnEnd(); seq.append(va.manpowerInArmy)
	print("HT displaced=", va.displaced, " men by turn ", seq)
	ok = ok and va.displaced and seq[1] < seq[0] and seq[12] == seq[11] and seq[12] > 0
	world._on_commander_home_changed(vf["tile"], "UK", "USA")
	va.onTurnEnd()
	print("HT restored displaced=", va.displaced, " men ", seq[12], " -> ", va.manpowerInArmy)
	ok = ok and not va.displaced and va.manpowerInArmy > seq[12]

	# a real loss of the liberated home: the army on the tile is destroyed with it
	world.tileSiegeWon(tt, "USA", "UK")
	for i in 5: await get_tree().process_frame
	world._tick_commander_remuster()          # notices the loss, starts the clock
	var c0: int = target["remuster"]
	for i in 3: world._tick_commander_remuster()   # enemy holds the home: clock must not move
	var c1: int = target["remuster"]
	world.tileSiegeWon(tt, "UK", "USA")
	world._retry_pending_commander_armies()
	var early: bool = world._army_alive(target["army"])
	var turns := 0
	while not world._army_alive(target["army"]) and turns < 20:
		world._tick_commander_remuster(); world._retry_pending_commander_armies(); turns += 1
	print("HT remuster: clock ", c0, " held-by-enemy ", c1, " army right after retake=", early, " back after ", turns, " held turns, new army=", target["army"] != la, " men=", target["army"].manpowerInArmy if world._army_alive(target["army"]) else -1)
	ok = ok and c0 == 10 and c1 == 10 and not early and turns == 10 and world._army_alive(target["army"])

	# War Room
	var wr = world.get_node("CanvasLayer/WarRoomPanel")
	wr.visible = true
	await get_tree().process_frame
	var txt := []
	_labels(wr.get_node("PanelBackground/TabContainer/COMMANDERS/ScrollContainer/CommanderVBox"), txt)
	var shown := 0
	for s in txt:
		if s.contains(" men ") or s.contains("BEHIND") or s.begins_with("    ") or s.contains("DISPLACED"):
			if shown < 9: print("HT wr: ", s)
			shown += 1
	print("HT wr lines=", txt.size(), " waiting=", wr.waitingCommanders.size())
	ok = ok and wr.waitingCommanders.size() == 20
	if OS.get_environment("SHOT_OUT") != "":
		for i in 10: await get_tree().process_frame
		get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT_OUT"))
	wr.visible = false

	# turns
	var ec = world.get_node("CanvasLayer/EventControl/EventContainer")
	for t in 4:
		for c in ec.get_children(): c.queue_free()
		world._skip_ai_playback = true
		await world._on_next_turn_pressed()
		for i in 10: await get_tree().process_frame
	var alive := 0
	for n in homes:
		if world._army_alive(homes[n]["army"]): alive += 1
	print("HT turn ", world.currentWorldTurn, " commander armies alive=", alive, " tiles=", world.playerCountryNode.OwnedTileList.size())
	print("HT RESULT ", "PASS" if ok else "FAIL")
	get_tree().quit(0 if ok else 1)
