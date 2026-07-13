extends Control

const VICTORY_COLOR := Color(0.95, 0.80, 0.20)   # gold
const DEFEAT_COLOR  := Color(0.72, 0.12, 0.12)   # dark red

const VICTORY_FLAVOR := "The Republic endures. History will remember."
const DEFEAT_FLAVOR  := "The Republic has fallen. But history is not yet written."

func _ready() -> void:
	$Panel/VBox/Buttons/ReturnButton.pressed.connect(_on_return_pressed)
	$Panel/VBox/Buttons/PlayAgainButton.pressed.connect(_on_play_again_pressed)

func show_result(won: bool, reason: String = "") -> void:
	var title_label   := $Panel/VBox/TitleLabel   as Label
	var flavor_label  := $Panel/VBox/FlavorLabel  as Label
	var reason_label  := $Panel/VBox/ReasonLabel  as Label

	title_label.text                      = "VICTORY" if won else "DEFEAT"
	title_label.add_theme_color_override("font_color", VICTORY_COLOR if won else DEFEAT_COLOR)
	flavor_label.text                     = VICTORY_FLAVOR if won else DEFEAT_FLAVOR
	reason_label.text                     = reason
	reason_label.visible                  = reason != ""

	visible = true
	$Panel/VBox/Buttons/ReturnButton.grab_focus()

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes and Scripts/main_menu.tscn")

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Game Scenes and Scripts/world.tscn")
