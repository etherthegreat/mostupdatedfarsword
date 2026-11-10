extends Node
func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 30: await get_tree().process_frame
	var ec = world.get_node("CanvasLayer/EventControl/EventContainer")
	for c in ec.get_children(): c.queue_free()
	var out: String = OS.get_environment("SHOT_OUT")
	# map: centre on Valley Forge (commander army + companies around it)
	var vf = world._commander_homes[1]["tile"]
	world.focus_camera_on(vf, 0.01)
	var cam = get_viewport().get_camera_2d()
	for i in 40: await get_tree().process_frame
	if cam != null: cam.zoom = Vector2(1.0, 1.0)
	for i in 20: await get_tree().process_frame
	get_viewport().get_texture().get_image().save_png(out + "_map.png")
	world._open_contract_panel()
	world._contract_pick("right", "arty")
	for i in 20: await get_tree().process_frame
	get_viewport().get_texture().get_image().save_png(out + "_panel.png")
	print("SHOT SAVED cam zoom ", cam.zoom if cam != null else "none")
	get_tree().quit(0)
