extends Control

class_name armyPathFollow

var thisArmy: Army
var thisCountry: country
var currentTile: Tile
var currentPath: Path2D

var currentPathPoint: pathPointButton
var destinationPathPoint: pathPointButton

var destinationNumber: int
var destinationPath: Path2D

var movingForward: bool = false
var movingBackward: bool = false

signal movingArmy

var progressRate: float

func move(key, keyPath, path):
	currentPathPoint.occupied = false
	currentPath = path
	match key:
		"start":
			progressRate = .1
			movingForward = true
			destinationPathPoint = keyPath
		"end":
			progressRate = .9
			movingBackward = true
			destinationPathPoint = keyPath
	emit_signal("movingArmy")
	pass

signal armyArrived
signal armyTraveling
func _process(delta: float) -> void:
	if movingBackward == true:
		progressRate -= 0.02
		if progressRate <= 0:
			movingBackward = false
			currentPathPoint = destinationPathPoint
			currentPathPoint.occupied = true
			#currentPathPoint.add_child(self)
			var currentContainer = get_parent()
			emit_signal("armyArrived", currentPath, destinationPathPoint, thisArmy, self, currentContainer)
			destinationPathPoint = null
		else:
			emit_signal("armyTraveling", progressRate, destinationPathPoint, thisArmy)
	if movingForward == true:
		progressRate += 0.02
		if progressRate >= 1:
			movingForward = false
			currentPathPoint = destinationPathPoint
			currentPathPoint.occupied = true
			#currentTile = currentPathPoint.ppbTile
			#currentPathPoint.add_child(self)
			var currentContainer = get_parent()
			emit_signal("armyArrived", currentPath, destinationPathPoint, thisArmy, self, currentContainer)
			destinationPathPoint = null
		else:
			emit_signal("armyTraveling", progressRate, destinationPathPoint, thisArmy)
	pass

func onRaise(Army, country, pathPoint):
	thisArmy = Army
	thisCountry = country
	currentPathPoint = pathPoint
	currentPathPoint.occupied = true
	#currentTile = Tile
#	match currentPathPoint.currentPathPoint
	#currentPath = path
	pass

signal apfSelected
func _on_apf_button_pressed() -> void:
	emit_signal("apfSelected", thisArmy, self, currentTile, thisCountry, currentPathPoint)
	pass # Replace with function body.
