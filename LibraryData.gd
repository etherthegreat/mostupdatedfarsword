extends Node
## LibraryData — global autoload.
## Persists gallery unlocks, journal entries, Records discoveries,
## and all settings across playthroughs.
## Register in Project → AutoLoad as "LibraryData".

const SAVE_PATH := "user://library_data.json"

# ── runtime state ─────────────────────────────────────────────────────────────
var gallery_unlocked:       Array[String] = []   # event_ids with art
var journal_entries:        Array          = []   # Array[Dictionary]
var records_discovered:     Array[String] = []   # entry ids for ? entries

var settings: Dictionary = {
	"language":            "eng",
	"master_volume":       80,
	"music_volume":        70,
	"sfx_volume":          90,
	"ambient_volume":      60,
	"fullscreen":          true,
	"resolution":          "1920x1080",
	"ui_scale":            100,
	"autosave_frequency":  1,
	"tutorial_tooltips":   true,
	"notification_speed":  "normal",
	"text_size":           "medium",
	"colorblind_mode":     "off",
	"high_contrast":       false,
	"content_sensual":     false,
	"content_explicit":    false,
	"content_kinky":       false,
}

# ── lifecycle ─────────────────────────────────────────────────────────────────
func _ready() -> void:
	load_data()

# ── gallery ───────────────────────────────────────────────────────────────────
func unlock_gallery(event_id: String) -> void:
	if event_id in gallery_unlocked:
		return
	gallery_unlocked.append(event_id)
	save_data()

func is_gallery_unlocked(event_id: String) -> bool:
	return event_id in gallery_unlocked

# ── journal ───────────────────────────────────────────────────────────────────
func add_journal_entry(id: String, turn: int, title: String, body: String,
		classification: String = "DECLASSIFIED") -> void:
	for e in journal_entries:
		if e["id"] == id:
			return   # already recorded
	journal_entries.append({
		"id":             id,
		"turn":           turn,
		"title":          title,
		"body":           body,
		"classification": classification,
	})
	# Keep newest-first order
	journal_entries.sort_custom(func(a, b): return a["turn"] > b["turn"])
	save_data()

# ── records discovery ─────────────────────────────────────────────────────────
func discover_entry(entry_id: String) -> void:
	if entry_id in records_discovered:
		return
	records_discovered.append(entry_id)
	save_data()

func is_discovered(entry_id: String) -> bool:
	return entry_id in records_discovered

# ── settings ──────────────────────────────────────────────────────────────────
func get_setting(key: String, default = null):
	return settings.get(key, default)

func set_setting(key: String, value) -> void:
	settings[key] = value
	save_data()
	_apply_settings()

func _apply_settings() -> void:
	# Fullscreen
	if settings.get("fullscreen", true):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	# Sync with existing Settings autoload if present
	if Engine.has_singleton("Settings") or get_node_or_null("/root/Settings") != null:
		var s = get_node("/root/Settings")
		s.content_sensual    = settings.get("content_sensual",  false)
		s.content_explicit   = settings.get("content_explicit", false)
		s.content_kinky_lewd = settings.get("content_kinky",    false)

# ── reset ─────────────────────────────────────────────────────────────────────
func reset_library_data() -> void:
	gallery_unlocked.clear()
	journal_entries.clear()
	records_discovered.clear()
	# Keep settings — only reset the library content
	save_data()

func reset_all() -> void:
	gallery_unlocked.clear()
	journal_entries.clear()
	records_discovered.clear()
	settings = {
		"language":            "eng",
		"master_volume":       80,
		"music_volume":        70,
		"sfx_volume":          90,
		"ambient_volume":      60,
		"fullscreen":          true,
		"resolution":          "1920x1080",
		"ui_scale":            100,
		"autosave_frequency":  1,
		"tutorial_tooltips":   true,
		"notification_speed":  "normal",
		"text_size":           "medium",
		"colorblind_mode":     "off",
		"high_contrast":       false,
		"content_sensual":     false,
		"content_explicit":    false,
		"content_kinky":       false,
	}
	save_data()

# ── persistence ───────────────────────────────────────────────────────────────
func save_data() -> void:
	var data := {
		"gallery_unlocked":   gallery_unlocked,
		"journal_entries":    journal_entries,
		"records_discovered": records_discovered,
		"settings":           settings,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var text   := file.get_as_text()
	file.close()
	var result := JSON.parse_string(text)
	if not result is Dictionary:
		return
	if result.has("gallery_unlocked"):
		gallery_unlocked = Array(result["gallery_unlocked"], TYPE_STRING, "", null)
	if result.has("journal_entries"):
		journal_entries = result["journal_entries"]
	if result.has("records_discovered"):
		records_discovered = Array(result["records_discovered"], TYPE_STRING, "", null)
	if result.has("settings"):
		for key in result["settings"]:
			settings[key] = result["settings"][key]
	_apply_settings()
