extends Node
func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 5: await get_tree().process_frame
	var n: int = int(OS.get_environment("SOAK_TURNS")) if OS.get_environment("SOAK_TURNS") != "" else 25
	for t in n:
		world._skip_ai_playback = true
		await world._on_next_turn_pressed()
		var usa = 0; var uk = 0; var holds = 0; var fired = 0
		for c in world.aliveCountriesList:
			for ar in c.countryArmyList:
				if not is_instance_valid(ar): continue
				if c.CID == "USA": usa += ar.manpowerInArmy
				if c.CID == "UK": uk += ar.manpowerInArmy
				for u in ar.unitsList:
					if u.unitStance == "hold": holds += 1
		print("TURN %d usaMP=%d ukMP=%d holdingUnits=%d ended=%s" % [world.currentWorldTurn, usa, uk, holds, str(world._game_ended)])
		if world._game_ended: break
	print("SOAK DONE")
	get_tree().quit(0)
