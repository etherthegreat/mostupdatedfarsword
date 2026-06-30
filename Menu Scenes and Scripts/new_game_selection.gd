extends Control

const settingsPath = "user://settings.txt"

var selectedCountry: String
var isCoopMode: bool = false
var settings: Dictionary = {}

func _ready() -> void:
	if FileAccess.file_exists(settingsPath):
		var file = FileAccess.open(settingsPath, FileAccess.READ)
		settings = file.get_var()
	# Canada is not playable in this build — hide its selector.
	var _ca_btn = get_node_or_null("SelectionPanel/CanadaButton")
	if _ca_btn: _ca_btn.visible = false
	var _ca_lbl = get_node_or_null("SelectionPanel/CanadaLabel")
	if _ca_lbl: _ca_lbl.visible = false

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes and Scripts/main_menu.tscn")
	updateInfoPanel()

func _on_anlaxia_button_pressed() -> void:
	selectedCountry = "ANL"
	updateInfoPanel()

func _on_america_button_pressed() -> void:
	selectedCountry = "USA"
	updateInfoPanel()

func _on_canada_button_pressed() -> void:
	selectedCountry = "CA"
	updateInfoPanel()

func _on_coop_button_toggled(toggled_on: bool) -> void:
	isCoopMode = toggled_on

func updateInfoPanel():
	match selectedCountry:
		"USA":
			$CountryInfoPanel/InfoPanel/CountryArt.texture = load("res://art assets/AmericanRevolutionArt/tempArt/Screenshot (2027).png")
			$CountryInfoPanel/InfoPanel/LeaderArt.texture = load("res://art assets/AmericanRevolutionArt/tempArt/Larkin Love10.jpg")
			$CountryInfoPanel/InfoPanel/DescriptionLabel.text = "USA IS UNDER ATTACK FUCK! LARKIN LOVE IS HOT!"
			$CountryInfoPanel/CountrySelectionPanel/CountrySelectionLabel.text = "Selected Country: American Rebels"
			pass
		"CA":
			$CountryInfoPanel/InfoPanel/CountryArt.texture = load("res://art assets/AmericanRevolutionArt/tempArt/Screenshot (2028).png")
			$CountryInfoPanel/InfoPanel/LeaderArt.texture = load("res://art assets/AmericanRevolutionArt/tempArt/starfire_again.jpg")
			$CountryInfoPanel/InfoPanel/DescriptionLabel.text = "The Republic of Canada is the last country in North America to have withstood British conquest. With recent sightings on the border, will Jessica Commanda Odjick hold the line?"
			$CountryInfoPanel/CountrySelectionPanel/CountrySelectionLabel.text = "Selected Country: Republic of Canada"
			pass
	$PlayButton.disabled = false

var newGameScene = load("res://Game Scenes and Scripts/world.tscn")
func _on_play_button_pressed() -> void:
	AudioManager.play_main_track()   # plays the looping music track (starts with la foret.mp3)
	var language: String = settings.get("gameLanguage", "eng")
	var newGame = newGameScene.instantiate()
	# Add world to the scene tree root — NOT as a child of this menu scene.
	# If world were a child of new_game_selection, freeing the menu would also
	# free the world and all country nodes (including playerCountryNode).
	get_tree().root.add_child(newGame)
	newGame.newGameBuild(selectedCountry, language, isCoopMode)
	# Free this menu — the built world is already in the root tree and fully ready.
	queue_free()
