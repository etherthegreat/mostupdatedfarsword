extends Control

const settingsPath = "user://settings.txt"
var gameLanguage: String

var masterVolume: String

var screenResolution: String
var colorBlindAccessibility: bool

var settings: Dictionary = {
}


func _ready():
	language()
	pass

func language():
	if FileAccess.file_exists(settingsPath):
		var file = FileAccess.open(settingsPath, FileAccess.READ)
		#screenResolution = file.get_var(screenResolution)
		settings = file.get_var()
		gameLanguage = settings["gameLanguage"]
		buildMainMenu()
	else:
		askForLanguage()
	pass

func askForLanguage():
	$LanguageSelection.visible = true
	$GridContainer.visible = true
	pass

func buildMainMenu():
	if FileAccess.file_exists(settingsPath):
		var file = FileAccess.open(settingsPath, FileAccess.READ)
		settings = file.get_var()
	else:
		settings = {
			#"screenResolution": "1920 x 1080", # screenResolution
			#"colorBlindAccessibility": false, #coloblind
			"gameLanguage": gameLanguage
			#"masterVolume": 100 #masterVolume
		}
		var file = FileAccess.open(settingsPath, FileAccess.WRITE_READ)
		file.store_var(settings)
		file.close()
		print("file didn't exist but does now, ", settings)
	loadLocBall(gameLanguage)
	pass

func loadLocBall(gL):
	
	pass

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes and Scripts/new_game_selection.tscn")
	pass # Replace with function body.


func _on_english_button_pressed() -> void:
	$LanguageSelection.visible = false
	$GridContainer.visible = false
	gameLanguage = "eng"
	buildMainMenu()
	pass # Replace with function body.
