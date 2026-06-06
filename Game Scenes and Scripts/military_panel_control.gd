extends Control
 
var bbButtonScene = preload("res://barracks_button.tscn")  # renamed from bbButton
var playerNode: country = null                              # typed null, not class ref
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
