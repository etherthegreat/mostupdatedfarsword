extends Control
# ============================================================
# SCENE STRUCTURE:
#
# MainMenu (Control, full screen)
# ├── VideoStreamPlayer   (full screen, autoplay, loop)
# ├── BottomBar           (HBoxContainer, bottom-anchored, full width)
# │   ├── NewGameButton      (Button, grey panel StyleBox)
# │   ├── ContinueButton     (Button, grey panel StyleBox)
# │   │   └── SaveInfoLabel  (Label, turn/season, sits below button)
# │   ├── LibraryButton      (Button, "PRESIDENTIAL LIBRARY")
# │   ├── SettingsButton     (Button)
# │   └── ExitButton         (Button)
# ├── VersionLabel        (Label, bottom-left corner)
# ├── LanguageSelection   (Control, shown first-run, full overlay)
# │   └── GridContainer   (flag buttons for language pick)
# └── PresidentialLibraryPanel  (instance, hidden by default)
# ============================================================

const AUTOSAVE_PATH  := "user://autosave.json"
const SETTINGS_PATH  := "user://settings.txt"   # legacy path kept for compat

var _game_language: String = "eng"

func _ready() -> void:
	_check_language()
	_check_continue_button()

# ── language (first-run) ──────────────────────────────────────────────────────
func _check_language() -> void:
	var lang = LibraryData.get_setting("language", "")
	if lang == "":
		# Check legacy settings.txt
		if FileAccess.file_exists(SETTINGS_PATH):
			var f := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
			if f:
				var data = f.get_var()
				if data is Dictionary and data.has("gameLanguage"):
					lang = data["gameLanguage"]
					LibraryData.set_setting("language", lang)
					f.close()
	if lang == "":
		# First launch — default to English so the overlay never blocks the menu.
		# Language can be changed later via Settings.
		lang = "eng"
		LibraryData.set_setting("language", lang)
	_game_language = lang
	_hide_language_picker()

func _show_language_picker() -> void:
	var ls := get_node_or_null("LanguageSelection")
	if ls: ls.visible = true

func _hide_language_picker() -> void:
	var ls := get_node_or_null("LanguageSelection")
	if ls: ls.visible = false

# ── continue button ───────────────────────────────────────────────────────────
func _check_continue_button() -> void:
	var btn       = get_node_or_null("BottomBar/ContinueButton")
	var info_lbl  = get_node_or_null("BottomBar/ContinueButton/SaveInfoLabel")
	if not btn:
		return

	var save_exists := FileAccess.file_exists(AUTOSAVE_PATH)
	btn.disabled = not save_exists
	if info_lbl:
		if save_exists:
			info_lbl.text    = _read_save_summary()
			info_lbl.visible = true
		else:
			info_lbl.text    = "No save found"
			info_lbl.visible = true

func _read_save_summary() -> String:
	var f := FileAccess.open(AUTOSAVE_PATH, FileAccess.READ)
	if not f:
		return ""
	var result: Variant = JSON.parse_string(f.get_as_text())
	f.close()
	if not result is Dictionary:
		return ""
	var turn: int = result.get("turn", 0)
	var season := _season_name(turn)
	var year   := 1782 + (turn / 4)
	return "%s %d  ·  Turn %d" % [season, year, turn]

func _season_name(turn: int) -> String:
	return ["Spring", "Summer", "Autumn", "Winter"][turn % 4]

# ── button handlers ───────────────────────────────────────────────────────────
func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file(
		"res://Menu Scenes and Scripts/new_game_selection.tscn")

func _on_continue_button_pressed() -> void:
	if not FileAccess.file_exists(AUTOSAVE_PATH):
		return
	get_tree().change_scene_to_file(
		"res://Game Scenes and Scripts/world.tscn")

func _on_library_button_pressed() -> void:
	var panel := get_node_or_null("PresidentialLibraryPanel")
	if panel and panel.has_method("open_library"):
		panel.open_library("RECORDS")

func _on_settings_button_pressed() -> void:
	var panel := get_node_or_null("SettingsPanel")
	if panel:
		panel.visible = true
		if panel.has_method("populate_from_settings"):
			panel.populate_from_settings()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

# ── language selection (legacy + new) ─────────────────────────────────────────
func _on_english_button_pressed() -> void:
	_confirm_language("eng")

func _on_spanish_button_pressed() -> void:
	_confirm_language("esp")

func _on_french_button_pressed() -> void:
	_confirm_language("fra")

func _confirm_language(lang_code: String) -> void:
	_game_language = lang_code
	LibraryData.set_setting("language", lang_code)
	# Write legacy settings.txt for world.gd compatibility
	var data := {"gameLanguage": lang_code}
	var f := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE_READ)
	if f:
		f.store_var(data)
		f.close()
	_hide_language_picker()
	_check_continue_button()
