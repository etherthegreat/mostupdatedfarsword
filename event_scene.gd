extends Control

var event_id: String
var event_type: String
var event_country: String
var target_tile: Tile
var event_data: Dictionary
var button_data: Array = []

signal eventButtonPressed
signal tileEventButtonPressed


func build_from_csv(eid: String, tile = null) -> void:
	event_id    = eid
	target_tile = tile
	event_data  = EventDatabase.get_event(eid)
	button_data = EventDatabase.get_buttons_for_event(eid)

	if event_data.is_empty():
		push_warning("eventScene: No event data found for ID: " + eid)
		queue_free()
		return

	# ── Console preview (always prints so you can see what fired) ──
	print("=== EVENT FIRED: " + eid + " ===")
	print("HEADLINE:   " + event_data.get("headline",   ""))
	print("SHORT DESC: " + event_data.get("short_desc", ""))
	print("LONG DESC:  " + event_data.get("long_desc",  ""))
	print("================================")

	event_type    = event_data.get("event_type", "standard")
	event_country = event_data.get("country_cid", "GEN")

	var content_flag = event_data.get("content_flag", "")
	if content_flag != "" and not _player_allows_content(content_flag):
		queue_free()
		return

	$EventPanel/EventNameLabel.text             = event_data.get("headline", "")
	$EventPanel/EventShortDescriptionLabel.text = event_data.get("short_desc", "")
	$EventPanel/EventLongDescriptionLabel.text  = event_data.get("long_desc", "")

	_build_buttons()


func _build_buttons() -> void:
	for child in $EventPanel/eventButtons.get_children():
		child.queue_free()

	for btn_data in button_data:
		var prereq = btn_data.get("prerequisite_flag", "")
		if prereq != "" and not _check_prerequisite(prereq):
			continue

		var newButton = Button.new()
		newButton.text = btn_data.get("button_text", "Choose")
		newButton.name = btn_data.get("button_id", "btn")
		newButton.set_meta("button_id",      btn_data.get("button_id", ""))
		newButton.set_meta("outcome_type",   btn_data.get("outcome_type", ""))
		newButton.set_meta("outcome_value",  btn_data.get("outcome_value", ""))
		newButton.set_meta("outcome_amount", btn_data.get("outcome_amount", 0))
		newButton.set_meta("next_event_id",  btn_data.get("next_event_id", ""))
		newButton.pressed.connect(_on_button_pressed.bind(newButton))
		$EventPanel/eventButtons.add_child(newButton)


func _on_button_pressed(btn: Button) -> void:
	var button_id     = btn.get_meta("button_id")
	var outcome_type  = btn.get_meta("outcome_type")
	var outcome_value = btn.get_meta("outcome_value")
	var outcome_amount = btn.get_meta("outcome_amount")

	if target_tile != null:
		emit_signal("tileEventButtonPressed",
			button_id, event_id, event_country,
			outcome_type, outcome_value, outcome_amount, target_tile)
	else:
		emit_signal("eventButtonPressed",
			button_id, event_id, event_country,
			outcome_type, outcome_value, outcome_amount)
	queue_free()


func _player_allows_content(flag: String) -> bool:
	match flag:
		"kinky_lewd": return Settings.content_kinky_lewd
		"explicit":   return Settings.content_explicit
	return true


func _check_prerequisite(prereq: String) -> bool:
	# TODO: expand as flag system grows
	return true


# ── LEGACY WRAPPERS ──────────────────────────────────────────
# Keep old-style callers working during transition

func buildSelf(eventType: String, eventID: String,
		eventCountry: String, _language: String) -> void:
	build_from_csv(eventID)

func buildTileEventSelf(eventType: String, eventID: String,
		eventCountry: String, tile: Tile, _language: String) -> void:
	build_from_csv(eventID, tile)
