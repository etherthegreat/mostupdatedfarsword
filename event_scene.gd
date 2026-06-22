extends Control

var event_id: String
var event_type: String
var event_country: String
var target_tile: Tile
var event_data: Dictionary
var button_data: Array = []
var player_country = null   # set by createNewEvent so prerequisites can check CountryFlags

# Holds button metadata while scene navigation UI is open
var _pending: Dictionary = {}

# Signals carry next_event_id so scene nav can override it per choice
signal eventButtonPressed(button_id, event_id, event_country, outcome_type, outcome_value, outcome_amount, next_event_id)
signal tileEventButtonPressed(button_id, event_id, event_country, outcome_type, outcome_value, outcome_amount, next_event_id, tile)


func build_from_data(data: Dictionary, tile = null, player = null) -> void:
	target_tile    = tile
	player_country = player
	event_id       = data.get("event_id", "DYNAMIC")
	event_type     = data.get("event_type", "standard")
	event_country  = data.get("country_cid", "GEN")
	event_data     = data
	# Use inline buttons if supplied; otherwise fall back to CSV lookup by event_id
	if data.has("buttons"):
		button_data = data["buttons"]
	else:
		button_data = EventDatabase.get_buttons_for_event(event_id)

	$EventPanel/EventNameLabel.text             = _substitute(data.get("headline",   ""))
	$EventPanel/EventShortDescriptionLabel.text = _substitute(data.get("short_desc", ""))
	$EventPanel/EventLongDescriptionLabel.text  = _substitute(data.get("long_desc",  ""))

	_build_buttons()


func build_from_csv(eid: String, tile = null, player = null) -> void:
	event_id       = eid
	target_tile    = tile
	player_country = player
	event_data  = EventDatabase.get_event(eid)
	button_data = EventDatabase.get_buttons_for_event(eid)

	if event_data.is_empty():
		push_warning("eventScene: No event data found for ID: " + eid)
		queue_free()
		return

	# ── Console preview ────────────────────────────────────────────────────────
	print("=== EVENT FIRED: " + eid + " ===")
	print("HEADLINE:   " + event_data.get("headline",   ""))
	print("SHORT DESC: " + event_data.get("short_desc", ""))
	print("LONG DESC:  " + event_data.get("long_desc",  ""))
	print("================================")

	event_type    = event_data.get("event_type", "standard")
	event_country = event_data.get("country_cid", "GEN")

	$EventPanel/EventNameLabel.text             = _substitute(event_data.get("headline", ""))
	$EventPanel/EventShortDescriptionLabel.text = _substitute(event_data.get("short_desc", ""))
	$EventPanel/EventLongDescriptionLabel.text  = _substitute(event_data.get("long_desc", ""))

	_build_buttons()


func _build_buttons() -> void:
	var btn_container = get_node_or_null("EventPanel/eventButtons")
	if btn_container == null:
		push_error("event_scene: eventButtons node not found!")
		return
	for child in btn_container.get_children():
		child.queue_free()

	print("event_scene._build_buttons: ", button_data.size(), " buttons for event '", event_id, "'")
	var s = get_node_or_null("/root/Settings")
	for btn_data in button_data:
		var prereq = btn_data.get("prerequisite_flag", "")
		if prereq != "" and not _check_prerequisite(prereq):
			continue

		var btype: String = btn_data.get("button_type", "standard")
		if btype == "explicit"    and (s == null or not s.content_explicit):
			continue
		if btype == "kinky_lewd"  and (s == null or not s.content_kinky_lewd):
			continue
		if btype == "sensual"     and (s == null or not s.content_sensual):
			continue

		var newButton = Button.new()
		newButton.text = btn_data.get("button_text", "Choose")
		newButton.name = btn_data.get("button_id", "btn")
		newButton.set_meta("button_id",      btn_data.get("button_id", ""))
		newButton.set_meta("button_type",    btn_data.get("button_type", "standard"))
		newButton.set_meta("outcome_type",   btn_data.get("outcome_type", ""))
		newButton.set_meta("outcome_value",  btn_data.get("outcome_value", ""))
		newButton.set_meta("outcome_amount", btn_data.get("outcome_amount", 0))
		newButton.set_meta("next_event_id",  btn_data.get("next_event_id", ""))
		newButton.pressed.connect(_on_button_pressed.bind(newButton))
		btn_container.add_child(newButton)
		print("event_scene: added button '", newButton.text, "' to container")


func _on_button_pressed(btn: Button) -> void:
	_pending = {
		"button_id":      btn.get_meta("button_id"),
		"button_type":    btn.get_meta("button_type", "standard"),
		"outcome_type":   btn.get_meta("outcome_type"),
		"outcome_value":  btn.get_meta("outcome_value"),
		"outcome_amount": btn.get_meta("outcome_amount"),
		"next_event_id":  btn.get_meta("next_event_id"),
	}
	var btype: String = _pending["button_type"]
	if btype in ["explicit", "kinky_lewd", "sensual"]:
		_show_scene_nav()
	else:
		_emit_resolved(_pending["next_event_id"])


func _show_scene_nav() -> void:
	var nav: Control = load("res://scene_navigation.gd").new()
	var s = get_node_or_null("/root/Settings")
	nav.streaming_mode = s != null and s.streaming_mode
	nav.scene_choice_made.connect(_on_scene_choice)
	add_child(nav)


func _on_scene_choice(choice: String) -> void:
	var next_id: String = _pending.get("next_event_id", "")
	match choice:
		"intimate":
			var iid := event_id + "_INTIMATE"
			next_id = iid if not EventDatabase.get_event(iid).is_empty() else ""
		"skip":
			next_id = ""
		# "full": keep original next_event_id unchanged

	if get_node_or_null("/root/LibraryData") != null:
		LibraryData.record_scene(event_id, choice, 0)

	_emit_resolved(next_id)


func _emit_resolved(next_id: String) -> void:
	if target_tile != null:
		tileEventButtonPressed.emit(
			_pending["button_id"], event_id, event_country,
			_pending["outcome_type"], _pending["outcome_value"],
			_pending["outcome_amount"], next_id, target_tile)
	else:
		eventButtonPressed.emit(
			_pending["button_id"], event_id, event_country,
			_pending["outcome_type"], _pending["outcome_value"],
			_pending["outcome_amount"], next_id)
	queue_free()


func _check_prerequisite(prereq: String) -> bool:
	if player_country == null:
		return true
	if prereq.begins_with("!"):
		return not player_country.CountryFlags.has(prereq.substr(1))
	return player_country.CountryFlags.has(prereq)


func _substitute(text: String) -> String:
	if target_tile != null:
		var tile_name: String = target_tile.tileName if target_tile.tileName else "the Fort"
		text = text.replace("[TILE_NAME]", tile_name)
		var cmd_name: String = "the Commander"
		if target_tile.tileGovernor != null:
			cmd_name = target_tile.tileGovernor.governorType
		text = text.replace("[COMMANDER_NAME]", cmd_name)
		# [GOVERNOR_TITLE]: General at lvl 3; Governor if courthouse present; else Commander
		var gov_title: String = "Commander"
		if target_tile.tileGovernor != null:
			if target_tile.tileGovernor.governorLevel >= 3:
				gov_title = "General"
			else:
				for b in target_tile.tileBuildingsList:
					if b.buildingType == "Courthouse" and b.enabled:
						gov_title = "Governor"
						break
		text = text.replace("[GOVERNOR_TITLE]", gov_title)
		# Pronoun tokens — fall back to they/them/their/themselves if no pronouns set
		var p: Dictionary = {}
		if target_tile.tileGovernor != null:
			p = target_tile.tileGovernor.pronouns
		text = text.replace("[CMD_SUBJECT]",    p.get("subject",    "they"))
		text = text.replace("[CMD_OBJECT]",     p.get("object",     "them"))
		text = text.replace("[CMD_POSSESSIVE]", p.get("possessive", "their"))
		text = text.replace("[CMD_REFLEXIVE]",  p.get("reflexive",  "themselves"))
	# Safety sweep: replace any tokens that survived (tile was null, governor missing, etc.)
	text = text.replace("[TILE_NAME]",      "the front")
	text = text.replace("[COMMANDER_NAME]", "the Commander")
	text = text.replace("[GOVERNOR_TITLE]", "Commander")
	text = text.replace("[CMD_SUBJECT]",    "they")
	text = text.replace("[CMD_OBJECT]",     "them")
	text = text.replace("[CMD_POSSESSIVE]", "their")
	text = text.replace("[CMD_REFLEXIVE]",  "themselves")
	return text


# ── LEGACY WRAPPERS ──────────────────────────────────────────────────────────
# Keep old-style callers working during transition

func buildSelf(eventType: String, eventID: String,
		eventCountry: String, _language: String) -> void:
	build_from_csv(eventID)

func buildTileEventSelf(eventType: String, eventID: String,
		eventCountry: String, tile: Tile, _language: String) -> void:
	build_from_csv(eventID, tile)
