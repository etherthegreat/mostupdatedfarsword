extends Node

var events: Dictionary = {}
var buttons: Dictionary = {}
var triggers: Array = []
var loaded: bool = false


func _ready() -> void:
	load_events("res://data/events.csv")
	load_buttons("res://data/event_buttons.csv")
	load_triggers("res://data/event_triggers.csv")
	loaded = true
		  buttons.size(), " buttons, ", triggers.size(), " triggers.")


func load_events(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("EventDatabase: Cannot open " + path)
		return
	var headers = file.get_csv_line()
	while not file.eof_reached():
		var row = file.get_csv_line()
		if row.size() < 2:
			continue
		var entry = {}
		for i in range(min(headers.size(), row.size())):
			entry[headers[i].strip_edges()] = row[i].strip_edges()
		entry["repeatable"]     = entry.get("repeatable", "false") == "true"
		entry["cooldown_turns"] = entry.get("cooldown_turns", "0").to_int()
		entry["_fire_count"]    = 0
		entry["_last_fired"]    = -999
		events[entry["event_id"]] = entry
	file.close()


func load_buttons(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("EventDatabase: Cannot open " + path)
		return
	var headers = file.get_csv_line()
	while not file.eof_reached():
		var row = file.get_csv_line()
		if row.size() < 2:
			continue
		var entry = {}
		for i in range(min(headers.size(), row.size())):
			entry[headers[i].strip_edges()] = row[i].strip_edges()
		entry["outcome_amount"] = entry.get("outcome_amount", "0").to_int()
		entry["loyalty_change"] = entry.get("loyalty_change", "0").to_int()
		buttons[entry["button_id"]] = entry
		# Index buttons under their event for fast lookup
		var eid = entry.get("event_id", "")
		if eid != "":
			if not events.has(eid):
				events[eid] = {}
			if not events[eid].has("_buttons"):
				events[eid]["_buttons"] = []
			events[eid]["_buttons"].append(entry["button_id"])
	file.close()


func load_triggers(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("EventDatabase: Cannot open " + path)
		return
	var headers = file.get_csv_line()
	while not file.eof_reached():
		var row = file.get_csv_line()
		if row.size() < 2:
			continue
		var entry = {}
		for i in range(min(headers.size(), row.size())):
			entry[headers[i].strip_edges()] = row[i].strip_edges()
		entry["priority"]          = entry.get("priority", "5").to_int()
		entry["min_liberty_score"] = entry.get("min_liberty_score", "0").to_int()
		entry["min_corruption"]    = entry.get("min_corruption", "0").to_int()
		entry["turn_min"]          = entry.get("turn_min", "0").to_int()
		entry["turn_max"]          = entry.get("turn_max", "9999").to_int()
		entry["tile_id"]           = entry.get("tile_id", "0").to_int()
		triggers.append(entry)
	file.close()
	triggers.sort_custom(func(a, b): return a["priority"] < b["priority"])


# ── GETTERS ──────────────────────────────────────────────────

func get_event(event_id: String) -> Dictionary:
	return events.get(event_id, {})

func get_buttons_for_event(event_id: String) -> Array:
	var button_ids = events.get(event_id, {}).get("_buttons", [])
	var result = []
	for bid in button_ids:
		if buttons.has(bid):
			result.append(buttons[bid])
	return result

func get_button(button_id: String) -> Dictionary:
	return buttons.get(button_id, {})

func get_triggers_for_type(trigger_type: String) -> Array:
	return triggers.filter(func(t): return t["trigger_type"] == trigger_type)

func event_can_fire(event_id: String, current_turn: int) -> bool:
	var ev = get_event(event_id)
	if ev.is_empty():
		return false
	if ev["_fire_count"] > 0 and not ev["repeatable"]:
		return false
	var cooldown = ev.get("cooldown_turns", 0)
	if cooldown > 0 and current_turn - ev["_last_fired"] < cooldown:
		return false
	return true

func mark_event_fired(event_id: String, current_turn: int) -> void:
	if events.has(event_id):
		events[event_id]["_fire_count"] += 1
		events[event_id]["_last_fired"] = current_turn


# ── TRIGGER EVALUATION ───────────────────────────────────────

func evaluate_tile_triggers(tile, current_turn: int) -> Array:
	var to_fire = []
	for trigger in triggers:
		if trigger["trigger_type"] not in ["tile_liberated", "tile_lost",
			"revolutionary_hotbed", "occupied_territory", "tile_feature"]:
			continue
		var event_id = trigger["event_id"]
		if not event_can_fire(event_id, current_turn):
			continue
		var tile_id_req = trigger.get("tile_id", 0)
		if tile_id_req > 0 and tile.tileNumber != tile_id_req:
			continue
		var feature_req = trigger.get("tile_feature_required", "")
		if feature_req != "" and not tile.has_special_feature(feature_req):
			continue
		var owner_req = trigger.get("tile_owner", "")
		if owner_req != "" and tile.tileOwner != owner_req:
			continue
		to_fire.append(event_id)
	return to_fire


func evaluate_date_triggers(current_turn: int, month: int) -> Array:
	var to_fire = []
	for trigger in triggers:
		if trigger["trigger_type"] not in ["game_start", "annual_date",
			"turn_range", "winter_onset"]:
			continue
		var event_id = trigger["event_id"]
		if not event_can_fire(event_id, current_turn):
			continue
		match trigger["trigger_type"]:
			"game_start":
				if current_turn == 1:
					to_fire.append(event_id)
			"annual_date":
				var req_month = trigger.get("trigger_condition", "0").to_int()
				if req_month > 0 and month == req_month:
					to_fire.append(event_id)
			"winter_onset":
				if month == 11 or month == 12:
					to_fire.append(event_id)
	return to_fire


func evaluate_state_triggers(state_code: String, current_turn: int) -> Array:
	var to_fire = []
	for trigger in triggers:
		if trigger["trigger_type"] != "state_liberated":
			continue
		if trigger.get("state_code", "") != state_code:
			continue
		var event_id = trigger["event_id"]
		if event_can_fire(event_id, current_turn):
			to_fire.append(event_id)
	return to_fire


func evaluate_commander_triggers(archetype_id: String,
		objective_num: int, current_turn: int) -> Array:
	var to_fire = []
	for trigger in triggers:
		if trigger["trigger_type"] != "commander_objective":
			continue
		if trigger.get("commander_archetype", "") != archetype_id:
			continue
		if trigger.get("trigger_condition", "1").to_int() != objective_num:
			continue
		var event_id = trigger["event_id"]
		if event_can_fire(event_id, current_turn):
			to_fire.append(event_id)
	return to_fire


func evaluate_protector_triggers(protector_id: String,
		trigger_type: String, current_turn: int) -> Array:
	var to_fire = []
	for trigger in triggers:
		if trigger["trigger_type"] != trigger_type:
			continue
		if trigger.get("protector_id", "") != protector_id:
			continue
		var event_id = trigger["event_id"]
		if event_can_fire(event_id, current_turn):
			to_fire.append(event_id)
	return to_fire
