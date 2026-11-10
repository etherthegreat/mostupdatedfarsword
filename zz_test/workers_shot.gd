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
	var pc = world.get_node("PathControl")
	var site = world._construction_sites[38]
	var civ = site["worker"]
	var cpf = world._worker_cpf(civ)
	world.focus_camera_on(site["tile"], 0.01)
	for i in 40: await get_tree().process_frame
	var cam = get_viewport().get_camera_2d()
	if cam != null: cam.zoom = Vector2(1.0, 1.0)
	pc.displaycpfInfo(civ, cpf, site["tile"], world.playerCountryNode, cpf.currentPathPoint)
	for i in 30: await get_tree().process_frame
	get_viewport().get_texture().get_image().save_png(out + "_worker.png")
	world.resetUI()
	world._on_civilian_button_pressed()
	for i in 30: await get_tree().process_frame
	get_viewport().get_texture().get_image().save_png(out + "_sites.png")
	print("SHOT SAVED")
	get_tree().quit(0)
