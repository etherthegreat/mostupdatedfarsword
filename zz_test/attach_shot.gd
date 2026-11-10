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
	pc.war_active = true
	var host = world._commander_homes[1]["army"]
	var vf = host.inTile
	world.playerCountryNode.TotalManpower = 5000
	world.hire_contract(vf, "musket", "saber")
	world.focus_camera_on(vf, 0.01)
	for i in 40: await get_tree().process_frame
	var cam = get_viewport().get_camera_2d()
	if cam != null: cam.zoom = Vector2(1.0, 1.0)
	var apf = vf.tileSpawnPoint.stationedAPF
	pc.displayapfInfo(host, apf, vf, world.playerCountryNode, vf.tileSpawnPoint)
	for i in 40: await get_tree().process_frame
	get_viewport().get_texture().get_image().save_png(out + "_card.png")
	print("SHOT SAVED moves ", host.currentMovementPoints, " lit ", pc._highlightedTiles.size())
	get_tree().quit(0)
