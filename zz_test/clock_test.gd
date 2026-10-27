extends Node
# Live standing must match the end screen: same builder, projected ending.
func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 5: await get_tree().process_frame
	var ok := true
	var r = world.live_run_report()
	print("T1 grade=%s score=%d left=%d end=%s" % [r.grade, r.score, r.turns_left, r.end_type])
	ok = ok and r.turns_left == 99 and world._runClock != null and world._runClock.turns_left == 99
	for t in 3:
		world._skip_ai_playback = true
		await world._on_next_turn_pressed()
	r = world.live_run_report()
	print("T%d grade=%s score=%d left=%d clock=%d" % [world.currentWorldTurn, r.grade, r.score, r.turns_left, world._runClock.turns_left])
	ok = ok and world._runClock.turns_left == 100 - world.currentWorldTurn
	var end = world._build_run_report(false, "", "endlessBattle")
	ok = ok and end.score == world._build_run_report(false, "", "endlessBattle").score
	world._open_run_progress()
	await get_tree().process_frame
	ok = ok and world.get_node("CanvasLayer").has_node("RunProgress")
	print("RESULT ", "PASS" if ok else "FAIL")
	get_tree().quit(0 if ok else 1)
