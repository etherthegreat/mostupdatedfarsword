extends Node
# Screenshot helper: boots the game, optionally runs a callable on the world, saves PNG.
func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 30: await get_tree().process_frame
	var mode := OS.get_environment("SHOT_MODE")
	if mode == "panel" and world.has_method("_open_run_progress"):
		world._open_run_progress()
		for i in 40: await get_tree().process_frame
	var img := get_viewport().get_texture().get_image()
	img.save_png(OS.get_environment("SHOT_OUT") if OS.get_environment("SHOT_OUT") != "" else "/home/claude/shot.png")
	print("SHOT SAVED")
	get_tree().quit(0)
