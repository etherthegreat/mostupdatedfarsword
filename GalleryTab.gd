extends Control
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# GalleryTab (Control)
# ├── ScrollContainer
# │   └── GalleryGrid (GridContainer, columns=4,
# │                    theme_override_constants/h_separation=8,
# │                    theme_override_constants/v_separation=8)
# └── Lightbox (Control, full-screen overlay, hidden by default)
#     ├── DarkBG          (ColorRect, full screen, rgba 0,0,0,0.9)
#     ├── FullArtRect     (TextureRect, large centered, expand_mode=fit)
#     ├── LightboxTitle   (Label, bold, bottom center)
#     ├── LightboxFlavor  (Label, italic, smaller, below title)
#     ├── PrevButton      (Button, "<", left side)
#     ├── NextButton      (Button, ">", right side)
#     └── CloseButton     (Button, "✕", top-right)
# ============================================================

const GALLERY_CATALOG := [
	# Add entries as { "event_id": "...", "title": "...", "hint": "...",
	#                   "art_path": "res://...", "flavor": "..." }
	# These are populated by the dev as adult events are written.
	# Example (placeholder):
	# { "event_id": "ualani_mark_lewd_01",
	#   "title":    "A Quiet Evening in Vermont",
	#   "hint":     "Complete the Mark Penoit arc",
	#   "art_path": "",
	#   "flavor":   "Some things transcend politics." },
]

var _tile_scene = preload("res://GalleryTile.tscn")
var _unlocked_list: Array = []   # filtered to only unlocked entries, for lightbox cycling
var _lightbox_index: int  = 0

func _ready() -> void:
	buildSelf()

func buildSelf() -> void:
	var grid = get_node_or_null("ScrollContainer/GalleryGrid")
	if not grid:
		return

	# clear old tiles
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	_unlocked_list.clear()

	for entry in GALLERY_CATALOG:
		var eid      := entry.get("event_id", "")
		var unlocked := LibraryData.is_gallery_unlocked(eid)

		var art: Texture2D = null
		if unlocked:
			var art_path := entry.get("art_path", "")
			if art_path != "" and ResourceLoader.exists(art_path):
				art = load(art_path)
			_unlocked_list.append(entry)

		var tile = _tile_scene.instantiate()
		tile.buildSelf(eid, entry.get("title", "???"), entry.get("hint", ""),
				art, unlocked)
		tile.tile_clicked.connect(_on_tile_clicked)
		grid.add_child(tile)

func _on_tile_clicked(event_id: String) -> void:
	for i in range(_unlocked_list.size()):
		if _unlocked_list[i]["event_id"] == event_id:
			_lightbox_index = i
			break
	_show_lightbox()

func _show_lightbox() -> void:
	var lb = get_node_or_null("Lightbox")
	if not lb:
		return
	lb.visible = true
	_update_lightbox()

func _update_lightbox() -> void:
	if _unlocked_list.is_empty():
		return
	var entry     := _unlocked_list[_lightbox_index]
	var art_rect   = get_node_or_null("Lightbox/FullArtRect")
	var title_lbl  = get_node_or_null("Lightbox/LightboxTitle")
	var flavor_lbl = get_node_or_null("Lightbox/LightboxFlavor")
	var prev_btn   = get_node_or_null("Lightbox/PrevButton")
	var next_btn   = get_node_or_null("Lightbox/NextButton")

	if art_rect:
		var art_path := entry.get("art_path", "")
		if art_path != "" and ResourceLoader.exists(art_path):
			art_rect.texture = load(art_path)
	if title_lbl:
		title_lbl.text = entry.get("title", "")
	if flavor_lbl:
		flavor_lbl.text = entry.get("flavor", "")
	if prev_btn:
		prev_btn.visible = _unlocked_list.size() > 1
	if next_btn:
		next_btn.visible = _unlocked_list.size() > 1

func _on_prev_button_pressed() -> void:
	_lightbox_index = (_lightbox_index - 1 + _unlocked_list.size()) % _unlocked_list.size()
	_update_lightbox()

func _on_next_button_pressed() -> void:
	_lightbox_index = (_lightbox_index + 1) % _unlocked_list.size()
	_update_lightbox()

func _on_close_button_pressed() -> void:
	var lb = get_node_or_null("Lightbox")
	if lb:
		lb.visible = false
