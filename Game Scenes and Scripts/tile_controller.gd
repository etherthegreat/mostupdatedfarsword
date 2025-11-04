extends Control

var allTilesList: Array = []

func connectTileSignals():
	print("elevator", str(get_children()))
	allTilesList.assign(get_children()) 
	for Tile in get_children():
		print(Tile.tileName, "penis penis penis")
		Tile.tileLoaded.connect(connectEventSignal)
		Tile.spellAssigned.connect(spellTileAssigned)
		Tile.tileColonized.connect(colonizeThisTile)
	pass

func discoverTiles(playerCountry):
	for Tile in get_children():
		Tile.activeView = false
		Tile.undiscovered = true
		Tile.discovered = false
	for Tile in get_children():
		Tile.calculateDiscovered(playerCountry)
pass

func updateTiles(mapMode, displayCorruption, playerCountry):
	for Tile in get_children():
		Tile.updateGraphics(mapMode, displayCorruption, playerCountry)
	pass

func connectEventSignal(tile):
	tile.tileEvent.connect(transferTileEvent)
	pass

signal transfer
func transferTileEvent(tile, type):
	print("yippie")
	emit_signal("transfer", tile, type)
	pass

func spellSelectionMode(newSpell, cost, playerCountry):
	match newSpell.militarySpell:
		false:
			for Tile in get_children():
				Tile.spellCastMode(newSpell, cost, playerCountry)
	pass

func normalMode():
	for Tile in get_children():
		Tile.normalMode()
	pass

signal colonizeTile
func colonizeThisTile(thisTile):
	emit_signal("colonizeTile", thisTile)
	pass

signal spellAssignedToTile
func spellTileAssigned(cost):
	emit_signal("spellAssignedToTile", cost)
	pass
