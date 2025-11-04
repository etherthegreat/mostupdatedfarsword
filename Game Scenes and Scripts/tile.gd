extends Control

class_name Tile

#Base Variables
@export var EXPTileNumber: int
var tileNumber: int
var tileName: String
var tileOwner: String
var tileContinent: String
var tilePop #every number represents 5000 people in this tile.
var coastal: bool #determines if this tile is coastal or not
var freshWater: bool #determines if this province has access to fresh water
var terrain #determines the terrain of this province
var season #determines the season, based on terrain type as well as current month
var tileEcoModifiers: Array = [] #all resource modifiers for this tile
var tileMilModifiers: Array = [] #all military modifiers for this tile

var countryCapital: bool

signal clicked
var thisTileNumber

var cropSlot : crop
var oreSlot: ore
var tileWizard: wizard
var tileTowerLevel
var tileSpell: spell

#TileGovernors
var filledGovernorSlot: bool
var tileGovernor: governor

#governorRequirements
var farmGovernorReq: bool = false
var mineGovernorReq: bool = false
var campGovernorReq: bool = false
var libraryGovernorReq: bool = false
var workshopGovernorReq: bool = false
var forgeGovernorReq: bool = false
var barracksGovernorReq: bool = false
var bathGovernorReq: bool = false
var theaterGovernorReq: bool = false
var towerGovernorReq: bool = false
var granaryGovernorReq: bool = false

#magicPoints
var alcPointsOutput: int #alchemy
var illPointsOutput: int #illusion
var sumPointsOutput: int #summoning
var druPointsOutput: int #druidism
var elePointsOutput: int #elementalism
var divPointsOutput: int #divination

#province neighbors, used for calculating movements, colonization, fog of war, etc.
@export var TileNeighborsEXP: Array = []
var TileNeighbors: Array = [] #only add other tiles to this list after all tiles have been spawned
var TileCrossingNeighbors: Array = [] #used for strait crossing calculations

#tile occupation mechanics
var enemyCountryList: Array = [] #used to determine what armies can occupy this tile
var tileDefenseScore: Array = [] #base 100.  tile modifiers can increase or decrease this score
var tileOccupied: bool #this bool determines if the tile is occuped or not
var tileOccupier #this uses the country CID to occupy the province
var tileArmiesList: Array = [] #can put all armies that are present in this tile in this array

#Economy
var maxFertility: int #how many farm buildings can be built in this province
var maxForestry: int #how many forestry buildings can be built in this tile
var geologicResource #the resource this tile's mines produce (doesn't change the metal, just gives different resources)
var allRuinsList: Array = [] #all ruins in the province
var tileBuildingsList: Array = [] #used to determine all buildings in this province
var possibleBuildingsList: Array = [] #used to determine what buildings can be built by the tile owner tech and terrain
var maxBuildingsInTile
var damagedBuildingsList: Array = [] #if buildings are damaged by weather or sieges, they are put here

var tileOutput: float #used to calculate the output of all yields in the tile.

#Resources produced by all this province's buildings
var buildingGoldOutput: float
var buildingFoodOutput 
var buildingWoodOutput
var buildingMetalOutput
var buildingMagicOutput
var buildingCultureOutput
var buildingFaithOutput
var buildingWeaponsOutput
var buildingScienceOutput
var buildingMandateOutput
var buildingHarmonyOutput: float
var buildingManpowerOutput
var buildingInfluenceOutput

#Resources consumed by all this province's buildings
var buildingGoldExpense: float
var buildingFoodExpense
var buildingWoodExpense
var buildingMetalExpense
var buildingMagicExpense
var buildingCultureExpense
var buildingFaithExpense
var buildingScienceExpense
var buildingWeaponsExpense
var buildingMandateExpense
var buildingHarmonyExpense: float
var buildingManpowerExpense
var buildingInfluenceExpense

#Yields this tile will produce this month
var tileFoodYield
var tileWoodYield
var tileGoldYield: float
var tileMetalYield
var tileMagicYield
var tileCultureYield
var tileFaithYield
var tileWeaponsYield
var tileScienceYield
var tileMandateYield
var tileHarmonyYield: float
var tileManpowerYield
var tileInfluenceYield

#Fillable Slots
var filledEmbassySlot: bool
var chosenEmbassay
var filledSpySlot: bool
var chosenSpy
var filledArmySlot: bool
var stationedArmy: Army
var filledNavySlot: bool
var chosenNavy

var corruption: int #scale of 0 to 100.  100 will make everything cost a ton of money and reduce all outputs
var corruptionComparison: int
var corruptionChange: int

#visible levels
var undiscovered: bool
var discovered: bool
var activeView: bool

#Map Graphics
var tileRing
var tileGraphic

#tile Movement
var tileSpawnPath: String
var tileSpawnPathPoint: int

var tileSpawnPoint: pathPointButton

signal tileLoaded
signal tileEvent

var buildingScene = load("res://Game Scenes and Scripts/building.tscn")

signal onNewGameWorldBuild
func onNewGame():
	#pretty much every variable of a tile will be determined in this function
	#it is determined by the tileNumber, which is non-dynamically created through the 
	#TILENUMBEREXP variable, which is hand-typed into each tile on the map.
	var corruptionModifier = tileEcoModifier.new()
	corruptionModifier.modType = "CORRUPTION"
	tileEcoModifiers.append(corruptionModifier)
	emit_signal("onNewGameWorldBuild")
	tileRing = $Ring
	tileGraphic = $TileGraphic
	tileNumber = EXPTileNumber
	for NodePath in TileNeighborsEXP:
		TileNeighbors.append(get_node(NodePath))
	match tileNumber:
		1:
			tileName = "Devil's Purlicue"
			tileOwner = "DEM"
			countryCapital = true
			tileContinent = "Farsword"
			tilePop = 10
			coastal = false
			freshWater = false
			terrain = "Rainforest"
			season = "FALL"
			corruption = 100
			tileMilModifiers
			TileNeighbors
			#buildnewGameBuildings
			var tileCrop = crop.new()
			tileCrop.cropType = "Wheat"
			cropSlot = tileCrop
			var tileOre = ore.new()
			tileOre.oreType = "Copper"
			oreSlot = tileOre
			addBuilding("Farm", 1)
			tileSpawnPoint = $"../../PathControl/PathPointsControl/3"
		2:
			tileName = "Eighth House"
			tileOwner = "EIG"
			countryCapital = true
			tileContinent
			tilePop
			coastal
			freshWater
			terrain
			season
			tileEcoModifiers
			tileMilModifiers
			corruption = 75
			TileNeighbors
			tileSpawnPoint = $"../../PathControl/PathPointsControl/3"
		3:
			tileSpawnPath = "Pender Tal"
			tileSpawnPathPoint = 1
			tileName = "Pender Tal"
			tileOwner = "PDT"
			countryCapital = true
			tileContinent
			tilePop
			coastal = false
			freshWater = true
			terrain = "Rainforest"
			season
			tileEcoModifiers
			tileMilModifiers
			corruption = 0
			TileNeighbors
			var tileCrop = crop.new()
			tileCrop.cropType = "Cannabis"
			cropSlot = tileCrop
			var tileOre = ore.new()
			tileOre.buildSelf("Copper")
			oreSlot = tileOre
			#addWizard("Druid")
			#addBuilding("Tower", 1)
			addBuilding("Farm", 3)
			#addBuilding("Granary", 1)
			addBuilding("Barracks", 2)
			addBuilding("Library", 4)
			#addBuilding("Mine", 2)
			#addBuilding("Forge", 1)
			#addBuilding("Camp", 5)
			tileSpawnPoint = $"../../PathControl/PathPointsControl/3"
		#var actingSpell = spell.new()
		#actingSpell.spellType = "Celebration"
		#tileSpell = actingSpell
		4:
			tileSpawnPath = "Pender Tal South"
			tileSpawnPathPoint = 17
			tileName = "Enthenar"
			#tileOwner = "PDT"
			countryCapital = false
			tileContinent = "Anlaxia"
			tilePop
			coastal = true
			freshWater = false
			terrain = "Grassland"
			season
			tileMilModifiers
			corruption = 100
			TileNeighbors
			var tileCrop = crop.new()
			tileCrop.cropType = "Papyrus"
			cropSlot = tileCrop
			var tileOre = ore.new()
			tileOre.buildSelf("Marble")
			oreSlot = tileOre
			addBuilding("Farm", 3)
			addBuilding("Granary", 2)
			addBuilding("Temple", 2)
			addBuilding("Barracks", 1)
			addBuilding("Bath", 2)
			addBuilding("Library", 2)
			tileSpawnPoint = $"../../PathControl/PathPointsControl/4"
		5:
			tileName
			tileOwner
			tileContinent
			tilePop
			coastal
			freshWater
			terrain
			season
			tileEcoModifiers
			tileMilModifiers
			corruption
			TileNeighbors
			tileSpawnPoint = $"../../PathControl/PathPointsControl/5"
		6:
			tileSpawnPoint = $"../../PathControl/PathPointsControl/6"
		7:
			tileSpawnPoint = $"../../PathControl/PathPointsControl/7"
		8:
			tileSpawnPoint = $"../../PathControl/PathPointsControl/8"
		9:
			tileSpawnPoint = $"../../PathControl/PathPointsControl/9"
		10:
			tileSpawnPoint = $"../../PathControl/PathPointsControl/10"
	calculateCorruption()
	emit_signal("tileLoaded", self)
	pass


signal onLoadWorldBuild
func onLoadGame():
	emit_signal("onLoadWorldBuild")
	#var gameFileToLoad = load(fileFromDocumentsPath)
	tileRing = $Ring
	tileGraphic = $TileGraphic
	tileNumber = EXPTileNumber
	if tileNumber == 1:
		tileNumber
		tileName
		tileOwner
		tileContinent
		tilePop
		coastal
		freshWater
		terrain
		season
		tileEcoModifiers
		tileMilModifiers
		corruption
		TileNeighbors
	pass
	if tileNumber == 2:
		tileNumber
		tileName
		tileOwner
		tileContinent
		tilePop
		coastal
		freshWater
		terrain
		season
		tileEcoModifiers
		tileMilModifiers
		corruption
		TileNeighbors
	pass
	if tileNumber == 3:
		tileNumber
		tileName
		tileOwner
		tileContinent
		tilePop
		coastal
		freshWater
		terrain
		season
		tileEcoModifiers
		tileMilModifiers
		corruption
		TileNeighbors
	pass
	if tileNumber == 4:
		tileNumber
		tileName
		tileOwner
		tileContinent
		tilePop
		coastal
		freshWater
		terrain
		season
		tileEcoModifiers
		tileMilModifiers
		corruption
		TileNeighbors
	pass
	if tileNumber == 5:
		tileNumber
		tileName
		tileOwner
		tileContinent
		tilePop
		coastal
		freshWater
		terrain
		season
		tileEcoModifiers
		tileMilModifiers
		corruption
		TileNeighbors
	pass

func calculateDailyTileEcoChanges():
	#this is for easy changes that need to be updated often.  no complicated calculations
	corruptionComparison = corruption
	corruption -= corruptionChange
	if corruption == corruptionComparison:
		return
	else:
		print(tileName, corruptionChange, corruption, "CORRUPTION CHECK")
		calculateCorruption()
	pass


func calculateDiscovered(playerCountry):
	if tileOwner == playerCountry.CID:
		discovered = true
		undiscovered = false
		print("DEBUG tile neighbors", TileNeighbors)
		for Tile in TileNeighbors:
			Tile.discovered = true
			Tile.undiscovered = false
	pass

func calculateCorruption():
	tileEcoModifiers.clear()
	if corruption >= 80:
		var newtileEco = tileEcoModifier.new()
		newtileEco.modName = "TotalCorruption"
		newtileEco.buildTileEcoMod()
		tileEcoModifiers.append(newtileEco)
	elif corruption >= 60 || corruption < 80:
		var newtileEco = tileEcoModifier.new()
		newtileEco.modName = "HeavyCorruption"
		newtileEco.buildTileEcoMod()
		tileEcoModifiers.append(newtileEco)
	elif corruption >= 40 || corruption < 60:
		var newtileEco = tileEcoModifier.new()
		newtileEco.modName = "ModerateCorruption"
		newtileEco.buildTileEcoMod()
		tileEcoModifiers.append(newtileEco)
	elif corruption >= 20 || corruption < 40:
		var newtileEco = tileEcoModifier.new()
		newtileEco.modName = "LightCorruption"
		newtileEco.buildTileEcoMod()
		tileEcoModifiers.append(newtileEco)
	else:
		var newtileEco = tileEcoModifier.new()
		newtileEco.modName = "NoCorruption"
		newtileEco.buildTileEcoMod()
		tileEcoModifiers.append(newtileEco)
	corruptionChange = 0
	calculateTerrain()
	pass

func calculateTerrain():
	if terrain == "Rainforest":
		var rainforest = tileEcoModifier.new()
		rainforest.modName = "Rainforest"
		rainforest.buildTileEcoMod()
		tileEcoModifiers.append(rainforest)
	if terrain == "Grassland":
		var grassland = tileEcoModifier.new()
		grassland.modName = "Grassland"
		grassland.buildTileEcoMod()
		tileEcoModifiers.append(grassland)
	if freshWater == true:
		var freshWater = tileEcoModifier.new()
		freshWater.modName = "FreshWater"
		freshWater.buildTileEcoMod()
		tileEcoModifiers.append(freshWater)
	if freshWater == false && coastal == true:
		var coastalWater = tileEcoModifier.new()
		coastalWater.modName = "CoastalWater"
		coastalWater.buildTileEcoMod()
		tileEcoModifiers.append(coastalWater)
	if freshWater == false && coastal == false:
		var dry = tileEcoModifier.new()
		dry.modName = "Dry"
		dry.buildTileEcoMod()
		tileEcoModifiers.append(dry)
	else:
		return
	pass

func calculateSeason(month):
	var tileMonth = month
	if tileMonth == 6:
		season = "Summer"
		var summerMod = tileEcoModifier.new()
		summerMod.modName = "Summer"
		summerMod.buildTileEcoMod()
		tileEcoModifiers.append(summerMod)
	pass

var tileGoldTax: float
var tileHarmonyTax: float

func surveyTile(playerCountryNode):
	calculateDailyTileEcoChanges()
	buildingFoodOutput = 0
	buildingWoodOutput = 0
	buildingGoldOutput = 0
	buildingMetalOutput = 0
	buildingWeaponsOutput = 0
	buildingScienceOutput = 0
	buildingFaithOutput = 0
	buildingMagicOutput = 0
	buildingMandateOutput = 0
	buildingInfluenceOutput = 0
	buildingManpowerOutput = 0
	buildingHarmonyOutput = 0 
	buildingCultureOutput = 0
	corruptionChange = 0
	tileGoldTax = 0
	tileHarmonyTax = 0
	for building in tileBuildingsList:
		building.calculateOutputs(playerCountryNode)
		buildingFoodOutput += building.totalBuildingFood
		buildingWoodOutput += building.totalBuildingWood
		buildingGoldOutput += building.totalBuildingGold
		buildingMetalOutput += building.totalBuildingMetal
		buildingWeaponsOutput += building.totalBuildingWeapons
		buildingScienceOutput += building.totalBuildingScience
		buildingFaithOutput += building.totalBuildingFaith
		buildingMagicOutput += building.totalBuildingMagic
		buildingCultureOutput += building.totalBuildingCulture
		buildingMandateOutput += building.totalBuildingMandate
		buildingHarmonyOutput += building.totalBuildingHarmony
		buildingManpowerOutput += building.totalBuildingManpower
		buildingInfluenceOutput += building.totalBuildingInfluence
		corruptionChange += building.corruptionChange
		tileGoldTax += building.goldTax
		tileHarmonyTax += building.harmonyTax
		match building.buildingType:
			"Farm":
				if building.buildingLevel >= 3:
					farmGovernorReq = true
				else:
					farmGovernorReq = false
				if building.buildingLevel > 1:
					tileFarmDevCost * (building.buildingLevel * 1.3)
				else:
					tileFarmDevCost * building.buildingLevel
			"Camp":
				if building.buildingLevel >= 3:
					campGovernorReq = true
				else:
					campGovernorReq = false
			"Mine":
				if building.buildingLevel >= 3:
					mineGovernorReq = true
				else:
					mineGovernorReq = false
			"Library":
				if building.buildingLevel >= 3:
					libraryGovernorReq = true
				else:
					libraryGovernorReq = false
			"Theater":
				if building.buildingLevel >= 3:
					theaterGovernorReq = true
				else:
					theaterGovernorReq = false
			"Workshop":
				if building.buildingLevel >= 3:
					workshopGovernorReq = true
				else:
					workshopGovernorReq = false
			"Forge":
				if building.buildingLevel >= 3:
					forgeGovernorReq = true
				else:
					forgeGovernorReq = false
			"Bath":
				if building.buildingLevel >= 3:
					bathGovernorReq = true
				else:
					bathGovernorReq = false
			"Tower":
				match building.magicOutput:
					"alchemist":
						alcPointsOutput = (1 * building.buildingLevel)
					"summoner":
						sumPointsOutput = (1 * building.buildingLevel)
					"elementalist":
						elePointsOutput = (1 * building.buildingLevel)
					"druid":
						druPointsOutput = (1 * building.buildingLevel)
					"illusionist":
						illPointsOutput = (1 * building.buildingLevel)
					"diviner":
						divPointsOutput = (1 * building.buildingLevel)
				if building.buildingLevel >= 3:
					towerGovernorReq = true
				else:
					towerGovernorReq = false
			"Granary":
				if building.buildingLevel >= 3:
					granaryGovernorReq = true
				else:
					granaryGovernorReq = false
	print("buildingMagicOutput1", buildingMagicOutput)
	pass

func addWizard(wizardType):
	var actingWizard = wizard.new()
	actingWizard.wizardType = wizardType
	tileWizard = actingWizard
	wizardCheck()
	pass

func wizardCheck():
	if tileWizard == null:
		print("No mother fuckin wizard type found")
		emit_signal("tileEvent", self, "wizard")
		pass
	else:
		for building in tileBuildingsList:
			if building.buildingType == "Tower":
				building.magicOutput = tileWizard.wizardType
	pass



func addBuilding(buildingType, level):
	var newBuild = buildingScene.instantiate()
	newBuild.buildingType = buildingType
	newBuild.buildingLevel = level
	newBuild.tile = self
	newBuild.number = tileNumber
	tileBuildingsList.append(newBuild)
	self.add_child(newBuild)
	if newBuild.buildingLevel == 1:
		match newBuild.buildingType:
			"Farm":
				farmDevelopmentPoints = 0
			"Camp":
				campDevelopmentPoints = 0
			"Mine":
				mineDevelopmentPoints = 0
			"Library":
				libraryDevelopmentPoints = 0
			"Granary":
				granaryDevelopmentPoints = 0
			"Temple":
				templeDevelopmentPoints = 0
			"Tower":
				towerDevelopmentPoints = 0
				newBuild.towerBuilding.connect(wizardCheck)
			"Workshop":
				workshopDevelopmentPoints = 0
			"Forge":
				forgeDevelopmentPoints = 0
			"Bath":
				bathDevelopmentPoints = 0
			"Faire":
				faireDevelopmentPoints = 0
			"Barracks":
				barracksDevelopmentPoints = 0
		newBuild.buildBuilding()
	else:
		match newBuild.buildingType:
			"Farm":
				farmDevelopmentPoints = 10 * ((newBuild.buildingLevel - 1) * 1.3)
				tileFarmDevCost = 10 * (newBuild.buildingLevel * 1.3)
			"Camp":
				campDevelopmentPoints = 10 * ((newBuild.buildingLevel - 1) * 1.3)
				tileCampDevCost = 10 * (newBuild.buildingLevel * 1.3)
			"Mine":
				mineDevelopmentPoints = 15 * ((newBuild.buildingLevel - 1) * 1.3)
				tileMineDevCost = 15 * (newBuild.buildingLevel * 1.3)
			"Library":
				libraryDevelopmentPoints = 25 * ((newBuild.buildingLevel - 1) * 1.3)
				tileLibraryDevCost = 25 * (newBuild.buildingLevel * 1.3)
			"Granary":
				granaryDevelopmentPoints = 25 * ((newBuild.buildingLevel - 1) * 1.3)
				tileGranaryDevCost = 25 * (newBuild.buildingLevel * 1.3)
			"Temple":
				templeDevelopmentPoints = 20 * ((newBuild.buildingLevel - 1) * 1.3)
				tileTempleDevCost = 20 * (newBuild.buildingLevel * 1.3)
			"Tower":
				towerDevelopmentPoints = 40 * ((newBuild.buildingLevel - 1) * 1.3)
				newBuild.towerBuilding.connect(wizardCheck)
				tileTowerDevCost = 40 * (newBuild.buildingLevel * 1.3)
			"Workshop":
				workshopDevelopmentPoints = 30 * ((newBuild.buildingLevel - 1) * 1.3)
				tileWorkshopDevCost = 30 * (newBuild.buildingLevel * 1.3)
			"Forge":
				forgeDevelopmentPoints = 30 * ((newBuild.buildingLevel - 1) * 1.3)
				tileForgeDevCost = 30 * (newBuild.buildingLevel * 1.3)
			"Bath":
				bathDevelopmentPoints = 25 * ((newBuild.buildingLevel - 1) * 1.3)
				tileBathDevCost = 25 * (newBuild.buildingLevel * 1.3)
			"Faire":
				faireDevelopmentPoints = 25 * ((newBuild.buildingLevel - 1) * 1.3)
				tileFaireDevCost = 25 * (newBuild.buildingLevel * 1.3)
			"Barracks":
				barracksDevelopmentPoints = 30 * ((newBuild.buildingLevel - 1) * 1.3)
				tileBarracksDevCost = 30 * (newBuild.buildingLevel * 1.3)
		newBuild.buildBuilding()
		#levelUpBuilding(newBuild.buildingType)
	pass

func levelUpBuilding(type):
	for building in tileBuildingsList:
		if building.buildingType == type:
			building.upgradeBuilding()
			match type:
				"Farm":
					tileFarmDevCost = 10 * (building.buildingLevel * 1.3)
				"Camp":
					tileCampDevCost = 10 * (building.buildingLevel * 1.3)
				"Granary":
					tileCampDevCost = 25 * (building.buildingLevel * 1.3)
				"Mine":
					tileMineDevCost = 15 * (building.buildingLevel * 1.3)
				"Library":
					tileLibraryDevCost = 25 * (building.buildingLevel * 1.3)
				"Tower":
					tileTowerDevCost = 40 * (building.buildingLevel * 1.3)
				"Temple":
					tileTempleDevCost = 20 * (building.buildingLevel * 1.3)
				"Faire":
					tileFaireDevCost = 25 * (building.buildingLevel * 1.3)
				"Bath":
					tileBathDevCost = 25 * (building.buildingLevel * 1.3)
				"Workshop":
					tileWorkshopDevCost = 30 * (building.buildingLevel * 1.3)
				"Forge":
					tileForgeDevCost = 30 * (building.buildingLevel * 1.3)
				"Barracks":
					tileBarracksDevCost = 30 * (building.buildingLevel * 1.3)
	pass

func addStationedArmy(armyNode):
	stationedArmy = armyNode
	pass

signal spellAssigned
func _on_area_2d_input_event(viewport, event, shape_idx):
		if event is InputEventMouseButton and event.pressed:
			if Input.is_action_just_pressed('Left Click'):
				if spellToCast == null:
					emit_signal("clicked", self)
				else:
					tileSpell = spellToCast
					emit_signal("spellAssigned", spellCostToCast)
					spellToCast = null
					spellCostToCast = 0
					match tileSpell.spellType:
						"Raise Spring":
							freshWater = true
							tileSpell = null
					calculateCorruption()

func _on_area_2d_mouse_entered() -> void:
	tileRing.modulate = Color(0, 0, 0)
	tileGraphic.modulate = Color(0, 0, 1)
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	tileRing.modulate = Color(1, 1, 1)
	tileGraphic.modulate = Color(1, 1, 1)
	pass # Replace with function body.

func assignNewGovernor(newGovernor):
	tileGovernor = newGovernor
	pass

var spellToCast: spell
var spellCostToCast: int
func spellCastMode(spell, cost, playerCountryNode):
	if tileOwner == playerCountryNode.CID:
		if tileSpell != null:
			if tileSpell.spellType != spell.spellType:
				if spell.spellType == "Raise Spring" && freshWater == true:
					visible = false
				else: 
					spellToCast = spell
					spellCostToCast = cost
			else:
				visible = false
		else:
			if spell.spellType == "Raise Spring" && freshWater == true:
				visible = false
			else:
				spellToCast = spell
				spellCostToCast = cost
	else:
		visible = false
	pass

func normalMode():
	spellToCast = null
	spellCostToCast = 0
	visible = true
	pass

func calculateSpellChanges():
	if tileSpell != null:
		match tileSpell.spellType:
			"Healing Winds":
				corruptionChange += 2
				buildingMagicOutput -= 4
				print(buildingMagicOutput, "buildingMagicOutput2")
	pass


func updateGraphics(mapMode, displayCorruption, playerCountry):
	if undiscovered == true:
		$TileFOW.modulate = Color(0,0,0)
		$TileFOW.visible = true
		$TileGraphic.visible = false
		activeView = false
		#print("TroubleShooting DEBUG undisocvered")
		return
		#for Tile in TileNeighbors:
			#if Tile.discovered == true:
				#$TileFOW.self_modulate.a
	if discovered == true:
		$TileGraphic.visible = true
		match mapMode:
			"Polis":
				polisMode()
			"Natural":
				naturalMode()
		if tileOwner == playerCountry.CID:
			activeView = true
			for Tile in TileNeighbors:
				Tile.activeView = true
				return
		
		if tileSpawnPoint.occupied == true:
			activeView = true
			for Tile in TileNeighbors:
				Tile.activeView = true
				return
		if tileSpawnPoint.occupied != true:
			for Tile in TileNeighbors:
				if Tile.tileSpawnPoint.occupied == true:
					activeView = true
					Tile.activeView = true
					return
				if Tile.tileOwner == playerCountry.CID:
					activeView = true
					Tile.activeView = true
					return
		activeView = false
func calculateActiveView():
	if activeView == true:
		$TileFOW.visible = false
	if activeView == false && discovered == true:
		$TileFOW.modulate = Color(0,0,0)
		$TileFOW.visible = true
		$TileFOW.self_modulate.a = .75
		#print("TroubleShooting DEBUG discovered by not visible")
	pass

func polisMode():
	$TileGraphic.modulate = Color(1,1,1)
	match tileOwner:
		"PDT":
			$TileGraphic.modulate = Color(0,1,0)
		"ANL":
			$TileGraphic.modulate = Color(0,0,1)
	pass

func naturalMode():
	$TileGraphic.modulate = Color(1,1,1)
	$TileFOW.self_modulate.a = 0.0
	pass

signal tileColonized

func colonizeTile(civilian):
	tileOwner = civilian.player.CID
	emit_signal("tileColonized", self)
	pass

var discoveryPoints: int = 0

func increasePlayerDiscoveryRate(rate):
	if discovered != true:
		discoveryPoints += rate
		if discoveryPoints >= 100:
			discoverTile()
	pass

func discoverTile():
	undiscovered = false
	discovered = true
	pass


var farmDevelopmentPoints: float
var tileFarmDevCost:float = 10
var campDevelopmentPoints: float
var tileCampDevCost:float = 10
var mineDevelopmentPoints: float
var tileMineDevCost:float = 15
var libraryDevelopmentPoints: float
var tileLibraryDevCost:float = 25
var towerDevelopmentPoints: float
var tileTowerDevCost:float = 40
var templeDevelopmentPoints: float
var tileTempleDevCost:float = 20
var faireDevelopmentPoints: float
var tileFaireDevCost:float = 25
var workshopDevelopmentPoints: float
var tileWorkshopDevCost:float = 30
var forgeDevelopmentPoints: float
var tileForgeDevCost:float = 30
var bathDevelopmentPoints: float
var tileBathDevCost:float = 25
var granaryDevelopmentPoints: float
var tileGranaryDevCost:float = 25
var barracksDevelopmentPoints: float
var tileBarracksDevCost:float = 30
var dockDevelopmentPoints: float
var tileDockDevCost: float =30

var colonizationPoints: float
var colonizationReq: float = 2

func devChange(devType, devCivilian):
	print("DEBUG DEV", devType, devCivilian)
	match devType:
		"Corruption":
			corruption -= 1
			match devCivilian.civilianKit.kitType:
				"Homesteader":
					#print("DEBUG HOMESTEADER CORRUPTION")
					corruption -= 1
		"Colonize":
			colonizationPoints += .1
			match devCivilian.civilianKit.kitType:
				"Homesteader":
					#print("DEBUG HOMESTEADER COLONIZATION")
					colonizationPoints += .2
			if colonizationPoints >= colonizationReq:
				colonizeTile(devCivilian)
		"Agriculture":
			farmDevelopmentPoints += 2
			granaryDevelopmentPoints += 2
			if farmDevelopmentPoints >= tileFarmDevCost:
				levelUpBuilding("Farm")
			if granaryDevelopmentPoints >= tileGranaryDevCost:
				levelUpBuilding("Granary")
		"Resource":
			campDevelopmentPoints += 2
			mineDevelopmentPoints += 2
			if mineDevelopmentPoints >= tileMineDevCost:
				levelUpBuilding("Mine")
			if campDevelopmentPoints >= tileCampDevCost:
				levelUpBuilding("Camp")
		"Urban":
			workshopDevelopmentPoints += 2
			bathDevelopmentPoints += 2
			faireDevelopmentPoints += 2
			if workshopDevelopmentPoints >= tileWorkshopDevCost:
				levelUpBuilding("Workshop")
			if bathDevelopmentPoints >= tileBathDevCost:
				levelUpBuilding("Bath")
			if faireDevelopmentPoints >= tileFaireDevCost:
				levelUpBuilding("Faire")
		"Elite":
			libraryDevelopmentPoints += 2
			templeDevelopmentPoints += 2
			towerDevelopmentPoints += 2
			if libraryDevelopmentPoints >= tileLibraryDevCost:
				levelUpBuilding("Library")
			if templeDevelopmentPoints >= tileTempleDevCost:
				levelUpBuilding("Temple")
			if towerDevelopmentPoints >= tileTowerDevCost:
				levelUpBuilding("Tower")
		"Military":
			barracksDevelopmentPoints += 2
			forgeDevelopmentPoints += 2
			if barracksDevelopmentPoints >= tileBarracksDevCost:
				levelUpBuilding("Barracks")
			if forgeDevelopmentPoints >= tileBarracksDevCost:
				levelUpBuilding("Barracks")
		"Discovery":
			for Tile in TileNeighbors:
				if Tile.discovered != true:
					if devCivilian.civilianKit.kitType == "Exploration":
						Tile.increasePlayerDiscoveryRate(50)
					else:
						Tile.increasePlayerDiscoveryRate(25)
	pass
