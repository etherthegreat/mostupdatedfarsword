extends Control
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# PresidentialLibraryPanel (Control, full screen)
# ├── DarkOverlay (ColorRect, full screen, rgba 0,0,0,0.88)
# └── LibraryContainer (Panel, large centered, e.g. 1200x800)
#     └── OuterVBox (VBoxContainer)
#         ├── HeaderRow (HBoxContainer)
#         │   ├── SealSprite  (TextureRect, ~60x60)
#         │   ├── TitleLabel  (Label, "PRESIDENTIAL LIBRARY")
#         │   └── CloseButton (Button, "X")
#         └── TabContainer (TabContainer, fills most of the panel)
#             ├── GALLERY  (Control, name="GALLERY")
#             ├── RECORDS  (Control, name="RECORDS")
#             └── JOURNAL  (Control, name="JOURNAL")
# ============================================================

const _GALLERY_SCENE := preload("res://GalleryTab.tscn")
const _RECORDS_SCENE := preload("res://RecordsTab.tscn")
const _JOURNAL_SCENE := preload("res://JournalTab.tscn")

const _TC_PATH := "LibraryContainer/OuterVBox/TabContainer"

func _ready() -> void:
	visible = false
	_spawn_tabs()

func _spawn_tabs() -> void:
	var tc := get_node_or_null(_TC_PATH)
	if not tc:
		return
	_add_tab_to(tc, "GALLERY", _GALLERY_SCENE)
	_add_tab_to(tc, "RECORDS", _RECORDS_SCENE)
	_add_tab_to(tc, "JOURNAL", _JOURNAL_SCENE)

func _add_tab_to(tc: Node, tab_name: String, scene: PackedScene) -> void:
	var container := tc.get_node_or_null(tab_name)
	if not container or container.get_child_count() > 0:
		return
	var tab := scene.instantiate()
	tab.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.add_child(tab)

func open_library(start_tab: String = "RECORDS") -> void:
	visible = true
	_refresh_all_tabs()
	_select_tab(start_tab)

func _refresh_all_tabs() -> void:
	var tc := get_node_or_null(_TC_PATH)
	if not tc:
		return
	for tab_name in ["GALLERY", "RECORDS", "JOURNAL"]:
		var container := tc.get_node_or_null(tab_name)
		if not container:
			continue
		var tab := container.get_child(0) if container.get_child_count() > 0 else null
		if tab and tab.has_method("buildSelf"):
			tab.buildSelf()

func _select_tab(tab_name: String) -> void:
	var tc := get_node_or_null(_TC_PATH)
	if not tc:
		return
	for i in range(tc.get_tab_count()):
		if tc.get_tab_title(i) == tab_name:
			tc.current_tab = i
			return

func navigate_to(tab: String, entry_id: String = "") -> void:
	_select_tab(tab)
	if entry_id == "":
		return
	var tc := get_node_or_null(_TC_PATH)
	if not tc:
		return
	var container := tc.get_node_or_null(tab)
	if not container:
		return
	var tab_scene := container.get_child(0) if container.get_child_count() > 0 else null
	if tab_scene and tab_scene.has_method("select_entry"):
		tab_scene.select_entry(entry_id)

func _on_close_button_pressed() -> void:
	visible = false
