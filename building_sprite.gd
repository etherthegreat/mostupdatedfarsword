extends Sprite2D

class_name buildingSprite

var buildingType: String
var buildingLevel: int
signal updateInspector
var thisBuilding: building

func buildBuildSprite(building):
	thisBuilding = building
	scale = Vector2(0.23,0.23)
	buildingType = thisBuilding.buildingType
	buildingLevel = thisBuilding.buildingLevel
	var buildingPanelButton = Button.new()
	buildingPanelButton.text = str(buildingType, "Lvl", buildingLevel)
	buildingPanelButton.pressed.connect(updateBuildingInspector)
	buildingPanelButton.scale = Vector2(6, 6)
	add_child(buildingPanelButton)
	pass

func updateUI(tile):
	if thisBuilding != null:
		match thisBuilding.buildingType:
			"Farm":
				$LevelUpPointsLabel.text = str(tile.farmDevelopmentPoints, " / " , tile.tileFarmDevCost)
	pass

func updateBuildingInspector():
	print("heeeeeeeeee")
	emit_signal("updateInspector", thisBuilding)
	pass
