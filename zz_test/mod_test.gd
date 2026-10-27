extends Node
# Combat rework step 3: newly wired mil mods actually change numbers.
const MM := preload("res://mil_mod.tscn")
var fails: Array = []

func _ready() -> void:
	var world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 5: await get_tree().process_frame
	var usa; var uk
	for c in world.aliveCountriesList:
		if c.CID == "USA": usa = c
		if c.CID == "UK": uk = c
	var a = _army(usa); var d = _army(uk)
	for u in a.unitsList: u.unitStance = "fire"; u.unitCurrentAP = u.get_max_ap(); u.reloadCounter = 0
	for u in d.unitsList: u.unitStance = "fire"; u.reloadCounter = 2

	# first engagement: Vanguard / QuickDraw
	var base = a.compute_battle_against(d).def_loss
	_give(a, "QuickDraw")
	var qd = a.compute_battle_against(d).def_loss
	_check("QuickDraw adds on first engagement", qd > base, [base, qd])
	a.on_attack_resolved(d, 0, false)
	for u in a.unitsList: u.unitCurrentAP = u.get_max_ap()
	var after = a.compute_battle_against(d).def_loss
	_check("QuickDraw gone after attacking from same tile", after < qd, [qd, after])
	a._engagedFromTile = null
	_take(a, "QuickDraw")

	# Quick Reload
	var u0 = a.unitsList[0]
	u0.start_reload(); var r0 = u0.reloadCounter
	_give(a, "Quick Reload"); u0 = a.unitsList[0]
	u0.start_reload(); var r1 = u0.reloadCounter
	_check("Quick Reload -1 reload", r1 == maxi(0, r0 - 1), [r0, r1])
	_take(a, "Quick Reload")
	for u in a.unitsList: u.reloadCounter = 0

	# Inspired status
	var pre = a.compute_battle_against(d).def_loss
	a.apply_status("Inspired", 3)
	var ins = a.compute_battle_against(d).def_loss
	_check("Inspired raises damage", ins > pre, [pre, ins])
	a.armyStatusEffects.clear(); a.surveySelf()

	# Fortified status raises block
	var b0 = d.avg_melee_block()
	d.apply_status("Fortified", 3)
	_check("Fortified raises block", d.avg_melee_block() > b0, [b0, d.avg_melee_block()])
	d.armyStatusEffects.clear(); d.surveySelf()

	# Burning really burns
	var mp0 = d.manpowerInArmy
	d.apply_status("Burning", 2)
	d._tick_status_effects()
	_check("Burning costs men", d.manpowerInArmy < mp0, [mp0, d.manpowerInArmy])

	# SaberCharge: give a unit a saber stance vs reloading defender
	var su = a.unitsList[0]
	var w_old = su.unitWeapon.weaponType
	su.upgradeWeaponTo("Cavalry Sword"); a.updateArmyUI()
	for u in a.unitsList: u.unitStance = "charge"; u.unitCurrentAP = u.get_max_ap()
	a._engagedFromTile = a.inTile
	for u in d.unitsList: u.reloadCounter = 2
	var sc_yes = a.compute_battle_against(d).def_loss
	for u in d.unitsList: u.reloadCounter = 0; u.unitStance = "fire"
	var sc_no = a.compute_battle_against(d).def_loss
	_check("SaberCharge x2 vs reloading guns", sc_yes > sc_no, [sc_no, sc_yes])
	su.upgradeWeaponTo(w_old); a.updateArmyUI()

	# Field Research science
	_give(a, "Field Research")
	var sci0 = usa.TotalScience
	a.on_attack_resolved(d, 100, false)
	_check("Field Research science", usa.TotalScience == sci0 + 20, [sci0, usa.TotalScience])

	print("FAILS: ", fails)
	print("RESULT ", "PASS" if fails.is_empty() else "FAIL")
	get_tree().quit(0 if fails.is_empty() else 1)

func _give(ar, t: String) -> void:
	# commander-style: put the mod on the commander's list so updateArmyUI keeps it
	var m = MM.instantiate(); m.buildSelf(t)
	ar.commanderModifiers1.append(m)
	if ar.commander == null:
		for u in ar.unitsList: u.addMilMod(m)
		ar.surveySelf()
	else:
		ar.updateArmyUI()

func _take(ar, t: String) -> void:
	for lst in [ar.commanderModifiers1]:
		for m in lst.duplicate():
			if m.milModType == t: lst.erase(m)
	for u in ar.unitsList:
		for m in u.militaryModifierList.duplicate():
			if m.milModType == t: u.militaryModifierList.erase(m)
	ar.surveySelf()

func _check(name: String, ok: bool, vals) -> void:
	print(("ok   " if ok else "FAIL ") + name + "  " + str(vals))
	if not ok: fails.append(name)

func _army(c):
	for ar in c.countryArmyList:
		if is_instance_valid(ar) and ar.unitsList.size() > 0: return ar
