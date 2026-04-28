extends Control

class_name pathPointButton

var stationedArmy: Army
var stationedAPF: armyPathFollow

@export var endNodePathsEXP: Array
var endNodePaths: Array

@export var startNodePathsEXP: Array
var startNodePaths: Array

@export var neighborPathPointsEXP: Array
var neighborPathPoints: Array

@export var ppbTileEXP: Tile
var ppbTile: Tile

var occupied: bool = false #is this occupied by any of our units?

var stationedCivilians: Array

var discoveredByPlayer: bool

func buildSelf():
	for NodePath in endNodePathsEXP:
		endNodePaths.append(get_node(NodePath))
	for NodePath in startNodePathsEXP:
		startNodePaths.append(get_node(NodePath))
	for NodePath in neighborPathPointsEXP:
		neighborPathPoints.append(get_node(NodePath))
	ppbTile = ppbTileEXP
	pass

signal pathPointClicked
func _on_button_pressed() -> void:
	print("DEBUG CLICK")
	#if occupied != true:
	emit_signal("pathPointClicked", self, endNodePaths, startNodePaths, neighborPathPoints, ppbTile)
	pass # Replace with function body.

func hideTile():
	ppbTile.fogOfWar()
	pass

func revealTile():
	ppbTile.discoverTile()
	pass

func calculateBattle(armyPath, type, attackingArmy, lastSelectedPathPoint):
	if stationedArmy != null:
		if stationedArmy.enemy == true:
			stationedArmy.calculateBattle(armyPath, type, attackingArmy, stationedAPF, lastSelectedPathPoint)
	pass

func deleteNeighborBattles():
	for pathPointButton in neighborPathPoints:
		if pathPointButton.stationedAPF != null:
			pathPointButton.stationedAPF.deleteBattle()
	pass

func siegeTile(army):
	ppbTile.siegeCalculate(army)
	pass
