extends Control

class_name armyPathFollow

var thisArmy: Army
var thisCountry
var currentTile: Tile
var currentPath: Path2D

signal siegeChange
var currentPathPoint: pathPointButton
var destinationPathPoint: pathPointButton

var destinationNumber: int
var destinationPath: Path2D

var movingForward: bool = false
var movingBackward: bool = false

signal movingArmy

var progressRate: float

var spellToCast: spell
var spellCost: int

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
var fuckyou : float
var tempmanpowerinarmy: float
var tempMaxManpower: float
func _process(delta: float) -> void:
	if thisArmy.deleteMode == false:
		tempmanpowerinarmy = thisArmy.manpowerInArmy
		tempMaxManpower = thisArmy.maxManpower
		$APFButton.icon = thisArmy.armyIcon
		fuckyou = ((tempmanpowerinarmy/tempMaxManpower)*100)
		if thisArmy.armyCharm != null:
			$Label.text = "win"
		$ProgressBar.value = fuckyou
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
			# Visual march speed — slowed by winter on cold tiles for non-adapted armies
			var march_speed: float = 0.02
			if currentTile != null and currentTile.winterScore > 0 \
					and not thisArmy.armyTags.has("Cold Weather"):
				march_speed *= currentTile.get_winter_army_modifier()
			progressRate += march_speed
			if progressRate >= 1:
				movingForward = false
				currentPathPoint = destinationPathPoint
				currentPathPoint.occupied = true
				currentTile = currentPathPoint.ppbTile
				#currentPathPoint.add_child(self)
				var currentContainer = get_parent()
				emit_signal("armyArrived", currentPath, destinationPathPoint, thisArmy, self, currentContainer)
				destinationPathPoint = null
			else:
				emit_signal("armyTraveling", progressRate, destinationPathPoint, thisArmy)
	else:
		currentPathPoint.stationedAPF = null
		currentPathPoint.stationedArmy = null
		thisArmy.queue_free()
		self.queue_free()
	pass

func onRaise(Army, country, pathPoint):
	thisArmy = Army
	thisCountry = country
	currentPathPoint = pathPoint
	currentPathPoint.occupied = true
	$APFButton.icon = Army.armyIcon
	currentTile = pathPoint.ppbTile   # populate immediately so winter drain/speed is safe on turn 1
	pass

signal apfSelected
func _on_apf_button_pressed() -> void:
	if spellToCast == null:
		emit_signal("apfSelected", thisArmy, self, currentTile, thisCountry, currentPathPoint)
	else:
		thisArmy.armyCharm = spellToCast
		spellToCast = null
	pass # Replace with function body.

func showBattle(battle):
	$battlecontrol.add_child(battle)
	pass

func deleteBattle():
	if $battlecontrol.get_children() != null:
		for Battle in $battlecontrol.get_children():
			Battle.queue_free()
		pass

func prepareMilSpell(spellForCast):
	spellToCast = spellForCast
	pass

func emitTileChange():
	emit_signal("siegeChange", thisArmy, currentPathPoint)
	pass
