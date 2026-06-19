extends Control

func _ready() -> void:
	$CenterContainer/VBox/ReturnButton.pressed.connect(_on_return_button_pressed)

func show_result(won: bool, reason: String = "") -> void:
	$CenterContainer/VBox/TitleLabel.text = "VICTORY" if won else "DEFEAT"
	$CenterContainer/VBox/ReasonLabel.text = reason
	visible = true
	$CenterContainer/VBox/ReturnButton.grab_focus()

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes and Scripts/main_menu.tscn")
