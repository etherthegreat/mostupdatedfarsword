extends Control

var bbButton = preload("res://barracks_button.tscn")

var playerNode = country

var playerBarracks: Array = []

func buildSelf(playerCountryNode):
	playerNode = playerCountryNode
	for building in playerNode.countryBuildingList:
		if building.buildingType == "Barracks":
			print("Barracks found!")
			playerBarracks.append(building)
			print("STAY WITH ME")
			#add a way to remove Barracks from this list when you make a way to remove/downgrade buildings
	#for building in playerBarracks:
		#if building.buildingTile != null:
	#print("MUSIC DANCE playerBarracks children", playerBarracks)
	if playerBarracks != null:
		for building in playerBarracks:
			var newBarracksButton = bbButton.instantiate()
			newBarracksButton.barracksBuilding = building
			newBarracksButton.barracksTile = building.tile
			#print(newBarracksButton.barracksTile, "RunawayTrain")
			newBarracksButton.addNewArmy.connect(buildNewArmy)
			newBarracksButton.buildSelf()
			$ScrollContainer/GridContainer.add_child(newBarracksButton)
		#for Army in playerNode.countryArmyList:
			
			for Tile in playerNode.OwnedTileList:
				if Tile.tileNumber == newBarracksButton.barracksTile.tileNumber:
					if Tile.stationedArmy != null:
						newBarracksButton.addPrebuiltArmy(Tile.stationedArmy)
	else:
		print("Illusion, playerBarracks = null")
	#for Army in playerNode.countryArmyList:
		#$Panel/GridContainer.add_child(Army)
		#print("NEVER WANT YOU BACK INTO MY LIFE< I REALLY DON", $Panel/GridContainer.get_children())
	pass

signal newArmySignal
func buildNewArmy(barracksBuilding, barracksTile, bbButton, newArmyName):
	emit_signal("newArmySignal", barracksBuilding, barracksTile, bbButton, playerNode, newArmyName)
	pass


func _process(delta: float) -> void:
	if playerNode != null:
		if visible == false:
			for Army in playerNode.countryArmyList:
				Army.stopUpdatingUI()
		else:
			for Army in playerNode.countryArmyList:
				Army.startUpdatingUI()
	pass
