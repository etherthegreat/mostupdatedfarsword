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

var ArmyName: String
#var Icon

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

var maxWeapons: int
var weaponsInArmy: int

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

func buildSelf(Name, countryNode, TileNumber):
	#print("wowo so cool")
	raised = false
	ArmyName = Name
	parentCountry = countryNode
	if TileNumber != 0:
		for Tile in parentCountry.OwnedTileList:
			if Tile.tileNumber == TileNumber:
				inTile = Tile
			else:
				print("error 1 - no matching tile in owned tile list, army, line 93")
	#print("UnitUIContainer 1 Children", $RadicalCoolTestPanel/UnitUIContainer.get_children())
	pass

func updateArmyUI(): #call whenever attacked, or just whenever the player opens the screen
	commanderCheck()
	surveySelf()
	updateUnitUIs()
	updateCommanderUI()
	updateFinalTotals()
	pass

func addUnitToArmy(unitToAdd):
	unitsList.append(unitToAdd)
	unitToAdd.updateArmy.connect(surveySelf)
	$UnitContainer.add_child(unitToAdd)
	var newUnitUI = unitUIScene.instantiate()
	newUnitUI.buildSelf(unitToAdd)
	$ScrollContainer/UnitUIContainer.add_child(newUnitUI)
	updateArmyUI()
	pass


func updateUnitUIs(): #call after battle, new unit, changed unit, any change to any thing in the army
	for unitUIScene in $ScrollContainer/UnitUIContainer.get_children():
		unitUIScene.updateUI()
	pass

func updateCommanderUI():
	if commander != null:
		$CommanderButton.icon = commander.governorTexture
		$CommanderLabel.text = str(commander.governorType)
	else:
		$CommanderButton.icon = load("res://art assets/finishedAssets/Panels/armypanelfinishedui/IMG_1564.PNG")
		$CommanderLabel.text = "No Commander"
	pass

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
		newMP.buildSelf("Food", armyFoodCost, tempResourcesDict)
	if armyWoodCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Wood", armyWoodCost, tempResourcesDict)
	if armyGoldCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Gold", armyGoldCost, tempResourcesDict)
	if armyMetalCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Metal", armyMetalCost, tempResourcesDict)
	if armyManpowerCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Manpower", armyManpowerCost, tempResourcesDict)
	if armyWeaponsCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Weapons", armyWeaponsCost, tempResourcesDict)
	if armyMagicCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Magic", armyMagicCost, tempResourcesDict)
	if armyScienceCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Science", armyScienceCost, tempResourcesDict)
	if armyCultureCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Culture", armyCultureCost, tempResourcesDict)
	if armyInfluenceCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Influence", armyInfluenceCost, tempResourcesDict)
	if armyHarmonyCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Harmony", armyHarmonyCost, tempResourcesDict)
	if armyFaithCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Faith", armyFaithCost, tempResourcesDict)
	pass

func surveySelf():
	maxUnitLevel = 0
	calculateMaxUnitLevel()
	armyPunch= 0
	armyBlock = 0
	armyLaunch = 0
	armyDefence = 0
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
	print("Surveying Self")
	var unitCount: int
	unitCount = 0
	for Unit in unitsList:
		unitCount += 1
	var minSize: int = (unitCount * 210)
	$ScrollContainer/UnitUIContainer.set_custom_minimum_size(Vector2(minSize, 0))
	for Unit in unitsList:
		Unit.enableMilModType("All")
		if Unit.unitCurrentManpower < Unit.unitMaxManpower:
			armyManpowerCost += (Unit.unitLevel * (-1 * parentCountry.armyReinforceRate)) #replace -3 with - var reinforceRaisedRate
		if Unit.unitCurrentManpower == 0:
			Unit.disableMilModType("All") #disable all milmods which are 
				#reliant on manpower.  all mil mods are reliant on manpow
		if parentCountry.TotalManpower > 0:
			Unit.refillManpower(parentCountry.armyReinforceRate)
				#Unit.hurt() #hurt takes the level of the unit down, and deletes the unit if reaches level 0.
		if parentCountry.TotalWeapons > 0:
			Unit.disableMilModType("Weapons")
			#disable replenish weapons button when encamped
		if parentCountry.TotalWood > 0:
			Unit.disableMilModType("Wood")
			#disable build camp
		if parentCountry.TotalHarmony > 0:
			Unit.disableMilModType("Harmony")
			#unitsWillBecomeMutinous
		if parentCountry.TotalCulture > 0:
			Unit.disableMilModType("Culture")
		if parentCountry.TotalFaith > 0:
			Unit.disableMilModType("Faith")
		if parentCountry.TotalInfluence > 0:
			Unit.disableMilModType("Influence")
		if parentCountry.TotalGold > 0:
			Unit.disableMilModType("Gold")
			#unitsWon'tListen To Orders
		if parentCountry.TotalScience > 0:
			Unit.disableMilModType("Science")
		if parentCountry.TotalMagic > 0:
			Unit.disableMilModType("Magic")
			#brings down spell defence by -100%
		if parentCountry.TotalFood > 0:
			Unit.disableMilModType("Food")
			#slowly kills units
		if parentCountry.TotalMetal > 0:
			Unit.disableMilModType("Metal")
			#prevents units from replenishing armor
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
			"Spear" , "Club" , "Dagger", "Atlatl":
				armyWeaponsCost += uLV
			"Machete", "Macuahitl", "Single Axe", "Mace":
				armyWeaponsCost += (2*uLV)
			"Flail", "Shortsword", "Pike":
				armyWeaponsCost += (3*uLV)
			"War Hammer", "War Axe", "War Sword":
				armyWeaponsCost += (4*uLV)
		if parentCountry != null: #find costs and savings from country specific modifiers here
			for law in parentCountry.lawsInConstitution:
				if law.lawType == "Mercantilism":
					armyHarmonyCost += (2*uLV)
	pass

func calculateMaxUnitLevel():
	if inTile != null:
		for building in inTile.tileBuildingsList:
			if building.buildingType == "Barracks":
				maxUnitLevel = building.buildingLevel
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
	updateArmyUI()
	pass

func commanderCheck():
	for Unit in $UnitContainer.get_children():
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
						for unitUIScene in $ScrollContainer/UnitUIContainer.get_children():
							unitUIScene.armyUpdateMilMods()
			2:
				for MilMod in commanderModifiers2:
					for Unit in unitsList:
						Unit.addMilMod(MilMod)
						#Unit.getUnitAttributes()
						for unitUIScene in $ScrollContainer/UnitUIContainer.get_children():
							unitUIScene.armyUpdateMilMods()
			3:
				for MilMod in commanderModifiers3:
					for Unit in unitsList:
						Unit.addMilMod(MilMod)
						#Unit.getUnitAttributes()
						for unitUIScene in $ScrollContainer/UnitUIContainer.get_children():
							unitUIScene.armyUpdateMilMods()
	else:
		print("no commander")
	pass

signal commanderButtonPressed
func _on_commander_button_pressed() -> void:
	emit_signal("commanderButtonPressed", commander)
	pass # Replace with function body.
