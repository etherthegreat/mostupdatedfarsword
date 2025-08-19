extends Control

var open


var thisTile: Tile

signal updateBuildingPanelUI

func displayBuildingInfo(tile):
	for Control in $Panel/BuildingGridContainer.get_children():
		$Panel/BuildingGridContainer.remove_child(Control)
		#Control.queue_free() #same performance issue here, we're not deleting them, but they are not in the way.  c
		#could cause clutter and performance issues further along a game.
	for building in tile.tileBuildingsList:
		#print( "building list for tile", thisTile.tileNumber, building, building.buildingType)
		var buildControl = Control.new()
		var buildSprite = buildingSprite.new()
		#buildSprite.thisBuilding = building
		buildSprite.updateInspector.connect(inspectBuilding)
		buildSprite.buildBuildSprite(building)
		buildControl.add_child(buildSprite)
		$Panel/BuildingGridContainer.add_child(buildControl)
	pass

func inspectBuilding(building):
	#emit_signal("updateBuildingPanelUI", building)
	#print("get tricked")
	$buildingPanelPanel.updateInspector(building)
	pass
