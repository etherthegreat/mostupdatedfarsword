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
			"Camp":
				$LevelUpPointsLabel.text = str(tile.campDevelopmentPoints, " / " , tile.tileCampDevCost)
			"Mine":
				$LevelUpPointsLabel.text = str(tile.mineDevelopmentPoints, " / " , tile.tileMineDevCost)
			"Granary":
				$LevelUpPointsLabel.text = str(tile.granaryDevelopmentPoints, " / " , tile.tileGranaryDevCost)
			"Library":
				$LevelUpPointsLabel.text = str(tile.libraryDevelopmentPoints, " / " , tile.tileLibraryDevCost)
			"Tower":
				$LevelUpPointsLabel.text = str(tile.towerDevelopmentPoints, " / " , tile.tileTowerDevCost)
			"Temple":
				$LevelUpPointsLabel.text = str(tile.templeDevelopmentPoints, " / " , tile.tileTemleDevCost)
			"Bath":
				$LevelUpPointsLabel.text = str(tile.bathDevelopmentPoints, " / " , tile.tileBathDevCost)
			"Workshop":
				$LevelUpPointsLabel.text = str(tile.workshopDevelopmentPoints, " / " , tile.tileWorkshopDevCost)
			"Faire":
				$LevelUpPointsLabel.text = str(tile.faireDevelopmentPoints, " / " , tile.tileFaireDevCost)
			"Forge":
				$LevelUpPointsLabel.text = str(tile.forgeDevelopmentPoints, " / " , tile.tileFrogeDevCost)
			"Barracks":
				$LevelUpPointsLabel.text = str(tile.barracksDevelopmentPoints, " / " , tile.tileBarracksDevCost)
	pass

func updateBuildingInspector():
	print("heeeeeeeeee")
	emit_signal("updateInspector", thisBuilding)
	pass
