extends Control

class_name civilianPathFollow

var thisCivilian: Civilian
var thisCountry: country
var currentTile: Tile
var currentPath: Path2D

var currentPathPoint: pathPointButton
var destinationPathPoint: pathPointButton

var destinationNumber: int
var destinationPath: Path2D

var movingForward: bool = false
var movingBackward: bool = false

signal movingCivilian

var progressRate: float

var civilianMode: String


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
	emit_signal("movingCivilian")
	pass

signal civilianArrived
signal civilianTraveling
func _process(delta: float) -> void:
	if movingBackward == true:
		progressRate -= 0.02
		if progressRate <= 0:
			movingBackward = false
			currentPathPoint = destinationPathPoint
			currentPathPoint.occupied = true
			#currentPathPoint.add_child(self)
			var currentContainer = get_parent()
			emit_signal("civilianArrived", currentPath, destinationPathPoint, thisCivilian, self, currentContainer)
			destinationPathPoint = null
			currentTile = currentPathPoint.ppbTile
		else:
			emit_signal("civilianTraveling", progressRate, destinationPathPoint, thisCivilian)
	if movingForward == true:
		progressRate += 0.02
		if progressRate >= 1:
			movingForward = false
			currentPathPoint = destinationPathPoint
			currentPathPoint.occupied = true
			currentTile = currentPathPoint.ppbTile
			#currentPathPoint.add_child(self)
			var currentContainer = get_parent()
			emit_signal("civilianArrived", currentPath, destinationPathPoint, thisCivilian, self, currentContainer)
			destinationPathPoint = null
		else:
			emit_signal("civilianTraveling", progressRate, destinationPathPoint, thisCivilian)
	pass

func onRaise(Civilian, country, pathPoint):
	thisCivilian = Civilian
	thisCountry = country
	currentPathPoint = pathPoint
	currentPathPoint.occupied = true
	#currentTile = Tile
#	match currentPathPoint.currentPathPoint
	#currentPath = path
	pass

signal cpfSelected
func _on_cpf_button_pressed() -> void:
	emit_signal("cpfSelected", thisCivilian, self, currentTile, thisCountry, currentPathPoint)
	pass # Replace with function body.


func colonizeMode():
	civilianMode = "Colonize"
	pass

func corruptionMode():
	civilianMode = "Corruption"
	pass

func agricultureMode():
	civilianMode = "Agriculture"
	pass

func resourceMode():
	civilianMode = "Resource"
	pass

func urbanMode():
	civilianMode = "Urban"
	pass

signal tileChanging
func emitTileChange():
	emit_signal("tileChanging", currentTile, civilianMode, thisCivilian)
	pass
