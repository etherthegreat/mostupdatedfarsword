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
		return

	# Pre-build a tileNumber → stationedArmy lookup so the sort can check army
	# presence before any BarracksButton nodes are instantiated.
	var army_by_tile: Dictionary = {}
	for tile in playerNode.OwnedTileList:
		army_by_tile[tile.tileNumber] = tile.stationedArmy

	# Sort order:
	#   0. Ualani Carlisle — pinned first always
	#   1. Vice President — pinned second
	#   2. Occupied barracks (other), largest army (manpower) first
	#   3. Unoccupied barracks, highest barracks level first
	playerBarracks.sort_custom(func(a, b):
		var _key := func(building) -> int:
			if _is_ualani_tile(building.tile):    return 0
			if _is_vp_tile(building.tile):        return 1
			if army_by_tile.get(building.tile.tileNumber, null) != null: return 2
			return 3
		var ak: int = _key.call(a)
		var bk: int = _key.call(b)
		if ak != bk:
			return ak < bk
		if ak == 2:
			var aa = army_by_tile.get(a.tile.tileNumber, null)
			var ba = army_by_tile.get(b.tile.tileNumber, null)
			return (aa.manpowerInArmy if aa else 0) > (ba.manpowerInArmy if ba else 0)
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

func _is_vp_tile(tile) -> bool:
	return tile != null \
		and tile.tileGovernor != null \
		and tile.tileGovernor.isVicePresident
