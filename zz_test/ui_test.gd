extends Node
# Panels: clicks must not fall through to the map, and only one panel shows at a time.
var world; var cl; var cam; var pc
func _click(pos: Vector2) -> void:
	get_viewport().warp_mouse(pos)   # the map asks where the real pointer is
	await get_tree().create_timer(0.05).timeout
	var mm := InputEventMouseMotion.new(); mm.position = pos; mm.global_position = pos
	Input.parse_input_event(mm)
	await get_tree().create_timer(0.08).timeout
	var ev := InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true; ev.position = pos; ev.global_position = pos
	Input.parse_input_event(ev)
	await get_tree().create_timer(0.08).timeout
	var up := InputEventMouseButton.new(); up.button_index = MOUSE_BUTTON_LEFT; up.pressed = false; up.position = pos; up.global_position = pos
	Input.parse_input_event(up)
	await get_tree().create_timer(0.08).timeout

func _hover(pos: Vector2):
	var mm := InputEventMouseMotion.new(); mm.position = pos; mm.global_position = pos
	get_viewport().push_input(mm)
	await get_tree().process_frame
	return get_viewport().gui_get_hovered_control()

func _aim(tile, screen_pos: Vector2) -> void:
	var vp: Vector2 = get_viewport().get_visible_rect().size
	cam.global_position = tile.tileSpawnPoint.global_position - (screen_pos - vp * 0.5) / cam.zoom.x
	await get_tree().create_timer(0.12).timeout

# Synthetic clicks land between frames and the tile handler wants the press in the same
# physics tick, so one try can miss. Three tries: any hit means the spot is reachable.
func _click_opens(pos: Vector2) -> bool:
	for attempt in 3:
		await _click(pos)
		if _card_open(): return true
	return false

func _card_open() -> bool:
	return world._tileInfoPanel != null and is_instance_valid(world._tileInfoPanel)

func _ready() -> void:
	world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 30: await get_tree().process_frame
	cl = world.get_node("CanvasLayer"); pc = world.get_node("PathControl")
	cam = world.get_node("CameraMovementController/Camera2D")
	for c in cl.get_node("EventControl/EventContainer").get_children(): c.queue_free()
	await get_tree().create_timer(0.6).timeout
	var ok := true
	var vp: Vector2 = get_viewport().get_visible_rect().size
	var T = null
	for t in world.get_node("TileController").get_children():
		if t.tileOwner == "USA" and t.tileSpawnPoint != null and not t.tileSpawnPoint.occupied and t.army_on(t) == null and t.terrain == "Farmlands":
			T = t; break
	var host = world._commander_homes[1]["army"]
	var grid := []
	for gx in 8:
		for gy in 6:
			grid.append(vp * Vector2((gx + 0.5) / 8.0, (gy + 0.5) / 6.0))
	# 1. nothing open: no part of the map is claimed, and real clicks reach tiles and armies
	var claimed := 0
	for g in grid:
		if cl.blocks_map_at(g): claimed += 1
	await _aim(T, vp * 0.5)
	var tile_ok: bool = await _click_opens(vp * 0.5)
	if not tile_ok:
		var hc0 = await _hover(vp * 0.5)
		print("UT   diag first click: events up=", cl.get_node("EventControl/EventContainer").get_child_count(), " hovered=", hc0.get_path() if hc0 != null else "none", " T on screen at ", T.tileSpawnPoint.get_global_transform_with_canvas().origin)
	world.resetUI()
	await _aim(host.inTile, vp * Vector2(0.5, 0.45))
	var tok: Vector2 = host.inTile.tileSpawnPoint.stationedAPF.get_node("APFButton").get_global_transform_with_canvas() * (host.inTile.tileSpawnPoint.stationedAPF.get_node("APFButton").size * 0.5)
	await _click(tok)
	var army_ok: bool = pc.selectedAPF != null
	world.resetUI()
	print("UT nothing open: map spots claimed by panels ", claimed, " of ", grid.size(), "   click a tile in mid-screen opens its card=", tile_ok, "   click an army selects it=", army_ok)
	ok = ok and claimed == 0 and tile_ok and army_ok
	# 2. each panel: inside what it covers the map stands down; beside it the map still works
	for nm in ["BeliefControl", "GovernmentControl", "FactionControl", "TechTree", "WarRoomPanel", "MilitaryPanelControl", "SpellSchoolsControl"]:
		var pn = cl.get_node(nm)
		cl.closeAllPanels()
		pn.visible = true
		await get_tree().create_timer(0.5).timeout
		if not cl._panel_rects.has(nm):
			print("UT %-22s covers nothing" % nm); ok = false; pn.visible = false; continue
		var r: Rect2 = cl._panel_rects[nm]
		var inside: Vector2 = r.position + r.size * Vector2(0.5, 0.9)
		await _aim(T, inside)
		var leaked: bool = await _click_opens(inside)
		world._close_tile_info()
		# an army token under the panel must not take the click either
		await _aim(host.inTile, r.get_center())
		await get_tree().create_timer(0.25).timeout
		var btn = host.inTile.tileSpawnPoint.stationedAPF.get_node("APFButton")
		var listening: bool = btn.mouse_filter != Control.MOUSE_FILTER_IGNORE
		var beside := "n/a (covers the screen)"
		if r.size.x < vp.x * 0.9:
			var out_pt := Vector2(r.position.x * 0.5, vp.y * 0.5) if r.position.x > 200.0 else Vector2((r.end.x + vp.x) * 0.5, vp.y * 0.5)
			pn.visible = true
			await _aim(T, out_pt)
			var b_ok: bool = await _click_opens(out_pt)
			if not b_ok:
				var hc = await _hover(out_pt)
				print("UT   diag beside ", out_pt, " hovered=", hc.get_path() if hc != null else "none", " claimed=", cl.blocks_map_at(out_pt), " rects=", cl._panel_rects.keys(), " T on screen at ", T.tileSpawnPoint.get_global_transform_with_canvas().origin)
			beside = str(b_ok)
			if not b_ok: ok = false
			world._close_tile_info()
		print("UT %-22s covers %s   tile click under it goes through=%s   army token under it listens=%s   tile click beside it works=%s" % [nm, str(r), str(leaked), str(listening), beside])
		ok = ok and not leaked and not listening
		pn.visible = false
		await get_tree().create_timer(0.3).timeout
	# 3. Area2D buttons inside a panel still get the mouse (beliefs and laws are built from them)
	cl.closeAllPanels()
	cl._on_belief_panel_button_pressed()
	await get_tree().create_timer(0.6).timeout
	var areas: Array = cl.get_node("BeliefControl").find_children("*", "Area2D", true, false)
	var got := [0]
	var probe = null
	for a in areas:
		if a.is_visible_in_tree() and a.input_pickable:
			probe = a; break
	if probe != null:
		probe.mouse_entered.connect(func(): got[0] += 1)
		var ap: Vector2 = probe.get_global_transform_with_canvas().origin
		for k in 4:
			var mm := InputEventMouseMotion.new(); mm.position = ap + Vector2(k, k); mm.global_position = mm.position
			Input.parse_input_event(mm)
			await get_tree().create_timer(0.1).timeout
	print("UT belief panel: ", areas.size(), " Area2D buttons; hovering one reaches it=", got[0] > 0)
	ok = ok and (probe == null or got[0] > 0)
	cl.closeAllPanels()
	await get_tree().create_timer(0.3).timeout
	# 4. and after closing everything the middle of the map is live again
	await _aim(T, vp * 0.5)
	var after_ok: bool = await _click_opens(vp * 0.5)
	print("UT after closing: tile in mid-screen opens its card=", after_ok)
	ok = ok and after_ok
	world.resetUI()
	# ── one panel at a time
	world._show_tile_info(T)
	var ppb = host.inTile.tileSpawnPoint
	pc.displayapfInfo(host, ppb.stationedAPF, host.inTile, world.playerCountryNode, ppb)
	await get_tree().process_frame
	var s1 := "army card=%s tile card=%s selected=%s" % [str(is_instance_valid(world._armyInfoPanel)), str(_card_open()), str(pc.selectedAPF != null)]
	ok = ok and is_instance_valid(world._armyInfoPanel) and not _card_open() and pc.selectedAPF != null
	cl._on_belief_panel_button_pressed()
	await get_tree().process_frame
	var s2 := "beliefs=%s army card=%s selected=%s" % [str(cl.get_node("BeliefControl").visible), str(world._armyInfoPanel != null), str(pc.selectedAPF != null)]
	ok = ok and cl.get_node("BeliefControl").visible and world._armyInfoPanel == null and pc.selectedAPF == null
	world._open_contract_panel()
	await get_tree().process_frame
	var s3 := "contracts=%s beliefs=%s" % [str(world._contractPanel != null), str(cl.get_node("BeliefControl").visible)]
	ok = ok and world._contractPanel != null and not cl.get_node("BeliefControl").visible
	var w0 = world._construction_sites[12]["worker"]; var cpf = world._worker_cpf(w0)
	pc.displaycpfInfo(w0, cpf, cpf.currentTile, world.playerCountryNode, cpf.currentPathPoint)
	await get_tree().process_frame
	var s4 := "worker=%s contracts=%s worker selected=%s" % [str(world._workerPanel != null), str(world._contractPanel != null), str(pc.selectedCPF != null)]
	ok = ok and world._workerPanel != null and world._contractPanel == null and pc.selectedCPF != null
	cl._on_war_room_button_pressed()
	await get_tree().process_frame
	var s5 := "war room=%s worker=%s" % [str(cl.get_node("WarRoomPanel").visible), str(world._workerPanel != null)]
	ok = ok and cl.get_node("WarRoomPanel").visible and world._workerPanel == null
	world._show_tile_info(T)
	cl.get_node("PauseMenu").open()
	var s6 := "paused: tile card=%s war room=%s menu on top=%s" % [str(_card_open()), str(cl.get_node("WarRoomPanel").visible), str(cl.get_child(cl.get_child_count() - 2).name == "PauseMenu")]
	ok = ok and not _card_open() and not cl.get_node("WarRoomPanel").visible
	cl.get_node("PauseMenu").close()
	for s in [s1, s2, s3, s4, s5, s6]: print("UT one at a time: ", s)
	print("UT RESULT ", "PASS" if ok else "FAIL")
	get_tree().quit(0 if ok else 1)
