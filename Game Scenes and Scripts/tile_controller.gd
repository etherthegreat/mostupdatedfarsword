extends Control

var allTilesList: Array = []

func connectTileSignals():
	print("elevator", str(get_children()))
	allTilesList.assign(get_children()) 
	print(allTilesList, "horses can't run")
	for Tile in get_children():
		print(Tile.tileName, "penis penis penis")
		Tile.tileLoaded.connect(connectEventSignal)
	pass

func connectEventSignal(tile):
	tile.tileEvent.connect(transferTileEvent)
	pass

signal transfer
func transferTileEvent(tile, type):
	print("yippie")
	emit_signal("transfer", tile, type)
	pass
