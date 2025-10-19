extends Control

class_name pathPointButton

@export var endNodePathsEXP: Array
var endNodePaths: Array

@export var startNodePathsEXP: Array
var startNodePaths: Array

@export var neighborPathPointsEXP: Array
var neighborPathPoints: Array

func buildSelf():
	endNodePaths = endNodePathsEXP
	startNodePaths = startNodePathsEXP
	neighborPathPoints = neighborPathPointsEXP
	pass

signal pathPointClicked
func _on_button_pressed() -> void:
	emit_signal("pathPointClicked", self, neighborPathPoints, endNodePaths, startNodePaths)
	pass # Replace with function body.
