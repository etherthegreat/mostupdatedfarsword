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

	# SoMA bureaucratic memo header
	$Panel/VBoxContainer/SomaMemoLabel.text = arcData.get("soma_memo", "")

	# Header
	$Panel/VBoxContainer/HBoxContainer/ProtectorNameLabel.text = \
		arcData.get("protector_name", "Unknown Protector")
	$Panel/VBoxContainer/HBoxContainer/DevotionBar.value = \
		arcData.get("devotion_level", 0)

	# Prayers
	var prayers = arcData.get("prayers", [])
	var complete = arcData.get("prayers_complete", [false, false, false])

	var prayer_labels = [
		$Panel/VBoxContainer/PrayersContainer/PrayerRow_1/PrayerLabel_1,
		$Panel/VBoxContainer/PrayersContainer/PrayerRow_2/PrayerLabel_2,
		$Panel/VBoxContainer/PrayersContainer/PrayerRow_3/PrayerLabel_3,
	]
	var check_sprites = [
		$Panel/VBoxContainer/PrayersContainer/PrayerRow_1/CheckSprite,
		$Panel/VBoxContainer/PrayersContainer/PrayerRow_2/CheckSprite,
		$Panel/VBoxContainer/PrayersContainer/PrayerRow_3/CheckSprite,
	]

	for i in range(3):
		if i < prayers.size():
			prayer_labels[i].text = prayers[i].get("label", "Condition " + str(i + 1))
		if complete[i]:
			prayer_labels[i].add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
			if checkTexture != null:
				check_sprites[i].texture = checkTexture
		else:
			prayer_labels[i].add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			if circleTexture != null:
				check_sprites[i].texture = circleTexture

	# Summon status
	var all_done = arcData.get("arc_complete", false)
	$Panel/VBoxContainer/SummonStatusLabel.text = \
		"ASSET ACQUISITION APPROVED — SUMMON AVAILABLE" if all_done \
		else "Complete all prayers to unlock presidential summon"
	if all_done:
		$Panel/VBoxContainer/SummonStatusLabel.add_theme_color_override(
			"font_color", Color(1.0, 0.85, 0.2))
		emit_signal("devotionCompleted", arcData.get("protector_id", ""))
