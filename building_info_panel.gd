extends Control

var open
var player

var thisTile: Tile

signal updateBuildingPanelUI

func buildSelf(playerCountry):
	player = playerCountry
	pass

var buildSpriteScene = load("res://building_sprite.tscn")

func displayBuildingInfo(tile):
	thisTile = tile
	for buildingSprite in $Panel/BuildingGridContainer.get_children():
		$Panel/BuildingGridContainer.remove_child(buildingSprite)
		#Control.queue_free() #same performance issue here, we're not deleting them, but they are not in the way.  c
		#could cause clutter and performance issues further along a game.
	for building in tile.tileBuildingsList:
		#print( "building list for tile", thisTile.tileNumber, building, building.buildingType)
		var buildSprite = buildSpriteScene.instantiate()
		buildSprite.thisBuilding = building
		buildSprite.updateInspector.connect(inspectBuilding)
		buildSprite.buildBuildSprite(building)
		buildSprite.updateUI(thisTile)
		$Panel/BuildingGridContainer.add_child(buildSprite)
	pass

func inspectBuilding(building):
	#emit_signal("updateBuildingPanelUI", building)
	#print("get tricked")
	$buildingPanelPanel.updateInspector(building)
	pass

var newBuildingButtonScene = load("res://new_building_button.tscn")

func addNewBuildingButton(newBuilding):
	var newBuildingButton = newBuildingButtonScene.instantiate()
	newBuildingButton.buildSelf(newBuilding, player)
	#if newBuildingButton.is_instance_valid() == true:
	for building in thisTile.tileBuildingsList:
		if building.buildingType == newBuildingButton.buildingType:
			newBuildingButton.queue_free()
		else:
			$AddBuildingControl/ScrollContainer/GridContainer.add_child(newBuildingButton)
			newBuildingButton.newBuilding.connect(newBuildingForTile)
	pass

signal newBuildingInTile
func newBuildingForTile(buildingType, goldCalculatedCost, foodCalculatedCost, woodCalculatedCost, metalCalculatedCost):
	emit_signal("newBuildingInTile", buildingType, goldCalculatedCost, foodCalculatedCost, woodCalculatedCost, metalCalculatedCost, thisTile, player)
	pass


func _process(delta: float) -> void:
	if $AddBuildingControl.visible == true:
		if $AddBuildingControl/ScrollContainer/GridContainer.get_children() != null:
			for buildingButton in $AddBuildingControl/ScrollContainer/GridContainer.get_children():
				buildingButton.updateUI()
	pass

signal fillWithUnlockedBuildings
func _on_add_building_button_pressed() -> void:
	if $AddBuildingControl/ScrollContainer/GridContainer.get_children() != null:
		for buildingButton in $AddBuildingControl/ScrollContainer/GridContainer.get_children():
			$AddBuildingControl/ScrollContainer/GridContainer.remove_child(buildingButton)
			buildingButton.queue_free()
	emit_signal("fillWithUnlockedBuildings")
	if $AddBuildingControl.visible == true:
		$AddBuildingControl.visible = false
	else:
		$AddBuildingControl.visible = true
	pass # Replace with function body.
