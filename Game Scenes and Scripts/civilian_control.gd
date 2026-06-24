extends Control

var playerCountry: country


func loadCivilians(player, playerTileList):
	playerCountry = player
	for Tile in playerTileList:
		buildNewCivilian(Tile)

var civilianScene = load("res://Civilian.tscn")

func buildNewCivilian(Tile):
	var newCivilian = civilianScene.instantiate()
	newCivilian.buildSelf("Wooden Tools", "Adventurer", Tile, Tile.tileSpawnPoint, playerCountry)
	newCivilian.kitSignal.connect(loadKitsGrid)
	newCivilian.toolSignal.connect(loadToolsGrid)
	newCivilian.raiseSignal.connect(raiseCivilianUnit)
	$"Civilian Container".add_child(newCivilian)

signal raiseThisUnit
func raiseCivilianUnit(civToRaise):
	emit_signal("raiseThisUnit", civToRaise, playerCountry)

func loadKitsGrid(thisCivilian):
	for Civilian in $"Civilian Container".get_children():
		if Civilian == thisCivilian:
			Civilian.displayAvailableKits(playerCountry)

func loadToolsGrid(thisCivilian):
	for Civilian in $"Civilian Container".get_children():
		if Civilian == thisCivilian:
			Civilian.displayAvailableTools(playerCountry)

func updateCivilians():
	for Civilian in $"Civilian Container".get_children():
		Civilian.updatePanelUI()




func _on_worker_button_pressed() -> void:
	$ResourcesContainer.visible = false
	$"Civilian Container".visible = true
