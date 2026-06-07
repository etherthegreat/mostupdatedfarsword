# CommanderArcEntry.gd
# One arc card per active commander.
# Follows the existing UI pattern: buildSelf() populates, no _process needed.
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# CommanderArcEntry (Control, min_size 280x180)
# └── Panel (NinePatchRect or Panel)
#     └── VBoxContainer
#         ├── HBoxContainer  (header)
#         │   ├── PortraitSprite  (TextureRect, 48x48)
#         │   └── VBoxContainer
#         │       ├── CommanderNameLabel  (Label, bold)
#         │       └── ArcNameLabel        (Label, smaller, italic)
#         ├── Separator
#         ├── ObjectivesContainer  (VBoxContainer)
#         │   ├── ObjectiveRow_1  (HBoxContainer)
#         │   │   ├── CheckSprite      (TextureRect, 16x16)
#         │   │   └── ObjectiveLabel_1 (Label, autowrap)
#         │   ├── ObjectiveRow_2  (same structure)
#         │   └── ObjectiveRow_3  (same structure)
#         ├── Separator
#         └── RewardLabel  (Label, smaller, color hint)
# ============================================================

extends Control

signal objectiveCompleted(arc_id, objective_num)

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
# Sets minimum sizes, size flags, and autowrap on every child node so the card
# sizes itself correctly inside a ScrollContainer/VBoxContainer without needing
# anything set manually in the editor.
func _apply_layout() -> void:
	# Clip all children (including decorative Sprite2Ds and fixed-position Labels)
	# to this Control's declared bounds.  Without this, Godot factors those nodes'
	# extended rendering positions into the ScrollContainer's scroll area, making
	# the list impossibly tall.
	clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW

	# Only set things that must be enforced at runtime — text autowrap on labels.
	# Everything else (panel size, portrait size, anchors) is set in the editor.

	var name_lbl := get_node_or_null(
		"Panel/VBoxContainer/HBoxContainer/VBoxContainer/CommanderNameLabel") as Label
	if name_lbl:
		name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var arc_lbl := get_node_or_null(
		"Panel/VBoxContainer/HBoxContainer/VBoxContainer/ArcNameLabel") as Label
	if arc_lbl:
		arc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	for i in range(1, 4):
		var obj_lbl := get_node_or_null(
			"Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_" + str(i) +
			"/ObjectiveLabel_" + str(i)) as Label
		if obj_lbl:
			obj_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var reward_lbl := get_node_or_null("Panel/VBoxContainer/RewardLabel") as Label
	if reward_lbl:
		reward_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	call_deferred("_fit_to_content")


func _fit_to_content() -> void:
	var vbox := get_node_or_null("Panel/VBoxContainer") as Control
	if vbox:
		custom_minimum_size.y = vbox.get_combined_minimum_size().y + 24


func _refresh_display() -> void:
	if arcData.is_empty():
		return

	# Helper: get a node by path and warn once if missing rather than crash.
	var _n = func(path: String) -> Node:
		var node = get_node_or_null(path)
		if node == null:
			push_warning("CommanderArcEntry: node not found — " + path)
		return node

	var gov: governor = arcData.get("governor")

	# Header
	var portrait = _n.call("Panel/VBoxContainer/HBoxContainer/PortraitSprite")
	if portrait and gov != null and gov.governorTexture != null:
		portrait.texture = gov.governorTexture

	var name_lbl = _n.call("Panel/VBoxContainer/HBoxContainer/VBoxContainer/CommanderNameLabel")
	if name_lbl:
		name_lbl.text = gov.governorType if gov != null else "Unknown Commander"

	var arc_lbl = _n.call("Panel/VBoxContainer/HBoxContainer/VBoxContainer/ArcNameLabel")
	if arc_lbl:
		arc_lbl.text = arcData.get("archetype_name", "")

	# Objectives
	var objectives = arcData.get("objectives", [])
	var complete = arcData.get("objectives_complete", [false, false, false])

	var obj_labels = [
		_n.call("Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_1/ObjectiveLabel_1"),
		_n.call("Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_2/ObjectiveLabel_2"),
		_n.call("Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_3/ObjectiveLabel_3"),
	]
	var check_sprites = [
		_n.call("Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_1/CheckSprite"),
		_n.call("Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_2/CheckSprite"),
		_n.call("Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_3/CheckSprite"),
	]

	for i in range(3):
		var lbl = obj_labels[i]
		var spr = check_sprites[i]
		if lbl == null:
			continue
		if i < objectives.size():
			lbl.text = objectives[i].get("label", "Objective " + str(i + 1))
		if complete[i]:
			lbl.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
			if spr and checkTexture != null:
				spr.texture = checkTexture
		else:
			lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			if spr and circleTexture != null:
				spr.texture = circleTexture

	# Reward hint
	var all_done = arcData.get("arc_complete", false)
	var reward_lbl = _n.call("Panel/VBoxContainer/RewardLabel")
	if reward_lbl:
		reward_lbl.text = \
			"REUNION UNLOCKED — READY" if all_done \
			else "Complete all objectives to unlock reunion scene"
		if all_done:
			reward_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
