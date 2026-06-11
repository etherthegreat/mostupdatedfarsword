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
var scene_history:          Dictionary    = {}   # scene_id → {version, turn}

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
	"streaming_mode":      false,
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

# ── scene history ─────────────────────────────────────────────────────────────
func record_scene(scene_id: String, version: String, turn: int) -> void:
	scene_history[scene_id] = {"version": version, "turn": turn, "played": true}
	save_data()

func get_scene_version(scene_id: String) -> String:
	return scene_history.get(scene_id, {}).get("version", "")

func scene_was_played(scene_id: String) -> bool:
	return scene_history.has(scene_id)

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
	# Sync streaming_mode to Settings autoload
	var s = get_node_or_null("/root/Settings")
	if s != null:
		s.streaming_mode = settings.get("streaming_mode", false)

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
	scene_history.clear()
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
		"streaming_mode":      false,
	}
	save_data()

# ── persistence ───────────────────────────────────────────────────────────────
func save_data() -> void:
	var data := {
		"gallery_unlocked":   gallery_unlocked,
		"journal_entries":    journal_entries,
		"records_discovered": records_discovered,
		"scene_history":      scene_history,
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
	if result.has("scene_history") and result["scene_history"] is Dictionary:
		scene_history = result["scene_history"]
	if result.has("settings"):
		for key in result["settings"]:
			settings[key] = result["settings"][key]
	_apply_settings()
