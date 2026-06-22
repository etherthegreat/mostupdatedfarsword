
extends Control


var allTilesList: Array = []


# ============================================================
# INITIALIZATION - called by world.gd during game setup
# ============================================================

func initializeTiles(is_new_game: bool, save_data: Dictionary = {}) -> void:
	allTilesList.assign(get_children())

	for tile in allTilesList:
		if not tile is Tile:
			continue

		# Set the tile number from the export variable you already have
		tile.tileNumber = tile.EXPTileNumber

		if is_new_game:
			# Load from CSV via TileDatabase
			tile.build_self()
		else:
			# Load from save data
			var tile_save = save_data.get(str(tile.EXPTileNumber), {})
			if tile_save.is_empty():
				# Fallback to CSV if no save data for this tile
				tile.build_self()
			else:
				tile.build_self_from_save(tile_save)

	print("TileController: All ", allTilesList.size(), " tiles initialized.")


# ============================================================
# YOUR EXISTING FUNCTIONS - preserved exactly as they were
# (removed the debug print though - see note below)
# ============================================================

signal spellAssignedToTile

func connectTileSignals() -> void:
	allTilesList.assign(get_children())
	for Tile in get_children():
		# NOTE: removed your "penis penis penis" debug print here :)
		Tile.tileLoaded.connect(connectEventSignal)
		#Tile.spellAssigned.connect(spellTileAssigned)
		#Tile.tileColonized.connect(colonizeThisTile)
		Tile.newSiegeStatus.connect(siegeWon)

signal newTileOwner
func siegeWon(theTile, tileOwner, newCountryCid):
	emit_signal("newTileOwner", theTile, tileOwner, newCountryCid)

func discoverTiles(playerCountry) -> void:
	for Tile in get_children():
		Tile.calculateDiscovered(playerCountry)


func updateTiles(mapMode, displayCorruption, playerCountry) -> void:
	for Tile in get_children():
		print("DEBUG updateTiles: updateGraphics for ", Tile.name)
		Tile.updateGraphics(mapMode, displayCorruption, playerCountry)
		print("DEBUG updateTiles: calculateActiveView for ", Tile.name)
		Tile.calculateActiveView()
		print("DEBUG updateTiles: done ", Tile.name)


func connectEventSignal(tile) -> void:
	tile.tileEvent.connect(transferTileEvent)


signal transfer

func transferTileEvent(tile, type) -> void:
	print("yippie")
	emit_signal("transfer", tile, type)


func spellSelectionMode(newSpell, cost, playerCountry) -> void:
	match newSpell.militarySpell:
		false:
			for Tile in get_children():
				Tile.activateSpellMode(newSpell, cost, playerCountry)
		true:
			for Tile in get_children():
				Tile.activateMilitarySpellMode(newSpell, cost, playerCountry)


# ============================================================
# SAVE GAME - serialize all tile states to Dictionary
# ============================================================

func saveTileStates() -> Dictionary:
	var save_dict: Dictionary = {}
	for tile in allTilesList:
		if not tile is Tile:
			continue
		save_dict[str(tile.tileNumber)] = {
			"tileName": tile.tileName,
			"country": tile.tileOwner,
			"state": tile.tileStateName,
			"terrain": tile.terrain,
			"corruption": tile.corruption,
			"winterScore": tile.winterScore,
			"tileCrop": tile.tileCrop,
			"buildings": tile.buildings,
			"specialFeatures": tile.tileSpecialFeatures,
			"lastConqueror": tile.lastConqueror,
			"turnsSinceConquest": tile.turnsSinceConquest,
			"lastEspionageTurn": tile.lastEspionageTurn,
			"espionageActive": tile.espionageActive,
		}
	return save_dict


# ============================================================
# UTILITY - get a specific tile by number
# ============================================================

func getTileByNumber(tile_number: int) -> Tile:
	for tile in allTilesList:
		if tile is Tile and tile.tileNumber == tile_number:
			return tile
	return null


func getTilesByOwner(owner: String) -> Array:
	var result: Array = []
	for tile in allTilesList:
		if tile is Tile and tile.tileOwner == owner:
			result.append(tile)
	return result


func getTilesWithDock() -> Array:
	var result: Array = []
	for tile in allTilesList:
		if tile is Tile and tile.has_dock():
			result.append(tile)
	return result
