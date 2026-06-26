extends Control
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# PresidentialLibraryPanel (Control, full screen)
# ├── DarkOverlay (ColorRect, full screen, rgba 0,0,0,0.88)
# └── LibraryContainer (Panel, large centered, e.g. 1200x800)
#     ├── SealSprite    (TextureRect, ~80x80, top-center,
#     │                  presidential seal art)
#     ├── TitleLabel    (Label, "PRESIDENTIAL LIBRARY", bold, large)
#     ├── TabContainer  (TabContainer, fills most of the panel)
#     │   ├── GALLERY   (Control, name="GALLERY")
#     │   │   └── [instance GalleryTab.tscn here]
#     │   ├── RECORDS   (Control, name="RECORDS")
#     │   │   └── [instance RecordsTab.tscn here]
#     │   └── JOURNAL   (Control, name="JOURNAL")
#     │       └── [instance JournalTab.tscn here]
#     └── CloseButton   (Button, "CLOSE", top-right corner)
# ============================================================

<<<<<<< Updated upstream
=======
const _GALLERY_SCENE = preload("res://GalleryTab.tscn")
const _RECORDS_SCENE = preload("res://RecordsTab.tscn")
const _JOURNAL_SCENE = preload("res://JournalTab.tscn")

const _TC_PATH := "LibraryContainer/OuterVBox/TabContainer"

>>>>>>> Stashed changes
func _ready() -> void:
	visible = false

func open_library(start_tab: String = "RECORDS") -> void:
	visible = true
	_refresh_all_tabs()
	_select_tab(start_tab)

func _refresh_all_tabs() -> void:
	var tc := get_node_or_null("LibraryContainer/TabContainer")
	if not tc:
		return

	var gallery_node = tc.get_node_or_null("GALLERY")
	if gallery_node:
		var gallery_tab = gallery_node.get_child(0) if gallery_node.get_child_count() > 0 else null
		if gallery_tab and gallery_tab.has_method("buildSelf"):
			gallery_tab.buildSelf()

	var journal_node = tc.get_node_or_null("JOURNAL")
	if journal_node:
		var journal_tab = journal_node.get_child(0) if journal_node.get_child_count() > 0 else null
		if journal_tab and journal_tab.has_method("buildSelf"):
			journal_tab.buildSelf()

func _select_tab(tab_name: String) -> void:
	var tc := get_node_or_null("LibraryContainer/TabContainer")
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
	var tc := get_node_or_null("LibraryContainer/TabContainer")
	if not tc:
		return
	var tab_node = tc.get_node_or_null(tab)
	if not tab_node:
		return
	var tab_scene = tab_node.get_child(0) if tab_node.get_child_count() > 0 else null
	if tab_scene and tab_scene.has_method("select_entry"):
		tab_scene.select_entry(entry_id)

func _on_close_button_pressed() -> void:
	visible = false
