extends PathFollow2D

class_name armyPathFollow

var thisArmy: Army
var thisCountry: country
var currentTile: Tile
var currentPath: Path2D

var destinationNumber: int
var destinationPath: Path2D

func onRaise(Army, country, Tile, path, pathNumber):
	thisArmy = Army
	thisCountry = country
	currentTile = Tile
	currentPath = path
	progress_ratio = pathNumber
	pass



signal apfSelected
func _on_apf_button_pressed() -> void:
	emit_signal("apfSelected", thisArmy, self, currentTile, thisCountry, currentPath, progress_ratio)
	pass # Replace with function body.

func _process(delta: float) -> void:
	var destinationNumberFloat: float
	destinationNumberFloat = destinationNumber *.01
	if destinationNumberFloat != progress_ratio:
		if progress_ratio > destinationNumberFloat:
			progress_ratio -= .005
			print("no equal")
		elif progress_ratio < destinationNumberFloat:
			progress_ratio += .005
			print("no equal")
		elif progress_ratio == destinationNumberFloat:
			print("equal found")
		if progress_ratio >= (destinationNumberFloat - .02) && progress_ratio <= (destinationNumberFloat + .02):
			progress_ratio = destinationNumberFloat
	pass


func comparePath2Ds(destinationPath, destinationPathNumber):
	#match currentPath:
		
	pass
