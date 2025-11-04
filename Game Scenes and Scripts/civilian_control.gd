extends Control

var playerCountry: country


func loadCivilians(player, playerTileList):
	playerCountry = player
	for Tile in playerTileList:
		buildNewCivilian(Tile)
	pass

var civilianScene = load("res://Civilian.tscn")

func buildNewCivilian(Tile):
	var newCivilian = civilianScene.instantiate()
	newCivilian.buildSelf("Wooden Tools", "Adventurer", Tile, Tile.tileSpawnPoint, playerCountry)
	newCivilian.kitSignal.connect(loadKitsGrid)
	newCivilian.toolSignal.connect(loadToolsGrid)
	newCivilian.raiseSignal.connect(raiseCivilianUnit)
	$"Civilian Container".add_child(newCivilian)
	pass

signal raiseThisUnit
func raiseCivilianUnit(civToRaise):
	emit_signal("raiseThisUnit", civToRaise, playerCountry)
	pass

func loadKitsGrid(thisCivilian):
	for Civilian in $"Civilian Container".get_children():
		if Civilian == thisCivilian:
			Civilian.displayAvailableKits(playerCountry)
	pass

func loadToolsGrid(thisCivilian):
	for Civilian in $"Civilian Container".get_children():
		if Civilian == thisCivilian:
			Civilian.displayAvailableTools(playerCountry)
	pass

func updateCivilians():
	for Civilian in $"Civilian Container".get_children():
		Civilian.updatePanelUI()
	pass


func _on_explorer_button_pressed() -> void:
	$ExpeditionsContainer.visible = true
	$"Civilian Container".visible = false
	pass # Replace with function body.

func _on_worker_button_pressed() -> void:
	$ExpeditionsContainer.visible = false
	$"Civilian Container".visible = true
	pass # Replace with function body.
