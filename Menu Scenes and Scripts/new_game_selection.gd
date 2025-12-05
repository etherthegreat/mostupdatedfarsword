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

func _on_pender_tal_button_pressed() -> void:
	selectedCountry = "PDT"
	updateInfoPanel()
	pass # Replace with function body.

func _on_eighth_house_button_pressed() -> void:
	selectedCountry = "EIG"
	updateInfoPanel()
	pass # Replace with function body.

func _on_demon_empire_button_pressed() -> void:
	selectedCountry = "DEM"
	updateInfoPanel()
	pass # Replace with function body.

func _on_valterian_order_button_pressed() -> void:
	selectedCountry = "VTO"
	updateInfoPanel()
	pass # Replace with function body.

func updateInfoPanel():
	match selectedCountry:
		"ANL":
			$CountryInfoPanel/InfoPanel/CountryArt.texture = load("res://art assets/UI Art/Placeholder Art/Screenshot (1067).png")
			$CountryInfoPanel/InfoPanel/LeaderArt.texture = load("res://art assets/UI Art/Placeholder Art/F4 - Copy.png")
			$CountryInfoPanel/InfoPanel/DescriptionLabel.text = "This country is a slave economy run by demonic wizards and shit!"
			$CountryInfoPanel/CountrySelectionPanel/CountrySelectionLabel.text = "Selected Country: Anlaxian Estates"
			pass
		"PDT":
			$CountryInfoPanel/InfoPanel/CountryArt.texture = load("res://art assets/UI Art/Placeholder Art/Screenshot (1065).png")
			$CountryInfoPanel/InfoPanel/LeaderArt.texture = load("res://art assets/UI Art/Placeholder Art/F3 - Copy.png")
			$CountryInfoPanel/InfoPanel/DescriptionLabel.text = "Pacifist Orcs reside high in their monastic commune, hidden for centuries from the Demon King"
			$CountryInfoPanel/CountrySelectionPanel/CountrySelectionLabel.text = "Selected Country: Pender Tal"
			pass
		"EIG":
			$CountryInfoPanel/InfoPanel/CountryArt.texture = load("res://art assets/UI Art/Placeholder Art/Screenshot (1069).png")
			$CountryInfoPanel/InfoPanel/LeaderArt.texture = load("res://art assets/UI Art/Placeholder Art/F11 - Copy.png")
			$CountryInfoPanel/InfoPanel/DescriptionLabel.text = "The military arm of the Demon King, this country is a demonic military with a state"
			$CountryInfoPanel/CountrySelectionPanel/CountrySelectionLabel.text = "Selected Country: Eighth House"
			pass
		"VTO":
			$CountryInfoPanel/InfoPanel/CountryArt.texture = load("res://art assets/UI Art/Placeholder Art/Screenshot (1066).png")
			$CountryInfoPanel/InfoPanel/LeaderArt.texture = load("res://art assets/UI Art/Placeholder Art/F13 - Copy.png")
			$CountryInfoPanel/InfoPanel/DescriptionLabel.text = "The final fighting resistance against the Demon King, this fragile coalition of humans and elves defend their island to the death!"
			$CountryInfoPanel/CountrySelectionPanel/CountrySelectionLabel.text = "Selected Country: Valtherian Order"
			pass
		"DEM":
			$CountryInfoPanel/InfoPanel/CountryArt.texture = load("res://art assets/UI Art/Placeholder Art/Screenshot (1068).png")
			$CountryInfoPanel/InfoPanel/LeaderArt.texture = load("res://art assets/UI Art/Placeholder Art/F12 - Copy.png")
			$CountryInfoPanel/InfoPanel/DescriptionLabel.text = "The Demon Empire rules Farsword with an iron fist.  But with the Demon King's health failing, who knows how much longer this will be the case."
			$CountryInfoPanel/CountrySelectionPanel/CountrySelectionLabel.text = "Selected Country: Demon Empire"
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
