extends Control

class_name armyPathFollow

const APF_BACKGROUNDS := {
	"USA": "res://art assets/AmericanRevolutionArt/apfs/apf us backgrounnd.png",
	"UK":  "res://art assets/AmericanRevolutionArt/apfs/apf uk background.png",
	"CA":  "res://art assets/AmericanRevolutionArt/apfs/apf ca background.png",
}

const APF_BASE_SCALE := 0.6     # resting on-screen size at zoom 1x (one knob to tune)
var _cam: Camera2D = null
var _hover_scale: float = 1.0

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
	$ProgressBar/ManpowerLabel.text = str(thisArmy.manpowerInArmy) + "/" + str(thisArmy.maxManpower)
	# Exhausted/Retreat/Hold now surface in the army panel (Phase 3), not on the token.
	if thisArmy.armyMaxShield > 0:
		$ShieldBar.visible = true
		$ShieldBar.value = (float(thisArmy.armyShield) / float(thisArmy.armyMaxShield)) * 100.0
		$ShieldBar/ShieldLabel.text = str(thisArmy.armyShield) + "/" + str(thisArmy.armyMaxShield)
	else:
		$ShieldBar.visible = false

func _process(_delta: float) -> void:
	if thisArmy != null and not is_instance_valid(thisArmy):
		# DEBUGLIST P0-1: army was freed without tearing this token down.
		# Only clear the spawn-point if WE still own it — an attacker may have advanced in.
		if is_instance_valid(currentPathPoint) and currentPathPoint.stationedAPF == self:
			currentPathPoint.stationedAPF = null
			currentPathPoint.stationedArmy = null
			currentPathPoint.occupied = false
		queue_free()
		return
	if thisArmy == null:
		return
	refreshHealthBar()
	_update_token_scale()
	# Fade our own token when it has no moves/actions left this turn.
	if not thisArmy.enemy:
		modulate = Color(0.5, 0.5, 0.55, 0.6) if not thisArmy.has_moves_left() else Color(1, 1, 1, 1)
	if thisArmy.deleteMode == false:
		if attack_mode:
			_process_attack()
		elif movingBackward == true:
			progressRate -= 0.01
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
			var march_speed: float = 0.01
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
		# deleteMode teardown — guard the spawn-point and don't clobber a new occupant.
		if is_instance_valid(currentPathPoint) and currentPathPoint.stationedAPF == self:
			currentPathPoint.stationedAPF = null
			currentPathPoint.stationedArmy = null
			currentPathPoint.occupied = false
		if thisArmy.parentCountry != null and is_instance_valid(thisArmy.parentCountry):
			thisArmy.parentCountry.countryArmyList.erase(thisArmy)
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
	currentTile = pathPoint.ppbTile
	_refresh_appearance()
	if not $APFButton.mouse_entered.is_connected(_on_apf_mouse_entered):
		$APFButton.mouse_entered.connect(_on_apf_mouse_entered)
		$APFButton.mouse_exited.connect(_on_apf_mouse_exited)
		$APFButton.gui_input.connect(_on_apf_gui_input)
	refreshHealthBar()

func _refresh_appearance() -> void:
	# APF button = country panel (US/UK/CA); the army icon rides on top via Sprite2D.
	var c = thisCountry
	if c == null and thisArmy != null:
		c = thisArmy.parentCountry
	var cid: String = c.CID if c != null else "USA"
	var bg_path: String = APF_BACKGROUNDS.get(cid, APF_BACKGROUNDS["USA"])
	if ResourceLoader.exists(bg_path):
		$APFButton.icon = load(bg_path)
	if thisArmy != null and thisArmy.armyIcon != null:
		$Sprite2D.texture = thisArmy.armyIcon
	_refresh_weapon_icons()


func _refresh_weapon_icons(show_them: bool = false) -> void:
	if thisArmy == null:
		return
	var units: Array = thisArmy.unitsList
	_set_weapon_sprite($Weapon1, units[0] if units.size() > 0 else null, show_them)
	_set_weapon_sprite($Weapon2, units[1] if units.size() > 1 else null, show_them)


func _set_weapon_sprite(sprite: Sprite2D, unit, show_it: bool) -> void:
	if sprite == null:
		return
	if unit != null and unit.unitWeapon != null and unit.unitWeapon.weaponImage != null:
		sprite.texture = unit.unitWeapon.weaponImage
		sprite.visible = show_it
	else:
		sprite.visible = false


signal apfHovered(apf, entered)
func _on_apf_mouse_entered() -> void:
	z_index = 60          # bring the hovered token fully to front (fixes cluster overlap)
	_hover_scale = 1.4
	_refresh_weapon_icons(true)
	emit_signal("apfHovered", self, true)


func _on_apf_mouse_exited() -> void:
	z_index = 15
	_hover_scale = 1.0
	_refresh_weapon_icons(false)
	emit_signal("apfHovered", self, false)


func _update_token_scale() -> void:
	# Zoom-responsive: hold a constant on-screen size (inverse of camera zoom) * hover pop.
	if _cam == null or not is_instance_valid(_cam):
		_cam = get_viewport().get_camera_2d()
	var zoomv: float = 1.0
	if _cam != null and _cam.zoom.x > 0.0:
		zoomv = _cam.zoom.x
	var sc: float = (APF_BASE_SCALE / zoomv) * _hover_scale
	scale = Vector2(sc, sc)


signal apfSelected
func _on_apf_button_pressed() -> void:
	if spellToCast == null:
		emit_signal("apfSelected", thisArmy, self, currentTile, thisCountry, currentPathPoint)
	else:
		# Left-click with a queued spell casts it on this army.
		thisArmy.armyCharm = spellToCast
		spellToCast = null


signal apfRightClicked
func _on_apf_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		emit_signal("apfRightClicked", thisArmy, self, currentTile, thisCountry, currentPathPoint)
		get_viewport().set_input_as_handled()

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
