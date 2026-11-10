extends Node
func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 10: await get_tree().process_frame
	var p = world.playerCountryNode
	for pass_i in 2:
		p.surveyResources()
		var tiles_sum := 0.0; var pos := 0.0; var neg := 0.0
		for t in p.OwnedTileList:
			tiles_sum += t.buildingDollarsOutput
			if t.buildingDollarsOutput > 0: pos += t.buildingDollarsOutput
			else: neg += t.buildingDollarsOutput
		print("EP pass ", pass_i, " tiles=", p.OwnedTileList.size(), " building dollars sum=", tiles_sum, " (+", pos, " ", neg, ") DPM=", p.DPM, " upkeep=", p.lastUpkeepDollars, " workers=", p.activeCivilianCount, " MAN=", p.MAN, " armies=", p.countryArmyList.size())
		var by := {}
		for a in p.countryArmyList:
			var k: String = "commander" if a.commanderHome != null else ("company" if a.isContract else "other " + a.ArmyName)
			by[k] = by.get(k, 0) + a.armyGoldCost
		print("EP armyGoldCost by kind ", by, " start treasury $", int(p.TotalDollars), " Mp ", p.TotalManpower)
		if pass_i == 0:
			for t in world.get_node("TileController").get_children():
				if world._tile_home_nation(t) == "USA" and t.tileOwner != "USA":
					world.tileSiegeWon(t, t.tileOwner, "USA")
			world._retry_pending_commander_armies()
	get_tree().quit(0)
