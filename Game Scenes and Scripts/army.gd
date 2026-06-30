extends Control


class_name Army

var armyFoodCost: int = 0
var armyWoodCost: int = 0
var armyMetalCost: int = 0
var armyGoldCost: int = 0
var armyFaithCost: int = 0
var armyMagicCost: int = 0
var armyScienceCost: int = 0
var armyCultureCost: int = 0
var armyHarmonyCost: int = 0
var armyMandateCost: int = 0
var armyInfluenceCost: int = 0

var armyWeaponsCost: int = 0
var armyManpowerCost: int = 0

# ── MOVEMENT POINTS ───────────────────────────────────────────────────────────
# Civ-style: each army gets maxMovementPoints per turn, spent when entering tiles.
# Terrain and winter conditions increase tile entry cost.  Armies with the
# "Cold Weather" tag in armyTags ignore winter cost penalties.
var maxMovementPoints: int = 3
var currentMovementPoints: int = 3

# ── ARMY TAGS ─────────────────────────────────────────────────────────────────
# Populated from army_templates.csv armyMods column (pipe-delimited).
# Used by the movement and winter-drain systems to grant terrain exemptions.
# Examples: "Cold Weather", "Naval Power", "Redcoats", "Pirates"
var armyTags: Array = []

var ArmyName: String
#var Icon

var homeTile #each army must be built in a barracks, barracks gives +2 maxUnits to army per level
#army gets destroyed if homeTile changes hands
var parentCountry #parent country, homeland
var parentMilModifiers: Array = [] #list of national modifiers to armies
var beliefMilMods: Array = []   # mil mods sourced from country beliefs / axis; cleared on update
var parentWarEnemies: Array = [] #list of all enemies of the parent nation

var commander: governor #create a character to lead the army, has traits that give the army modifiers
var commanderModifiers1: Array = []
var commanderModifiers2: Array = []
var commanderModifiers3: Array = []

var armyCurse: spell #harmful spell from anybody
var armyCharm: spell #beneficial spell from player or ally

var maxUnits #number that determines how many units this army can hold, determined by technology, policies, leader
var unitsList: Array = []
var maxUnitLevel: int

var maxManpower:int #used to determine the maximum manpower of all units, used for a calculation for refilling army
var manpowerInArmy:int #actual manpower in armies, will be lower if units are damaged
#it costs costly resources but you can instantly refill your army's manpower, also takes from manpower pool

var maxWeapons: int
var weaponsInArmy: int

var armyIcon: Texture2D

#Combat Modifiers
var averageExperience: int #used to calculate the level of this army's level
var armyLevel: int #1 = recruit, 2 = regulars, 3 = expert, 4 = veteran, gives buffs per level
var armyAbility: int #recruit = 100, regulars = 105, expert = 110, veteran = 115.  Basically vets do 15% more damage
#armyAbility can also be improved/debuffed by other modifiers through tech, leader, modifiers, etc.
var armyStrength: int #basically how much health this unit has.  once  0, this army will be expelled from combat.  

var armyPunch: int
var armyBlock: int
var armyLaunch: int
var armyDefence: int
var armyMagicDefense: int
var armyShield: int
var armyMaxShield: int

# ── SPY EFFECTS ───────────────────────────────────────────────────────────────
var sabotaged: bool = false       # enemy spy Sabotage — blocks movement/action for the turn
var sabotageTimer: int = 0        # turns remaining before sabotage clears
var reconDebuffed: bool = false   # enemy spy Reconnaissance — reduces armyDefence in battle
var reconDebuffTimer: int = 0     # turns remaining before recon debuff clears
var propagandaBuff: int = 0       # flat attack bonus (and equivalent defence penalty) from propaganda events

# ── STATUS EFFECTS ─────────────────────────────────────────────────────────────
var armyStatusEffects: Array = []   # Array of {type: String, turnsLeft: int}
var attackBlocked: bool = false     # set by Routed/Pacified/Seduced/Love-Struck/Mutinous
var reinforcementBlocked: bool = false  # set by Supply Cut/Quarantined
var isGuarding: bool = false        # player-toggled: skip in end-turn army cycle

var armySiegeScore: float

var stationaryTurns: int = 0       # increments each turn army doesn't move; resets on movement
var movedThisTurn: bool = false    # set true by path_control when army spends movement points
var attacksFromCurrentTile: int = 0  # counts attacks without moving; resets on movement

var is_anarchist: bool = false  # anarchist armies auto-attack UK each turn, no shield, uncontrollable

#spawning and tiles
var awake: bool #if a unit isn't stationed in a barracks, it is awake.  if awake, can be controlled
var inTile: Tile #the tile this unit is currently in
var inTileTerrain #terrain type, used to determine unit stats and modifiers
var targetTile: Tile #the tile this unit would like to move to.  builds a path from this inTile to targetTile to determining
#pathfinding.
var pathLine #a tilequeue created for army pathfinding through the worldspace, if the army isn't going anywhere, = null

#combat
var combatModifiers: Array #if army is in active combat, this variable is true.  if else, is false
#when a unit detects another unit in the same tile, it will check if the enemy is in the unit is owned by 
#a country in parentWarEnemies.  if it is, the defender will create a Battle class node.  this temporarily consumes
#the unit and will spit it back out with changed stats after the battle finishes.  
var inRetreat: bool #if in retreat, will become uncontrollable until the retreat is finished
var retreatTarget: Tile

const unitUIScene = preload("res://unit_ui.tscn")

var raised: bool

const manaPanelScene = preload("res://mana_panel.tscn")

var tempResourcesDict: Dictionary = {}

var enemy: bool #for any non-playable country

var deleteMode: bool

signal armyDestroyed
var attackedThisTurn: bool = false  # set when this army attacks; drives Exhausted/Retreat
var isHolding: bool = false         # combat Hold stance; distinct from isGuarding
var holdPending: bool = false       # Hold declared after moving -> arms next turn

func buildSelf(Name, countryNode, TileNumber, icon):
	$VBoxContainer/BannerControl/BannerSprite.texture = icon
	enemy = false
	raised = false
	deleteMode = false
	armyIcon = icon
	ArmyName = Name
	parentCountry = countryNode
	match parentCountry.CID:
			"UK":
				enemy = true   # King George's forces are THE enemy in Uprisings
			"DEM", "EIG", "DUM":
				enemy = true   # keep for DODK compatibility
	if TileNumber != 0:
		for Tile in parentCountry.OwnedTileList:
			if Tile.tileNumber == TileNumber:
				inTile = Tile
				break
		if inTile == null:
			push_warning("army.buildSelf: tile " + str(TileNumber) + " not found in OwnedTileList for " + parentCountry.CID)
	for armyCostUI in $resourcescontainer.get_children():
		armyCostUI.buildSelf()

func updateArmyUI(): #call whenever attacked, or just whenever the player opens the screen
	for Unit in unitsList:
		Unit.getUnitAttributes()
	commanderCheck()
	surveySelf()
	updateUnitUIs()
	updateCommanderUI()
	updateFinalTotals()
	var gb := get_node_or_null("VBoxContainer/GuardControl/GuardButton") as CheckButton
	if gb:
		gb.set_pressed_no_signal(isGuarding)

func _commander_movement_bonus() -> int:
	if commander == null:
		return 0
	var mods: Array
	match commander.governorLevel:
		1: mods = commander.govMilModsLvl1
		2: mods = commander.govMilModsLvl2
		3: mods = commander.govMilModsLvl3
		_: mods = commander.govMilModsLvl1
	var bonus: int = 0
	for mm in mods:
		if not mm.disabled:
			match mm.milModType:
				"President":       bonus += 3
				"Election Season": bonus += 3
				"Mountain Pathfinder":
					if inTile != null and inTile.terrain == "Foothills":
						bonus += 1
	return bonus

func onTurnEnd():
	# Stationary turn tracking — must happen before movement points reset
	if movedThisTurn:
		stationaryTurns = 0
		attacksFromCurrentTile = 0
	else:
		stationaryTurns += 1
	movedThisTurn = false
	# Combat-economy per-turn reset
	attackedThisTurn = false
	if holdPending:
		isHolding = true
		holdPending = false
	# Restore full movement points at the start of each new turn
	currentMovementPoints = maxMovementPoints + _commander_movement_bonus()
	# Reset per-turn flags (re-derived below from active statuses)
	attackBlocked = false
	reinforcementBlocked = false
	# Tick spy effect timers
	if sabotageTimer > 0:
		sabotageTimer -= 1
		if sabotageTimer <= 0:
			sabotaged = false
	if reconDebuffTimer > 0:
		reconDebuffTimer -= 1
		if reconDebuffTimer <= 0:
			reconDebuffed = false
	# Tick per-unit temporary mods
	var unit_mods_changed: bool = false
	for Unit in unitsList:
		if Unit.tick_temp_mods():
			unit_mods_changed = true
	# Tick army-level status effects (DoT, decrement, removal)
	_tick_status_effects()
	# Apply movement reductions and re-derive blocked flags from remaining statuses
	_apply_status_flags()
	# Reinforce only if not supply-cut or quarantined
	if not reinforcementBlocked and parentCountry.TotalManpower > 0:
		var heal_rate: int = parentCountry.armyReinforceRate
		if parentCountry.selectedBeliefs.any(func(b): return b.beliefType == "Mary Edwards Walker"):
			heal_rate = int(float(heal_rate) * 1.15)
		for Unit in unitsList:
			Unit.refillManpower(heal_rate)
	if unit_mods_changed:
		surveySelf()
	# Master Baiter: +10% shield recharge per turn
	if commander != null and armyMaxShield > 0:
		var cmd_mods: Array
		match commander.governorLevel:
			1: cmd_mods = commander.govMilModsLvl1
			2: cmd_mods = commander.govMilModsLvl2
			3: cmd_mods = commander.govMilModsLvl3
			_: cmd_mods = commander.govMilModsLvl1
		for mod in cmd_mods:
			if mod.milModType == "Master Baiter" and not mod.disabled:
				armyShield = mini(armyShield + int(armyMaxShield * 0.1), armyMaxShield)
				break
	# Corruption disease check (Park Ranger grants immunity)
	if inTile != null and inTile.corruption > 0 and not _army_has_active_mod("Park Ranger"):
		if randf() * 100.0 < float(inTile.corruption):
			apply_status("Diseased", 2)
	updateArmyUI()

func apply_status(type: String, duration: int, magic_cost: int = 0) -> void:
	for s in armyStatusEffects:
		if s.type == type:
			s.turnsLeft = max(s.turnsLeft, duration)
			s.magicCostPerTurn = magic_cost
			surveySelf()
			_apply_status_flags()
			return
	armyStatusEffects.append({type = type, turnsLeft = duration, magicCostPerTurn = magic_cost})
	surveySelf()
	_apply_status_flags()

func _army_has_active_mod(mod_name: String) -> bool:
	for unit in unitsList:
		for mm in unit.militaryModifierList:
			if mm.milModType == mod_name and not mm.disabled:
				return true
	return false

func declareHold() -> void:
	# Combat Hold: instant if the army has not moved, else arms next turn.
	if movedThisTurn:
		holdPending = true
	else:
		isHolding = true
		surveySelf()


func cancelHold() -> void:
	isHolding = false
	holdPending = false


func combat_status_tag() -> String:
	var tags: Array = []
	if isHolding:
		tags.append("HOLD")
	if _has_status("Exhausted"):
		tags.append("EXH")
	if _has_status("Retreat"):
		tags.append("RET")
	return " ".join(tags)


func _has_status(type: String) -> bool:
	for s in armyStatusEffects:
		if s.type == type:
			return true
	return false

func _tick_status_effects() -> void:
	var to_remove: Array = []
	for s in armyStatusEffects:
		# Magic upkeep: sustained protector buffs drain magic each turn
		var magic_cost: int = s.get("magicCostPerTurn", 0)
		if magic_cost > 0:
			if parentCountry != null and parentCountry.TotalMagic >= magic_cost:
				parentCountry.TotalMagic -= magic_cost
			else:
				to_remove.append(s)
				continue
			# Sustained effects don't expire naturally — only when magic runs dry
			continue
		match s.type:
			"Burning":
				calculateDefenderResults("fire", 5 * max(1, unitCount))
			"Diseased":
				calculateDefenderResults("disease", 3 * max(1, unitCount))
			"Quarantined":
				calculateDefenderResults("disease", max(1, unitCount))
		s.turnsLeft -= 1
		if s.turnsLeft <= 0:
			to_remove.append(s)
	for s in to_remove:
		armyStatusEffects.erase(s)
	if to_remove.size() > 0:
		surveySelf()

func _apply_status_effects_to_stats() -> void:
	for s in armyStatusEffects:
		match s.type:
			"Exhausted":
				armyPunch = int(armyPunch * 0.9)
				armyLaunch = int(armyLaunch * 0.9)
			"Stunned":
				armyPunch = 0
			"Suppressed":
				armyLaunch = 0
			"Shaken":
				armyBlock = int(float(armyBlock) * 0.5)
			"Terrified":
				armyPunch = int(float(armyPunch) * 0.5)
				armyBlock = int(float(armyBlock) * 0.7)
			"Routed":
				armyPunch = 0
				armyDefence = int(float(armyDefence) * 0.5)
			"Blinded":
				armyLaunch = int(float(armyLaunch) * 0.5)
				armyDefence = int(float(armyDefence) * 0.5)
			"Hexed":
				armyMagicDefense = 0
			"Demoralized":
				armyPunch = int(float(armyPunch) * 0.8)
				armyBlock = int(float(armyBlock) * 0.8)
			"Waterlogged":
				armyPunch  = int(float(armyPunch)  * 0.8)
				armyLaunch = int(float(armyLaunch) * 0.8)
			"Frostbitten":
				armyPunch  = int(float(armyPunch)  * 0.7)
				armyLaunch = int(float(armyLaunch) * 0.7)
			"Seduced":
				armyPunch = 0
			"Starstruck":
				armyPunch   = int(float(armyPunch)   * 0.7)
				armyLaunch  = int(float(armyLaunch)  * 0.7)
				armyBlock   = int(float(armyBlock)   * 0.7)
				armyDefence = int(float(armyDefence) * 0.7)
			"Hangover":
				armyPunch   = int(float(armyPunch)   * 0.5)
				armyLaunch  = int(float(armyLaunch)  * 0.5)
				armyBlock   = int(float(armyBlock)   * 0.5)
				armyDefence = int(float(armyDefence) * 0.5)
			"Love-Struck":
				armyPunch = int(float(armyPunch) * 0.3)
				armyBlock = int(float(armyBlock) * 0.3)
			"Mutinous":
				armyPunch = int(float(armyPunch) * 0.6)
			# ── USA PROTECTOR BUFFS ──────────────────────────────────────────────
			"Mothman Presence":
				armyLaunch  += 20
				armyDefence += 15
			"Jersey Devil's Fury":
				armyPunch  += 25
				armyLaunch += 10
				armyBlock  += 10
			"Wood Booger's Solidarity":
				armyBlock  += 30
				armyPunch  += 15
			"Thunderbird's Sovereignty":
				armyLaunch += 25
				armyPunch  += 10
			"Headless Terror":
				armyPunch  += 20
				armyBlock  += 10
			"Chessie's Blessing":
				armyBlock   += 20
				armyDefence += 15
			"Bell Witch's Harassment":
				armyPunch   += 15
				armyDefence += 20
			"Old Ironsides' Hull":
				armyShield += 30
				armyBlock  += 20
			"Valley Forge's Will":
				armyPunch   += 10
				armyBlock   += 25
				armyDefence += 20
			"Snallygaster's Claim":
				armyPunch  += 20
				armyLaunch += 10
				armyBlock  += 10
			"Paul Revere's Ride":
				armyLaunch += 15
				armyPunch  += 10
			"Liberty Bell's Resonance":
				armyBlock   += 25
				armyDefence += 15
			"Green Mountain Haunting":
				armyBlock   += 20
				armyDefence += 15
			"Presidential Decree":
				armyPunch   += 20
				armyBlock   += 20
				armyLaunch  += 15
				armyDefence += 15
			"Skunk Ape's Domain":
				armyPunch += 20
				armyBlock += 15
			"Eternal Vigilance":
				armyBlock  += 25
				armyPunch  += 10
			"Lincoln's Mandate":
				armyPunch   += 15
				armyBlock   += 15
				armyLaunch  += 15
				armyDefence += 10
			# ── DOCTRINE AURA BUFFS ──────────────────────────────────────────────
			"Spirit of the General":
				armyPunch += 15
			# Presidential aura buffs (Ualani's intro gift)
			"Beautiful Flower":
				armyDefence += 3
			"Executive Enforcer":
				armyPunch += 3
			# ── LOYAL GOVERNOR BUFFS ─────────────────────────────────────────────
			"Mercenary Zeal":
				armyPunch += 2  # Border Mercenary coin pact — timed 10 turns
			"Iron Discipline":
				armyDefence += 1  # Border Mercenary discipline — permanent (duration 9999)
			# ── CANADIAN PROTECTOR BUFFS ─────────────────────────────────────────
			"Le Wendigo's Hunger":
				armyPunch += 30
			"Loup-Garou's Frenzy":
				armyPunch   += 25
				armyBlock   += 15
				armyDefence += 10
			"Feux Follets' Misdirection":
				armyDefence += 25
				armyBlock   += 15
			"Mishepeshu's Depths":
				armyBlock   += 20
				armyDefence += 20
			"La Corriveau's Cage":
				armyLaunch += 20
				armyPunch  += 15
			"Le Carcajou's Tenacity":
				armyPunch   += 20
				armyBlock   += 15
				armyDefence += 10
			"La Chasse-Galerie":
				armyPunch  += 15
				armyLaunch += 15
			"Le Gougou's Terror":
				armyPunch   += 15
				armyDefence += 20
	# Combat Hold stance: defensive bonus (distinct from the end-turn Guard toggle)
	if isHolding:
		armyBlock += 20
		armyDefence += 20
	# Guard bonus applied last so status-effect penalties don't erase it
	var glvl: int = _guard_level()
	if glvl > 0:
		var guard_mult: float = 1.0 + 0.15 * float(glvl)
		armyBlock   = int(float(armyBlock)   * guard_mult)
		armyDefence = int(float(armyDefence) * guard_mult)

func _apply_status_flags() -> void:
	for s in armyStatusEffects:
		match s.type:
			"Routed", "Pacified", "Seduced", "Love-Struck":
				attackBlocked = true
			"Retreat":
				attackBlocked = true
			"Stunned":
				attackBlocked = true
			"Supply Cut", "Quarantined":
				reinforcementBlocked = true
			"Mutinous":
				if randf() < 0.5:
					attackBlocked = true
			"Exhausted":
				currentMovementPoints = min(currentMovementPoints, 1)
			"Bogged Down":
				currentMovementPoints = 0
			"Paul Revere's Ride":
				currentMovementPoints += 3
			"La Chasse-Galerie":
				currentMovementPoints += 4

func addUnitToArmy(unitToAdd):
	if unitsList.size() >= 2:
		push_warning("Army '%s': cannot add more than 2 units." % ArmyName)
		return
	unitsList.append(unitToAdd)
	#unitToAdd.updateArmy.connect(surveySelf)
	$UnitContainer.add_child(unitToAdd)
	var newUnitUI = unitUIScene.instantiate()
	newUnitUI.buildSelf(unitToAdd, parentCountry)
	$ScrollContainer/UnitUIContainer.add_child(newUnitUI)
	#updateArmyUI()

func updateUnitUIs(): #call after battle, new unit, changed unit, any change to any thing in the army
	for unitUIScene in $ScrollContainer/UnitUIContainer.get_children():
		unitUIScene.updateUI()

func updateCommanderUI():
	if commander != null:
		$CommanderButton.icon = commander.governorTexture
		$CommanderLabel.text = str(commander.governorType)
		$CommanderButton.modulate = _commander_portrait_modulate()
	else:
		$CommanderButton.icon = load("res://art assets/finishedAssets/Panels/armypanelfinishedui/IMG_1564.PNG")
		$CommanderLabel.text = "No Commander"
		$CommanderButton.modulate = Color.WHITE

func _commander_portrait_modulate() -> Color:
	var ratio: float = 1.0
	if maxManpower > 0:
		ratio = clampf(float(manpowerInArmy) / float(maxManpower), 0.0, 1.0)
	var r: float = 1.0
	var g: float = 0.3 + 0.7 * ratio
	var b: float = 0.3 + 0.7 * ratio
	if armyShield > 0:
		r *= 0.75
		g *= 0.75
		b = minf(b + 0.5, 1.0)
	return Color(r, g, b, 1.0)

func updateFinalTotals():
	$resourcescontainer/armyCostUI.updateSelf(armyPunch,armyPunch)
	$resourcescontainer/armyCostUI2.updateSelf(armyLaunch, armyLaunch)
	$resourcescontainer/armyCostUI3.updateSelf(armyShield, armyMaxShield)
	$resourcescontainer/armyCostUI4.updateSelf(armyBlock, armyBlock)
	$resourcescontainer/armyCostUI5.updateSelf(armyDefence, armyDefence)
	$resourcescontainer/armyCostUI6.updateSelf(armyMagicDefense, armyMagicDefense)
	
	$manpowerweaponscontainer/manpowercontrol/Manpower/manpowerlabel.text = str(manpowerInArmy, maxManpower)
	$manpowerweaponscontainer/weaponscontrol/Weapons/weaponslabel. text = str(weaponsInArmy, maxWeapons)
	if $ScrollContainer2/VBoxContainer.get_children() != null:
		for manaPanel in $ScrollContainer2/VBoxContainer.get_children():
			manaPanel.queue_free()
	if armyFoodCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Food", -armyFoodCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyWoodCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Wood", -armyWoodCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyGoldCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Gold", -armyGoldCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyMetalCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Metal", -armyMetalCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyManpowerCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Manpower", -armyManpowerCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyWeaponsCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Weapons", -armyWeaponsCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyMagicCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Magic", -armyMagicCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyScienceCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Science", -armyScienceCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyCultureCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Culture", -armyCultureCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyInfluenceCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Influence", -armyInfluenceCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyHarmonyCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Harmony", -armyHarmonyCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyFaithCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Faith", -armyFaithCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)

var unitCount: int

func surveySelf():
	maxUnitLevel = 0
	calculateMaxUnitLevel()
	armyPunch= 0
	armyBlock = 0
	armyLaunch = 0
	armyDefence = 0
	armyShield = 0
	armyMaxShield = 0
	armyMagicDefense = 0
	maxManpower = 0
	manpowerInArmy = 0
	maxWeapons = 0
	weaponsInArmy = 0
	armyFoodCost = 0
	armyWoodCost = 0
	armyGoldCost = 0
	armyMetalCost = 0
	armyManpowerCost = 0
	armyWeaponsCost = 0
	armyMagicCost = 0
	armyScienceCost = 0
	armyCultureCost = 0
	armyInfluenceCost = 0
	armyHarmonyCost = 0
	armyFaithCost = 0
	armySiegeScore = 0
	unitCount = 0
	for Unit in unitsList:
		unitCount += Unit.unitLevel
	var minSize: int = (unitCount * 210)
	$ScrollContainer/UnitUIContainer.set_custom_minimum_size(Vector2(minSize, 0))
	armySiegeScore = unitCount * 0.1
	if inTile != null:
		armySiegeScore *= inTile.get_siege_difficulty()
	# CannonBlast: artillery adds bonus siege progress (doubled with Tempering)
	var cannon_count: int = 0
	for Unit in unitsList:
		for mm in Unit.militaryModifierList:
			if mm.milModType == "CannonBlast" and not mm.disabled:
				cannon_count += 1
				break
	if cannon_count > 0:
		var has_tempering = parentCountry != null and parentCountry.unlockedTechnologies.any(func(t): return t.techName == "Tempuring")
		var cannon_siege_bonus: float = float(cannon_count) * (0.3 if has_tempering else 0.15)
		armySiegeScore += cannon_siege_bonus
	for Unit in unitsList:
		Unit.enableMilModType("All")
		if Unit.unitCurrentManpower < Unit.unitMaxManpower:
			armyManpowerCost += (Unit.unitLevel * (-1 * parentCountry.armyReinforceRate)) #replace -3 with - var reinforceRaisedRate
		if Unit.unitCurrentManpower == 0:
			Unit.disableMilModType("All") #disable all milmods which are 
				#reliant on manpower.  all mil mods are reliant on manpow
		#if parentCountry.TotalManpower > 0:
			#Unit.refillManpower(parentCountry.armyReinforceRate)
				#Unit.hurt() #hurt takes the level of the unit down, and deletes the unit if reaches level 0.
		if parentCountry.TotalWeapons <= 0:
			Unit.disableMilModType("Weapons")
		if parentCountry.TotalWood <= 0:
			Unit.disableMilModType("Wood")
		if parentCountry.TotalHappiness <= 0:
			Unit.disableMilModType("Happiness")
			# unitsWillBecomeMutinous
		if parentCountry.TotalCulture <= 0:
			# TotalCulture now covers both Culture and old Faith
			Unit.disableMilModType("Culture")
		# TotalFaith removed — merged into TotalCulture
		if parentCountry.TotalInfluence <= 0:
			Unit.disableMilModType("Influence")
		if parentCountry.TotalDollars <= 0:
			Unit.disableMilModType("Gold")
			# unitsWon'tListenToOrders
		if parentCountry.TotalScience <= 0:
			Unit.disableMilModType("Science")
		if parentCountry.TotalMagic <= 0:
			Unit.disableMilModType("Magic")
			# brings down spell defence
		if parentCountry.TotalFood <= 0:
			Unit.disableMilModType("Food")
			# slowly kills units
		if parentCountry.TotalMetal <= 0:
			Unit.disableMilModType("Metal")
			# prevents units from replenishing armor
		Unit.currentTerrain    = inTile.terrain if inTile != null else ""
		Unit.currentStorm      = inTile.stormType if (inTile != null and inTile.stormActive) else ""
		Unit.currentState      = inTile.tileContinent if inTile != null else ""
		Unit.inIvyLeagueTile   = inTile.has_special_feature("Ivy League") if inTile != null else false
		Unit.inFortifiedTile   = (inTile != null and (inTile.has_building("Barracks") or inTile.has_building("Fortress")))
		Unit.inHomeTile        = (inTile != null and inTile.tileOwner == parentCountry.CID)
		Unit.inEntrenched      = (stationaryTurns >= 3)
		Unit.inCoastalTile     = (inTile != null and inTile.isCoastal)
		Unit.armyDemoralized   = _has_status("Demoralized")
		Unit.calculateMilMods()
		armyPunch += Unit.unitOffensiveScore
		armyBlock += Unit.unitDefensiveScore
		maxManpower += Unit.unitMaxManpower
		manpowerInArmy += Unit.unitCurrentManpower
		maxWeapons += Unit.unitMaxWeapons
		weaponsInArmy += Unit.unitCurrentWeapons
		armyLaunch += Unit.unitRangedOffence
		armyDefence += Unit.unitRangedDefence
		armyMagicDefense += Unit.unitMagicDefence
		armyShield += Unit.unitShield
		armyMaxShield += Unit.unitMaxShield
		var uLV = Unit.unitLevel
		match Unit.unitOre.oreType:
			"Copper":
				armyMetalCost += uLV
				armyGoldCost += uLV
			"Gold":
				armyGoldCost += (2*uLV)
			"Wood":
				armyWoodCost += uLV
			"Iron":
				armyMetalCost += (3*uLV)
				armyGoldCost += uLV
			"Ivoroid":
				armyWoodCost += uLV
				armyMetalCost += (2*uLV)
		match Unit.unitWeapon.weaponType:
			"Spear", "Club", "Dagger", "Atlatl":
				armyWeaponsCost += uLV
			"Machete", "Macuahitl", "Single Axe", "Mace":
				armyWeaponsCost += (2 * uLV)
			"Flail", "Shortsword", "Pike", "Cutlass":
				armyWeaponsCost += (3 * uLV)
			"War Hammer", "War Axe", "War Sword", "Cavalry Sword", "Flintlock":
				armyWeaponsCost += (4 * uLV)
			"Officer Sword", "Brown Bess", "Field Cannon":
				armyWeaponsCost += (5 * uLV)
			"Marine Mameluke", "Percussion Cap", "Field Gun":
				armyWeaponsCost += (6 * uLV)
			"Lever Repeater", "Howitzer":
				armyWeaponsCost += (7 * uLV)
			"Mortar":
				armyWeaponsCost += (8 * uLV)
		if parentCountry != null: #find costs and savings from country specific modifiers here
			for law in parentCountry.lawsInConstitution:
				if law.lawType == "Mercantilism":
					armyHarmonyCost += (2*uLV)
	if commander != null:
		var mm: float = 1.0 + (float(commander.morale) / 100.0) * 0.25
		armyPunch   = int(float(armyPunch)   * mm)
		armyDefence = int(float(armyDefence) * mm)
		# Experienced Fisherman: +1 attack per gov level when in wetlands tile
		if inTile != null and inTile.terrain == "Wetlands":
			var cmd_mods: Array
			match commander.governorLevel:
				1: cmd_mods = commander.govMilModsLvl1
				2: cmd_mods = commander.govMilModsLvl2
				3: cmd_mods = commander.govMilModsLvl3
				_: cmd_mods = commander.govMilModsLvl1
			for mod in cmd_mods:
				if mod.milModType == "Experienced Fisherman" and not mod.disabled:
					armyPunch += commander.governorLevel
					break
	if propagandaBuff != 0:
		armyPunch   += propagandaBuff
		armyDefence -= propagandaBuff
	_apply_status_effects_to_stats()

func calculateMaxUnitLevel():
	if inTile != null:
		for building in inTile.tileBuildingsList:
			if building.buildingType == "Barracks":
				maxUnitLevel = building.buildingLevel

signal raisingArmy

func raiseSelf():
	if inTile == null:
		push_warning("Army '%s': raiseSelf() skipped — inTile is null" % ArmyName)
		return
	raised = true
	emit_signal("raisingArmy", self, parentCountry, inTile)

func _on_raise_army_pressed() -> void:
	if inTile == null:
		push_warning("Army '%s': raise pressed but inTile is null" % ArmyName)
		return
	raised = true
	emit_signal("raisingArmy", self, parentCountry, inTile)

func addUnitCommander(newCommander):
	commander = newCommander
	var passes = 2 if commander.isVicePresident else 1
	for i in passes:
		for MilMod in commander.govMilModsLvl1:
			commanderModifiers1.append(MilMod)
		for MilMod in commander.govMilModsLvl2:
			commanderModifiers2.append(MilMod)
		for MilMod in commander.govMilModsLvl3:
			commanderModifiers3.append(MilMod)
	#updateArmyUI()

func applyCountryBeliefMilMods() -> void:
	# Clear previously-applied belief mods from all units before re-applying.
	# Belief mods are tagged via beliefMilMods so we can track and remove them.
	for Unit in unitsList:
		for mm in beliefMilMods:
			Unit.removeMilMod(mm)
	beliefMilMods.clear()

	if parentCountry == null:
		return

	# Collect which mod types to grant based on active beliefs and axis level.
	var modsToGrant: Array[String] = []

	for belief in parentCountry.selectedBeliefs:
		match belief.beliefType:
			"George Washington":
				pass  # Handled by _apply_ualani_aura() adjacency in world.gd
			"Harriet Tubman":
				modsToGrant.append("Combahee River Raid")
			"Abraham Lincoln":
				modsToGrant.append("Emancipation Advance")
				modsToGrant.append("Red Badge of Courage")
			"Theodore Roosevelt":
				modsToGrant.append("Rough Rider's Charge")
			"Frederick Douglass":
				modsToGrant.append("North Star Address")
			"Sitting Bull":
				modsToGrant.append("Little Bighorn Ambush")
			"Inland Maritime Expertise":
				modsToGrant.append("Woodsman")
			"Defense Production Act":
				modsToGrant.append("Vanguard")
			"National Parks Act":
				modsToGrant.append("Woodsman")
			"War Measures Act":
				modsToGrant.append("Vanguard")
			"Laura Secord":
				modsToGrant.append("Secord's Alert")
			"Louis Riel":
				modsToGrant.append("Batoche's Stand")
			"Roméo Dallaire":
				modsToGrant.append("Peacekeeping Mandate")

	# PROT_08 (Old Ironsides) agreed — USS Constitution Support for all armies
	if parentCountry.CountryFlags.has("prot_08_agreed"):
		modsToGrant.append("USS Constitution Support")

	# churchLevel ±3 axis grants
	match parentCountry.churchLevel:
		3:
			modsToGrant.append("Entrenched")
		-3:
			modsToGrant.append("Sharpshooter")

	# Instantiate and apply to all units.
	var milModScene = preload("res://mil_mod.tscn")
	for modType in modsToGrant:
		var newMod = milModScene.instantiate()
		newMod.buildSelf(modType)
		beliefMilMods.append(newMod)
		for Unit in unitsList:
			Unit.addMilMod(newMod)

func commanderCheck():
	if commander != null:
		$CommanderButton.visible = true
		$CommanderButton.icon = commander.governorTexture
		match commander.governorLevel:
			1:
				for MilMod in commanderModifiers1:
					for Unit in unitsList:
						Unit.addMilMod(MilMod)
			2:
				for MilMod in commanderModifiers2:
					for Unit in unitsList:
						Unit.addMilMod(MilMod)
			3:
				for MilMod in commanderModifiers3:
					for Unit in unitsList:
						Unit.addMilMod(MilMod)

signal commanderButtonPressed
func _on_commander_button_pressed() -> void:
	# Pass both the current commander (may be null) AND this army so the
	# world can decide whether to show details or open a commander picker.
	emit_signal("commanderButtonPressed", commander, self)

signal battleBuilt

func calculateBattle(armyPath, type, attacker, defenderAPF, lastSelectedPathPoint):
	var newBattle = load("res://Game Scenes and Scripts/battle.tscn").instantiate()
	newBattle.buildSelf(type, attacker, self)
	defenderAPF.showBattle(newBattle)
	newBattle.sendDefenderResults.connect(calculateDefenderResults)
	newBattle.sendAttackerResults.connect(calculateAttackerResults)
	newBattle.deleteBattles.connect(lastSelectedPathPoint.deleteNeighborBattles)

func calculateAttackerResults(type: String, manpowerLossAmount: int) -> void:
	if manpowerLossAmount <= 0:
		return
	var living = unitsList.filter(func(u): return u.unitCurrentManpower > 0)
	var damagePerUnit = int(manpowerLossAmount / max(1, living.size()))
	for Unit in living:
		Unit.takeLosses(type, float(damagePerUnit))
	if type == "ranged":
		for Unit in unitsList:
			Unit.tick_reload()
	surveySelf()
	if manpowerInArmy <= 0:
		emit_signal("armyDestroyed", self)

func calculateDefenderResults(type: String, manpowerLossAmount: int) -> void:
	if manpowerLossAmount <= 0:
		return
	var living = unitsList.filter(func(u): return u.unitCurrentManpower > 0)
	var damagePerUnit = int(manpowerLossAmount / max(1, living.size()))
	for Unit in living:
		Unit.takeLosses(type, float(damagePerUnit))
	surveySelf()
	if manpowerInArmy <= 0:
		emit_signal("armyDestroyed", self)

var bannerButtonScene= load("res://banner_button.tscn")

func _on_banner_button_pressed() -> void:
	if $VBoxContainer/BannerControl/BannerContainer.get_children() != null:
		for bannerButton in $VBoxContainer/BannerControl/BannerContainer.get_children():
			bannerButton.queue_free()
	if $VBoxContainer/BannerControl/BannerContainer.visible == false:
		for Texture in parentCountry.armyIconList:
			var newBannerButton = bannerButtonScene.instantiate()
			newBannerButton.buildSelf(Texture)
			newBannerButton.bannerButtonPressed.connect(changeArmyBanner)
			$VBoxContainer/BannerControl/BannerContainer.add_child(newBannerButton)
		$VBoxContainer/BannerControl/Sprite2D.visible = true
		$VBoxContainer/BannerControl/BannerContainer.visible = true
	else:
		$VBoxContainer/BannerControl/BannerContainer.visible = false
		$VBoxContainer/BannerControl/Sprite2D.visible = false

signal changeBanner
func changeArmyBanner(icon):
	armyIcon = icon
	$VBoxContainer/BannerControl/BannerSprite.texture = armyIcon
	$VBoxContainer/BannerControl/Sprite2D.visible = false
	$VBoxContainer/BannerControl/BannerContainer.visible = false

func _guard_level() -> int:
	if not isGuarding:
		return 0
	if parentCountry == null:
		return 1
	const MIL_ORG_TECHS := ["Organization", "Logistics", "Tactics", "Authority"]
	var bonus: int = 0
	for tech in parentCountry.unlockedTechnologies:
		if tech.techName in MIL_ORG_TECHS:
			bonus += 1
	return clampi(1 + bonus, 1, 4)

func cancelGuard() -> void:
	isGuarding = false
	var guard_btn = get_node_or_null("VBoxContainer/GuardButton")
	if guard_btn != null:
		guard_btn.set_pressed_no_signal(false)

func _on_guard_button_toggled(button_pressed: bool) -> void:
	isGuarding = button_pressed

#=================
#Helpers
#================
func has_ready_ranged_units() -> bool:
	for Unit in unitsList:
		if Unit.can_fire_ranged():
			return true
	return false

func has_melee_units() -> bool:
	for Unit in unitsList:
		if Unit.can_charge_melee():
			return true
	return false

func tick_all_reloads() -> void:
	for Unit in unitsList:
		if Unit.is_reloading():
			Unit.tick_reload()

func get_army_weapon_classes() -> Dictionary:
	var counts = {"Saber": 0, "Musket": 0, "Artillery": 0, "Legacy": 0}
	for Unit in unitsList:
		if Unit.unitWeapon != null:
			var wClass = Unit.unitWeapon.weaponClass
			if counts.has(wClass):
				counts[wClass] += 1
			else:
				counts[wClass] = 1
	return counts

func is_pure_artillery() -> bool:
	var classes = get_army_weapon_classes()
	return classes.get("Artillery", 0) > 0 and \
		   classes.get("Saber", 0) == 0 and \
		   classes.get("Musket", 0) == 0
