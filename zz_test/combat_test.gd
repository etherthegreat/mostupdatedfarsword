extends Node
# Headless combat-rework checks. Boots the real game like the menu does, then runs
# compute_battle_against between real USA and UK armies under controlled stances.

func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 5:
		await get_tree().process_frame
	var usa = null
	var uk = null
	for c in world.aliveCountriesList:
		if c.CID == "USA": usa = c
		if c.CID == "UK": uk = c
	var a = _first_army(usa)
	var d = _first_army(uk)
	if a == null or d == null:
		print("RESULT FAIL no armies usa=", a, " uk=", d)
		get_tree().quit(1); return
	print("ATK ", a.ArmyName, " units=", _desc(a))
	print("DEF ", d.ArmyName, " units=", _desc(d))
	a.surveySelf(); d.surveySelf()
	print("DEF block melee=%.3f ranged=%.3f (sum %.3f/%.3f)" % [d.avg_melee_block(), d.avg_ranged_block(), d.armyBlock, d.armyDefence])

	_stances(a, "fire"); _full_ap(a)
	_stances(d, "fire"); _reload(d, 2)          # defender spent its volley: EXPOSED
	var exposed = a.compute_battle_against(d)
	_stances(d, "hold"); _reload(d, 0)          # both loaded & holding
	var held = a.compute_battle_against(d)
	print("FIRE vs exposed: ", exposed)
	print("FIRE vs holding: ", held)

	_stances(a, "charge")
	_stances(d, "fire"); _reload(d, 2)
	var ch_exposed = a.compute_battle_against(d)
	_stances(d, "fortify")
	var ch_fort = a.compute_battle_against(d)
	print("CHARGE vs exposed: ", ch_exposed)
	print("CHARGE vs fortified: ", ch_fort)

	_stances(a, "fire"); _stances(d, "fire"); _reload(d, 2)
	var before = a.compute_battle_against(d)
	a.apply_status("Thunderbird's Sovereignty", 3)
	var after = a.compute_battle_against(d)
	print("ranged_mult before/after Thunderbird: %.3f" % a.ranged_mult(), " ", before, " -> ", after)

	var ok := true
	ok = ok and held["hold_fired"] and not exposed["hold_fired"]
	ok = ok and held["atk_loss"] > exposed["atk_loss"]
	ok = ok and held["def_loss"] < exposed["def_loss"]
	ok = ok and ch_fort["def_loss"] < ch_exposed["def_loss"]
	ok = ok and after["def_loss"] > before["def_loss"]
	_stances(d, "fortify")
	ok = ok and d.avg_melee_block() > 0.0 and d.avg_melee_block() <= Army.BLOCK_CAP
	print("fortified melee block: %.3f" % d.avg_melee_block())
	# no stat creep: surveying twice gives identical numbers
	a.surveySelf(); var p1 = a.armyLaunch; a.surveySelf()
	print("stable survey: ", p1, " ", a.armyLaunch)
	ok = ok and is_equal_approx(p1, a.armyLaunch)
	# real fight side effect: holders reload after first-fire
	_stances(d, "hold"); _reload(d, 0)
	d.consume_hold_volley()
	var reloading := 0
	for u in d.unitsList:
		if u.is_reloading(): reloading += 1
	print("holders reloading after volley: ", reloading)
	print("RESULT ", "PASS" if ok else "FAIL")
	get_tree().quit(0 if ok else 1)

func _first_army(c):
	if c == null: return null
	for ar in c.countryArmyList:
		if is_instance_valid(ar) and ar.unitsList.size() > 0:
			return ar
	return null

func _desc(ar) -> String:
	var t := []
	for u in ar.unitsList:
		t.append("%s L%d mp%d R%.1f M%.1f blk%.2f/%.2f" % [u.unitWeapon.weaponType, u.unitLevel, u.unitCurrentManpower, u.unitRangedOffence, u.unitOffensiveScore, u.unitDefensiveScore, u.unitRangedDefence])
	return ", ".join(t)

func _stances(ar, k):
	for u in ar.unitsList:
		var key = k
		if k == "fire" and u.unitWeapon.is_saber(): key = "charge"
		if k == "charge" and not u.can_charge_melee(): key = "fire"
		u.unitStance = key

func _full_ap(ar):
	for u in ar.unitsList: u.unitCurrentAP = u.get_max_ap()

func _reload(ar, n):
	for u in ar.unitsList: u.reloadCounter = n
