extends Control
 
var bbButtonScene = preload("res://barracks_button.tscn")  # renamed from bbButton
var playerNode                      # typed null, not class ref
var playerBarracks: Array = []
 
func buildSelf(playerCountryNode):
	playerNode = playerCountryNode
	playerBarracks.clear()  # clear in case buildSelf called more than once
 
	# Find all barracks buildings in player's building list
	for building in playerNode.countryBuildingList:
		if building.buildingType == "Barracks":
			playerBarracks.append(building)
 
	if playerBarracks.is_empty():
		print("MilitaryPanelControl: no barracks found for ", playerNode.CID)
		return

	# Pre-build a tileNumber → stationedArmy lookup so the sort can check army
	# presence before any BarracksButton nodes are instantiated.
	var army_by_tile: Dictionary = {}
	for tile in playerNode.OwnedTileList:
		army_by_tile[tile.tileNumber] = tile.stationedArmy

	# Sort order:
	#   1. Ualani Carlisle's barracks — pinned to the top always
	#   2. Occupied barracks (army present), highest level → lowest
	#   3. Unoccupied barracks, highest level → lowest
	# TODO: add visual category separator labels between groups once UI nodes exist.
	playerBarracks.sort_custom(func(a, b):
		var a_ualani := _is_ualani_tile(a.tile)
		var b_ualani := _is_ualani_tile(b.tile)
		if a_ualani != b_ualani:
			return a_ualani
		var a_army := army_by_tile.get(a.tile.tileNumber, null) != null
		var b_army := army_by_tile.get(b.tile.tileNumber, null) != null
		if a_army != b_army:
			return a_army
		return a.buildingLevel > b.buildingLevel
	)

	# Pass 1: instantiate and build all buttons
	var builtButtons: Array = []
	for building in playerBarracks:
		var newBarracksButton = bbButtonScene.instantiate()
		newBarracksButton.barracksBuilding = building
		newBarracksButton.barracksTile = building.tile
		newBarracksButton.addNewArmy.connect(buildNewArmy)
		newBarracksButton.buildSelf()
		$ScrollContainer/GridContainer.add_child(newBarracksButton)
		builtButtons.append(newBarracksButton)
 
	# Pass 2: populate pre-built armies for each button
	# Separate loop prevents the scoping bug where only the last
	# button got its army assigned
	for button in builtButtons:
		for Tile in playerNode.OwnedTileList:
			if Tile.tileNumber == button.barracksTile.tileNumber:
				if Tile.stationedArmy != null:
					button.addPrebuiltArmy(Tile.stationedArmy)
 
signal newArmySignal
func buildNewArmy(barracksBuilding, barracksTile, bbButton, newArmyName):
	# bbButton here is the parameter (specific button instance) — unambiguous now
	emit_signal("newArmySignal", barracksBuilding, barracksTile, bbButton, playerNode, newArmyName)


func _is_ualani_tile(tile) -> bool:
	return tile != null \
		and tile.tileGovernor != null \
		and tile.tileGovernor.governorType == "Ualani Carlisle"
