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
	_refresh_display()


func _refresh_display() -> void:
	if arcData.is_empty():
		return

	var gov: governor = arcData.get("governor")

	# Header
	if gov != null and gov.governorTexture != null:
		$Panel/VBoxContainer/HBoxContainer/PortraitSprite.texture = gov.governorTexture
	$Panel/VBoxContainer/HBoxContainer/VBoxContainer/CommanderNameLabel.text = \
		gov.governorType if gov != null else "Unknown Commander"
	$Panel/VBoxContainer/HBoxContainer/VBoxContainer/ArcNameLabel.text = \
		arcData.get("archetype_name", "")

	# Objectives
	var objectives = arcData.get("objectives", [])
	var complete = arcData.get("objectives_complete", [false, false, false])

	var obj_labels = [
		$Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_1/ObjectiveLabel_1,
		$Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_2/ObjectiveLabel_2,
		$Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_3/ObjectiveLabel_3,
	]
	var check_sprites = [
		$Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_1/CheckSprite,
		$Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_2/CheckSprite,
		$Panel/VBoxContainer/ObjectivesContainer/ObjectiveRow_3/CheckSprite,
	]

	for i in range(3):
		if i < objectives.size():
			obj_labels[i].text = objectives[i].get("label", "Objective " + str(i + 1))
		if complete[i]:
			obj_labels[i].add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
			if checkTexture != null:
				check_sprites[i].texture = checkTexture
		else:
			obj_labels[i].add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			if circleTexture != null:
				check_sprites[i].texture = circleTexture

	# Reward hint
	var all_done = arcData.get("arc_complete", false)
	$Panel/VBoxContainer/RewardLabel.text = \
		"REUNION UNLOCKED — READY" if all_done \
		else "Complete all objectives to unlock reunion scene"
	if all_done:
		$Panel/VBoxContainer/RewardLabel.add_theme_color_override(
			"font_color", Color(1.0, 0.85, 0.2))
