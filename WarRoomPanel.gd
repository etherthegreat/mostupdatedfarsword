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

var playerCountryNode: country
var activeCommanderArcs: Array = []
var activeProtectorArcs: Array = []

var commanderArcEntryScene = preload("res://CommanderArcEntry.tscn")
var protectorArcEntryScene = preload("res://CommanderArcEntry.tscn")

signal arcObjectiveCompleted(arc_id, objective_num)
signal arcFullyCompleted(arc_id)
signal requestEventFire(event_id, tile)


func buildSelf(playerNode: country) -> void:
	playerCountryNode = playerNode
	_populate_commander_tab()
	_populate_presidential_tab()


func _populate_commander_tab() -> void:
	if $PanelBackground/TabContainer/COMMANDERS/ScrollContainer/CommanderVBox.get_children() != null:
		for child in $PanelBackground/TabContainer/COMMANDERS/ScrollContainer/CommanderVBox.get_children():
			child.queue_free()

	for arcData in activeCommanderArcs:
		var entry = commanderArcEntryScene.instantiate()
		entry.buildSelf(arcData, playerCountryNode)
		entry.objectiveCompleted.connect(_on_commander_objective_completed)
		$PanelBackground/TabContainer/COMMANDERS/ScrollContainer/CommanderVBox.add_child(entry)

	if activeCommanderArcs.is_empty():
		var placeholder = Label.new()
		placeholder.text = "No commanders currently assigned.\nAssign a governor to a tile to begin their arc."
		placeholder.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		$PanelBackground/TabContainer/COMMANDERS/ScrollContainer/CommanderVBox.add_child(placeholder)


func _populate_presidential_tab() -> void:
	for child in $"PanelBackground/TabContainer/DEPTARTMENT OF MYTHOLOGICAL  AFFAIRS/ScrollContainer/PresidentialVBox".get_children():
		child.queue_free()

	var somaHeader = Label.new()
	somaHeader.text = "DEPARTMENT OF MYTHOLOGICAL AFFAIRS\nSecretary: [POSITION FILLED, NAME CLASSIFIED]\nBudget: Approved (Unusual Line Items Expected)\n─────────────────────────────────────"
	somaHeader.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	$"PanelBackground/TabContainer/DEPTARTMENT OF MYTHOLOGICAL  AFFAIRS/ScrollContainer/PresidentialVBox".add_child(somaHeader)

	for arcData in activeProtectorArcs:
		var entry = protectorArcEntryScene.instantiate()
		entry.buildSelf(arcData, playerCountryNode)
		entry.devotionCompleted.connect(_on_protector_devotion_completed)
		$"PanelBackground/TabContainer/DEPTARTMENT OF MYTHOLOGICAL  AFFAIRS/ScrollContainer/PresidentialVBox".add_child(entry)

	if activeProtectorArcs.is_empty():
		var placeholder = Label.new()
		placeholder.text = "RE: Asset Acquisition\nStatus: No active acquisition requests.\nNote: The Secretary is available for consultation."
		placeholder.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		$"PanelBackground/TabContainer/DEPTARTMENT OF MYTHOLOGICAL  AFFAIRS/ScrollContainer/PresidentialVBox".add_child(placeholder)


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
	var arcData = {
		"governor": gov,
		"archetype_id": archetype.get("archetype_id", ""),
		"archetype_name": archetype.get("archetype_name", ""),
		"home_tile": assignedTile,
		"objectives": _build_commander_objectives(archetype),
		"objectives_complete": [false, false, false],
		"arc_active": true,
		"arc_complete": false,
		"arc_start_turn": 0,
	}
	activeCommanderArcs.append(arcData)
	_populate_commander_tab()


func registerProtectorArc(protector_id: String) -> void:
	for existing in activeProtectorArcs:
		if existing["protector_id"] == protector_id:
			return
	var eventData = EventDatabase.get_event("PROT_" + protector_id + "_SUMMON")
	if eventData.is_empty():
		return
	var protectorData = {
		"protector_id": protector_id,
		"protector_name": eventData.get("headline", protector_id),
		"prayers": _build_protector_prayers(protector_id),
		"prayers_complete": [false, false, false],
		"devotion_level": 0,
		"arc_complete": false,
		"soma_memo": _get_soma_memo(protector_id),
	}
	activeProtectorArcs.append(protectorData)
	_populate_presidential_tab()


# ============================================================
# OBJECTIVE CHECKING — called from world.gd _on_next_turn_pressed()
# ============================================================

func checkObjectives(allTiles: Array, currentTurn: int) -> void:
	_check_commander_objectives(allTiles, currentTurn)
	_check_protector_prayers(allTiles, currentTurn)
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


func _check_protector_prayers(allTiles: Array, currentTurn: int) -> void:
	for arcData in activeProtectorArcs:
		if arcData["arc_complete"]:
			continue
		for i in range(3):
			if arcData["prayers_complete"][i]:
				continue
			var prayer = arcData["prayers"][i]
			var fulfilled = _evaluate_protector_prayer(prayer, allTiles, currentTurn)
			if fulfilled:
				arcData["prayers_complete"][i] = true
				arcData["devotion_level"] = min(100, arcData["devotion_level"] + 33)
		if arcData["prayers_complete"].all(func(b): return b):
			arcData["arc_complete"] = true
			emit_signal("requestEventFire",
				"PROT_" + arcData["protector_id"] + "_SUMMON", null)


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

		_:
			return false


func _evaluate_protector_prayer(prayer: Dictionary,
		_allTiles: Array, _currentTurn: int) -> bool:
	match prayer.get("prayer_type", ""):

		"liberate_tile":
			var tile_num = prayer.get("tile_id", 0)
			for tile in playerCountryNode.OwnedTileList:
				if tile.tileNumber == tile_num:
					return true
			return false

		"liberate_terrain":
			var terrain = prayer.get("terrain", "")
			var count_required = prayer.get("count", 1)
			var count = 0
			for tile in playerCountryNode.OwnedTileList:
				if tile.terrain == terrain:
					count += 1
			return count >= count_required

		"hold_region":
			var state = prayer.get("state_code", "")
			var min_tiles = prayer.get("min_tiles", 3)
			var count = 0
			for tile in playerCountryNode.OwnedTileList:
				if tile.tileContinent.begins_with(state):
					count += 1
			return count >= min_tiles

		"player_in_tile":
			# TODO: wire to a presidential movement tracker
			return false

		_:
			return false


# ============================================================
# DATA BUILDERS
# ============================================================

func _build_commander_objectives(archetype: Dictionary) -> Array:
	var arc_id = archetype.get("archetype_id", "")
	return [
		_get_commander_objective(arc_id, 1),
		_get_commander_objective(arc_id, 2),
		_get_commander_objective(arc_id, 3),
	]


func _get_commander_objective(arc_id: String, num: int) -> Dictionary:
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

		"ARC_09":  # War Widow
			match num:
				1: return {
					"label": "Liberate any major city tile (Metro terrain)",
					"condition_type": "liberate_tile_terrain",
					"condition_value": "Metro",
					"condition_state": "",
					"obj_index": 0,
				}
				2: return {
					"label": "Survive 8 turns without retreating",
					"condition_type": "turns_survived",
					"condition_value": "8",
					"obj_index": 1,
				}
				3: return {
					"label": "Hold the liberated city for 5 turns",
					"condition_type": "hold_tile_turns",
					"condition_value": "5",
					"terrain": "Metro",
					"obj_index": 2,
				}

		"ARC_20":  # Hawaiian Refugee
			match num:
				1: return {
					"label": "Liberate any 3 tiles (any terrain, any region)",
					"condition_type": "liberate_tile_count",
					"condition_value": "3",
					"obj_index": 0,
				}
				2: return {
					"label": "Liberate a tile with a Monument building",
					"condition_type": "liberate_tile_with_feature",
					"condition_value": "monument",
					"obj_index": 1,
				}
				3: return {
					"label": "Designate a home tile (assign commander to any liberated tile)",
					"condition_type": "commander_present_in_tile",
					"condition_value": "",
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
		"PROT_17":
			return "RE: Consultation Request — Lincoln's Ghost (PROT_17)\nStatus: PENDING DC LIBERATION\nNote: Asset has been on-site since 1865. Asset will not require briefing. Asset has opinions about the memos. Most of them are correct."
		_:
			return "RE: Asset Acquisition Request — [CLASSIFIED]\nStatus: Pending\nNote: See attached procurement forms. There are many forms."


func _get_archetype_for_governor(gov: governor) -> Dictionary:
	match gov.governorType:
		"War Widow":        return {"archetype_id": "ARC_09", "archetype_name": "The War Widow"}
		"Wetlands Fisher":  return {"archetype_id": "ARC_01", "archetype_name": "The Wetlands Fisher"}
		"Hawaiian Refugee": return {"archetype_id": "ARC_20", "archetype_name": "The Hawaiian Refugee"}
		# TODO: add more archetypes as procedural commanders are added
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
	print("Commander arc ", arc_id, " objective ", obj_num, " complete!")


func _on_protector_devotion_completed(protector_id: String) -> void:
	print("Protector ", protector_id, " prayers fulfilled!")


func _on_close_button_pressed() -> void:
	self.visible = false
