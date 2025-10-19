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

var movingForward: bool
var movingBackward: bool

signal movingArmy

var progressRate: float

func move(key, keyPath):
	emit_signal("movingArmy")
	match key:
		"start":
			progressRate = .1
			movingForward = true
			destinationPathPoint = keyPath
		"end":
			progressRate = .9
			movingBackward = true
			destinationPathPoint = keyPath
	pass

signal armyArrived
signal armyTraveling
func _process(delta: float) -> void:
	if movingBackward == true:
		progressRate -= 0.02
		if progressRate <= 0:
			movingBackward = false
			currentPathPoint = destinationPathPoint
			currentPathPoint.add_child(self)
			destinationPathPoint = null
			emit_signal("armyArrived", currentPath)
		else:
			emit_signal("armyTraveling", progressRate)
	if movingForward == true:
		progressRate += 0.02
		if progressRate >= 1:
			movingForward = false
			currentPathPoint = destinationPathPoint
			currentPathPoint.add_child(self)
			destinationPathPoint = null
			emit_signal("armyArrived", currentPath)
		emit_signal("armyTraveling")
	pass

func onRaise(Army, country, pathPoint):
	thisArmy = Army
	thisCountry = country
	currentPathPoint = pathPoint
	#currentTile = Tile
#	match currentPathPoint.currentPathPoint
	#currentPath = path
	pass

signal apfSelected
func _on_apf_button_pressed() -> void:
	emit_signal("apfSelected", thisArmy, self, currentTile, thisCountry)
	pass # Replace with function body.
