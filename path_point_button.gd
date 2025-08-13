extends Control

class_name pathPointButton

@export var expPath: Path2D
var realPath:Path2D

@export var expPathNumber: int
var realPathNumber: int

@export var expNeighborPPBs: Array = []
var neighborPPBs: Array = []

signal pathPointClicked
func _on_button_pressed() -> void:
	realPath = expPath
	realPathNumber = expPathNumber
	neighborPPBs = expNeighborPPBs
	emit_signal("pathPointClicked", realPath, realPathNumber)
	pass # Replace with function body.
