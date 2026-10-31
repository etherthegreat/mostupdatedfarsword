extends Node
# ═════════════════════════════════════════════════════════════════════════════
# STRATEGY BOT — headless 100-turn strain test (2026-10-27)
# Plays the USA through the game's real buy / move / attack code paths with one
# of several strategies, and prints one CSV line per turn.
#   STRAT = idle | spam | smart | turtle | cav | arty     SEED = int   TURNS = int
# Output lines start with "ROW," (per turn) and "END," (final).
# ═════════════════════════════════════════════════════════════════════════════

const ARMY_CARD = preload("res://Game Scenes and Scripts/army_card.gd")
var world
var pc          # PathControl
var usa         # player country node
var strat := "spam"
var stats := {"battles": 0, "kills": 0, "captures": 0, "lost_armies": 0, "bought": 0,
	"spent": 0, "atk_loss": 0, "def_loss": 0, "techs": [], "beliefs": [], "tech_tok": 0, "cult_tok": 0}

const TECH_PRIORITY := {
	"spam":  ["Muskets", "Breechloaders", "Rifles", "Repeaters", "Tricorne Hat", "Forage Cap", "Organization", "Logistics"],
	"smart": ["Muskets", "Breechloaders", "Tricorne Hat", "Rifles", "Field Gunnery", "Forage Cap", "Swordsmanship", "Cavalry Drills", "Repeaters", "Organization", "Tactics"],
	"turtle":["Tricorne Hat", "Forage Cap", "Tombstone Cap", "Hardee Hat", "Muskets", "Breechloaders"],
	"cav":   ["Swordsmanship", "Cavalry Drills", "Officer Training", "Marine Discipline", "Tricorne Hat"],
	"arty":  ["Field Gunnery", "Siege Works", "Explosive Charges", "Rocket Artillery", "Muskets", "Breechloaders"],
}
const BELIEF_PRIORITY := ["George Washington", "Frederick Douglass", "Defense Production Act", "Abraham Lincoln",
	"Benjamin Franklin", "First Amendment", "Mark Twain", "Harriet Tubman", "Mary Edwards Walker", "John Brown", "Malcolm X"]


func _ready() -> void:
	strat = OS.get_environment("STRAT") if OS.get_environment("STRAT") != "" else "spam"
	var sd: int = int(OS.get_environment("SEED")) if OS.get_environment("SEED") != "" else 1
	var turns: int = int(OS.get_environment("TURNS")) if OS.get_environment("TURNS") != "" else 100
	seed(sd)
	world = load("res://Game Scenes and Scripts/world.tscn").instantiate()
	get_tree().root.add_child.call_deferred(world)
	await get_tree().process_frame
	get_tree().current_scene = world
	world.newGameBuild("USA", "eng", false)
	for i in 5: await get_tree().process_frame
	world._test_fast_ai = true
	pc = world.get_node("PathControl")
	usa = world.playerCountryNode
	print("HDR,strat,seed,turn,usaT,ukT,caT,usaArmies,usaMen,ukArmies,ukMen,dollars,weapons,techTok,cultTok,techs,battles,kills,captures,bought")
	for t in turns:
		if world._game_ended:
			break
		if strat == "buyonce":
			if t == 0:
				for k in 6:
					usa.TotalDollars += 400
					_buy()
			await world._on_next_turn_pressed()
			for f in int(OS.get_environment("SETTLE") if OS.get_environment("SETTLE") != "" else "0"): await get_tree().process_frame
			_row(sd)
			continue
		if strat != "idle":
			_spend_tokens()
			_buy()
			await _act()
		await world._on_next_turn_pressed()
		for f in int(OS.get_environment("SETTLE") if OS.get_environment("SETTLE") != "" else "0"): await get_tree().process_frame
		_row(sd)
	var info := _summary()
	print("END,%s,%d,%d,%s,%s,%s" % [strat, sd, world.currentWorldTurn, str(world._game_ended), info.reason, JSON.stringify(stats)])
	get_tree().quit(0)


# ── helpers ──────────────────────────────────────────────────────────────────
func _tiles() -> Array:
	return world.get_node("TileController").get_children()

func _occupant(tile):
	if tile == null:
		return null
	var a = tile.stationedArmy
	if (a == null or not is_instance_valid(a)) and tile.tileSpawnPoint != null:
		a = tile.tileSpawnPoint.stationedArmy
	if a == null or not is_instance_valid(a) or a.deleteMode or a.manpowerInArmy <= 0:
		return null
	return a

func _is_enemy_tile(t) -> bool:
	return t.tileOwner == "UK"

func _frontier_dist() -> Dictionary:
	# BFS distance from every tile to the nearest UK tile.
	var d := {}
	var q: Array = []
	for t in _tiles():
		if t.tileOwner == "UK":
			d[t] = 0
			q.append(t)
	while not q.is_empty():
		var c = q.pop_front()
		for nb in c.TileNeighbors:
			if nb != null and not d.has(nb):
				d[nb] = d[c] + 1
				q.append(nb)
	return d

func _apf_for(army):
	if army.inTile != null and army.inTile.tileSpawnPoint != null:
		var ap = army.inTile.tileSpawnPoint.stationedAPF
		if ap != null and is_instance_valid(ap) and ap.thisArmy == army:
			return ap
	for ap in pc.raisedPlayerAPFs:
		if is_instance_valid(ap) and ap.thisArmy == army:
			return ap
	return null

func _wait_until(cond: Callable, cap: int = 600) -> void:
	var n := 0
	while not cond.call() and n < cap:
		await get_tree().process_frame
		n += 1

func _summary() -> Dictionary:
	return {"reason": ""}


# ── tokens ───────────────────────────────────────────────────────────────────
func _spend_tokens() -> void:
	var tt = world.get_node("CanvasLayer/TechTree")
	var prio: Array = TECH_PRIORITY.get(strat, TECH_PRIORITY["spam"])
	var guard := 0
	while usa.techTokens > 0 and guard < 20:
		guard += 1
		var picked = null
		for name in prio:
			var b = tt._buttons.get(name)
			if b != null and not b.purchased and b._requirements_met():
				picked = b
				break
		if picked == null:   # anything affordable
			for name in tt._buttons:
				var b = tt._buttons[name]
				if not b.purchased and b._requirements_met():
					picked = b
					break
		if picked == null:
			break
		tt.selectInvestmentFunc(picked)
		stats.techs.append(picked.techID)
	guard = 0
	while usa.cultureTokens > 0 and guard < 20:
		guard += 1
		var have := {}
		for b in usa.selectedBeliefs:
			have[b.beliefType] = true
		var choice := ""
		for n in BELIEF_PRIORITY:
			if not have.has(n):
				choice = n
				break
		if choice == "":
			break
		world._on_belief_control_purchased_belief(choice, 0)
		stats.beliefs.append(choice)


# ── buying ───────────────────────────────────────────────────────────────────
func _best_template(cls: String) -> Dictionary:
	var best := {}
	for e in world.BUY_CATALOG:
		if e["class"] != cls:
			continue
		if e["tech"] != "" and not world._player_has_tech(e["tech"]):
			continue
		if best.is_empty() or int(e["gold"]) > int(best["gold"]):
			best = e
	return best

func _pick_template(i: int) -> Dictionary:
	match strat:
		"spam", "buyonce":
			return world._catalog_entry_for("Minutemen")
		"cav":
			return _best_template("Saber") if i % 3 != 2 else _best_template("Musket")
		"arty":
			return _best_template("Artillery") if i % 2 == 0 else _best_template("Musket")
		"smart":
			# 2 line : 1 gun : 1 horse
			var k := i % 4
			if k == 2: return _best_template("Artillery")
			if k == 3: return _best_template("Saber")
			return _best_template("Musket")
		_:
			return _best_template("Musket")

func _buy() -> void:
	var dist := _frontier_dist()
	var free: Array = []
	if world.has_method("_free_muster_tiles"):
		free = world._free_muster_tiles()
	for t in ([] if world.has_method("_free_muster_tiles") else _tiles()):
		if t.tileOwner == "USA" and _occupant(t) == null and t.tileSpawnPoint != null and not t.tileSpawnPoint.occupied \
				and (not t.has_method("is_muster_point") or t.is_muster_point()):
			free.append(t)
	free.sort_custom(func(a, b): return dist.get(a, 99) < dist.get(b, 99))
	if OS.get_environment("BUYDBG") != "":
		print("BUYFREE t=", world.currentWorldTurn, " n=", free.size(), " $", usa.TotalDollars)
	var reserve := 0 if strat == "spam" else 40
	if strat == "smart" and "lastUpkeepDollars" in usa:
		reserve = maxi(40, int(usa.lastUpkeepDollars))   # never buy into debt: keep a turn of upkeep
	var cap: int = int(OS.get_environment("ARMY_CAP")) if OS.get_environment("ARMY_CAP") != "" else 9999
	if usa.countryArmyList.size() >= cap:
		return
	var i := 0
	for t in free:
		var e: Dictionary = _pick_template(stats.bought)
		if e.is_empty():
			e = world._catalog_entry_for("Minutemen")
		var gold: int = int(world._row_gold(e)) if world.has_method("_row_gold") else int(e["gold"])
		var weap: int = int(e["weapons"])
		if usa.TotalDollars - gold < reserve or usa.TotalWeapons < weap:
			e = world._catalog_entry_for("Minutemen")
			gold = int(world._row_gold(e)) if world.has_method("_row_gold") else 40
			weap = 0
			if usa.TotalDollars - gold < reserve:
				break
		if world.has_method("try_buy_and_raise"):
			if not world.try_buy_and_raise(t, e):
				if OS.get_environment("BUYDBG") != "":
					print("BUYFAIL t=", world.currentWorldTurn, " tile=", t.tileName, " $", usa.TotalDollars, " W", usa.TotalWeapons, " mp", usa.TotalManpower, " sa=", t.stationedArmy, " own=", t.tileOwner, " ent=", e.get("template"))
				break   # out of manpower (or the spot is gone)
		else:
			usa.TotalDollars -= gold
			usa.TotalWeapons -= weap
			world._raise_archetype_army(t, str(e["template"]))
		stats.spent += gold
		stats.bought += 1
		i += 1


# ── acting ───────────────────────────────────────────────────────────────────
func _set_stances(army, attacking: bool) -> void:
	for u in army.unitsList:
		if u.unitCurrentManpower <= 0:
			continue
		var saber: bool = u.unitWeapon != null and u.unitWeapon.is_saber()
		match strat:
			"turtle":
				if saber:
					if not army.movedThisTurn:
						ARMY_CARD._apply_stance(u, "fortify")
				else:
					u.unitStance = "hold"
			"smart":
				u.unitStance = "charge" if saber else "fire"
			_:
				u.unitStance = "charge" if saber else "fire"

func _brace(army) -> void:
	# Smart: after acting, anything still loaded holds so the line fires first.
	for u in army.unitsList:
		if u.unitCurrentManpower > 0 and u.unitWeapon != null and not u.unitWeapon.is_saber() and u.unitCurrentAP > 0:
			u.unitStance = "hold"

func _attack(army, apf, target_tile) -> void:
	if not pc.war_active:
		return   # the UI blocks striking the British before the war opens
	var ppb = target_tile.tileSpawnPoint
	pc.selectedAPF = apf
	if not pc._in_firing_range(ppb):
		return
	var def = _occupant(target_tile)
	var before_def: int = def.manpowerInArmy
	var before_atk: int = army.manpowerInArmy
	pc._initiate_attack(ppb)
	await _wait_until(func(): return not is_instance_valid(apf) or not apf.attack_mode)
	await get_tree().process_frame
	stats.battles += 1
	var d_after: int = def.manpowerInArmy if is_instance_valid(def) and not def.deleteMode else 0
	stats.def_loss += before_def - d_after
	if is_instance_valid(army):
		stats.atk_loss += before_atk - army.manpowerInArmy
	if d_after <= 0:
		stats.kills += 1

func _move(army, apf, target_tile) -> bool:
	var ppb = target_tile.tileSpawnPoint
	if ppb == null or ppb.occupied:
		return false
	if ppb not in apf.currentPathPoint.neighborPathPoints:
		return false
	if target_tile.tileOwner == "UK" and not pc.war_active:
		return false   # a human can't cross the border before the war (tryMoveSelectedAPFToTile)
	pc.selectedAPF = apf
	var mp_before: int = army.currentMovementPoints
	pc.calculateArmyMovement(ppb, ppb.neighborPathPoints, target_tile)
	if army.currentMovementPoints == mp_before:
		return false
	await _wait_until(func(): return not is_instance_valid(apf) or (not apf.movingForward and apf.destinationPathPoint == null))
	await get_tree().process_frame
	if target_tile.tileOwner == "USA":
		stats.captures += 1
	return true

func _act() -> void:
	var armies: Array = usa.countryArmyList.duplicate()
	for army in armies:
		if not is_instance_valid(army) or army.deleteMode or army.manpowerInArmy <= 0:
			continue
		if world._game_ended:
			return
		var apf = _apf_for(army)
		if apf == null:
			continue
		if strat == "turtle":
			_set_stances(army, false)
			continue
		_set_stances(army, true)
		# up to 2 actions per army: attack, else capture, else advance
		for step in 3:
			if not is_instance_valid(army) or army.deleteMode or army.inTile == null:
				break
			var here = army.inTile
			var best = null
			var best_score := -INF
			for nb in here.TileNeighbors:
				if nb == null or not _is_enemy_tile(nb):
					continue
				var occ = _occupant(nb)
				if occ == null or not occ.enemy:
					continue
				var bt: Dictionary = army.compute_battle_against(occ)
				var score: float = float(bt["def_loss"]) - float(bt["atk_loss"])
				if strat == "smart":
					# only fight when the exchange is good or the kill is on
					if bt["def_loss"] < occ.manpowerInArmy and bt["def_loss"] < bt["atk_loss"] * 1.3:
						continue
				elif bt["def_loss"] <= 0:
					continue
				if score > best_score:
					best_score = score
					best = nb
			if best != null and army.has_moves_left() and not army.attackBlocked:
				var any_ap := false
				for u in army.unitsList:
					if u.unitCurrentManpower > 0 and u.unitCurrentAP > 0:
						any_ap = true
				if any_ap:
					await _attack(army, apf, best)
					continue
			# holding a siege → stay put until it falls
			if here.tileOwner == "UK" and "siegeArmy" in here and here.siegeArmy == army:
				break
			# empty enemy tile → walk in and take it
			var took := false
			if army.currentMovementPoints > 0 and not army.attackedThisTurn:
				for nb in here.TileNeighbors:
					if nb != null and _is_enemy_tile(nb) and _occupant(nb) == null and nb.tileSpawnPoint != null and not nb.tileSpawnPoint.occupied:
						took = await _move(army, apf, nb)
						if took:
							break
			if took:
				continue
			# advance toward the front through own tiles
			if army.currentMovementPoints > 0 and not army.attackedThisTurn:
				var dist := _frontier_dist()
				var cur: int = dist.get(here, 99)
				if cur > 1:
					var step_to = null
					for nb in here.TileNeighbors:
						if nb != null and nb.tileOwner == "USA" and dist.get(nb, 99) < cur and _occupant(nb) == null and nb.tileSpawnPoint != null and not nb.tileSpawnPoint.occupied:
							step_to = nb
							break
					if step_to != null and await _move(army, apf, step_to):
						continue
			break
		if strat == "smart" and is_instance_valid(army):
			_brace(army)


# ── reporting ────────────────────────────────────────────────────────────────
func _row(sd: int) -> void:
	var c := {"USA": 0, "UK": 0, "CA": 0}
	for t in _tiles():
		if c.has(t.tileOwner):
			c[t.tileOwner] += 1
	var ua := 0; var um := 0; var ka := 0; var km := 0
	for co in world.aliveCountriesList:
		for ar in co.countryArmyList:
			if not is_instance_valid(ar) or ar.deleteMode: continue
			if co.CID == "USA": ua += 1; um += ar.manpowerInArmy
			if co.CID == "UK": ka += 1; km += ar.manpowerInArmy
	print("ROW,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d" % [strat, sd, world.currentWorldTurn,
		c.USA, c.UK, c.CA, ua, um, ka, km, usa.TotalDollars, usa.TotalWeapons, usa.techTokens, usa.cultureTokens,
		stats.techs.size(), stats.battles, stats.kills, stats.captures, stats.bought] + ",mp=%d" % usa.TotalManpower)
	print("MEM,%d,objs=%d,nodes=%d,orphans=%d,mb=%d" % [world.currentWorldTurn, Performance.get_monitor(Performance.OBJECT_COUNT),
		Performance.get_monitor(Performance.OBJECT_NODE_COUNT), Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT),
		int(OS.get_static_memory_usage() / 1048576)])
