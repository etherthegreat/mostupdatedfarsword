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

# ── ATTACK ANIMATION STATE ────────────────────────────────────────────────────
var attack_mode: bool = false        # true while running attack advance/retreat
var attack_at_midpoint: bool = false # true after midpoint is hit, prevents re-fire

signal attackMidpoint(apf)                        # fires once at progress 0.5
signal attackRetreated(apf, returnPoint)           # fires when retreat reaches 0.0

func beginAttack(targetPPB: pathPointButton, path: Path2D) -> void:
	currentPathPoint.occupied = false
	currentPath = path
	destinationPathPoint = targetPPB
	attack_mode = true
	attack_at_midpoint = false
	progressRate = 0.0
	movingForward = true
	movingBackward = false
	emit_signal("movingArmy")

func resolveAttack(conquered: bool) -> void:
	if conquered:
		movingForward = true   # continue forward to 1.0 — take the tile
	else:
		movingBackward = true  # retreat back to 0.0 — bounce back

# ── END ATTACK STATE ──────────────────────────────────────────────────────────

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

signal armyArrived
signal armyTraveling

func refreshHealthBar() -> void:
	if thisArmy == null or thisArmy.maxManpower == 0:
		return
	$ProgressBar.value = (float(thisArmy.manpowerInArmy) / thisArmy.maxManpower) * 100.0
	$Label.text = "win" if thisArmy.armyCharm != null else ""

func _process(_delta: float) -> void:
	if thisArmy == null:
		return
	if thisArmy.deleteMode == false:
		if attack_mode:
			_process_attack()
		elif movingBackward == true:
			progressRate -= 0.02
			if progressRate <= 0:
				movingBackward = false
				currentPathPoint = destinationPathPoint
				currentPathPoint.occupied = true
				var currentContainer = get_parent()
				emit_signal("armyArrived", currentPath, destinationPathPoint, thisArmy, self, currentContainer)
				destinationPathPoint = null
			else:
				emit_signal("armyTraveling", progressRate, destinationPathPoint, thisArmy)
		elif movingForward == true:
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

func _process_attack() -> void:
	var speed: float = 0.025
	if movingForward:
		progressRate += speed
		if not attack_at_midpoint and progressRate >= 0.5:
			progressRate = 0.5
			movingForward = false
			attack_at_midpoint = true
			emit_signal("attackMidpoint", self)
			# execution pauses here until resolveAttack() sets a direction
		elif progressRate >= 1.0:
			progressRate = 1.0
			movingForward = false
			attack_mode = false
			currentPathPoint = destinationPathPoint
			currentPathPoint.occupied = true
			currentTile = currentPathPoint.ppbTile
			emit_signal("armyArrived", currentPath, destinationPathPoint, thisArmy, self, get_parent())
			destinationPathPoint = null
		else:
			emit_signal("armyTraveling", progressRate, destinationPathPoint, thisArmy)
	elif movingBackward:
		progressRate -= speed
		if progressRate <= 0.0:
			progressRate = 0.0
			movingBackward = false
			attack_mode = false
			currentPathPoint.occupied = true
			emit_signal("attackRetreated", self, currentPathPoint)
		else:
			emit_signal("armyTraveling", progressRate, destinationPathPoint, thisArmy)

func onRaise(Army, country, pathPoint):
	thisArmy = Army
	thisCountry = country
	currentPathPoint = pathPoint
	currentPathPoint.occupied = true
	$APFButton.icon = Army.armyIcon
	currentTile = pathPoint.ppbTile
	refreshHealthBar()

signal apfSelected
func _on_apf_button_pressed() -> void:
	if spellToCast == null:
		emit_signal("apfSelected", thisArmy, self, currentTile, thisCountry, currentPathPoint)
	else:
		thisArmy.armyCharm = spellToCast
		spellToCast = null

func showBattle(battle):
	$battlecontrol.add_child(battle)

func deleteBattle():
	if $battlecontrol.get_children() != null:
		for Battle in $battlecontrol.get_children():
			Battle.queue_free()

func prepareMilSpell(spellForCast):
	spellToCast = spellForCast

func emitTileChange():
	emit_signal("siegeChange", thisArmy, currentPathPoint)
