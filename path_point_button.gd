extends Control

class_name pathPointButton

@export var pathNumberEXP: int
var pathNumber: int

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

func buildSelf():
	pathNumber = pathNumberEXP
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
	if occupied != true:
		emit_signal("pathPointClicked", self, endNodePaths, startNodePaths, neighborPathPoints, ppbTile)
	pass # Replace with function body.

func hideTile():
	ppbTile.fogOfWar()
	pass

func revealTile():
	ppbTile.reveal()
	pass
