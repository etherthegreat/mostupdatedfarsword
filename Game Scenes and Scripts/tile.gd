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
var buildingGoldOutput
var buildingFoodOutput 
var buildingWoodOutput
var buildingMetalOutput
var buildingMagicOutput
var buildingCultureOutput
var buildingFaithOutput
var buildingWeaponsOutput
var buildingScienceOutput
var buildingMandateOutput
var buildingHarmonyOutput
var buildingManpowerOutput
var buildingInfluenceOutput

#Resources consumed by all this province's buildings
var buildingGoldExpense
var buildingFoodExpense
var buildingWoodExpense
var buildingMetalExpense
var buildingMagicExpense
var buildingCultureExpense
var buildingFaithExpense
var buildingScienceExpense
var buildingWeaponsExpense
var buildingMandateExpense
var buildingHarmonyExpense
var buildingManpowerExpense
var buildingInfluenceExpense

#Yields this tile will produce this month
var tileFoodYield
var tileWoodYield
var tileGoldYield
var tileMetalYield
var tileMagicYield
var tileCultureYield
var tileFaithYield
var tileWeaponsYield
var tileScienceYield
var tileMandateYield
var tileHarmonyYield
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


#Map Graphics
var tileRing
var tileGraphic

#tile Movement
var tileSpawnPath: String
var tileSpawnPathPoint: int

signal tileLoaded
signal tileEvent

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
	if tileNumber == 1:
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
		var Farm = building.new()
		Farm.buildingType = "Farm"
		Farm.buildingLevel = 3
		Farm.tile = self
		Farm.number = tileNumber
		Farm.buildBuilding()
		tileBuildingsList.append(Farm)
		var Granary = building.new()
		Granary.buildingType = "Granary"
		Granary.buildingLevel = 1
		Granary.tile = self
		Granary.number = tileNumber
		Granary.buildBuilding()
		tileBuildingsList.append(Granary)
	pass
	if tileNumber == 2:
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
	pass
	if tileNumber == 3:
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
		emit_signal("tileLoaded", self)
		var tileCrop = crop.new()
		tileCrop.cropType = "Wereroot"
		cropSlot = tileCrop
		var tileOre = ore.new()
		tileOre.oreType = "Iron"
		oreSlot = tileOre
		#addWizard("Druid")
		addBuilding("Tower", 1)
		addBuilding("Farm", 3)
		addBuilding("Granary", 1)
		addBuilding("Barracks", 2)
		addBuilding("Library", 1)
		addBuilding("Mine", 2)
		addBuilding("Forge", 1)
		addBuilding("Camp", 5)
		
		var actingSpell = spell.new()
		actingSpell.spellType = "Celebration"
		tileSpell = actingSpell
	pass
	if tileNumber == 4:
		tileSpawnPath = "Pender Tal South"
		tileSpawnPathPoint = 17
		tileName = "Enthenar"
		tileOwner = "PDT"
		countryCapital = false
		tileContinent = "Anlaxia"
		tilePop
		coastal = true
		freshWater = false
		terrain = "Grassland"
		season
		tileMilModifiers
		corruption = 25
		TileNeighbors
		var tileCrop = crop.new()
		tileCrop.cropType = "Razorberry"
		cropSlot = tileCrop
		var tileOre = ore.new()
		tileOre.oreType = "Copper"
		oreSlot = tileOre
		var Farm = building.new()
		Farm.buildingType = "Farm"
		Farm.buildingLevel = 3
		Farm.tile = self
		Farm.number = tileNumber
		Farm.buildBuilding()
		tileBuildingsList.append(Farm)
		var Granary = building.new()
		Granary.buildingType = "Granary"
		Granary.buildingLevel = 1
		Granary.tile = self
		Granary.number = tileNumber
		Granary.buildBuilding()
		tileBuildingsList.append(Granary)
		var Temple = building.new()
		Temple.buildingType = "Temple"
		Temple.buildingLevel = 3
		Temple.tile = self
		Temple.number = tileNumber
		Temple.buildBuilding()
		tileBuildingsList.append(Temple)
		var Barracks = building.new()
		Barracks.buildingType = "Barracks"
		Barracks.buildingLevel = 1
		Barracks.tile = self
		Barracks.number = tileNumber
		Barracks.buildBuilding()
		tileBuildingsList.append(Barracks)
		var Bath = building.new()
		Bath.buildingType = "Bath"
		Bath.buildingLevel = 2
		Bath.tile = self
		Bath.number = tileNumber
		Bath.buildBuilding()
		tileBuildingsList.append(Bath)
		calculateCorruption()
		calculateTerrain()
	pass
	if tileNumber == 5:
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
	calculateCorruption()
	calculateTerrain()
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


func calculateCorruption():
	if tileEcoModifiers != null:
		for tileEcoModifier in tileEcoModifiers:
			if tileEcoModifier.modType == "CORRUPTION":
				if corruption >= 80:
					tileEcoModifier.modName = "TotalCorruption"
					tileEcoModifier.buildTileEcoMod()
					return
				if corruption >= 60 && corruption < 80:
					tileEcoModifier.modName = "HeavyCorruption"
					tileEcoModifier.buildTileEcoMod()
					return
				if corruption >= 40 && corruption < 60:
					tileEcoModifier.modName = "ModerateCorruption"
					tileEcoModifier.buildTileEcoMod()
					return
				if corruption >= 20 && corruption < 40:
					tileEcoModifier.modName = "LightCorruption"
					tileEcoModifier.buildTileEcoMod()
					return
				if corruption < 20:
					tileEcoModifier.modName = "NoCorruption"
					tileEcoModifier.buildTileEcoMod()
					return
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
		match building.buildingType:
			"Farm":
				if building.buildingLevel >= 3:
					farmGovernorReq = true
				else:
					farmGovernorReq = false
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
	#print("buildingMagicOutput", buildingMagicOutput)
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
	var newBuild = building.new()
	newBuild.buildingType = buildingType
	newBuild.buildingLevel = level
	newBuild.tile = self
	newBuild.number = tileNumber
	tileBuildingsList.append(newBuild)
	self.add_child(newBuild)
	if newBuild.buildingType == "Tower":
		newBuild.towerBuilding.connect(wizardCheck)
	newBuild.buildBuilding()
	pass

func addStationedArmy(armyNode):
	stationedArmy = armyNode
	pass

func _on_area_2d_input_event(viewport, event, shape_idx):
		if event is InputEventMouseButton and event.pressed:
			if Input.is_action_just_pressed('Left Click'):
				emit_signal("clicked", self)


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
