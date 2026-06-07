# ProtectorArcEntry.gd
# One prayer card per active protector (Dept. of Mythological Affairs tab).
# Follows the same pattern as CommanderArcEntry.gd.
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# ProtectorArcEntry (Control, min_size 280x200)
# └── Panel (NinePatchRect or Panel)
#     └── VBoxContainer
#         ├── SomaMemoLabel      (Label, smaller font, italic, autowrap)
#         ├── HBoxContainer  (header)
#         │   ├── ProtectorNameLabel  (Label, bold)
#         │   └── DevotionBar         (ProgressBar, min 0, max 100)
#         ├── Separator
#         ├── PrayersContainer  (VBoxContainer)
#         │   ├── PrayerRow_1  (HBoxContainer)
#         │   │   ├── CheckSprite   (TextureRect, 16x16)
#         │   │   └── PrayerLabel_1 (Label, autowrap)
#         │   ├── PrayerRow_2  (same structure)
#         │   └── PrayerRow_3  (same structure)
#         ├── Separator
#         └── SummonStatusLabel  (Label, smaller)
# ============================================================

extends Control

signal devotionCompleted(protector_id)
signal summonRequested(protector_id)   # emitted when player presses the Summon button

var arcData: Dictionary
var playerNode: country

var checkTexture = null    # TODO: load your checkmark asset
var circleTexture = null   # TODO: load your empty circle asset


func buildSelf(data: Dictionary, player: country) -> void:
	arcData = data
	playerNode = player
	_apply_layout()
	_refresh_display()


# ── LAYOUT ───────────────────────────────────────────────────────────────────
func _apply_layout() -> void:
	# Clip all children (including decorative Sprite2Ds and fixed-position Labels)
	# to this Control's declared bounds.  Without this, Godot factors those nodes'
	# extended rendering positions into the ScrollContainer's scroll area, making
	# the list impossibly tall.
	clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW

	# Only set things that must be enforced at runtime — text autowrap on labels,
	# and the summon button which doesn't exist in the scene file.
	# Everything else (panel size, anchors, bar sizes) is set in the editor.

	var soma_lbl := get_node_or_null("Panel/VBoxContainer/SomaMemoLabel") as Label
	if soma_lbl:
		soma_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var name_lbl := get_node_or_null(
		"Panel/VBoxContainer/HBoxContainer/ProtectorNameLabel") as Label
	if name_lbl:
		name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	for i in range(1, 4):
		var prayer_lbl := get_node_or_null(
			"Panel/VBoxContainer/PrayersContainer/PrayerRow_" + str(i) +
			"/PrayerLabel_" + str(i)) as Label
		if prayer_lbl:
			prayer_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var status_lbl := get_node_or_null("Panel/VBoxContainer/SummonStatusLabel") as Label
	if status_lbl:
		status_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Summon button — created in code since it doesn't live in the scene file.
	# Only create it once (layout is called from buildSelf, not on every refresh).
	if get_node_or_null("Panel/VBoxContainer/SummonButton") == null:
		var summonvbox := get_node_or_null("Panel/VBoxContainer")
		if summonvbox:
			var btn := Button.new()
			btn.name                    = "SummonButton"
			btn.text                    = "SUMMON ASSET — PRESIDENTIAL ORDER"
			btn.disabled                = true
			btn.size_flags_horizontal   = Control.SIZE_EXPAND_FILL
			btn.custom_minimum_size     = Vector2(200, 44)
			btn.pressed.connect(_on_summon_pressed)
			summonvbox.add_child(btn)

	call_deferred("_fit_to_content")


func _fit_to_content() -> void:
	var vbox := get_node_or_null("Panel/VBoxContainer") as Control
	if vbox:
		custom_minimum_size.y = vbox.get_combined_minimum_size().y + 24


func _on_summon_pressed() -> void:
	# Disable the button immediately so the event can only fire once per run.
	var btn := get_node_or_null("Panel/VBoxContainer/SummonButton") as Button
	if btn:
		btn.disabled = true
		btn.text     = "ASSET SUMMONED — AWAITING CONTACT"
	emit_signal("summonRequested", arcData.get("protector_id", ""))


func _refresh_display() -> void:
	if arcData.is_empty():
		return

	# Helper: get a node by path and warn once if it's missing rather than crash.
	# This tolerates minor scene-name mismatches during development.
	var _n = func(path: String) -> Node:
		var node = get_node_or_null(path)
		if node == null:
			push_warning("ProtectorArcEntry: node not found — " + path)
		return node

	# SoMA bureaucratic memo header
	var soma_lbl = _n.call("Panel/VBoxContainer/SomaMemoLabel")
	if soma_lbl:
		soma_lbl.text = arcData.get("soma_memo", "")

	# Header
	var name_lbl = _n.call("Panel/VBoxContainer/HBoxContainer/ProtectorNameLabel")
	if name_lbl:
		name_lbl.text = arcData.get("protector_name", "Unknown Protector")

	var devotion_bar = _n.call("Panel/VBoxContainer/HBoxContainer/DevotionBar")
	if devotion_bar:
		devotion_bar.value = arcData.get("devotion_level", 0)

	# Prayers
	var prayers = arcData.get("prayers", [])
	var complete = arcData.get("prayers_complete", [false, false, false])

	var prayer_labels = [
		_n.call("Panel/VBoxContainer/PrayersContainer/PrayerRow_1/PrayerLabel_1"),
		_n.call("Panel/VBoxContainer/PrayersContainer/PrayerRow_2/PrayerLabel_2"),
		_n.call("Panel/VBoxContainer/PrayersContainer/PrayerRow_3/PrayerLabel_3"),
	]
	var check_sprites = [
		_n.call("Panel/VBoxContainer/PrayersContainer/PrayerRow_1/CheckSprite"),
		_n.call("Panel/VBoxContainer/PrayersContainer/PrayerRow_2/CheckSprite"),
		_n.call("Panel/VBoxContainer/PrayersContainer/PrayerRow_3/CheckSprite"),
	]

	for i in range(3):
		var lbl = prayer_labels[i]
		var spr = check_sprites[i]
		if lbl == null:
			continue
		if i < prayers.size():
			lbl.text = prayers[i].get("label", "Condition " + str(i + 1))
		if complete[i]:
			lbl.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
			if spr and checkTexture != null:
				spr.texture = checkTexture
		else:
			lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			if spr and circleTexture != null:
				spr.texture = circleTexture

	# Summon status label
	var all_done: bool = arcData.get("arc_complete", false)
	var status_lbl = _n.call("Panel/VBoxContainer/SummonStatusLabel")
	if status_lbl:
		if all_done:
			status_lbl.text = "ASSET ACQUISITION APPROVED — PRESS BUTTON TO SUMMON"
			status_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
			emit_signal("devotionCompleted", arcData.get("protector_id", ""))
		else:
			status_lbl.text = "Complete all three prayers to unlock presidential summon"

	# Summon button: enabled only when all prayers are done
	var summon_btn := get_node_or_null("Panel/VBoxContainer/SummonButton") as Button
	if summon_btn:
		summon_btn.disabled = not all_done
		if all_done:
			summon_btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
