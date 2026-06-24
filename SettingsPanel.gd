extends Control
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# SettingsPanel (Control, full screen overlay)
# ├── DarkOverlay (ColorRect, full screen, rgba 0,0,0,0.85)
# └── SettingsContainer (Panel, large centered, e.g. 900x700)
#     ├── TitleLabel   (Label, "SETTINGS", bold, large, top-center)
#     ├── HSplitContainer
#     │   ├── SidebarScroll (ScrollContainer, ~200px wide)
#     │   │   └── SidebarList (VBoxContainer)
#     │   │       # category buttons injected at runtime
#     │   └── ContentScroll (ScrollContainer, fills remaining width)
#     │       └── ContentVBox (VBoxContainer, padding 12px)
#     │           # sections shown/hidden per category:
#     │           ├── AudioSection      (VBoxContainer)
#     │           ├── DisplaySection    (VBoxContainer)
#     │           ├── GameplaySection   (VBoxContainer)
#     │           ├── AccessibilitySection (VBoxContainer)
#     │           ├── LanguageSection   (VBoxContainer)
#     │           └── DataSection       (VBoxContainer)
#     └── CloseButton (Button, "CLOSE", bottom-right or top-right)
# ============================================================

const SECTIONS := [
	"AUDIO", "DISPLAY", "GAMEPLAY", "ACCESSIBILITY", "LANGUAGE", "DATA"
]

func _ready() -> void:
	_build_sidebar()
	_show_section("AUDIO")

# ── sidebar ───────────────────────────────────────────────────────────────────
func _build_sidebar() -> void:
	var list = get_node_or_null(
		"SettingsContainer/HSplitContainer/SidebarScroll/SidebarList")
	if not list:
		return
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()
	for sec in SECTIONS:
		var btn := Button.new()
		btn.text      = sec
		btn.flat      = true
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_show_section.bind(sec))
		list.add_child(btn)

	# DATA section gets a visual separator before it
	var sep := HSeparator.new()
	# insert before last button (DATA)
	var data_btn := list.get_child(list.get_child_count() - 1)
	list.remove_child(data_btn)
	list.add_child(sep)
	list.add_child(data_btn)

func _show_section(section: String) -> void:
	var content = get_node_or_null(
		"SettingsContainer/HSplitContainer/ContentScroll/ContentVBox")
	if not content:
		return
	for child in content.get_children():
		child.visible = false

	var target := content.get_node_or_null(section.capitalize() + "Section")
	if target:
		target.visible = true

# ── AUDIO ─────────────────────────────────────────────────────────────────────
# Sliders connect via .tscn binds=["key"]; Godot appends bound args after signal args,
# so the signature is (value, key) not (key, value).
func _on_audio_changed(value: float, key: String) -> void:
	LibraryData.set_setting(key, int(value))
	# TODO: wire to AudioManager when built — see SFX-001

# ── DISPLAY ───────────────────────────────────────────────────────────────────
func _on_fullscreen_toggled(enabled: bool) -> void:
	LibraryData.set_setting("fullscreen", enabled)
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resolution_selected(index: int) -> void:
	var resolutions := ["1920x1080", "1600x900", "1280x720"]
	if index < resolutions.size():
		LibraryData.set_setting("resolution", resolutions[index])
		var parts := resolutions[index].split("x")
		if parts.size() == 2:
			DisplayServer.window_set_size(Vector2i(int(parts[0]), int(parts[1])))

func _on_ui_scale_changed(value: float) -> void:
	LibraryData.set_setting("ui_scale", int(value))
	get_tree().root.content_scale_factor = value / 100.0

# ── GAMEPLAY ──────────────────────────────────────────────────────────────────
func _on_autosave_selected(index: int) -> void:
	var frequencies := [1, 5, 10]
	if index < frequencies.size():
		LibraryData.set_setting("autosave_frequency", frequencies[index])

func _on_tooltips_toggled(enabled: bool) -> void:
	LibraryData.set_setting("tutorial_tooltips", enabled)

func _on_notification_speed_selected(index: int) -> void:
	var speeds := ["slow", "normal", "fast"]
	if index < speeds.size():
		LibraryData.set_setting("notification_speed", speeds[index])

# ── ACCESSIBILITY ─────────────────────────────────────────────────────────────
func _on_text_size_selected(index: int) -> void:
	var sizes := ["small", "medium", "large"]
	if index < sizes.size():
		LibraryData.set_setting("text_size", sizes[index])
	# TODO: apply font size via theme

func _on_colorblind_selected(index: int) -> void:
	var modes := ["off", "deuteranopia", "protanopia", "tritanopia"]
	if index < modes.size():
		LibraryData.set_setting("colorblind_mode", modes[index])
	# TODO: apply shader / palette swap

func _on_high_contrast_toggled(enabled: bool) -> void:
	LibraryData.set_setting("high_contrast", enabled)
	# TODO: apply high-contrast theme

# ── LANGUAGE ──────────────────────────────────────────────────────────────────
# Language flag buttons call this directly
func _on_language_selected(lang_code: String) -> void:
	LibraryData.set_setting("language", lang_code)
	# Sync with old settings.txt path for backwards compatibility
	var old_settings: Dictionary = {"gameLanguage": lang_code}
	var file := FileAccess.open("user://settings.txt", FileAccess.WRITE_READ)
	if file:
		file.store_var(old_settings)
		file.close()

# ── CONTENT FLAGS (removed per PAA scene navigation spec) ────────────────────
# Scene content choice is made at the scene, not in Settings.
# Streaming Mode toggle belongs in the pause menu, not here.
func _on_content_sensual_toggled(_enabled: bool) -> void: pass
func _on_content_explicit_toggled(_enabled: bool) -> void: pass
func _on_content_kinky_toggled(_enabled: bool) -> void: pass

# ── DATA ─────────────────────────────────────────────────────────────────────
func _on_reset_data_pressed() -> void:
	var dlg = get_node_or_null("SettingsContainer/ResetConfirmDialog")
	if dlg:
		dlg.popup_centered()
	else:
		# Fallback if confirmation dialog not wired yet
		push_warning("SettingsPanel: ResetConfirmDialog not found — add it to the scene.")

func _on_reset_confirmed() -> void:
	LibraryData.reset_library_data()
	var dlg = get_node_or_null("SettingsContainer/ResetConfirmDialog")
	if dlg:
		dlg.hide()

# ── CLOSE ─────────────────────────────────────────────────────────────────────
func _on_close_button_pressed() -> void:
	visible = false

# ── populate controls from saved settings ─────────────────────────────────────
func populate_from_settings() -> void:
	# Call this when the panel becomes visible to sync controls to saved values.
	# Each control type needs individual wiring in the scene.
	# Sliders: set value; OptionButtons: select index; CheckButtons: set pressed.
	# This is a stub — wire per-control in the scene's _ready or here once nodes exist.
	pass
