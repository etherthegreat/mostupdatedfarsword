extends Node
# Depth pass 2026-10-31: boot a normal USA game (Agent 355 reel on), walk turns 1-3,
# check events fire, the muster panel opens with manpower, and the score screen ends a run.
func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 30: await get_tree().process_frame
	var ec = world.get_node("CanvasLayer/EventControl/EventContainer")
	var ok := true
	for t in 3:
		var names := []
		for c in ec.get_children():
			names.append(str(c.get("eventID") if c.get("eventID") != null else c.name))
		print("DB turn ", world.currentWorldTurn, " events showing: ", names.size(), " ", names)
		if t == 1 and names.size() == 0:
			ok = false
		for c in ec.get_children():
			c.queue_free()
		world._skip_ai_playback = true
		await world._on_next_turn_pressed()
		for i in 10: await get_tree().process_frame
	# muster panel + manpower
	world._open_muster_panel()
	await get_tree().process_frame
	var b = world._musterPanel.get_node("Budget").text
	print("DB muster: ", b)
	ok = ok and b.contains("Manpower")
	world._musterCounts[0] = 1
	world._muster_refresh()
	print("DB total: ", world._musterPanel.get_node("Total").text)
	if OS.get_environment("SHOT_OUT") != "":
		for i in 10: await get_tree().process_frame
		get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT_OUT") + "_muster.png")
	var mp0: int = world.playerCountryNode.TotalManpower
	var n0: int = world.playerCountryNode.countryArmyList.size()
	world._muster_confirm()
	print("DB muster spots=", world._free_muster_tiles().size(), " queue=", world._muster_place_queue.size())
	world._auto_place_rest()
	print("DB bought armies: ", world.playerCountryNode.countryArmyList.size() - n0, " manpower ", mp0, " -> ", world.playerCountryNode.TotalManpower)
	ok = ok and world.playerCountryNode.countryArmyList.size() == n0 + 1 and world.playerCountryNode.TotalManpower == mp0 - 200
	if OS.get_environment("SHOT_OUT") != "":
		world._close_muster_panel()
		# tile card on a British strongpoint
		for c in ec.get_children():
			c.queue_free()
		var pick = null
		for t in world.get_node("TileController").get_children():
			if t.tileOwner == "UK" and t.is_strongpoint() and t.redcoat_line_army("USA") != null:
				pick = t
				break
		print("DB card tile: ", pick.tileName if pick != null else "none")
		world._show_tile_info(pick)
		world._show_notice("Redcoat line — movement stops")
		for i in 20: await get_tree().process_frame
		get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT_OUT") + "_card.png")
	world._trigger_game_over(false, "Depth boot test", "endlessBattle")
	for i in 20: await get_tree().process_frame
	print("DB game ended: ", world._game_ended)
	ok = ok and world._game_ended
	print("RESULT ", "PASS" if ok else "FAIL")
	get_tree().quit(0 if ok else 1)
