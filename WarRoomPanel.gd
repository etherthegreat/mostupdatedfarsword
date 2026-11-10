# WarRoomPanel.gd
# Follows the existing panel pattern:
#   buildSelf(playerCountryNode)  — called from world.gd updatePlayerUI()
#   checkObjectives()             — called from world.gd _on_next_turn_pressed()
#   visibility toggled by PanelOpenerControl button
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# WarRoomPanel (Control)
# └── PanelBackground (Panel or NinePatchRect)
#     └── VBoxContainer
#         ├── TitleLabel ("WAR ROOM")
#         ├── TabContainer
#         │   ├── CommandersTab (Control, name="COMMANDERS")
#         │   │   └── ScrollContainer
#         │   │       └── CommanderVBox (VBoxContainer)
#         │   └── PresidentialTab (Control, name="DEPT. OF MYTH. AFFAIRS")
#         │       └── ScrollContainer
#         │           └── PresidentialVBox (VBoxContainer)
#         └── CloseButton
# ============================================================

extends Control

var playerCountryNode
var playerCountryID: String = "USA"
var activeCommanderArcs: Array = []
var activeProtectorArcs: Array = []
var waitingCommanders: Array = []   # commander homes still behind enemy lines: {tile, archetype_name, army_label}

const WarRoomCard := preload("res://war_room_card.gd")

const PROTECTOR_GOVERNOR_UNLOCKS: Dictionary = {
	"PROT_01": "Mothman",
	"PROT_17": "Lincoln's Ghost",
}
const STAGE_KEYS := ["contact", "trust", "accord"]
const STAGE_EVENTS := {"contact": "_SUMMON", "trust": "_TAME", "accord": "_AGREE"}
const STAGE_FLAGS := {"contact": "_summoned", "trust": "_tame", "accord": "_agreed"}
const STAGE_SCENE_NAMES := {"contact": "first contact", "trust": "the truce", "accord": "the accord"}
const OWNER_NAMES := {"USA": "the United States", "UK": "the British Empire", "CA": "Canada"}

signal arcObjectiveCompleted(arc_id, objective_num)
signal arcFullyCompleted(arc_id)
signal requestEventFire(event_id, tile)
signal protectorSummoned(origin_tile, protector_name, protector_id)   # legacy: no longer emitted (rewards land at the accord)
signal protectorReady(protector_name)   # a spirit's contact tasks are done and the order button is live

var _arcs_by_country: Dictionary = {}   # country filter -> protector arcs, so progress survives turn changes
var _all_tiles: Array = []
var _last_turn: int = 1


func _ready() -> void:
	$PanelBackground/CloseButton.pressed.connect(_on_close_button_pressed)
	_apply_panel_style()
	visibility_changed.connect(_on_visibility_changed)


# The scene file only supplies the node tree; the look is set here so the UI
# overhaul can restyle the whole panel from one place.
func _apply_panel_style() -> void:
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.04, 0.05, 0.10, 0.97)
	bg.border_color = Color(0.85, 0.62, 0.18)
	bg.set_border_width_all(2)
	bg.set_corner_radius_all(6)
	$PanelBackground.add_theme_stylebox_override("panel", bg)
	var title: Label = $PanelBackground/TitleLabel
	title.text = "WAR ROOM"
	title.add_theme_color_override("font_color", Color(1.0, 0.82, 0.32))
	title.offset_right = $PanelBackground.size.x
	var tabs: TabContainer = $PanelBackground/TabContainer
	tabs.add_theme_font_size_override("font_size", 17)
	tabs.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	for tab_name in ["COMMANDERS", "DEPARTMENT OF MYTHOLOGICAL AFFAIRS"]:
		var sc: ScrollContainer = tabs.get_node(tab_name + "/ScrollContainer")
		sc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		sc.offset_left = 10
		sc.offset_right = -6
		sc.offset_top = 8
		sc.offset_bottom = -8
		sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		var vb: VBoxContainer = sc.get_child(0)
		vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vb.add_theme_constant_override("separation", 10)


func _on_visibility_changed() -> void:
	# Opening the panel shows live progress (it does not fire scenes mid-turn).
	if visible and playerCountryNode != null:
		_refresh_protector_progress(_last_turn)
		_populate_commander_tab()
		_populate_presidential_tab()


func buildSelf(playerNode) -> void:
	playerCountryNode = playerNode
	playerCountryID   = playerNode.CID if playerNode != null else "USA"
	_populate_commander_tab()
	_populate_presidential_tab()


func _intro_line(txt: String) -> Label:
	var l := Label.new()
	l.text = txt
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_size_override("font_size", 14)
	l.add_theme_color_override("font_color", Color(0.72, 0.80, 0.95))
	return l


func _clear(vbox: Node) -> void:
	for child in vbox.get_children():
		vbox.remove_child(child)
		child.queue_free()


func _populate_commander_tab() -> void:
	var vbox = $PanelBackground/TabContainer/COMMANDERS/ScrollContainer/CommanderVBox
	_clear(vbox)
	if activeCommanderArcs.is_empty():
		vbox.add_child(_intro_line("No commanders in the field yet. Assign a commander to a tile and their personal objectives appear here."))
		_add_waiting_commanders(vbox)
		return
	vbox.add_child(_intro_line("Every commander has three personal objectives. Finish all three and their reunion scene unlocks."))
	for arcData in activeCommanderArcs:
		var rows: Array = []
		var objectives: Array = arcData.get("objectives", [])
		var complete: Array = arcData.get("objectives_complete", [])
		for i in objectives.size():
			rows.append({"label": objectives[i].get("label", "Objective"), "done": i < complete.size() and complete[i], "progress": ""})
		var card = WarRoomCard.new()
		vbox.add_child(card)
		card.build_commander(arcData, rows)
	_add_waiting_commanders(vbox)


# world.gd hands over the commander homes that are still in enemy hands.
func setWaitingCommanders(list: Array) -> void:
	waitingCommanders = list
	if is_visible_in_tree():
		_populate_commander_tab()


func _add_waiting_commanders(vbox: Node) -> void:
	if waitingCommanders.is_empty():
		return
	vbox.add_child(_intro_line("BEHIND ENEMY LINES: %d commanders are waiting. Liberate a commander's home and they join you with their army." % waitingCommanders.size()))
	for w in waitingCommanders:
		var t = w.get("tile")
		if t == null or not is_instance_valid(t):
			continue
		vbox.add_child(_intro_line("    %s, %s  •  %s  •  %s" % [str(t.tileName), str(t.tileContinent), str(w.get("archetype_name", "")), str(w.get("army_label", ""))]))


func _populate_presidential_tab() -> void:
	var vbox = $"PanelBackground/TabContainer/DEPARTMENT OF MYTHOLOGICAL AFFAIRS/ScrollContainer/PresidentialVBox"
	_clear(vbox)
	vbox.add_child(_intro_line("A spirit joins the Republic in three steps: Contact, then Trust, then Accord. Finish the tasks listed on a file and its next scene arrives. Spirits still outside the Republic spread corruption."))
	# Files that need you first, then work in progress, then allies.
	var order := {"order": 0, "answer": 1, "working": 2, "waiting": 3, "complete": 4}
	var entries: Array = []
	for i in activeProtectorArcs.size():
		var view: Dictionary = _protector_view(activeProtectorArcs[i])
		entries.append([order.get(view.get("state", "working"), 2), -int(activeProtectorArcs[i].get("stage_index", 0)), i, view])
	entries.sort()
	var ready: int = 0
	for e in entries:
		var arcData: Dictionary = activeProtectorArcs[e[2]]
		if e[3].get("state", "") in ["order", "answer"]:
			ready += 1
		var card = WarRoomCard.new()
		vbox.add_child(card)
		card.build_protector(arcData, e[3])
		card.order_pressed.connect(_on_protector_summon_requested)
	var tabs: TabContainer = $PanelBackground/TabContainer
	tabs.set_tab_title(1, "DEPARTMENT OF MYTHOLOGICAL AFFAIRS" + (" (%d)" % ready if ready > 0 else ""))


# ============================================================
# ARC REGISTRATION
# ============================================================

func registerCommanderArc(gov: governor, assignedTile) -> void:
	var archetype = _get_archetype_for_governor(gov)
	if archetype.is_empty():
		return
	for existing in activeCommanderArcs:
		if existing["governor"] == gov:
			return
	var home_terrain: String = assignedTile.terrain if assignedTile != null else "Farmlands"
	var arcData = {
		"governor": gov,
		"archetype_id": archetype.get("archetype_id", ""),
		"archetype_name": archetype.get("archetype_name", ""),
		"home_tile": assignedTile,
		"home_terrain": home_terrain,
		"home_tile_building_start": _count_building_levels_in(assignedTile) if assignedTile != null else 0,
		"objectives": _build_commander_objectives(archetype, home_terrain),
		"objectives_complete": [false, false, false],
		"arc_active": true,
		"arc_complete": false,
		"arc_start_turn": 0,
	}
	activeCommanderArcs.append(arcData)
	_populate_commander_tab()


func registerProtectorArc(protector_id: String) -> void:
	# Thin wrapper kept for mid-game / scripted calls.
	# Full game-start setup uses setupAllProtectors() instead.
	for existing in activeProtectorArcs:
		if existing["protector_id"] == protector_id:
			return
	_populate_presidential_tab()


# ── FULL PROTECTOR SETUP (called from world.gd after the world is built) ─────
# Builds one three-step file per spirit from data/protector_objectives.csv (who they
# are, where they live) and data/protector_stages.csv (hand-written tasks per step).
# A spirit with no hand-written rows gets the standard ladder:
#   CONTACT  hold their home and raise it by N building levels, then give the order
#   TRUST    bring the President there in person
#   ACCORD   stockpile their tribute
# world.gd calls this every time the active player changes, so the files are built
# once per country and kept; rebuilding them would wipe the player's progress.
func setupAllProtectors(allTiles: Array, country_id: String = "") -> void:
	if country_id != "":
		playerCountryID = country_id
	_all_tiles = allTiles
	if _arcs_by_country.has(playerCountryID):
		activeProtectorArcs = _arcs_by_country[playerCountryID]
		_populate_presidential_tab()
		return
	activeProtectorArcs = []
	_arcs_by_country[playerCountryID] = activeProtectorArcs
	var stage_rows: Dictionary = _load_protector_stages()
	for row in _load_protector_objectives():
		var pid: String = row.get("protector_id", "")
		if pid == "":
			continue
		# Filter by country: USA sees PROT_XX, CA sees CA_PROT_XX, coop sees all
		var is_ca_prot: bool = pid.begins_with("CA_")
		if playerCountryID == "USA" and is_ca_prot:
			continue
		if playerCountryID == "CA" and not is_ca_prot:
			continue
		if EventDatabase.get_event(pid + "_SUMMON").is_empty():
			push_warning("WarRoomPanel: no summon event for " + pid + " — skipping")
			continue
		activeProtectorArcs.append(_build_protector_arc(row, stage_rows.get(pid, {})))
	_refresh_protector_progress(_last_turn)
	_populate_presidential_tab()


func resetProtectors() -> void:
	# New game / load: forget every country's files.
	_arcs_by_country.clear()
	activeProtectorArcs = []


func _build_protector_arc(row: Dictionary, authored: Dictionary) -> Dictionary:
	var pid: String = row.get("protector_id", "")
	var origin_tile = _find_protector_origin(row, _all_tiles)
	var origin_name: String = origin_tile.tileName if origin_tile != null else "their home"
	var rmin: int = row.get("resource_min", 20)
	var rmax: int = row.get("resource_max", 40)
	var threshold: int = rmin + (randi() % max(1, rmax - rmin + 1))
	var resource: String = row.get("resource_type", "gold")
	var dev_req: int = row.get("dev_levels", 3)
	var leader: String = "Prime Minister Odjick" if pid.begins_with("CA_") else "President Carlisle"
	var defaults: Dictionary = {
		"contact": {"fire": "order", "objectives": [
			{"type": "hold_tile", "target": origin_name, "label": "Liberate " + origin_name},
			{"type": "dev_progress", "target": origin_name, "amount": dev_req,
			 "label": "Raise " + origin_name + " by " + str(dev_req) + " building levels"},
		]},
		"trust": {"fire": "auto", "objectives": [
			{"type": "leader_at", "target": origin_name, "label": "Bring " + leader + " to " + origin_name},
		]},
		"accord": {"fire": "auto", "objectives": [
			{"type": "resource", "target": resource, "amount": threshold,
			 "label": "Stockpile " + str(threshold) + " " + _resource_label(resource)},
		]},
	}
	var stages: Array = []
	for key in STAGE_KEYS:
		var src: Dictionary = authored.get(key, defaults[key])
		var objectives: Array = src.get("objectives", []).duplicate(true)
		for obj in objectives:
			obj["tile"] = _find_tile_named(str(obj.get("target", "")))
			obj["label"] = str(obj.get("label", "")).replace("{origin}", origin_name).replace("{leader}", leader)
		var done: Array = []
		done.resize(objectives.size())
		done.fill(false)
		stages.append({
			"key": key,
			"fire": src.get("fire", "auto"),
			"event_id": pid + STAGE_EVENTS[key],
			"flag": pid.to_lower() + STAGE_FLAGS[key],
			"objectives": objectives,
			"done": done,
			"progress": [],
		})
	var memo: String = _gen_soma_memo(pid, row.get("protector_name", pid))
	var note: String = ""
	var at: int = memo.find("Note:")
	if at >= 0:
		note = memo.substr(at + 5).strip_edges()
	return {
		"protector_id":          pid,
		"protector_name":        row.get("protector_name", pid),
		"soma_memo":             memo,
		"memo_note":             note,
		"origin_tile":           origin_tile,
		"origin_tile_name":      origin_name,
		"origin_building_start": _count_building_levels_in(origin_tile) if origin_tile != null else 0,
		"stages":                stages,
		"stage_index":           0,
		"arc_complete":          false,
		"ready_announced":       false,
	}


# data/protector_stages.csv -> {protector_id: {stage: {fire, objectives[]}}}
func _load_protector_stages() -> Dictionary:
	var out: Dictionary = {}
	var file = FileAccess.open("res://data/protector_stages.csv", FileAccess.READ)
	if not file:
		return out
	var headers = file.get_csv_line()
	while not file.eof_reached():
		var row = file.get_csv_line()
		if row.size() < 4:
			continue
		var e: Dictionary = {}
		for i in range(min(headers.size(), row.size())):
			e[headers[i].strip_edges()] = row[i].strip_edges()
		var pid: String = e.get("protector_id", "")
		var stage: String = e.get("stage", "")
		if pid == "" or not STAGE_KEYS.has(stage):
			continue
		if not out.has(pid):
			out[pid] = {}
		if not out[pid].has(stage):
			out[pid][stage] = {"fire": e.get("fire", "auto"), "objectives": []}
		out[pid][stage]["objectives"].append({
			"type":   e.get("objective", ""),
			"target": e.get("target", ""),
			"amount": e.get("amount", "0").to_int(),
			"param":  e.get("param", ""),
			"label":  e.get("label", ""),
		})
	file.close()
	return out


func _find_tile_named(tile_name: String):
	if tile_name == "":
		return null
	for tile in _all_tiles:
		if is_instance_valid(tile) and tile.tileName == tile_name:
			return tile
	return null


func _resource_label(resource: String) -> String:
	match resource:
		"gold", "dollars": return "Dollars"
		"faith":           return "Culture"
		"harmony":         return "Happiness"
	return resource.capitalize()


func _load_protector_objectives() -> Array:
	var result: Array = []
	var file = FileAccess.open("res://data/protector_objectives.csv", FileAccess.READ)
	if not file:
		push_error("WarRoomPanel: cannot open protector_objectives.csv")
		return result
	var headers = file.get_csv_line()
	while not file.eof_reached():
		var row = file.get_csv_line()
		if row.size() < 2:
			continue
		var entry: Dictionary = {}
		for i in range(min(headers.size(), row.size())):
			entry[headers[i].strip_edges()] = row[i].strip_edges()
		entry["resource_min"]   = entry.get("resource_min",   "20").to_int()
		entry["resource_max"]   = entry.get("resource_max",   "40").to_int()
		entry["dev_levels"]     = entry.get("dev_levels",     "3").to_int()
		entry["origin_tile_id"] = entry.get("origin_tile_id", "0").to_int()
		result.append(entry)
	file.close()
	return result


func _find_protector_origin(pdata: Dictionary, allTiles: Array):
	var origin_type: String = pdata.get("origin_type", "dynamic")
	var tile_id: int        = pdata.get("origin_tile_id", 0)
	var req_state: String   = pdata.get("origin_state", "")
	var req_terrain: String = pdata.get("origin_terrain", "")

	if origin_type == "fixed":
		for tile in allTiles:
			if tile.tileNumber == tile_id:
				return tile
		return null

	# Dynamic: filter all tiles by state and/or terrain, prefer player-owned
	var candidates: Array = []
	for tile in allTiles:
		var state_ok   = req_state   == "" or tile.tileContinent.begins_with(req_state)
		var terrain_ok = req_terrain == "" or tile.terrain       == req_terrain
		if state_ok and terrain_ok:
			candidates.append(tile)
	if candidates.is_empty():
		return null
	# Prefer player-owned tiles; fall back to any matching tile
	var owned: Array = candidates.filter(
		func(t): return playerCountryNode != null and t.tileOwner == playerCountryNode.CID)
	var pool: Array = owned if not owned.is_empty() else candidates
	return pool[randi() % pool.size()]


func _count_building_levels_in(tile) -> int:
	var total: int = 0
	if tile == null or not is_instance_valid(tile):
		return 0
	for bname in tile.buildings:
		total += tile.buildings[bname]
	return total


func _get_resource_amount(resource: String) -> float:
	if playerCountryNode == null:
		return 0.0
	match resource:
		"dollars", "gold":       return playerCountryNode.TotalDollars   # "gold" for CSV compat
		"food":                  return playerCountryNode.TotalFood
		"wood":                  return playerCountryNode.TotalWood
		"metal":                 return playerCountryNode.TotalMetal
		"weapons":               return playerCountryNode.TotalWeapons
		"faith", "culture":      return playerCountryNode.TotalCulture   # "faith" for CSV compat
		"magic":                 return playerCountryNode.TotalMagic
		"happiness", "harmony":  return playerCountryNode.TotalHappiness # "harmony" for CSV compat
		"mandate":               return playerCountryNode.TotalMandate
		"manpower":              return playerCountryNode.TotalManpower
	return 0.0


func _gen_soma_memo(pid: String, name: String) -> String:
	# Return the hand-written memo for special protectors, otherwise auto-generate
	var custom: String = _get_soma_memo(pid)
	if not custom.begins_with("RE: Asset Acquisition Request — [CLASSIFIED]"):
		return custom
	return ("RE: Asset Acquisition Request — " + name + " (" + pid + ")\n" +
			"Status: In Progress\n" +
			"Classification: MYTHOLOGICAL / SUPERNATURAL\n" +
			"Note: The Secretary recommends receptive posture and avoidance of" +
			" skepticism in initial contact. Standard acquisition forms attached.")


# ============================================================
# OBJECTIVE CHECKING — called from world.gd _on_next_turn_pressed()
# ============================================================

func checkObjectives(allTiles: Array, currentTurn: int) -> void:
	_all_tiles = allTiles
	_last_turn = currentTurn
	_check_commander_objectives(allTiles, currentTurn)
	_advance_protectors(currentTurn)
	_populate_commander_tab()
	_populate_presidential_tab()


func _check_commander_objectives(allTiles: Array, currentTurn: int) -> void:
	for arcData in activeCommanderArcs:
		if arcData["arc_complete"]:
			continue
		# Record start turn on first check
		if arcData.get("arc_start_turn", 0) == 0:
			arcData["arc_start_turn"] = currentTurn
		for i in range(3):
			if arcData["objectives_complete"][i]:
				continue
			var obj = arcData["objectives"][i]
			var condition_met = _evaluate_commander_condition(obj, arcData, allTiles, currentTurn)
			if condition_met:
				arcData["objectives_complete"][i] = true
				emit_signal("arcObjectiveCompleted", arcData["archetype_id"], i + 1)
				var event_triggers = EventDatabase.evaluate_commander_triggers(
					arcData["archetype_id"], i + 1, currentTurn)
				for event_id in event_triggers:
					emit_signal("requestEventFire", event_id, arcData["home_tile"])
		if arcData["objectives_complete"].all(func(b): return b):
			arcData["arc_complete"] = true
			emit_signal("arcFullyCompleted", arcData["archetype_id"])


# ── THE SPIRIT LADDER ────────────────────────────────────────────────────────
# Once a turn, for every spirit:
#   1. Catch up with the story: the flag a scene's buttons set (prot_16_summoned,
#      prot_16_tame, prot_16_agreed) moves the file to the next step.
#   2. Re-check the tasks of the step in progress.
#   3. If they are all done, fire that step's scene ("auto"), or light the order
#      button ("order"). "external" steps are fired by world.gd itself.
func _advance_protectors(currentTurn: int) -> void:
	_refresh_protector_progress(currentTurn)
	for arc in activeProtectorArcs:
		if arc["arc_complete"]:
			continue
		var stage: Dictionary = arc["stages"][arc["stage_index"]]
		if not _stage_tasks_done(stage):
			continue
		match stage["fire"]:
			"auto":
				if EventDatabase.event_can_fire(stage["event_id"], currentTurn):
					emit_signal("requestEventFire", stage["event_id"], arc.get("origin_tile"))
			"order":
				if not arc["ready_announced"]:
					arc["ready_announced"] = true
					emit_signal("protectorReady", arc["protector_name"])


func _refresh_protector_progress(currentTurn: int) -> void:
	if playerCountryNode == null:
		return
	for arc in activeProtectorArcs:
		_sync_stage_with_flags(arc)
		if arc["arc_complete"]:
			continue
		var stage: Dictionary = arc["stages"][arc["stage_index"]]
		stage["progress"] = []
		for i in stage["objectives"].size():
			var res: Dictionary = _objective_state(stage["objectives"][i], arc, currentTurn)
			stage["done"][i] = res["done"]
			stage["progress"].append(res["text"])


func _sync_stage_with_flags(arc: Dictionary) -> void:
	var flags: Dictionary = playerCountryNode.CountryFlags
	var reached: int = arc["stage_index"]
	for i in arc["stages"].size():
		if flags.has(arc["stages"][i]["flag"]):
			reached = max(reached, i + 1)
	if reached != arc["stage_index"]:
		arc["stage_index"] = reached
		arc["ready_announced"] = false
	if reached >= arc["stages"].size() and not arc["arc_complete"]:
		arc["arc_complete"] = true
		_on_protector_devotion_completed(arc["protector_id"])


func _stage_tasks_done(stage: Dictionary) -> bool:
	if stage["fire"] == "external":
		return false
	for d in stage["done"]:
		if not d:
			return false
	return true


# True while a step's scene has been delivered but not yet answered.
func _stage_awaiting_answer(stage: Dictionary) -> bool:
	var ev: Dictionary = EventDatabase.get_event(stage["event_id"])
	return int(ev.get("_fire_count", 0)) > 0 and int(ev.get("_last_fired", -999)) >= _last_turn - 1


# What the card shows for a spirit right now.
func _protector_view(arc: Dictionary) -> Dictionary:
	var origin = arc.get("origin_tile")
	var where: String = arc.get("origin_tile_name", "")
	if origin != null and is_instance_valid(origin) and playerCountryNode != null:
		if origin.tileOwner == playerCountryNode.CID:
			where += "  •  in your hands"
		else:
			where += "  •  held by " + OWNER_NAMES.get(origin.tileOwner, origin.tileOwner)
	var reward: String = "Accord grants: a Tower at " + arc.get("origin_tile_name", "their home")
	var world = get_tree().current_scene if is_inside_tree() else null
	if world != null and world.has_method("_protector_id_to_spell"):
		var spell: String = world._protector_id_to_spell(arc["protector_id"])
		if spell != "":
			reward += "  •  Presidential power: " + spell.capitalize()
	if arc["arc_complete"]:
		return {"state": "complete", "where": where, "tasks": [],
				"status": "Allied with the Republic.", "reward": reward.replace("Accord grants:", "Granted:")}
	var stage: Dictionary = arc["stages"][arc["stage_index"]]
	var tasks: Array = []
	for i in stage["objectives"].size():
		tasks.append({
			"label": stage["objectives"][i]["label"],
			"done": stage["done"][i],
			"progress": stage["progress"][i] if i < stage["progress"].size() else "",
		})
	var scene_name: String = STAGE_SCENE_NAMES[stage["key"]]
	var state: String = "working"
	var status: String = "Finish the tasks below and " + scene_name + " follows next turn."
	if stage["fire"] == "external":
		state = "waiting"
		status = "The Department is still gathering reports. Follow the lead below."
	elif _stage_tasks_done(stage):
		if stage["fire"] == "order":
			state = "order"
			status = "Ready. Give the order and " + arc["protector_name"] + " answers."
		elif _stage_awaiting_answer(stage):
			state = "answer"
			status = "A dispatch is waiting for your answer."
		else:
			state = "answer"
			status = "Tasks complete. " + scene_name.capitalize() + " arrives at the start of next turn."
	elif stage["fire"] == "order":
		status = "Finish the tasks below, then give the order to make contact."
	return {"state": state, "where": where, "tasks": tasks, "status": status, "reward": reward}


# One task -> {done, text}. "text" is the short progress read-out on the right of the row.
func _objective_state(obj: Dictionary, arc: Dictionary, currentTurn: int) -> Dictionary:
	var cid: String = playerCountryNode.CID
	var tile = obj.get("tile")
	if tile == null or not is_instance_valid(tile):
		tile = arc.get("origin_tile")
	var amount: int = int(obj.get("amount", 0))
	match obj.get("type", ""):
		"turn_reached":
			return {"done": currentTurn >= amount, "text": "Turn %d / %d" % [min(currentTurn, amount), amount]}
		"hold_tile":
			if tile == null:
				return {"done": false, "text": ""}
			var held: bool = tile.tileOwner == cid
			return {"done": held, "text": "Held" if held else "Occupied"}
		"hold_adjacent":
			if tile == null:
				return {"done": false, "text": ""}
			var need: int = max(1, amount)
			var n: int = need if tile.tileOwner == cid else 0
			for nb in tile.TileNeighbors:
				if nb != null and nb.tileOwner == cid:
					n += 1
			return {"done": n >= need, "text": "%d / %d" % [min(n, need), need]}
		"leader_at", "leader_near":
			if tile == null:
				return {"done": false, "text": ""}
			var spots: Array = [tile]
			if obj["type"] == "leader_near":
				spots.append_array(tile.TileNeighbors)
			var here: bool = false
			for lt in _leader_tiles():
				if spots.has(lt):
					here = true
			return {"done": here, "text": "Present" if here else "Not there yet"}
		"dev_progress":
			if tile == null:
				return {"done": false, "text": ""}
			var gained: int = _count_building_levels_in(tile) - int(arc.get("origin_building_start", 0))
			var ok: bool = tile.tileOwner == cid and gained >= amount
			return {"done": ok, "text": "%d / %d" % [clampi(gained, 0, amount), amount]}
		"resource":
			var have: int = int(_get_resource_amount(str(obj.get("target", "gold"))))
			return {"done": have >= amount, "text": "%d / %d" % [min(have, amount), amount]}
		"building_level":
			if tile == null:
				return {"done": false, "text": ""}
			var lvl: int = int(tile.buildings.get(str(obj.get("param", "")).to_lower(), 0)) if tile.tileOwner == cid else 0
			return {"done": lvl >= amount, "text": "Level %d / %d" % [min(lvl, amount), amount]}
		"dual_buildings":
			# param "dock+barracks@3": both buildings at level 3 or better; amount = how many tiles
			var spec: PackedStringArray = str(obj.get("param", "dock+barracks@1")).split("@")
			var pair: PackedStringArray = spec[0].split("+")
			var min_lvl: int = spec[1].to_int() if spec.size() > 1 else 1
			var count: int = 0
			if pair.size() == 2:
				for t in playerCountryNode.OwnedTileList:
					if t.buildings.get(pair[0], 0) >= min_lvl and t.buildings.get(pair[1], 0) >= min_lvl:
						count += 1
			return {"done": count >= amount, "text": "%d / %d" % [min(count, amount), amount]}
		"cannons":
			var done_c: bool = _evaluate_protector_prayer({"prayer_type": "cannon_units_in_armies", "count": amount}, arc, currentTurn)
			return {"done": done_c, "text": ""}
		"dma_investigation":
			var done_d: bool = _evaluate_protector_prayer({"prayer_type": "dma_investigation_done"}, arc, currentTurn)
			return {"done": done_d, "text": ""}
	return {"done": false, "text": ""}


# Where the nation's leader is: the tile she governs, or the tile of an army she commands.
func _leader_tiles() -> Array:
	var leader: String = "Jessica Commanda Odjick" if playerCountryNode.CID == "CA" else "Ualani Carlisle"
	var out: Array = []
	for t in playerCountryNode.OwnedTileList:
		if t.tileGovernor != null and t.tileGovernor.governorType == leader:
			out.append(t)
	for army in playerCountryNode.countryArmyList:
		if army.commander != null and army.commander.governorType == leader and army.inTile != null:
			out.append(army.inTile)
	return out


# ============================================================
# CONDITION EVALUATORS
# ============================================================

func _evaluate_commander_condition(obj: Dictionary,
		arcData: Dictionary, _allTiles: Array, currentTurn: int) -> bool:
	match obj.get("condition_type", ""):

		"liberate_tile_terrain":
			var terrain = obj.get("condition_value", "")
			var state_code = obj.get("condition_state", "")
			for tile in playerCountryNode.OwnedTileList:
				if tile.terrain == terrain:
					if state_code == "" or tile.tileContinent.begins_with(state_code):
						return true
			return false

		"liberate_specific_tile":
			var tile_num = obj.get("condition_value", "0").to_int()
			for tile in playerCountryNode.OwnedTileList:
				if tile.tileNumber == tile_num:
					return true
			return false

		"liberate_tile_count":
			var required = obj.get("condition_value", "3").to_int()
			return playerCountryNode.OwnedTileList.size() >= required

		"hold_tile_turns":
			var required_turns = obj.get("condition_value", "5").to_int()
			var obj_key = "tile_captured_turn_" + str(obj.get("obj_index", 0))
			var tile_captured_turn = arcData.get(obj_key, -1)
			if tile_captured_turn < 0:
				var target_tile = _find_held_terrain_tile(obj.get("terrain", ""))
				if target_tile != null:
					arcData[obj_key] = currentTurn
				return false
			return (currentTurn - tile_captured_turn) >= required_turns

		"commander_present_in_tile":
			var terrain = obj.get("condition_value", "")
			for tile in playerCountryNode.OwnedTileList:
				if tile.tileGovernor == arcData["governor"]:
					if terrain == "" or tile.terrain == terrain:
						return true
			return false

		"liberate_tile_with_feature":
			var feature = obj.get("condition_value", "")
			for tile in playerCountryNode.OwnedTileList:
				if tile.has_special_feature(feature):
					return true
			return false

		"turns_survived":
			var start_turn = arcData.get("arc_start_turn", currentTurn)
			var required = obj.get("condition_value", "5").to_int()
			return (currentTurn - start_turn) >= required

		"build_in_home_tile":
			var home_tile = arcData.get("home_tile")
			if home_tile == null:
				return false
			var required = obj.get("condition_value", "2").to_int()
			var bstart   = arcData.get("home_tile_building_start", 0)
			return (_count_building_levels_in(home_tile) - bstart) >= required

		"home_tile_corruption_below":
			var home_tile = arcData.get("home_tile")
			if home_tile == null:
				return false
			return home_tile.corruption <= obj.get("condition_value", "20").to_int()

		"home_tile_moral_decay_below":
			var home_tile = arcData.get("home_tile")
			if home_tile == null:
				return false
			return home_tile.tileMoralDecay <= obj.get("condition_value", "20").to_int()

		"resource_threshold":
			var resource = obj.get("condition_value", "gold")
			var amount   = obj.get("condition_amount", "50").to_float()
			return _get_resource_amount(resource) >= amount

		"liberate_tiles_in_state":
			var state_code = obj.get("condition_state", "")
			var required   = obj.get("condition_value", "2").to_int()
			var count: int = 0
			for tile in playerCountryNode.OwnedTileList:
				if tile.tileContinent.begins_with(state_code):
					count += 1
			return count >= required

		"home_tile_has_building":
			var home_tile = arcData.get("home_tile")
			if home_tile == null:
				return false
			var bname    = obj.get("condition_value", "").to_lower()
			var req_lvl  = obj.get("condition_amount", "1").to_int()
			return home_tile.buildings.get(bname, 0) >= req_lvl

		"liberate_any_with_building":
			var bname   = obj.get("condition_value", "").to_lower()
			var req_lvl = obj.get("condition_amount", "1").to_int()
			for tile in playerCountryNode.OwnedTileList:
				if tile.buildings.get(bname, 0) >= req_lvl:
					return true
			return false

		"liberate_state_count":
			var required = obj.get("condition_value", "3").to_int()
			var states: Dictionary = {}
			for tile in playerCountryNode.OwnedTileList:
				states[tile.tileContinent] = true
			return states.size() >= required

		_:
			return false


func _evaluate_protector_prayer(prayer: Dictionary,
		arcData: Dictionary, _currentTurn: int) -> bool:
	match prayer.get("prayer_type", ""):

		"resource_threshold":
			# Nation must have accumulated the required amount in stockpiles
			var resource: String = prayer.get("resource", "gold")
			var amount: float    = float(prayer.get("amount", 50))
			return _get_resource_amount(resource) >= amount

		"dev_progress":
			# Origin tile must have gained N building levels since game start
			var origin_tile = arcData.get("origin_tile")
			if origin_tile == null:
				return false
			var required: int = prayer.get("levels", 3)
			var bstart: int   = arcData.get("origin_building_start", 0)
			var current: int  = _count_building_levels_in(origin_tile)
			return (current - bstart) >= required

		"ualani_in_origin":
			# An army commanded by Ualani Carlisle must be in the origin tile
			var origin_tile = arcData.get("origin_tile")
			if origin_tile == null or playerCountryNode == null:
				return false
			for army in playerCountryNode.countryArmyList:
				if army.commander != null:
					if army.commander.governorType == "Ualani Carlisle":
						if army.inTile == origin_tile:
							return true
			return false

		"tiles_with_dual_buildings":
			if playerCountryNode == null:
				return false
			var ba: String = prayer.get("building_a", "dock").to_lower()
			var bb: String = prayer.get("building_b", "barracks").to_lower()
			var required: int = prayer.get("count", 3)
			var count: int = 0
			for tile in playerCountryNode.OwnedTileList:
				if tile.buildings.get(ba, 0) >= 1 and tile.buildings.get(bb, 0) >= 1:
					count += 1
			return count >= required

		"tiles_with_dual_buildings_min_level":
			if playerCountryNode == null:
				return false
			var ba: String = prayer.get("building_a", "dock").to_lower()
			var bb: String = prayer.get("building_b", "barracks").to_lower()
			var min_lvl: int = prayer.get("min_level", 3)
			var required: int = prayer.get("count", 3)
			var count: int = 0
			for tile in playerCountryNode.OwnedTileList:
				if tile.buildings.get(ba, 0) >= min_lvl and tile.buildings.get(bb, 0) >= min_lvl:
					count += 1
			return count >= required

		"cannon_units_in_armies":
			if playerCountryNode == null:
				return false
			var required: int = prayer.get("count", 8)
			var count: int = 0
			for army in playerCountryNode.countryArmyList:
				for unit in army.unitList:
					if unit.unitType == "Cannon" or unit.unitClass == "siege":
						count += 1
			return count >= required

		"dma_investigation_done":
			if playerCountryNode == null:
				return false
			for tile in playerCountryNode.OwnedTileList:
				if tile.dmaInvestigationPending:
					return true
			return false

		"building_level_in_tile":
			if playerCountryNode == null:
				return false
			var tile_id: int = prayer.get("tile_id", 0)
			var btype: String = prayer.get("building_type", "courthouse").to_lower()
			var min_lvl: int  = prayer.get("min_level", 6)
			for tile in playerCountryNode.OwnedTileList:
				if tile.tileNumber == tile_id:
					return tile.buildings.get(btype, 0) >= min_lvl
			return false

		_:
			return false


# ============================================================
# DATA BUILDERS
# ============================================================

func _build_commander_objectives(archetype: Dictionary, home_terrain: String = "Farmlands") -> Array:
	var arc_id = archetype.get("archetype_id", "")
	return [
		_get_commander_objective(arc_id, 1, home_terrain),
		_get_commander_objective(arc_id, 2, home_terrain),
		_get_commander_objective(arc_id, 3, home_terrain),
	]


func _get_commander_objective(arc_id: String, num: int, home_terrain: String = "Farmlands") -> Dictionary:
	match arc_id:
		"ARC_01":  # Wetlands Fisher
			match num:
				1: return {
					"label": "Liberate a Wetlands tile in VA, SC, MD, or NJ",
					"condition_type": "liberate_tile_terrain",
					"condition_value": "Wetlands",
					"condition_state": "",
					"obj_index": 0,
				}
				2: return {
					"label": "Hold that tile for 5 turns without retreating",
					"condition_type": "hold_tile_turns",
					"condition_value": "5",
					"terrain": "Wetlands",
					"obj_index": 1,
				}
				3: return {
					"label": "Assign this commander to the liberated tile personally",
					"condition_type": "commander_present_in_tile",
					"condition_value": "Wetlands",
					"obj_index": 2,
				}

		"ARC_02":  # Appalachian Miner
			match num:
				1: return {"label":"Liberate a Foothills tile","condition_type":"liberate_tile_terrain","condition_value":"Foothills","condition_state":"","obj_index":0}
				2: return {"label":"Build 2 new levels in your home tile","condition_type":"build_in_home_tile","condition_value":"2","obj_index":1}
				3: return {"label":"Drive corruption in your home tile below 20","condition_type":"home_tile_corruption_below","condition_value":"20","obj_index":2}

		"ARC_03":  # Ivy League Dropout
			match num:
				1: return {"label":"Liberate any Metro tile","condition_type":"liberate_tile_terrain","condition_value":"Metro","condition_state":"","obj_index":0}
				2: return {"label":"Survive 10 turns active","condition_type":"turns_survived","condition_value":"10","obj_index":1}
				3: return {"label":"Accumulate 200 gold in national treasury","condition_type":"resource_threshold","condition_value":"gold","condition_amount":"200","obj_index":2}

		"ARC_04":  # Seminole Fighter
			match num:
				1: return {"label":"Liberate a Wetlands tile","condition_type":"liberate_tile_terrain","condition_value":"Wetlands","condition_state":"","obj_index":0}
				2: return {"label":"Hold that Wetlands tile for 8 turns","condition_type":"hold_tile_turns","condition_value":"8","terrain":"Wetlands","obj_index":1}
				3: return {"label":"Station in a liberated Wetlands tile personally","condition_type":"commander_present_in_tile","condition_value":"Wetlands","obj_index":2}

		"ARC_05":  # Green Mountain Farmer
			match num:
				1: return {"label":"Liberate a Farmlands tile","condition_type":"liberate_tile_terrain","condition_value":"Farmlands","condition_state":"","obj_index":0}
				2: return {"label":"Ensure your home tile has a Farm","condition_type":"home_tile_has_building","condition_value":"farm","condition_amount":"1","obj_index":1}
				3: return {"label":"Stockpile 150 food nationally","condition_type":"resource_threshold","condition_value":"food","condition_amount":"150","obj_index":2}

		"ARC_06":  # Chesapeake Shipwright
			match num:
				1: return {"label":"Liberate any tile with a Dock","condition_type":"liberate_any_with_building","condition_value":"dock","condition_amount":"1","obj_index":0}
				2: return {"label":"Build 2 new levels in your home tile","condition_type":"build_in_home_tile","condition_value":"2","obj_index":1}
				3: return {"label":"Station in a coastal Wetlands tile","condition_type":"commander_present_in_tile","condition_value":"Wetlands","obj_index":2}

		"ARC_07":  # Loyalist Turncoat
			match num:
				1: return {"label":"Prove loyalty: survive 5 turns active","condition_type":"turns_survived","condition_value":"5","obj_index":0}
				2: return {"label":"Help liberate a Metro tile","condition_type":"liberate_tile_terrain","condition_value":"Metro","condition_state":"","obj_index":1}
				3: return {"label":"Drive Crown corruption in your home tile below 15","condition_type":"home_tile_corruption_below","condition_value":"15","obj_index":2}

		"ARC_08":  # Tobacco Belt Drifter
			match num:
				1: return {"label":"Liberate a Farmlands tile","condition_type":"liberate_tile_terrain","condition_value":"Farmlands","condition_state":"","obj_index":0}
				2: return {"label":"Hold that Farmlands tile for 6 turns","condition_type":"hold_tile_turns","condition_value":"6","terrain":"Farmlands","obj_index":1}
				3: return {"label":"Bring morale decay in your home tile below 20","condition_type":"home_tile_moral_decay_below","condition_value":"20","obj_index":2}

		"ARC_09":  # War Widow
			match num:
				1: return {"label":"Liberate any major city tile (Metro terrain)","condition_type":"liberate_tile_terrain","condition_value":"Metro","condition_state":"","obj_index":0}
				2: return {"label":"Survive 8 turns without retreating","condition_type":"turns_survived","condition_value":"8","obj_index":1}
				3: return {"label":"Hold the liberated city for 5 turns","condition_type":"hold_tile_turns","condition_value":"5","terrain":"Metro","obj_index":2}

		"ARC_10":  # Indigenous Scout
			match num:
				1: return {"label":"Liberate a Woods tile","condition_type":"liberate_tile_terrain","condition_value":"Woods","condition_state":"","obj_index":0}
				2: return {"label":"Hold that Woods tile for 5 turns","condition_type":"hold_tile_turns","condition_value":"5","terrain":"Woods","obj_index":1}
				3: return {"label":"Station in a liberated Woods tile","condition_type":"commander_present_in_tile","condition_value":"Woods","obj_index":2}

		"ARC_11":  # Boston Rabble-Rouser
			match num:
				1: return {"label":"Liberate a Metro tile","condition_type":"liberate_tile_terrain","condition_value":"Metro","condition_state":"","obj_index":0}
				2: return {"label":"Rally 100 culture nationally","condition_type":"resource_threshold","condition_value":"culture","condition_amount":"100","obj_index":1}
				3: return {"label":"Bring morale decay in home tile below 25","condition_type":"home_tile_moral_decay_below","condition_value":"25","obj_index":2}

		"ARC_12":  # Continental Surgeon
			match num:
				1: return {"label":"Drive corruption in your home tile below 20","condition_type":"home_tile_corruption_below","condition_value":"20","obj_index":0}
				2: return {"label":"Build national food supply to 100","condition_type":"resource_threshold","condition_value":"food","condition_amount":"100","obj_index":1}
				3: return {"label":"Build 2 new levels in your home tile","condition_type":"build_in_home_tile","condition_value":"2","obj_index":2}

		"ARC_13":  # Nantucket Sailor
			match num:
				1: return {"label":"Liberate any tile with a Dock","condition_type":"liberate_any_with_building","condition_value":"dock","condition_amount":"1","obj_index":0}
				2: return {"label":"Hold a Wetlands tile for 5 turns","condition_type":"hold_tile_turns","condition_value":"5","terrain":"Wetlands","obj_index":1}
				3: return {"label":"Station in a Wetlands tile personally","condition_type":"commander_present_in_tile","condition_value":"Wetlands","obj_index":2}

		"ARC_14":  # Frontier Preacher
			match num:
				1: return {"label":"Liberate a Woods tile","condition_type":"liberate_tile_terrain","condition_value":"Woods","condition_state":"","obj_index":0}
				2: return {"label":"Bring morale decay in home tile below 20","condition_type":"home_tile_moral_decay_below","condition_value":"20","obj_index":1}
				3: return {"label":"Inspire 80 culture nationally","condition_type":"resource_threshold","condition_value":"culture","condition_amount":"80","obj_index":2}

		"ARC_15":  # DC Bureaucrat
			match num:
				1: return {"label":"Liberate a Metro tile","condition_type":"liberate_tile_terrain","condition_value":"Metro","condition_state":"","obj_index":0}
				2: return {"label":"Build 3 new levels in your home tile","condition_type":"build_in_home_tile","condition_value":"3","obj_index":1}
				3: return {"label":"Drive corruption in home tile below 10","condition_type":"home_tile_corruption_below","condition_value":"10","obj_index":2}

		"ARC_16":  # Rust Belt Steelworker
			match num:
				1: return {"label":"Liberate a Suburbs tile","condition_type":"liberate_tile_terrain","condition_value":"Suburbs","condition_state":"","obj_index":0}
				2: return {"label":"Build 3 new levels in your home tile","condition_type":"build_in_home_tile","condition_value":"3","obj_index":1}
				3: return {"label":"Ensure your home tile has a Forge","condition_type":"home_tile_has_building","condition_value":"forge","condition_amount":"1","obj_index":2}

		"ARC_17":  # Plantation Deserter
			match num:
				1: return {"label":"Liberate a Farmlands tile","condition_type":"liberate_tile_terrain","condition_value":"Farmlands","condition_state":"","obj_index":0}
				2: return {"label":"Hold that Farmlands tile for 6 turns","condition_type":"hold_tile_turns","condition_value":"6","terrain":"Farmlands","obj_index":1}
				3: return {"label":"Bring morale decay in home tile below 20","condition_type":"home_tile_moral_decay_below","condition_value":"20","obj_index":2}

		"ARC_18":  # Swamp Witch
			match num:
				1: return {"label":"Liberate a Wetlands tile","condition_type":"liberate_tile_terrain","condition_value":"Wetlands","condition_state":"","obj_index":0}
				2: return {"label":"Purge corruption in home tile below 10","condition_type":"home_tile_corruption_below","condition_value":"10","obj_index":1}
				3: return {"label":"Station in a Wetlands tile personally","condition_type":"commander_present_in_tile","condition_value":"Wetlands","obj_index":2}

		"ARC_19":  # Caribbean Privateer
			match num:
				1: return {"label":"Seize a port: liberate any tile with a Dock","condition_type":"liberate_any_with_building","condition_value":"dock","condition_amount":"1","obj_index":0}
				2: return {"label":"Accumulate 150 gold in national stockpiles","condition_type":"resource_threshold","condition_value":"gold","condition_amount":"150","obj_index":1}
				3: return {"label":"Station in a Wetlands tile personally","condition_type":"commander_present_in_tile","condition_value":"Wetlands","obj_index":2}

		"ARC_20":  # Hawaiian Refugee
			match num:
				1: return {"label":"Liberate any 3 tiles (any terrain, any region)","condition_type":"liberate_tile_count","condition_value":"3","obj_index":0}
				2: return {"label":"Liberate a tile with a Monument building","condition_type":"liberate_tile_with_feature","condition_value":"monument","obj_index":1}
				3: return {"label":"Designate a home tile (assign commander to any liberated tile)","condition_type":"commander_present_in_tile","condition_value":"","obj_index":2}

		"ARC_21":  # Border Mercenary
			match num:
				1: return {"label":"Liberate a Suburbs tile","condition_type":"liberate_tile_terrain","condition_value":"Suburbs","condition_state":"","obj_index":0}
				2: return {"label":"Hold that Suburbs tile for 8 turns","condition_type":"hold_tile_turns","condition_value":"8","terrain":"Suburbs","obj_index":1}
				3: return {"label":"Put 50 weapons in the national stockpile","condition_type":"resource_threshold","condition_value":"weapons","condition_amount":"50","obj_index":2}

		"ARC_22":  # Acadian Forest Ranger
			match num:
				1: return {"label":"Liberate a Woods tile","condition_type":"liberate_tile_terrain","condition_value":"Woods","condition_state":"","obj_index":0}
				2: return {"label":"Hold that Woods tile for 5 turns","condition_type":"hold_tile_turns","condition_value":"5","terrain":"Woods","obj_index":1}
				3: return {"label":"Station in a liberated Woods tile","condition_type":"commander_present_in_tile","condition_value":"Woods","obj_index":2}

		"ARC_23":  # Gettysburg Descendant
			match num:
				1: return {"label":"Liberate Gettysburg (tile 11)","condition_type":"liberate_specific_tile","condition_value":"11","obj_index":0}
				2: return {"label":"Hold Gettysburg for 5 turns","condition_type":"hold_tile_turns","condition_value":"5","terrain":"Foothills","obj_index":1}
				3: return {"label":"Survive the full campaign: 15 turns active","condition_type":"turns_survived","condition_value":"15","obj_index":2}

		"ARC_24":  # LGBTQ+ Organizer
			match num:
				1: return {"label":"Liberate a Metro tile","condition_type":"liberate_tile_terrain","condition_value":"Metro","condition_state":"","obj_index":0}
				2: return {"label":"Build national culture to 120","condition_type":"resource_threshold","condition_value":"culture","condition_amount":"120","obj_index":1}
				3: return {"label":"Liberate tiles in 3 distinct states","condition_type":"liberate_state_count","condition_value":"3","obj_index":2}

		"ARC_25":  # Carnival Barker
			match num:
				1: return {"label":"Help liberate 5 tiles total","condition_type":"liberate_tile_count","condition_value":"5","obj_index":0}
				2: return {"label":"Put 100 gold in the national coffers","condition_type":"resource_threshold","condition_value":"gold","condition_amount":"100","obj_index":1}
				3: return {"label":"Station at any liberated tile","condition_type":"commander_present_in_tile","condition_value":"","obj_index":2}

	# Generic fallback (should never hit for ARC_01–25)
	return _get_generic_objective(home_terrain, num)


func _get_generic_objective(terrain: String, num: int) -> Dictionary:
	match num:
		1: return {
			"label": "Liberate a " + terrain + " tile",
			"condition_type": "liberate_tile_terrain",
			"condition_value": terrain,
			"condition_state": "",
			"obj_index": 0,
		}
		2: return {
			"label": "Hold that " + terrain + " tile for 5 turns without retreating",
			"condition_type": "hold_tile_turns",
			"condition_value": "5",
			"terrain": terrain,
			"obj_index": 1,
		}
		3: return {
			"label": "Be personally present in a liberated " + terrain + " tile",
			"condition_type": "commander_present_in_tile",
			"condition_value": terrain,
			"obj_index": 2,
		}
	return {"label": "Unknown objective", "condition_type": "none", "obj_index": num - 1}


func _build_protector_prayers(protector_id: String) -> Array:
	match protector_id:
		"PROT_01":  # Mothman
			return [
				{"label": "Liberate Harper's Ferry (tile 46) or any WV Foothills tile",
				 "prayer_type": "liberate_terrain",
				 "terrain": "Foothills", "count": 1},
				{"label": "Hold 2 Appalachian tiles simultaneously",
				 "prayer_type": "hold_region",
				 "state_code": "WV", "min_tiles": 2},
				{"label": "Liberate a tile with the Appalachian Minerals special feature",
				 "prayer_type": "liberate_tile",
				 "tile_id": 46},
			]
		"PROT_12":  # Liberty Bell
			return [
				{"label": "Liberate Philadelphia (tile 2)",
				 "prayer_type": "liberate_tile",
				 "tile_id": 2},
				{"label": "Hold Philadelphia for 5 turns",
				 "prayer_type": "hold_region",
				 "state_code": "PA", "min_tiles": 3},
				{"label": "Liberate Valley Forge AND Philadelphia simultaneously",
				 "prayer_type": "liberate_tile",
				 "tile_id": 2},
			]
		"PROT_17":  # Lincoln's Ghost
			return [
				{"label": "Liberate Washington DC (tile 188)",
				 "prayer_type": "liberate_tile",
				 "tile_id": 188},
				{"label": "Hold DC for 3 turns",
				 "prayer_type": "hold_region",
				 "state_code": "DC", "min_tiles": 1},
				{"label": "Liberate both DC and Baltimore (tile 37)",
				 "prayer_type": "liberate_tile",
				 "tile_id": 37},
			]
		_:
			return [
				{"label": "Condition 1", "prayer_type": "none"},
				{"label": "Condition 2", "prayer_type": "none"},
				{"label": "Condition 3", "prayer_type": "none"},
			]


func _get_soma_memo(protector_id: String) -> String:
	match protector_id:
		"PROT_01":
			return "RE: Asset Acquisition Request — Mothman (PROT_01)\nStatus: In Progress\nBudget: Approved\nWeirdness Level: Elevated\nNote: Asset has been attempting contact for decades. Recommend receptive posture."
		"PROT_12":
			return "RE: Asset Reactivation — Liberty Bell (PROT_12)\nStatus: In Progress\nNote: Asset has expressed willingness to assist. Asset is self-conscious about the crack. Please do not mention the crack unless the asset brings it up first."
		"PROT_08":
			return "RE: Asset Reactivation — Old Ironsides (PROT_08)\nStatus: OBSERVING\nClassification: NAUTICAL / SUPERNATURAL\nNote: Asset has been conducting unauthorized coastal patrols since 1812. Asset does not appear to require fuel. Asset does not appear to require crew. DMA field investigation recommended before formal contact. Suggest complimentary remarks about hull integrity. Do NOT mention the British."
		"PROT_17":
			return "RE: Consultation Request — Lincoln's Ghost (PROT_17)\nStatus: OBSERVING\nClassification: SUPERNATURAL / HISTORICAL\nNote: Asset has been on-site since 1865. Asset will not require briefing. Asset has opinions about the memos. Most of them are correct. DMA recommends formal contact once a level 6 Courthouse is operational in Washington DC."
		_:
			return "RE: Asset Acquisition Request — [CLASSIFIED]\nStatus: Pending\nNote: See attached procurement forms. There are many forms."


func _get_archetype_for_governor(gov: governor) -> Dictionary:
	# Procedurally generated commanders store their archetype ID directly
	if gov.governorArchetypeId != "":
		return _arc_id_to_dict(gov.governorArchetypeId)
	# Named historic governors matched by governorType display name
	match gov.governorType:
		"War Widow":        return _arc_id_to_dict("ARC_09")
		"Wetlands Fisher":  return _arc_id_to_dict("ARC_01")
		"Hawaiian Refugee": return _arc_id_to_dict("ARC_20")
	return {}


func _arc_id_to_dict(arc_id: String) -> Dictionary:
	match arc_id:
		"ARC_01": return {"archetype_id": "ARC_01", "archetype_name": "The Wetlands Fisher"}
		"ARC_02": return {"archetype_id": "ARC_02", "archetype_name": "The Appalachian Miner"}
		"ARC_03": return {"archetype_id": "ARC_03", "archetype_name": "The Ivy League Dropout"}
		"ARC_04": return {"archetype_id": "ARC_04", "archetype_name": "The Seminole Fighter"}
		"ARC_05": return {"archetype_id": "ARC_05", "archetype_name": "The Green Mountain Farmer"}
		"ARC_06": return {"archetype_id": "ARC_06", "archetype_name": "The Chesapeake Shipwright"}
		"ARC_07": return {"archetype_id": "ARC_07", "archetype_name": "The Loyalist Turncoat"}
		"ARC_08": return {"archetype_id": "ARC_08", "archetype_name": "The Tobacco Belt Drifter"}
		"ARC_09": return {"archetype_id": "ARC_09", "archetype_name": "The War Widow"}
		"ARC_10": return {"archetype_id": "ARC_10", "archetype_name": "The Indigenous Scout"}
		"ARC_11": return {"archetype_id": "ARC_11", "archetype_name": "The Boston Rabble-Rouser"}
		"ARC_12": return {"archetype_id": "ARC_12", "archetype_name": "The Continental Surgeon"}
		"ARC_13": return {"archetype_id": "ARC_13", "archetype_name": "The Nantucket Sailor"}
		"ARC_14": return {"archetype_id": "ARC_14", "archetype_name": "The Frontier Preacher"}
		"ARC_15": return {"archetype_id": "ARC_15", "archetype_name": "The DC Bureaucrat"}
		"ARC_16": return {"archetype_id": "ARC_16", "archetype_name": "The Rust Belt Steelworker"}
		"ARC_17": return {"archetype_id": "ARC_17", "archetype_name": "The Plantation Deserter"}
		"ARC_18": return {"archetype_id": "ARC_18", "archetype_name": "The Swamp Witch"}
		"ARC_19": return {"archetype_id": "ARC_19", "archetype_name": "The Caribbean Privateer"}
		"ARC_20": return {"archetype_id": "ARC_20", "archetype_name": "The Hawaiian Refugee"}
		"ARC_21": return {"archetype_id": "ARC_21", "archetype_name": "The Border Mercenary"}
		"ARC_22": return {"archetype_id": "ARC_22", "archetype_name": "The Acadian Forest Ranger"}
		"ARC_23": return {"archetype_id": "ARC_23", "archetype_name": "The Gettysburg Descendant"}
		"ARC_24": return {"archetype_id": "ARC_24", "archetype_name": "The LGBTQ+ Organizer"}
		"ARC_25": return {"archetype_id": "ARC_25", "archetype_name": "The Carnival Barker"}
	return {}


func _find_held_terrain_tile(terrain: String):
	for tile in playerCountryNode.OwnedTileList:
		if tile.terrain == terrain:
			return tile
	return null


# ============================================================
# SIGNAL HANDLERS
# ============================================================

func _on_commander_objective_completed(arc_id: String, obj_num: int) -> void:
	pass


func _on_protector_devotion_completed(protector_id: String) -> void:
	var gov_name: String = PROTECTOR_GOVERNOR_UNLOCKS.get(protector_id, "")
	if gov_name == "" or playerCountryNode == null:
		return
	for existing in playerCountryNode.unlockedGovernors:
		if existing.governorType == gov_name:
			return
	var new_gov = governor.new()
	new_gov.buildSelf(gov_name, 1)
	playerCountryNode.unlockedGovernors.append(new_gov)


func _on_protector_summon_requested(protector_id: String) -> void:
	# The Presidential Order: delivers the spirit's first-contact scene.
	for arc in activeProtectorArcs:
		if arc.get("protector_id", "") == protector_id:
			emit_signal("requestEventFire", protector_id + "_SUMMON", arc.get("origin_tile", null))
			return


# Spirits whose first contact this panel fires by itself (world.gd skips them in its
# turn-scheduled summons so the scene cannot arrive twice).
func owns_contact(protector_id: String) -> bool:
	for arc in activeProtectorArcs:
		if arc.get("protector_id", "") == protector_id:
			return arc["stages"][0]["fire"] == "auto"
	return false


func _on_close_button_pressed() -> void:
	self.visible = false
