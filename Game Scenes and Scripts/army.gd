extends Control


class_name Army

var armyFoodCost: int = 0
var armyWoodCost: int = 0
var armyMetalCost: int = 0
var armyGoldCost: int = 0
var armyFaithCost: int = 0
var armyWeaponsCost: int = 0
var armyMagicCost: int = 0
var armyScienceCost: int = 0
var armyCultureCost: int = 0
var armyHarmonyCost: int = 0
var armyMandateCost: int = 0
var armyInfluenceCost: int = 0

var armyManpowerCost: int = 0

var ArmyName: String
var Icon

var homeTile #each army must be built in a barracks, barracks gives +2 maxUnits to army per level
#army gets destroyed if homeTile changes hands
var parentCountry: country #parent country, homeland
var parentMilModifiers: Array = [] #list of national modifiers to armies
var parentWarEnemies: Array = [] #list of all enemies of the parent nation

var commander: governor #create a character to lead the army, has traits that give the army modifiers
var commanderModifiers1: Array = []
var commanderModifiers2: Array = []
var commanderModifiers3: Array = []

var armyWizard: wizard #if null = true, can assign a wizard from your pool to this army.  each wizard has at least three spells
var wizardTraitModifiers: Array = []
var wizardSpells: Array = []

var maxUnits #number that determines how many units this army can hold, determined by technology, policies, leader
var unitsList: Array = []
var maxUnitLevel: int

var maxManpower:int #used to determine the maximum manpower of all units, used for a calculation for refilling army
var manpowerInArmy:int #actual manpower in armies, will be lower if units are damaged
#it costs costly resources but you can instantly refill your army's manpower, also takes from manpower pool

#Combat Modifiers
var averageExperience: int #used to calculate the level of this army's level
var armyLevel: int #1 = recruit, 2 = regulars, 3 = expert, 4 = veteran, gives buffs per level
var armyAbility: int #recruit = 100, regulars = 105, expert = 110, veteran = 115.  Basically vets do 15% more damage
#armyAbility can also be improved/debuffed by other modifiers through tech, leader, modifiers, etc.
var armyStrength: int #basically how much health this unit has.  once  0, this army will be expelled from combat.  

var armyAttackScore: int
var armyDefenseScore: int

#spawning and tiles
var awake: bool #if a unit isn't stationed in a barracks, it is awake.  if awake, can be controlled
var inTile: Tile #the tile this unit is currently in
var inTileTerrain #terrain type, used to determine unit stats and modifiers
var targetTile: Tile #the tile this unit would like to move to.  builds a path from this inTile to targetTile to determining
#pathfinding.
var pathLine #a line created for army pathfinding through the worldspace, if the army isn't going anywhere, = null

#combat
var inCombat: bool #if army is in active combat, this variable is true.  if else, is false
#when a unit detects another unit in the same tile, it will check if the enemy is in the unit is owned by 
#a country in parentWarEnemies.  if it is, the defender will create a Battle class node.  this temporarily consumes
#the unit and will spit it back out with changed stats after the battle finishes.  
var inRetreat: bool #if in retreat, will become uncontrollable until the retreat is finished
var retreatTarget: Tile

const unitUIScene = preload("res://unit_ui.tscn")

var raised: bool

#functions this code will do:
#display the units as UI objects in two places, in the army control panel, and on the bottom screen if the 
#army is selected on the map.  Will also display a UI icon/symbol above the province the army is stationed in (although
#maybe the actual organization of the armies will be done in the Tile script)
#can retire an army back to its homeTile, where it will make awake = false

func updateSelf(Name, countryNode, TileNumber):
	#print("wowo so cool")
	raised = false
	ArmyName = Name
	parentCountry = countryNode
	if TileNumber != 0:
		for Tile in parentCountry.OwnedTileList:
			if Tile.tileNumber == TileNumber:
				inTile = Tile
	#print("UnitUIContainer 1 Children", $RadicalCoolTestPanel/UnitUIContainer.get_children())
	
	for unitUIScene in $RadicalCoolTestPanel/UnitUIContainer.get_children():
		if is_instance_valid(unitUIScene):
			unitUIScene.queue_free()
	#print("UnitUiContainer Children", $RadicalCoolTestPanel/UnitUIContainer.get_children())
	if unitsList != null:
		for Unit in unitsList:
			#print("Unit in Radical Cool Panel", Unit, Unit.unitType)
			var newUnitUI = unitUIScene.instantiate()
			newUnitUI.assignUnit(Unit)
			newUnitUI.findMilMods(Unit)
			newUnitUI.updateControl
			$RadicalCoolTestPanel/UnitUIContainer.add_child(newUnitUI)
			#print("Unit", Unit.unitType, "Level", Unit.unitLevel)
	surveySelf()
	pass

var UnitConfirmationList: Array = []
func _process(delta: float) -> void:
	#print("unitslist", unitsList)
	#if UnitConfirmationList != null:
		#for Unit in UnitConfirmationList:
		#	UnitConfirmationList.erase(Unit)
	#if $RadicalCoolTestPanel/UnitContainer.get_children() != null:
		#for Unit in $RadicalCoolTestPanel/UnitContainer.get_children():
			#UnitConfirmationList.append(Unit)
		#if UnitConfirmationList == unitsList:
			#print("booyah confirmed same")
			#return
		#else:
			#unitsList = UnitConfirmationList
			#print("yucky had to change")
			#pass
	if maxUnitLevel != null:
		for unitUIScene in $RadicalCoolTestPanel/UnitUIContainer.get_children():
			unitUIScene.upgradeButtonCalculation(maxUnitLevel)
	pass

func addUnitToArmy(unitToAdd):
	unitsList.append(unitToAdd)
	unitToAdd.updateArmy.connect(surveySelf)
	$RadicalCoolTestPanel/UnitContainer.add_child(unitToAdd)
	#print("units listfrom addUnit", unitsList)
	#print("unitsConfirmation List", UnitConfirmationList)
	
	pass

func stopUpdatingUI():
	for unitUIScene in $RadicalCoolTestPanel/UnitUIContainer.get_children():
		unitUIScene.stopUpdating()
	pass

func startUpdatingUI():
	
	for unitUIScene in $RadicalCoolTestPanel/UnitUIContainer.get_children():
		unitUIScene.startUpdating()
	pass

func buildUnitUIs():
	
	pass

func surveySelf():
	maxUnitLevel = 0
	calculateMaxUnitLevel()
	armyAttackScore= 0
	armyDefenseScore = 0
	maxManpower = 0
	manpowerInArmy = 0
	
	maxManpower = 0
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
	print("Surveyingg Self")
	if raised == true || raised != true:
		#for Unit in unitsList:
			#var unitManpower: int = Unit.unitCurrentManpower
			#maxManpower += (Unit.unitLevel * Unit.unitMaxManpower)
		print(unitsList,"PEEEENNNNIIIIISSSS", $RadicalCoolTestPanel/UnitContainer.get_children())
		for Unit in unitsList:
			#print("unit level", Unit.unitLevel)
			#print("unit metal", Unit.unitMetal.oreType)
			Unit.enableMilModType("All")
			#manpower
			if Unit.unitCurrentManpower < Unit.unitMaxManpower:
				armyManpowerCost += (Unit.unitLevel * (-1 * parentCountry.armyReinforceRate)) #replace -3 with - var reinforceRaisedRate
			if Unit.unitCurrentManpower == 0:
				Unit.disableMilModType("All") #disable all milmods which are 
				#reliant on manpower.  most mil mods are reliant on manpow
			if parentCountry.TotalManpower > 0:
				Unit.refillManpower(parentCountry.armyReinforceRate)
			match Unit.unitMetal.oreType: 
				"Wood":
					armyWoodCost += (Unit.unitLevel * -1)
				"Copper":
					armyMetalCost += (Unit.unitLevel * -1)
				"Iron":
					armyMetalCost += (Unit.unitLevel * -3)
				"Gold":
					armyMetalCost += (Unit.unitLevel * -1)
					armyGoldCost += (Unit.unitLevel * -3)
				"Floodstone":
					armyMetalCost += (Unit.unitLevel * -1)
					armyMagicCost += (Unit.unitLevel * -3)
				#fill out the rest of the metals and ores.  also add "refined wood?" for a druid unlock?
			match Unit.unitWeapon.weaponType:
				"Atlatl":
					armyWeaponsCost += (Unit.unitLevel * -1)
				"Club":
					armyWeaponsCost += (Unit.unitLevel * -2)
				#fill out the rest of the weapons for match
			for MilMod in Unit.militaryModifierList:
				match MilMod.milModType:
					"Berserkers":
						armyHarmonyCost += (Unit.unitLevel * -2)
			if parentCountry.TotalWeapons > 0:
				Unit.disableMilModType("Weapons")
			if parentCountry.TotalWood > 0:
				Unit.disableMilModType("Wood")
			if parentCountry.TotalHarmony > 0:
				Unit.disableMilModType("Harmony")
			if parentCountry.TotalCulture > 0:
				Unit.disableMilModType("Culture")
			if parentCountry.TotalFaith > 0:
				Unit.disableMilModType("Faith")
			if parentCountry.TotalInfluence > 0:
				Unit.disableMilModType("Influence")
			if parentCountry.TotalGold > 0:
				Unit.disableMilModType("Gold")
			if parentCountry.TotalScience > 0:
				Unit.disableMilModType("Science")
			if parentCountry.TotalMagic > 0:
				Unit.disableMilModType("Magic")
			if parentCountry.TotalFood > 0:
				Unit.disableMilModType("Food")
			if parentCountry.TotalMetal > 0:
				Unit.disableMilModType("Metal")
			armyAttackScore += Unit.unitOffensiveScore
			armyDefenseScore += Unit.unitDefensiveScore
			maxManpower += Unit.unitMaxManpower
			manpowerInArmy += Unit.unitCurrentManpower
			#print("army metal maintenance cost", armyMetalCost)
			#print("army weapons maintenance cost", armyWeaponsCost)
		$MetalCost.text = str(armyMetalCost)
		$WeaponsCost.text = str(armyWeaponsCost)
		$HarmonyCost.text = str(armyHarmonyCost)
		$FoodCost.text = str(armyFoodCost)
		$MandateCost.text = str(armyMandateCost)
		$MagicCost.text = str(armyMagicCost)
		$FaithCost.text = str(armyFaithCost)
		$WoodCost.text = str(armyWoodCost)
		$HarmonyCost.text = str(armyHarmonyCost)
		$InfluenceCost.text = str(armyInfluenceCost)
		$GoldCost.text = str(armyGoldCost)
		$AttackDefencePanel/Attack.text = str(armyAttackScore)
		$AttackDefencePanel/Defense.text = str(armyDefenseScore)
		$AttackDefencePanel/Manpower.text = str(manpowerInArmy, "/", maxManpower)
		print("Yeehaw Cowboy")
	else:
		for Unit in unitsList:
		#manpower
			if Unit.unitCurrentManpower < Unit.unitMaxManpower:
				armyManpowerCost += (Unit.unitLevel * (-1 * parentCountry.armyReinforceRate)) #replace -3 with - var reinforceUnraisedRate
	pass

func calculateMaxUnitLevel():
	if inTile != null:
		for building in inTile.tileBuildingsList:
			if building.buildingType == "Barracks":
				maxUnitLevel = building.buildingLevel
				print("DRINKING", maxUnitLevel)
	pass

signal raisingArmy
func _on_raise_army_pressed() -> void:
	raised = true
	emit_signal("raisingArmy", self, parentCountry, inTile)
	pass # Replace with function body.

func addUnitCommander(newCommander):
	commander = newCommander
	for MilMod in commander.govMilModsLvl1:
		commanderModifiers1.append(MilMod)
	for MilMod in commander.govMilModsLvl2:
		commanderModifiers2.append(MilMod)
	for MilMod in commander.govMilModsLvl3:
		commanderModifiers3.append(MilMod)
	print("MILMODS IN 1", commanderModifiers1)
	commanderCheck()
	surveySelf()
	pass

func commanderCheck():
	for Unit in $RadicalCoolTestPanel/UnitContainer.get_children():
		if Unit.militaryModifierList != null:
			for MilMod in Unit.militaryModifierList:
				if MilMod.commanderMod == true:
					MilMod.queue_free()
	if commander != null:
		$CommanderButton.visible = true
		#print("The commander is in", commander, commander.governorLevel)
		$CommanderButton.icon = commander.governorTexture
		match commander.governorLevel:
			1:
				for MilMod in commanderModifiers1:
					for Unit in unitsList:
						Unit.addMilMod(MilMod)
						#Unit.getUnitAttributes()
						for unitUIScene in $RadicalCoolTestPanel/UnitUIContainer.get_children():
							unitUIScene.armyUpdateMilMods()
			2:
				for MilMod in commanderModifiers2:
					for Unit in unitsList:
						Unit.addMilMod(MilMod)
						#Unit.getUnitAttributes()
						for unitUIScene in $RadicalCoolTestPanel/UnitUIContainer.get_children():
							unitUIScene.armyUpdateMilMods()
			3:
				for MilMod in commanderModifiers3:
					for Unit in unitsList:
						Unit.addMilMod(MilMod)
						#Unit.getUnitAttributes()
						for unitUIScene in $RadicalCoolTestPanel/UnitUIContainer.get_children():
							unitUIScene.armyUpdateMilMods()
	pass

signal commanderButtonPressed
func _on_commander_button_pressed() -> void:
	emit_signal("commanderButtonPressed", commander)
	pass # Replace with function body.
