extends Node
func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 5: await get_tree().process_frame
	var n := 0; var names := []
	var uk_sp := 0
	for t in world.get_node("TileController").get_children():
		if t.tileOwner == "USA" and t.is_muster_point():
			n += 1; names.append(t.tileName + ("*" if t.stationedArmy != null else ""))
		if t.tileOwner == "UK" and t.is_strongpoint(): uk_sp += 1
	print("PM usa muster points ", n, " free ", world._free_muster_tiles().size(), " ", names)
	print("PM uk strongpoints ", uk_sp, " uk cap ", world._country_by_cid("UK").uk_army_cap())
	print("PM usa mp ", world.playerCountryNode.TotalManpower, " $", world.playerCountryNode.TotalDollars, " W ", world.playerCountryNode.TotalWeapons)
	get_tree().quit(0)
