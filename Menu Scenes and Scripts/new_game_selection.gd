extends Control

const settingsPath = "user://settings.txt"

var selectedCountry: String
var settings: Dictionary = {}

func _ready() -> void:
	if FileAccess.file_exists(settingsPath):
		var file = FileAccess.open(settingsPath, FileAccess.READ)
		settings = file.get_var()
	pass

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes and Scripts/main_menu.tscn")
	updateInfoPanel()
	pass # Replace with function body.

func _on_anlaxia_button_pressed() -> void:
	selectedCountry = "ANL"
	updateInfoPanel()
	pass # Replace with function body.

func _on_america_button_pressed() -> void:
	selectedCountry = "USA"
	updateInfoPanel()
	pass # Replace with function body.

func _on_canada_button_pressed() -> void:
	selectedCountry = "CAN"
	updateInfoPanel()
	pass # Replace with function body.

func updateInfoPanel():
	match selectedCountry:
		"USA":
			$CountryInfoPanel/InfoPanel/CountryArt.texture = load("res://art assets/AmericanRevolutionArt/tempArt/Screenshot (2027).png")
			$CountryInfoPanel/InfoPanel/LeaderArt.texture = load("res://art assets/AmericanRevolutionArt/tempArt/Larkin Love10.jpg")
			$CountryInfoPanel/InfoPanel/DescriptionLabel.text = "USA IS UNDER ATTACK FUCK! LARKIN LOVE IS HOT!"
			$CountryInfoPanel/CountrySelectionPanel/CountrySelectionLabel.text = "Selected Country: American Rebels"
			pass
		"CAN":
			$CountryInfoPanel/InfoPanel/CountryArt.texture = load("res://art assets/AmericanRevolutionArt/tempArt/Screenshot (2028).png")
			$CountryInfoPanel/InfoPanel/LeaderArt.texture = load("res://art assets/AmericanRevolutionArt/tempArt/starfire_again.jpg")
			$CountryInfoPanel/InfoPanel/DescriptionLabel.text = "The Republic of Canada is the last country in North America to have withstood British conquest.  With recent citings on the border, will they hold out?"
			$CountryInfoPanel/CountrySelectionPanel/CountrySelectionLabel.text = "Selected Country: Republic of Canada"
			pass
	$PlayButton.disabled = false
	pass

var newGameScene = load("res://Game Scenes and Scripts/world.tscn")
func _on_play_button_pressed() -> void:
	$ScenePanel.queue_free()
	$ReturnButton.queue_free()
	$PlayButton.queue_free()
	$SelectionPanel.queue_free()
	$CountryInfoPanel.queue_free()
	var language = settings.gameLanguage
	var newGame = newGameScene.instantiate()
	add_child(newGame)
	newGame.newGameBuild(selectedCountry, language)
	pass # Replace with function body.
