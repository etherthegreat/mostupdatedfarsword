extends Control
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# GalleryTile (Control, custom_minimum_size 160x200)
# └── Panel (NinePatchRect or Panel)
#     ├── ArtRect         (TextureRect, expand/fill, top portion)
#     ├── LockedOverlay   (ColorRect, full size, rgba 0,0,0,0.85)
#     │   ├── LockIcon    (TextureRect, 32x32, centered)
#     │   └── LockedTitle (Label, "???", centered bottom)
#     ├── UnlockedTitle   (Label, scene title, bottom strip)
#     └── HoverHint       (PanelContainer, hidden by default)
#         └── HintLabel   (Label, hint text, autowrap)
# ============================================================

signal tile_clicked(event_id: String)

var event_id:    String = ""
var title:       String = ""
var hint_text:   String = ""
var art_texture: Texture2D = null
var is_unlocked: bool    = false

func buildSelf(p_event_id: String, p_title: String, p_hint: String,
		p_art: Texture2D, p_unlocked: bool) -> void:
	event_id    = p_event_id
	title       = p_title
	hint_text   = p_hint
	art_texture = p_art
	is_unlocked = p_unlocked
	_refresh()

func _refresh() -> void:
	var art_rect     = get_node_or_null("Panel/ArtRect")
	var locked_ov    = get_node_or_null("Panel/LockedOverlay")
	var locked_title = get_node_or_null("Panel/LockedOverlay/LockedTitle")
	var unlocked_lbl = get_node_or_null("Panel/UnlockedTitle")
	var hint_panel   = get_node_or_null("Panel/HoverHint")
	var hint_lbl     = get_node_or_null("Panel/HoverHint/HintLabel")

	if art_rect and art_texture:
		art_rect.texture = art_texture

	if locked_ov:
		locked_ov.visible = not is_unlocked
	if unlocked_lbl:
		unlocked_lbl.text    = title
		unlocked_lbl.visible = is_unlocked
	if locked_title:
		locked_title.text = "???"
	if hint_panel:
		hint_panel.visible = false
	if hint_lbl:
		hint_lbl.text = hint_text

func _on_mouse_entered() -> void:
	if is_unlocked:
		return
	var hint_panel = get_node_or_null("Panel/HoverHint")
	if hint_panel:
		hint_panel.visible = true

func _on_mouse_exited() -> void:
	var hint_panel = get_node_or_null("Panel/HoverHint")
	if hint_panel:
		hint_panel.visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT and is_unlocked:
		emit_signal("tile_clicked", event_id)
