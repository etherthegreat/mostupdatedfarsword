extends Node
const AC = preload("res://Game Scenes and Scripts/army_card.gd")
func _ready() -> void:
	seed(1)
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 5: await get_tree().process_frame
	var usa = world.playerCountryNode
	var uk_army = null
	for c in world.aliveCountriesList:
		if c.CID == "UK":
			for a in c.countryArmyList:
				if is_instance_valid(a) and a.manpowerInArmy > 0: uk_army = a; break
	var desc := ""
	for u in uk_army.unitsList: desc += str(u.unitWeapon.weaponType) + " L" + str(u.unitLevel) + " " + str(u.unitCurrentManpower) + "men; "
	print("SM UK defender: ", desc)
	var templates := ["Minutemen", "Breechloader Line", "Percussion Line", "Repeater Line", "Dragoons", "Heavy Cavalry", "Artillery Battery", "Mortar Battery"]
	var free: Array = []
	for t in world.get_node("TileController").get_children():
		if t.tileOwner == "USA" and t.tileSpawnPoint != null and not t.tileSpawnPoint.occupied and t.stationedArmy == null: free.append(t)
	var i := 0
	for tp in templates:
		world._raise_archetype_army(free[i], tp); i += 1
		var a = usa.countryArmyList.back()
		for i2 in 2: await get_tree().process_frame
		var line := "SM %-18s cost=$%-4s men=%-4d |" % [tp, str(world._catalog_entry_for(tp).get("gold", "?")), a.manpowerInArmy]
		for dstance in ["fire", "hold", "fortify"]:
			for u in uk_army.unitsList:
				u.unitCurrentAP = u.get_max_ap(); u.reloadCounter = 0; u.fortifyRefundAP = 0
				u.unitStance = "fire"
				if dstance == "fortify": AC._apply_stance(u, "fortify")
				else: u.unitStance = dstance
			for astance in ["fire", "charge"]:
				for u in a.unitsList:
					u.unitCurrentAP = u.get_max_ap(); u.reloadCounter = 0
					var sab: bool = u.unitWeapon.is_saber()
					u.unitStance = "charge" if (astance == "charge" or sab) else "fire"
					if astance == "charge" and not sab and not u.can_charge_melee(): u.unitStance = "fire"
				var bt: Dictionary = a.compute_battle_against(uk_army)
				line += " %s>%s %d/%d" % [astance.substr(0,2), dstance.substr(0,3), bt.def_loss, bt.atk_loss]
		print(line)
	# reverse: UK attacks a braced USA army
	for tp in ["Minutemen", "Breechloader Line", "Artillery Battery"]:
		world._raise_archetype_army(free[i], tp); i += 1
		var d = usa.countryArmyList.back()
		for i2 in 2: await get_tree().process_frame
		var line := "SM UK attacks %-18s |" % tp
		for dst in ["fire", "hold", "fortify"]:
			for u in d.unitsList:
				u.unitCurrentAP = u.get_max_ap(); u.reloadCounter = 0; u.fortifyRefundAP = 0; u.unitStance = "fire"
				if dst == "fortify": AC._apply_stance(u, "fortify")
				else: u.unitStance = dst
			for u in uk_army.unitsList:
				u.unitCurrentAP = u.get_max_ap(); u.reloadCounter = 0; u.unitStance = "fire"
			var bt: Dictionary = uk_army.compute_battle_against(d)
			line += " vs %s: dealt %d / took %d (hold_fired=%s)" % [dst, bt.def_loss, bt.atk_loss, str(bt.hold_fired)]
		print(line)
	print("SM legend: attackerStance>defenderStance  damageDealt/damageTaken")
	get_tree().quit(0)
