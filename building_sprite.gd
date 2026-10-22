extends Control

class_name buildingSprite

var buildingType: String
var buildingLevel: int
signal updateInspector
var thisBuilding

func buildBuildSprite(building):
	thisBuilding = building
	buildingType = thisBuilding.buildingType
	buildingLevel = thisBuilding.buildingLevel
	$Button.text = str(buildingType, "Lvl", buildingLevel)
	$Button.pressed.connect(updateBuildingInspector)

func updateUI(tile):
	if thisBuilding != null:
		match thisBuilding.buildingType:
			"Farm":
				$LevelUpPointsLabel.text = str(tile.farmDevelopmentPoints, " / " , tile.tileFarmDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/farm.png")
			"Camp":
				$LevelUpPointsLabel.text = str(tile.campDevelopmentPoints, " / " , tile.tileCampDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/camp.png")
			"Mine":
				$LevelUpPointsLabel.text = str(tile.mineDevelopmentPoints, " / " , tile.tileMineDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/mine.png")
			"Granary":
				$LevelUpPointsLabel.text = str(tile.granaryDevelopmentPoints, " / " , tile.tileGranaryDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/granary.png")
			"Library":
				$LevelUpPointsLabel.text = str(tile.libraryDevelopmentPoints, " / " , tile.tileLibraryDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/library.png")
			"Tower":
				$LevelUpPointsLabel.text = str(tile.towerDevelopmentPoints, " / " , tile.tileTowerDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/tower.png")
			"Temple":
				$LevelUpPointsLabel.text = str(tile.templeDevelopmentPoints, " / " , tile.tileTempleDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/temple.png")
			"Bath":
				$LevelUpPointsLabel.text = str(tile.bathDevelopmentPoints, " / " , tile.tileBathDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/bath.png")
			"Workshop":
				$LevelUpPointsLabel.text = str(tile.workshopDevelopmentPoints, " / " , tile.tileWorkshopDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/workshop.png")
			"Faire":
				$LevelUpPointsLabel.text = str(tile.faireDevelopmentPoints, " / " , tile.tileFaireDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/faire.png")
			"Forge":
				$LevelUpPointsLabel.text = str(tile.forgeDevelopmentPoints, " / " , tile.tileForgeDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/forge.png")
			"Barracks":
				$LevelUpPointsLabel.text = str(tile.barracksDevelopmentPoints, " / " , tile.tileBarracksDevCost)
				$Button.icon = load("res://art assets/finishedAssets/buildingsketches/barracks.png")

func updateBuildingInspector():
	emit_signal("updateInspector", thisBuilding)
