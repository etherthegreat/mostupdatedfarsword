extends Control

class_name pathPointButton

var stationedArmy: Army
var stationedAPF: armyPathFollow

@export var neighborPathPointsEXP: Array
var neighborPathPoints: Array

@export var navalPathPointsEXP: Array
var navalPathPoints: Array

@export var ppbTileEXP: Tile
var ppbTile: Tile

var occupied: bool = false #is this occupied by any of our units?

var stationedCivilians: Array

var discoveredByPlayer: bool

func buildSelf():
	for NodePath in neighborPathPointsEXP:
		neighborPathPoints.append(get_node(NodePath))
	for NodePath in navalPathPointsEXP:
		navalPathPoints.append(get_node(NodePath))
	ppbTile = ppbTileEXP
	setMarkerVisible(false)

signal pathPointClicked
func _on_button_pressed() -> void:
	#if occupied != true:
	emit_signal("pathPointClicked", self,neighborPathPoints, ppbTile)

func hideTile():
	ppbTile.fogOfWar()

func revealTile():
	ppbTile.discoverTile()

func calculateBattle(armyPath, type, attackingArmy, lastSelectedPathPoint):
	if stationedArmy != null and is_instance_valid(stationedArmy):
		if stationedArmy.enemy == true:
			attackingArmy.attacksFromCurrentTile += 1
			stationedArmy.calculateBattle(armyPath, type, attackingArmy, stationedAPF, lastSelectedPathPoint)

func deleteNeighborBattles():
	for pathPointButton in neighborPathPoints:
		if pathPointButton.stationedAPF != null and is_instance_valid(pathPointButton.stationedAPF):
			pathPointButton.stationedAPF.deleteBattle()

func siegeTile(army):
	ppbTile.siegeCalculate(army)

func setMarkerVisible(v: bool) -> void:
	if has_node("Button"):
		$Button.visible = v
