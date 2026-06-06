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

var armySiegeScore: float

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

func buildSelf(Name, countryNode, TileNumber, icon):
	#print("wowo so cool")
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
			else:
				print("error 1 - no matching tile in owned tile list, army, line 93")
	#print("UnitUIContainer 1 Children", $RadicalCoolTestPanel/UnitUIContainer.get_children())
	for armyCostUI in $resourcescontainer.get_children():
		armyCostUI.buildSelf()
	pass

func updateArmyUI(): #call whenever attacked, or just whenever the player opens the screen
	for Unit in unitsList:
		Unit.getUnitAttributes()
	commanderCheck()
	surveySelf()
	updateUnitUIs()
	updateCommanderUI()
	updateFinalTotals()
	pass

func onTurnEnd():
	if parentCountry.TotalManpower > 0:
		for Unit in unitsList:
			Unit.refillManpower(parentCountry.armyReinforceRate)
			print("unitREFILL", Unit.unitCurrentManpower, parentCountry.armyReinforceRate)
	updateArmyUI()
	pass

func addUnitToArmy(unitToAdd):
	unitsList.append(unitToAdd)
	#unitToAdd.updateArmy.connect(surveySelf)
	$UnitContainer.add_child(unitToAdd)
	var newUnitUI = unitUIScene.instantiate()
	newUnitUI.buildSelf(unitToAdd)
	$ScrollContainer/UnitUIContainer.add_child(newUnitUI)
	#updateArmyUI()
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
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyWoodCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Wood", armyWoodCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyGoldCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Gold", armyGoldCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyMetalCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Metal", armyMetalCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyManpowerCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Manpower", armyManpowerCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyWeaponsCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Weapons", armyWeaponsCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyMagicCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Magic", armyMagicCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyScienceCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Science", armyScienceCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyCultureCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Culture", armyCultureCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyInfluenceCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Influence", armyInfluenceCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyHarmonyCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Harmony", armyHarmonyCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	if armyFaithCost != 0:
		var newMP = manaPanelScene.instantiate()
		newMP.buildSelf("Faith", armyFaithCost, tempResourcesDict)
		$ScrollContainer2/VBoxContainer.add_child(newMP)
	pass

var unitCount: int

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
	armySiegeScore = 0
	print("Surveying Self")
	unitCount = 0
	for Unit in unitsList:
		unitCount += Unit.unitLevel
	var minSize: int = (unitCount * 210)
	$ScrollContainer/UnitUIContainer.set_custom_minimum_size(Vector2(minSize, 0))
	armySiegeScore = unitCount * 0.1
	if inTile != null:
		armySiegeScore *= inTile.get_siege_difficulty()
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
		if parentCountry.TotalHarmony <= 0:
			Unit.disableMilModType("Harmony")
			# unitsWillBecomeMutinous
		if parentCountry.TotalCulture <= 0:
			Unit.disableMilModType("Culture")
		if parentCountry.TotalFaith <= 0:
			Unit.disableMilModType("Faith")
		if parentCountry.TotalInfluence <= 0:
			Unit.disableMilModType("Influence")
		if parentCountry.TotalGold <= 0:
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

func raiseSelf():
	raised = true
	emit_signal("raisingArmy", self, parentCountry, inTile)
	pass

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
	#updateArmyUI()
	pass

func commanderCheck():
	if commander != null:
		$CommanderButton.visible = true
		#print("The commander is in", commander, commander.governorLevel)
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
	else:
		print("no commander")
	pass

signal commanderButtonPressed
func _on_commander_button_pressed() -> void:
	emit_signal("commanderButtonPressed", commander)
	pass # Replace with function body.

signal battleBuilt

var battleScene = preload("res://Game Scenes and Scripts/battle.tscn")
func calculateBattle(armyPath, type, attacker, defenderAPF, lastSelectedPathPoint):
	var newBattle = battleScene.instantiate()
	newBattle.buildSelf(type, attacker, self)
	defenderAPF.showBattle(newBattle)
	newBattle.sendDefenderResults.connect(calculateDefenderResults)
	newBattle.sendAttackerResults.connect(calculateAttackerResults)
	newBattle.deleteBattles.connect(lastSelectedPathPoint.deleteNeighborBattles)
	pass

func calculateAttackerResults(type: String, manpowerLossAmount: int) -> void:
	# Called when attacker takes counter-damage from defender
	if manpowerLossAmount <= 0:
		return
	var damagePerUnit = int(manpowerLossAmount / max(1, unitCount))
	for Unit in unitsList:
		Unit.takeLosses(type, float(damagePerUnit))
	# Also tick reload for all units (ranged combat round passed)
	if type == "ranged":
		for Unit in unitsList:
			Unit.tick_reload()
	surveySelf()
	# Check retreat threshold (25% manpower)
	if manpowerInArmy <= 0:
		deleteMode = true
	elif float(manpowerInArmy) / float(max(1, maxManpower)) < 0.25:
		inRetreat = true
		print(ArmyName, " is retreating! Manpower: ", manpowerInArmy, "/", maxManpower)

func calculateDefenderResults(type: String, manpowerLossAmount: int) -> void:
	if manpowerLossAmount <= 0:
		return
	var damagePerUnit = int(manpowerLossAmount / max(1, unitCount))
	for Unit in unitsList:
		Unit.takeLosses(type, float(damagePerUnit))
	surveySelf()
	if manpowerInArmy <= 0:
		deleteMode = true
	elif float(manpowerInArmy) / float(max(1, maxManpower)) < 0.25:
		inRetreat = true
		print(ArmyName, " is retreating! Manpower: ", manpowerInArmy, "/", maxManpower)

var bannerButtonScene= load("res://banner_button.tscn")

func _on_banner_button_pressed() -> void:
	if $VBoxContainer/BannerControl/BannerContainer.get_children() != null:
		for bannerButton in $VBoxContainer/BannerControl/BannerContainer.get_children():
			bannerButton.queue_free()
	if $VBoxContainer/BannerControl/BannerContainer.visible == false:
		for Texture in parentCountry.armyIconList:
			print("ANTICLIMATIC", parentCountry.armyIconList)
			var newBannerButton = bannerButtonScene.instantiate()
			newBannerButton.buildSelf(Texture)
			newBannerButton.bannerButtonPressed.connect(changeArmyBanner)
			$VBoxContainer/BannerControl/BannerContainer.add_child(newBannerButton)
		$VBoxContainer/BannerControl/Sprite2D.visible = true
		$VBoxContainer/BannerControl/BannerContainer.visible = true
	else:
		$VBoxContainer/BannerControl/BannerContainer.visible = false
		$VBoxContainer/BannerControl/Sprite2D.visible = false
	pass # Replace with function body.

signal changeBanner
func changeArmyBanner(icon):
	armyIcon = icon
	$VBoxContainer/BannerControl/BannerSprite.texture = armyIcon
	$VBoxContainer/BannerControl/Sprite2D.visible = false
	$VBoxContainer/BannerControl/BannerContainer.visible = false
	pass


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
	# Call at end of each combat round for non-firing units
	for Unit in unitsList:
		if Unit.is_reloading():
			Unit.tick_reload()
 
func get_army_weapon_classes() -> Dictionary:
	# Returns count of each weapon class in this army
	# Use for UI display and special formation bonuses
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
	# Army composed entirely of artillery — cannot melee at all
	var classes = get_army_weapon_classes()
	return classes.get("Artillery", 0) > 0 and \
		   classes.get("Saber", 0) == 0 and \
		   classes.get("Musket", 0) == 0

# ============================================================
# ARMY SPELL TRACKING (placeholder for future implementation)
# These variables should be added to army.gd class variables
# ============================================================
 
# var armySpell: spell = null         # spell currently affecting this army
# var armySpellDuration: int = 0      # turns remaining on active spell
# var armySpellCaster: country = null # who cast the spell
 
# func apply_spell(newSpell: spell, duration: int, caster: country) -> void:
#     armySpell = newSpell
#     armySpellDuration = duration
#     armySpellCaster = caster
 
# func tick_spell() -> void:
#     # Call each turn in _on_next_turn_pressed
#     if armySpellDuration > 0:
#         armySpellDuration -= 1
#         if armySpellDuration <= 0:
#             armySpell = null
#             armySpellCaster = null
 
# func has_active_spell() -> bool:
#     return armySpell != null and armySpellDuration > 0
