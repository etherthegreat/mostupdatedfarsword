extends Control

class_name Tile

@export var oceanEXP: bool

# ============================================================
# BASE VARIABLES
# ============================================================
@export var EXPTileNumber: int
var tileNumber: int
var tileName: String
var tileOwner: String
var tileContinent: String  # used for state/region e.g. "PA", "CA - OT"
var tilePop            # every number represents 5000 people in this tile
var ocean: bool
var coastal: bool      # determines if this tile is coastal or not
var freshWater: bool   # determines if this province has access to fresh water
var terrain: String    # determines the terrain of this province
var season             # determines the season, based on terrain type and current month
var tileEcoModifiers: Array = []  # all resource modifiers for this tile
var tileMilModifiers: Array = []  # all military modifiers for this tile

# ── PROTECTOR / DMA FLAGS ────────────────────────────────────────────────────
# isCoastal: set in the editor on coastal MA/RI/etc tiles; used by USS Constitution Support mil mod
@export var isCoastal: bool = false
# hasMysteriousShipRaids: set in the editor on affected coastal tiles; applies -2 dollars per building
@export var hasMysteriousShipRaids: bool = false
# hasMysteriousOrations: set in the editor on Washington DC (tile 188); applies -1 mandate per building
# until PROT_17 (Lincoln's Ghost) is summoned via DMA investigation
@export var hasMysteriousOrations: bool = false
# dmaInvestigationPending: set true when a DMA-badge civilian investigates this tile;
# world.gd checks this at turn start and fires the associated protector summon event
var dmaInvestigationPending: bool = false

var tileWizard: wizard
var tileSpell: spell

var countryCapital: bool

signal clicked
var thisTileNumber

# ============================================================
# NEW: CSV-LOADED DATA VARIABLES
# ============================================================
var tileCrop: String = "corn"          # corn, apples, hay, soybeans, peanuts, peaches, oranges, mushrooms, cannabis
var corruption: int = 0                # scale 0-100; environmental decay — reduces tile output
var tileMoralDecay: int = 0            # scale 0-100; political corruption — reduces tile output; grows on courthouse tiles
var electionPressure: int = 0         # scale -100 to 100; tracks election momentum (-100=Crown, +100=Liberty Coalition)
var fortDisrepair: bool = false        # set by FORT_001 event chain; reduces garrison output
var presidentFailedTimer: int = 0      # > 0: presidential neglect active; ticks down each turn
var disabled_buildings: Dictionary = {}   # buildingType → turns_remaining until re-enabled
var buildings: Dictionary = {}         # {"barracks": 3, "farm": 1, "dock": 2}
var tileSpecialFeatures: Array = []    # ["Gettysburg Memorial", "Appalachian Minerals"]
var winterScore: int = 0
# ── STORM SYSTEM ──────────────────────────────────────────────────────────────
# Storms spawn on a tile, spread to TileNeighbors for their duration, then clear.
# Type is determined by winterScore + terrain at spawn time.
var stormActive: bool = false
var stormType: String = ""       # "Fog" | "Thunderstorm" | "Blizzard" | "Nor'easter" | "Hurricane" | "Tornado"
var stormDuration: int = 0       # turns remaining (2–6 set at spawn)
var stormIntensity: int = 1      # 1=light  2=medium  3=severe
var stormOriginId: String = ""   # shared ID across all tiles in the same storm cluster
# Road infrastructure — built by construction worker civilians (Pickaxe tool)
# 0 = no road, 1 = dirt road (−1 move cost), 2 = post road (−2), 3 = king's highway (−3, min 1)
var road_level: int = 0
# Eco modifier tracking
var isRevolutionaryHotbed: bool = false   # computed, not from CSV
var isOccupiedTerritory: bool = false     # computed, not from CSV
var isSunbeltHeat: bool = false           # set from specialFeature
# Conquest tracking (for recently_conquered helper)
var lastConqueror: String = ""            # CID of who last took this tile
var turnsSinceConquest: int = 0           # increments each month
var conquestThreshold: int = 6           # 6 months = "recently conquered"
# Espionage tracking (for has_recent_espionage helper)
var lastEspionageTurn: int = -999         # world turn when spy last operated here
var espionageCooldown: int = 12           # 12 months before tile is "clear"
var espionageActive: bool = false         # is a spy currently embedded here
# ============================================================
# TILE GOVERNORS
# ============================================================
var filledGovernorSlot: bool
var tileGovernor: governor

# Governor requirements
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
var courthouseGovernorReq: bool = false

# ============================================================
# NEIGHBORS & MOVEMENT
# ============================================================
@export var TileNeighborsEXP: Array = []
var TileNeighbors: Array = []         # only populated after all tiles spawned
var TileCrossingNeighbors: Array = [] # used for strait crossing calculations

var tileSpawnPath: String
var tileSpawnPathPoint: int
var tileSpawnPoint: pathPointButton

# ============================================================
# OCCUPATION MECHANICS
# ============================================================
var enemyCountryList: Array = []
var tileDefenseScore: Array = []
var tileOccupied: bool
var tileOccupier
var tileArmiesList: Array = []

# ============================================================
# ECONOMY
# ============================================================
var maxFertility: int
var maxForestry: int
var geologicResource
var allRuinsList: Array = []
var tileBuildingsList: Array = []
var possibleBuildingsList: Array = []
var maxBuildingsInTile
var damagedBuildingsList: Array = []

var tileOutput: float

# Building outputs
var buildingDollarsOutput: float   # renamed from buildingDollarsOutput
var buildingFoodOutput
var buildingWoodOutput
var buildingMetalOutput
var buildingMagicOutput
var buildingCultureOutput          # now covers old Faith + Culture
# buildingFaithOutput removed — merged into buildingCultureOutput
var buildingWeaponsOutput
var buildingScienceOutput
var buildingMandateOutput
var buildingHappinessOutput: float # renamed from buildingHappinessOutput
var buildingManpowerOutput
var buildingInfluenceOutput
var buildingMoralDecayReduction: int = 0

# Building expenses
var buildingDollarsExpense: float  # renamed from buildingDollarsExpense
var buildingFoodExpense
var buildingWoodExpense
var buildingMetalExpense
var buildingMagicExpense
var buildingCultureExpense         # covers old Faith + Culture
# buildingFaithExpense removed
var buildingScienceExpense
var buildingWeaponsExpense
var buildingMandateExpense
var buildingHappinessExpense: float # renamed from buildingHappinessExpense
var buildingManpowerExpense
var buildingInfluenceExpense

# Monthly yields
var tileFoodYield
var tileWoodYield
var tileDollarsYield: float   # renamed from tileDollarsYield
var tileMetalYield
var tileMagicYield
var tileCultureYield          # covers old Faith + Culture
# tileFaithYield removed
var tileWeaponsYield
var tileScienceYield
var tileMandateYield
var tileHappinessYield: float # renamed from tileHappinessYield
var tileBoatsYield: int       # new Boats resource
var tileManpowerYield
var tileInfluenceYield

# ============================================================
# FILLABLE SLOTS
# ============================================================
var filledEmbassySlot: bool
var chosenEmbassay
var filledSpySlot: bool
var chosenSpy
var filledArmySlot: bool
var stationedArmy: Army
var filledNavySlot: bool
var chosenNavy

# ============================================================
# VISIBILITY & SIEGE
# ============================================================
var corruptionComparison: int
var corruptionChange: int

var undiscovered: bool
var discovered: bool
var activeView: bool

var currentSiegeProgress: float
var maxSiegeProgress: float

# ============================================================
# MAP GRAPHICS
# ============================================================
var tileRing
var tileGraphic

# ============================================================
# DEVELOPMENT POINTS
# ============================================================
var farmDevelopmentPoints: float
var tileFarmDevCost: float = 10
var campDevelopmentPoints: float
var tileCampDevCost: float = 10
var mineDevelopmentPoints: float
var tileMineDevCost: float = 15
var libraryDevelopmentPoints: float
var tileLibraryDevCost: float = 25
var towerDevelopmentPoints: float
var tileTowerDevCost: float = 40
var templeDevelopmentPoints: float
var tileTempleDevCost: float = 20
var faireDevelopmentPoints: float
var tileFaireDevCost: float = 25
var workshopDevelopmentPoints: float
var tileWorkshopDevCost: float = 30
var forgeDevelopmentPoints: float
var tileForgeDevCost: float = 30
var bathDevelopmentPoints: float
var tileBathDevCost: float = 25
var granaryDevelopmentPoints: float
var tileGranaryDevCost: float = 25
var barracksDevelopmentPoints: float
var tileBarracksDevCost: float = 30
var dockDevelopmentPoints: float
var tileDockDevCost: float = 30
var courthouseDevelopmentPoints: float
var tileCourthouseDevCost: float = 35
var marketDevelopmentPoints: float
var tileMarketDevCost: float = 30
var monumentDevelopmentPoints: float
var tileMonumentDevCost: float = 30
var resortDevelopmentPoints: float
var tileResortDevCost: float = 35
var fortressDevelopmentPoints: float
var tileFortressDevCost: float = 40

var colonizationPoints: float
var colonizationReq: float = 2

# ============================================================
# SIGNALS
# ============================================================
signal tileLoaded
signal tileEvent
signal onNewGameWorldBuild
signal onLoadWorldBuild
signal spellAssigned
signal tileColonized
signal newSiegeStatus
signal censusComplete

# ============================================================
# SCENES
# ============================================================
var buildingScene = load("res://Game Scenes and Scripts/building.tscn")

# ============================================================
# SPELL
# ============================================================
var spellToCast: spell
var spellCostToCast: int

var tileFoodDic:      Dictionary = {}
var tileDollarsDic:   Dictionary = {}
var tileWoodDic:      Dictionary = {}
var tileMetalDic:     Dictionary = {}
var tileMagicDic:     Dictionary = {}
var tileCultureDic:   Dictionary = {}
var tileWeaponsDic:   Dictionary = {}
var tileScienceDic:   Dictionary = {}
var tileMandateDic:   Dictionary = {}
var tileHappinessDic: Dictionary = {}
var tileManpowerDic:  Dictionary = {}
var tileInfluenceDic: Dictionary = {}

var discoveryPoints: int = 0


# ============================================================
# NEW GAME INITIALIZATION
# ============================================================

func onNewGame():
	# Sets up siege, signals, rings, neighbors, then loads tile data from CSV
	maxSiegeProgress = 1
	currentSiegeProgress = 0
	var corruptionModifier = tileEcoModifier.new()
	corruptionModifier.modType = "CORRUPTION"
	tileEcoModifiers.append(corruptionModifier)
	emit_signal("onNewGameWorldBuild")
	tileRing = $Ring
	tileGraphic = $TileGraphic
	tileNumber = EXPTileNumber
	ocean = oceanEXP
	discovered = false
	undiscovered = true
	activeView = false
	# Ensure correct draw order: TileFOW(0) < TileGraphic(2) < Ring(5)
	var fow_node  = get_node_or_null("TileFOW")
	var gfx_node  = get_node_or_null("TileGraphic")
	if fow_node  != null: fow_node.z_index  = 0
	if gfx_node  != null: gfx_node.z_index  = 2
	for NodePath in TileNeighborsEXP:
		var nb = get_node_or_null(NodePath)
		if nb != null:
			TileNeighbors.append(nb)
		else:
			push_warning("Tile %d: neighbor path '%s' not found — skipped" % [EXPTileNumber, str(NodePath)])
	#if ocean == true:
		#calculateOceanAttributes(tileNumber)
	#else:
	build_self()       # <-- replaces calculateAttributes()
	calculateCorruption()
	emit_signal("tileLoaded", self)


func build_self() -> void:
	# Loads all tile data from TileDatabase (CSV) by tileNumber
	var data = TileDatabase.get_tile(tileNumber)

	if data.is_empty():
		# Tile not in CSV - use safe defaults so game doesn't crash
		push_warning("Tile " + str(tileNumber) + " not found in TileDatabase - using defaults")
		tileName = "Unknown Territory"
		tileOwner = "Neutral"
		terrain = "Woods"
		corruption = 0
		tileCrop = "corn"
		buildings = {}
		tileSpecialFeatures = []
		tileSpawnPoint = get_node_or_null("../../PathControl/PathPointsControl/" + str(tileNumber))
		return

	# Core identity from CSV
	tileName = data.get("tileName", "Unknown")
	tileOwner = data.get("country", "Neutral")
	tileContinent = data.get("state", "")
	terrain = data.get("terrain", "Woods")
	corruption = data.get("corruption", 0)
	winterScore = data.get("winterScore",0)
	tileCrop = data.get("tileCrop", "corn")
	buildings = data.get("buildings", {})
	tileSpecialFeatures = data.get("specialFeatures", [])

	# Feed special features into tileEcoModifiers
	for feature in tileSpecialFeatures:
		var ecoMod = tileEcoModifier.new()
		ecoMod.modType = feature
		tileEcoModifiers.append(ecoMod)

	# Spawn buildings from buildings dictionary
	for building_name in buildings:
		var level = buildings[building_name]
		addBuilding(building_name.capitalize(), level)

	determine_geologic_resource()

	# Connect tile to its path point on the map
	tileSpawnPoint = get_node_or_null("../../PathControl/PathPointsControl/" + str(tileNumber))
# ============================================================
# LOAD GAME INITIALIZATION
# ============================================================

signal onLoadGame_signal
func onLoadGame():
	emit_signal("onLoadWorldBuild")
	tileRing = $Ring
	tileGraphic = $TileGraphic
	tileNumber = EXPTileNumber
	ocean = oceanEXP
	discovered = false
	undiscovered = true
	activeView = false
	for NodePath in TileNeighborsEXP:
		var nb = get_node_or_null(NodePath)
		if nb != null:
			TileNeighbors.append(nb)
		else:
			push_warning("Tile %d: neighbor path '%s' not found — skipped" % [EXPTileNumber, str(NodePath)])
	build_self()  # CSV is the source of truth for load game too until save system is built
	calculateCorruption()
	emit_signal("tileLoaded", self)


func build_self_from_save(save_data: Dictionary) -> void:
	# Called when loading a saved game - same structure as build_self but from JSON
	tileName = save_data.get("tileName", tileName)
	tileOwner = save_data.get("country", tileOwner)
	tileContinent = save_data.get("state", tileContinent)
	terrain = save_data.get("terrain", terrain)
	corruption = save_data.get("corruption", corruption)
	tileMoralDecay     = save_data.get("tileMoralDecay", 0)
	electionPressure   = save_data.get("electionPressure", 0)
	winterScore = save_data.get("winterScore",0)
	tileCrop = save_data.get("tileCrop", tileCrop)
	buildings = save_data.get("buildings", {})
	tileSpecialFeatures = save_data.get("specialFeatures", [])
	lastConqueror = save_data.get("lastConqueror", "")
	turnsSinceConquest = save_data.get("turnsSinceConquest", 0)
	lastEspionageTurn = save_data.get("lastEspionageTurn", -999)
	espionageActive = save_data.get("espionageActive", false)
	for feature in tileSpecialFeatures:
		var ecoMod = tileEcoModifier.new()
		ecoMod.modType = feature
		tileEcoModifiers.append(ecoMod)

	for building_name in buildings:
		var level = buildings[building_name]
		addBuilding(building_name.capitalize(), level)

	tileSpawnPoint = get_node("../../PathControl/PathPointsControl/" + str(tileNumber))


# ============================================================
# ECONOMY CALCULATIONS
# ============================================================

func calculateDailyTileEcoChanges():
	corruptionComparison = corruption
	corruption -= corruptionChange
	if corruption == corruptionComparison:
		return
	else:
		calculateCorruption()


func calculateCorruption():
	tileEcoModifiers.clear()
	if corruption >= 80:
		var newtileEco = tileEcoModifier.new()
		newtileEco.modName = "TotalCorruption"
		newtileEco.buildTileEcoMod()
		tileEcoModifiers.append(newtileEco)
	elif corruption >= 60:
		var newtileEco = tileEcoModifier.new()
		newtileEco.modName = "HeavyCorruption"
		newtileEco.buildTileEcoMod()
		tileEcoModifiers.append(newtileEco)
	elif corruption >= 40:
		var newtileEco = tileEcoModifier.new()
		newtileEco.modName = "ModerateCorruption"
		newtileEco.buildTileEcoMod()
		tileEcoModifiers.append(newtileEco)
	elif corruption >= 20:
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
		var fw = tileEcoModifier.new()
		fw.modName = "FreshWater"
		fw.buildTileEcoMod()
		tileEcoModifiers.append(fw)
	elif coastal == true:
		var coastalWater = tileEcoModifier.new()
		coastalWater.modName = "CoastalWater"
		coastalWater.buildTileEcoMod()
		tileEcoModifiers.append(coastalWater)
	else:
		var dry = tileEcoModifier.new()
		dry.modName = "Dry"
		dry.buildTileEcoMod()
		tileEcoModifiers.append(dry)
	calculateWinterModifier()
	calculateDynamicModifiers()

func determine_geologic_resource() -> void:
	# Derives the mine resource from terrain and specialFeatures
	# Called at end of build_self() so data is already loaded
	# Sets geologicResource string used by building.gd Mine
 
	# Special features take priority — named deposits
	if has_special_feature("Appalachian Minerals"):
		geologicResource = "Iron"
		return
	if has_special_feature("Gun Valley"):
		geologicResource = "Iron"    # Connecticut iron made the guns
		return
	if has_special_feature("Niagara Falls"):
		geologicResource = "Marble"  # limestone/dolomite geology
		return
	if has_special_feature("Canadian Shield"):
		geologicResource = "Gold"    # Shield geology is gold/nickel country
		return
	if has_special_feature("Adirondack Wilderness"):
		geologicResource = "Iron"    # Adirondack iron ore is historically real
		return
	if has_special_feature("Laurentian Highlands"):
		geologicResource = "Gold"
		return
	if has_special_feature("Blue Ridge Highlands"):
		geologicResource = "Copper"
		return
	if has_special_feature("Great Smoky Mountains"):
		geologicResource = "Copper"
		return
	if has_special_feature("Muskoka Highlands"):
		geologicResource = "Marble"
		return
 
	# Terrain-based fallback
	match terrain:
		"Foothills":
			geologicResource = "Copper"   # most common Appalachian ore
		"Fortress":
			geologicResource = "Iron"     # fortress tiles built near iron deposits
		"Metro":
			geologicResource = "Marble"   # cities built near quarryable stone
		"Farmlands":
			geologicResource = "Copper"   # shallow surface deposits
		"Woods":
			geologicResource = "Copper"
		"Wetlands":
			geologicResource = "None"     # wetlands don't mine well
		"Suburbs":
			geologicResource = "None"
		_:
			geologicResource = "Copper"   # safe default

func calculateSeason(month):
	var tileMonth = month
	if tileMonth == 6:
		season = "Summer"
		var summerMod = tileEcoModifier.new()
		summerMod.modName = "Summer"
		summerMod.buildTileEcoMod()
		tileEcoModifiers.append(summerMod)


func censusTile(playerCountryNode):
	calculateDailyTileEcoChanges()
	buildingFoodOutput = 0
	buildingWoodOutput = 0
	buildingDollarsOutput = 0
	buildingMetalOutput = 0
	buildingWeaponsOutput = 0
	buildingScienceOutput = 0
	# buildingFaithOutput removed — merged into buildingCultureOutput
	buildingMagicOutput = 0
	buildingMandateOutput = 0
	buildingInfluenceOutput = 0
	buildingManpowerOutput = 0
	buildingHappinessOutput = 0
	buildingCultureOutput = 0
	corruptionChange = 0
	for building in tileBuildingsList:
		if not building.enabled:
			continue
		building.calculateOutputs(playerCountryNode)
		buildingFoodOutput += building.totalBuildingFood
		buildingWoodOutput += building.totalBuildingWood
		buildingDollarsOutput += building.totalBuildingDollars
		buildingMetalOutput += building.totalBuildingMetal
		buildingWeaponsOutput += building.totalBuildingWeapons
		buildingScienceOutput += building.totalBuildingScience
		# totalBuildingFaith removed — merged into totalBuildingCulture
		buildingMagicOutput += building.totalBuildingMagic
		buildingCultureOutput += building.totalBuildingCulture  # covers old faith + culture
		buildingMandateOutput += building.totalBuildingMandate
		buildingHappinessOutput += building.totalBuildingHappiness
		buildingManpowerOutput += building.totalBuildingManpower
		buildingInfluenceOutput += building.totalBuildingInfluence
		buildingMoralDecayReduction += building.totalBuildingMoralDecayReduction
		corruptionChange += building.corruptionChange
	# Mysterious Ship Raids: -2 dollars per active building per turn
	if hasMysteriousShipRaids:
		var active_count: int = 0
		for b in tileBuildingsList:
			if b.enabled:
				active_count += 1
		buildingDollarsOutput -= 2.0 * float(active_count)
	# Mysterious Orations: -1 mandate per active building per turn
	if hasMysteriousOrations:
		var active_count: int = 0
		for b in tileBuildingsList:
			if b.enabled:
				active_count += 1
		buildingMandateOutput -= active_count
	_apply_output_reductions()
	tileFoodDic.clear();      tileDollarsDic.clear();   tileWoodDic.clear()
	tileMetalDic.clear();     tileMagicDic.clear();     tileCultureDic.clear()
	tileWeaponsDic.clear();   tileScienceDic.clear();   tileMandateDic.clear()
	tileHappinessDic.clear(); tileManpowerDic.clear();  tileInfluenceDic.clear()
	for building in tileBuildingsList:
		if not building.foodDic.is_empty():      tileFoodDic[building.buildingType]      = building.foodDic
		if not building.dollarsDic.is_empty():   tileDollarsDic[building.buildingType]   = building.dollarsDic
		if not building.woodDic.is_empty():      tileWoodDic[building.buildingType]      = building.woodDic
		if not building.metalDic.is_empty():     tileMetalDic[building.buildingType]     = building.metalDic
		if not building.magicDic.is_empty():     tileMagicDic[building.buildingType]     = building.magicDic
		if not building.cultureDic.is_empty():   tileCultureDic[building.buildingType]   = building.cultureDic
		if not building.weaponsDic.is_empty():   tileWeaponsDic[building.buildingType]   = building.weaponsDic
		if not building.scienceDic.is_empty():   tileScienceDic[building.buildingType]   = building.scienceDic
		if not building.mandateDic.is_empty():   tileMandateDic[building.buildingType]   = building.mandateDic
		if not building.happinessDic.is_empty(): tileHappinessDic[building.buildingType] = building.happinessDic
		if not building.manpowerDic.is_empty():  tileManpowerDic[building.buildingType]  = building.manpowerDic
		if not building.influenceDic.is_empty(): tileInfluenceDic[building.buildingType] = building.influenceDic
	if not tileFoodDic.is_empty():      emit_signal("censusComplete", "Food",      buildingFoodOutput,      tileFoodDic)
	if not tileDollarsDic.is_empty():   emit_signal("censusComplete", "Dollars",   buildingDollarsOutput,   tileDollarsDic)
	if not tileWoodDic.is_empty():      emit_signal("censusComplete", "Wood",      buildingWoodOutput,      tileWoodDic)
	if not tileMetalDic.is_empty():     emit_signal("censusComplete", "Metal",     buildingMetalOutput,     tileMetalDic)
	if not tileMagicDic.is_empty():     emit_signal("censusComplete", "Magic",     buildingMagicOutput,     tileMagicDic)
	if not tileCultureDic.is_empty():   emit_signal("censusComplete", "Culture",   buildingCultureOutput,   tileCultureDic)
	if not tileWeaponsDic.is_empty():   emit_signal("censusComplete", "Weapons",   buildingWeaponsOutput,   tileWeaponsDic)
	if not tileScienceDic.is_empty():   emit_signal("censusComplete", "Science",   buildingScienceOutput,   tileScienceDic)
	if not tileMandateDic.is_empty():   emit_signal("censusComplete", "Mandate",   buildingMandateOutput,   tileMandateDic)
	if not tileHappinessDic.is_empty(): emit_signal("censusComplete", "Happiness", buildingHappinessOutput, tileHappinessDic)
	if not tileManpowerDic.is_empty():  emit_signal("censusComplete", "Manpower",  buildingManpowerOutput,  tileManpowerDic)
	if not tileInfluenceDic.is_empty(): emit_signal("censusComplete", "Influence", buildingInfluenceOutput, tileInfluenceDic)


func surveyTile(playerCountryNode):
	calculateDailyTileEcoChanges()
	buildingFoodOutput = 0
	buildingWoodOutput = 0
	buildingDollarsOutput = 0
	buildingMetalOutput = 0
	buildingWeaponsOutput = 0
	buildingScienceOutput = 0
	# buildingFaithOutput removed — merged into buildingCultureOutput
	buildingMagicOutput = 0
	buildingMandateOutput = 0
	buildingInfluenceOutput = 0
	buildingManpowerOutput = 0
	buildingHappinessOutput = 0
	buildingCultureOutput = 0
	buildingMoralDecayReduction = 0
	corruptionChange = 0
	for building in tileBuildingsList:
		if not building.enabled:
			continue
		building.calculateOutputs(playerCountryNode)
		buildingFoodOutput += building.totalBuildingFood
		buildingWoodOutput += building.totalBuildingWood
		buildingDollarsOutput += building.totalBuildingDollars
		buildingMetalOutput += building.totalBuildingMetal
		buildingWeaponsOutput += building.totalBuildingWeapons
		buildingScienceOutput += building.totalBuildingScience
		# totalBuildingFaith removed — merged into totalBuildingCulture
		buildingMagicOutput += building.totalBuildingMagic
		buildingCultureOutput += building.totalBuildingCulture  # covers old faith + culture
		buildingMandateOutput += building.totalBuildingMandate
		buildingHappinessOutput += building.totalBuildingHappiness
		buildingManpowerOutput += building.totalBuildingManpower
		buildingInfluenceOutput += building.totalBuildingInfluence
		buildingMoralDecayReduction += building.totalBuildingMoralDecayReduction
		corruptionChange += building.corruptionChange
		match building.buildingType:
			"Farm":
				farmGovernorReq = building.buildingLevel >= 3
				if building.buildingLevel > 1:
					tileFarmDevCost * (building.buildingLevel * 1.3)
				else:
					tileFarmDevCost * building.buildingLevel
			"Camp":
				campGovernorReq = building.buildingLevel >= 3
			"Mine":
				mineGovernorReq = building.buildingLevel >= 3
			"Library":
				libraryGovernorReq = building.buildingLevel >= 3
			"Theater":
				theaterGovernorReq = building.buildingLevel >= 3
			"Workshop":
				workshopGovernorReq = building.buildingLevel >= 3
			"Forge":
				forgeGovernorReq = building.buildingLevel >= 3
			"Bath":
				bathGovernorReq = building.buildingLevel >= 3
			"Tower":
				towerGovernorReq = building.buildingLevel >= 3
			"Granary":
				granaryGovernorReq = building.buildingLevel >= 3
			"Courthouse":
				courthouseGovernorReq = building.buildingLevel >= 3
	_apply_output_reductions()


# ============================================================
# BUILDINGS
# ============================================================

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
			"Farm":       farmDevelopmentPoints = 0
			"Camp":       campDevelopmentPoints = 0
			"Mine":       mineDevelopmentPoints = 0
			"Library":    libraryDevelopmentPoints = 0
			"Granary":    granaryDevelopmentPoints = 0
			"Temple":     templeDevelopmentPoints = 0
			"Tower":
				towerDevelopmentPoints = 0
				newBuild.towerBuilding.connect(wizardCheck)
			"Workshop":   workshopDevelopmentPoints = 0
			"Forge":      forgeDevelopmentPoints = 0
			"Bath":       bathDevelopmentPoints = 0
			"Faire":      faireDevelopmentPoints = 0
			"Barracks":   barracksDevelopmentPoints = 0
			"Dock":       dockDevelopmentPoints = 0
			"Courthouse": courthouseDevelopmentPoints = 0
			"Market":     marketDevelopmentPoints = 0
			"Monument":   monumentDevelopmentPoints = 0
			"Resort":     resortDevelopmentPoints = 0
			"Fortress":   fortressDevelopmentPoints = 0
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
			"Dock":
				dockDevelopmentPoints = 30 * ((newBuild.buildingLevel - 1) * 1.3)
				tileDockDevCost = 30 * (newBuild.buildingLevel * 1.3)
			"Courthouse":
				courthouseDevelopmentPoints = 35 * ((newBuild.buildingLevel - 1) * 1.3)
				tileCourthouseDevCost = 35 * (newBuild.buildingLevel * 1.3)
			"Market":
				marketDevelopmentPoints = 30 * ((newBuild.buildingLevel - 1) * 1.3)
				tileMarketDevCost = 30 * (newBuild.buildingLevel * 1.3)
			"Monument":
				monumentDevelopmentPoints = 30 * ((newBuild.buildingLevel - 1) * 1.3)
				tileMonumentDevCost = 30 * (newBuild.buildingLevel * 1.3)
			"Resort":
				resortDevelopmentPoints = 35 * ((newBuild.buildingLevel - 1) * 1.3)
				tileResortDevCost = 35 * (newBuild.buildingLevel * 1.3)
			"Fortress":
				fortressDevelopmentPoints = 40 * ((newBuild.buildingLevel - 1) * 1.3)
				tileFortressDevCost = 40 * (newBuild.buildingLevel * 1.3)
		newBuild.buildBuilding()


func levelUpBuilding(type):
	for building in tileBuildingsList:
		if building.buildingType == type:
			building.upgradeBuilding()
			match type:
				"Farm":       tileFarmDevCost = 10 * (building.buildingLevel * 1.3)
				"Camp":       tileCampDevCost = 10 * (building.buildingLevel * 1.3)
				"Granary":    tileGranaryDevCost = 25 * (building.buildingLevel * 1.3)
				"Mine":       tileMineDevCost = 15 * (building.buildingLevel * 1.3)
				"Library":    tileLibraryDevCost = 25 * (building.buildingLevel * 1.3)
				"Tower":      tileTowerDevCost = 40 * (building.buildingLevel * 1.3)
				"Temple":     tileTempleDevCost = 20 * (building.buildingLevel * 1.3)
				"Faire":      tileFaireDevCost = 25 * (building.buildingLevel * 1.3)
				"Bath":       tileBathDevCost = 25 * (building.buildingLevel * 1.3)
				"Workshop":   tileWorkshopDevCost = 30 * (building.buildingLevel * 1.3)
				"Forge":      tileForgeDevCost = 30 * (building.buildingLevel * 1.3)
				"Barracks":   tileBarracksDevCost = 30 * (building.buildingLevel * 1.3)
				"Dock":       tileDockDevCost = 30 * (building.buildingLevel * 1.3)
				"Courthouse": tileCourthouseDevCost = 35 * (building.buildingLevel * 1.3)
				"Market":     tileMarketDevCost = 30 * (building.buildingLevel * 1.3)
				"Monument":   tileMonumentDevCost = 30 * (building.buildingLevel * 1.3)
				"Resort":     tileResortDevCost = 35 * (building.buildingLevel * 1.3)
				"Fortress":   tileFortressDevCost = 40 * (building.buildingLevel * 1.3)


# ============================================================
# WIZARD (kept from original, used in DODK)
# ============================================================

func addWizard(wizardType: String, wizardSchool: String = ""):
	var actingWizard = wizard.new()
	actingWizard.wizardType   = wizardType
	actingWizard.wizardSchool = wizardSchool if wizardSchool != "" \
		else _resolve_wizard_school(wizardType)
	tileWizard = actingWizard
	wizardCheck()

# Maps a wizard/protector name to its school short key.
func _resolve_wizard_school(wtype: String) -> String:
	match wtype:
		"Mothman", "Jersey Devil", "Wood Booger", "Snallygaster", \
		"Skunk Ape":                                               return "cryptid"
		"Headless Horseman", "Green Mountain Ghost", \
		"Lincoln's Ghost":                                         return "spectral"
		"Thunderbird", "Chessie", "Bell Witch":                    return "storm"
		"Old Ironsides", "Valley Forge Guardian", \
		"Agent 355":                                               return "spectral"
		"Paul Revere", "Liberty Bell":                             return "liberty"
		# Legacy role keys pass through unchanged
		"alchemist":   return "manifest"
		"summoner":    return "cryptid"
		"illusionist": return "spectral"
		"druid":       return "storm"
		"elementalist":return "iron"
		"diviner":     return "liberty"
	return wtype

func wizardCheck():
	if tileWizard == null:
		emit_signal("tileEvent", self, "wizard")
	else:
		for building in tileBuildingsList:
			if building.buildingType == "Tower":
				# Route through school key so the points match works,
				# while wizardType keeps the protector's display name.
				building.magicOutput = tileWizard.wizardSchool \
					if tileWizard.wizardSchool != "" else tileWizard.wizardType


# ============================================================
# ARMY
# ============================================================

func addStationedArmy(armyNode):
	stationedArmy = armyNode


# ============================================================
# DISCOVERY & COLONIZATION
# ============================================================

func calculateDiscovered(playerCountry):
	if playerCountry == null:
		return
	if tileOwner == playerCountry.CID:
		discovered = true
		undiscovered = false
		for Tile in TileNeighbors:
			Tile.discovered = true
			Tile.undiscovered = false

func increasePlayerDiscoveryRate(rate):
	if discovered != true:
		discoveryPoints += rate
		if discoveryPoints >= 100:
			discoverTile()

func discoverTile():
	undiscovered = false
	discovered = true

func colonizeTile(civilian):
	tileOwner = civilian.player.CID
	emit_signal("tileColonized", self)


# ============================================================
# DEVELOPMENT
# ============================================================

func devChange(devType, devCivilian):
	match devType:
		"Corruption":
			corruption -= 1
			if devCivilian.civilianKit.kitType == "Homesteader":
				corruption -= 1
		"Colonize":
			colonizationPoints += .1
			if devCivilian.civilianKit.kitType == "Homesteader":
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
			if forgeDevelopmentPoints >= tileForgeDevCost:
				levelUpBuilding("Forge")
		"Discovery":
			for Tile in TileNeighbors:
				if Tile.discovered == false:
					if devCivilian.civilianKit.kitType == "Exploration":
						Tile.increasePlayerDiscoveryRate(50)
					else:
						Tile.increasePlayerDiscoveryRate(25)
		"Road":
			# Each fortnight the construction worker improves the tile's road level
			# by 1, up to the max of 3 (King's Highway).
			# Level 0 → 1 = Dirt Road      (−1 move cost)
			# Level 1 → 2 = Post Road      (−2 move cost)
			# Level 2 → 3 = King's Highway (−3 move cost, floored at 1)
			if road_level < 3:
				road_level += 1


# ============================================================
# SIEGE
# ============================================================

func siegeCalculate(army):
	if tileOwner == "":
		return
	if army.parentCountry.CID != tileOwner:
		currentSiegeProgress += army.armySiegeScore
	if currentSiegeProgress >= maxSiegeProgress:
		emit_signal("newSiegeStatus", self, tileOwner, army.parentCountry.CID)


# ============================================================
# SPELLS
# ============================================================

func spellCastMode(spell, cost, playerCountryNode):
	if tileOwner == playerCountryNode.CID:
		if tileSpell != null:
			if tileSpell.spellType != spell.spellType:
				if spell.spellType == "UNAUTHORIZED WEATHER MODIFICATION ACT" && freshWater == true:
					visible = false
				else:
					spellToCast = spell
					spellCostToCast = cost
			else:
				visible = false
		else:
			if spell.spellType == "UNAUTHORIZED WEATHER MODIFICATION ACT" && freshWater == true:
				visible = false
			else:
				spellToCast = spell
				spellCostToCast = cost
	else:
		visible = false

func normalMode():
	spellToCast = null
	spellCostToCast = 0
	visible = true

func calculateSpellChanges():
	if tileSpell != null:
		match tileSpell.spellType:
			"THOUGHTS & PRAYERS (FEDERAL ALLOCATION)":
				corruptionChange += 2
				buildingMagicOutput -= 4


# ============================================================
# GRAPHICS
# ============================================================

func updateGraphics(mapMode, displayCorruption, playerCountry, max_val: float = 1.0):
	var fow: Node = get_node_or_null("TileFOW")
	var gfx: Node = get_node_or_null("TileGraphic")
	if fow == null or gfx == null:
		return
	if undiscovered == true:
		fow.modulate = Color(0,0,0)
		fow.self_modulate.a = .975
		fow.visible = true
		gfx.visible = false
		activeView = false
		return
	if discovered == true:
		match mapMode:
			"Polis":        polisMode()
			"Natural":      naturalMode()
			"MapFood":      _resource_map_mode(Color(0.0,  0.5,  0.0),  get_map_mode_value(mapMode), max_val)
			"MapWood":      _resource_map_mode(Color(0.8,  0.3,  0.0),  get_map_mode_value(mapMode), max_val)
			"MapMetal":     _resource_map_mode(Color(0.75, 0.75, 0.75), get_map_mode_value(mapMode), max_val)
			"MapFaith":     _resource_map_mode(Color(0.5,  0.0,  0.8),  get_map_mode_value(mapMode), max_val)
			"MapHappiness": _resource_map_mode(Color(0.9,  0.8,  0.0),  get_map_mode_value(mapMode), max_val)
			"MapManpower":  _resource_map_mode(Color(0.8,  0.0,  0.0),  get_map_mode_value(mapMode), max_val)
			"MapWeapons":   _resource_map_mode(Color(0.45, 0.45, 0.45), get_map_mode_value(mapMode), max_val)
			"MapDollars":   _resource_map_mode(Color(0.85, 0.7,  0.0),  get_map_mode_value(mapMode), max_val)
			"MapMagic":     _resource_map_mode(Color(0.9,  0.2,  0.7),  get_map_mode_value(mapMode), max_val)
			"MapMandate":   _resource_map_mode(Color(0.55, 0.0,  0.0),  get_map_mode_value(mapMode), max_val)
			"MapArmy":      _resource_map_mode(Color(0.0,  0.5,  0.8),  get_map_mode_value(mapMode), max_val)
			"MapGovernors": _governors_map_mode()
			_:              polisMode()
		if playerCountry == null:
			activeView = false
			return
		if tileOwner == playerCountry.CID:
			activeView = true
			for neighbor in TileNeighbors:
				if neighbor != null:
					neighbor.activeView = true
			return
		if tileSpawnPoint != null and is_instance_valid(tileSpawnPoint) and tileSpawnPoint.occupied == true:
			activeView = true
			for neighbor in TileNeighbors:
				if neighbor != null:
					neighbor.activeView = true
			return
		activeView = false

func calculateActiveView():
	var fow: Node = get_node_or_null("TileFOW")
	if fow == null:
		return
	if activeView == true:
		fow.visible = false
	if activeView == false && discovered == true:
		fow.modulate = Color(0,0,0)
		fow.visible = true
		fow.self_modulate.a = .6

func polisMode():
	var gfx:  Node = get_node_or_null("TileGraphic")
	var ring: Node = get_node_or_null("Ring")
	if gfx == null:
		return
	# Default: show terrain naturally, Ring white
	gfx.visible = true
	gfx.modulate = Color(1, 1, 1)
	if ring != null:
		ring.modulate = Color(1, 1, 1)
	# Country colour applied to both graphic and Ring (z=5)
	var country_color: Color
	match tileOwner:
		"USA": country_color = Color(0.35, 0.55, 1.0)    # bright American blue
		"UK":  country_color = Color(0.9,  0.1,  0.2)    # bright British red
		"CA":  country_color = Color(1.0,  0.25, 0.25)   # bright Canadian red
		"BA":  country_color = Color(0.1,  0.8,  0.5)    # bright Bahamian teal
		# Legacy factions
		"PDT": country_color = Color(0.2, 1.0, 0.3)
		"ANL": country_color = Color(0.3, 0.4, 1.0)
		"EIG": country_color = Color(1.0, 0.2, 0.6)
		"VTO": country_color = Color(1.0, 0.6, 0.1)
		"DUM": country_color = Color(0.9, 1.0, 0.5)
		_:
			return   # Neutral or unknown — leave white
	gfx.modulate  = country_color
	if ring != null:
		ring.modulate = country_color

func naturalMode():
	var gfx:  Node = get_node_or_null("TileGraphic")
	var fow:  Node = get_node_or_null("TileFOW")
	var ring: Node = get_node_or_null("Ring")
	if gfx  != null: gfx.modulate  = Color(1, 1, 1)
	if fow  != null: fow.self_modulate.a = 0.0
	if ring != null: ring.modulate  = Color(1, 1, 1)

func get_map_mode_value(mode: String) -> float:
	match mode:
		"MapFood":      return float(buildingFoodOutput     + tileFoodYield)
		"MapWood":      return float(buildingWoodOutput     + tileWoodYield)
		"MapMetal":     return float(buildingMetalOutput    + tileMetalYield)
		"MapFaith":     return float(buildingCultureOutput  + tileCultureYield)
		"MapHappiness": return float(buildingHappinessOutput+ tileHappinessYield)
		"MapManpower":  return float(buildingManpowerOutput + tileManpowerYield)
		"MapWeapons":   return float(buildingWeaponsOutput  + tileWeaponsYield)
		"MapDollars":   return float(buildingDollarsOutput  + tileDollarsYield)
		"MapMagic":     return float(buildingMagicOutput    + tileMagicYield)
		"MapMandate":   return float(buildingMandateOutput  + tileMandateYield)
		"MapArmy":
			if stationedArmy != null:
				return float(stationedArmy.manpowerInArmy)
	return 0.0

func _resource_map_mode(target_color: Color, value: float, max_val: float) -> void:
	var gfx:  Node = get_node_or_null("TileGraphic")
	var ring: Node = get_node_or_null("Ring")
	if gfx == null:
		return
	gfx.visible = true
	var t: float = clampf(value / maxf(max_val, 1.0), 0.0, 1.0)
	var c: Color = Color.WHITE.lerp(target_color, t)
	gfx.modulate  = c
	if ring != null:
		ring.modulate = c

func _governors_map_mode() -> void:
	var gfx:  Node = get_node_or_null("TileGraphic")
	var ring: Node = get_node_or_null("Ring")
	if gfx == null:
		return
	gfx.visible = true
	if not filledGovernorSlot or tileGovernor == null:
		gfx.modulate  = Color(1, 1, 1)
		if ring != null: ring.modulate = Color(1, 1, 1)
		return
	var gov_level: int = get_governor_level()
	var c: Color
	match gov_level:
		1: c = Color(0.8,  0.5,  0.2)   # bronze
		2: c = Color(0.75, 0.75, 0.8)   # silver
		_: c = Color(1.0,  0.85, 0.0)   # gold (level 3+)
	gfx.modulate  = c
	if ring != null: ring.modulate = c


# ============================================================
# INPUT
# ============================================================

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
					"UNAUTHORIZED WEATHER MODIFICATION ACT":
						freshWater = true
						tileSpell = null
				calculateCorruption()

var _pre_hover_ring_modulate: Color = Color.WHITE
var _pre_hover_graphic_modulate: Color = Color.WHITE

func _on_area_2d_mouse_entered() -> void:
	if tileRing == null or tileGraphic == null: return
	_pre_hover_ring_modulate = tileRing.modulate
	_pre_hover_graphic_modulate = tileGraphic.modulate
	tileRing.modulate = Color(0, 0, 0)
	tileGraphic.modulate = Color(0, 0, 1)

func _on_area_2d_mouse_exited() -> void:
	if tileRing == null or tileGraphic == null: return
	tileRing.modulate = _pre_hover_ring_modulate
	tileGraphic.modulate = _pre_hover_graphic_modulate


# ============================================================
# GOVERNOR
# ============================================================

func assignNewGovernor(newGovernor):
	tileGovernor = newGovernor




# ============================================================
# TILE HELPERS - add these to tile_complete.gd
# Replace the existing "BUILDING HELPERS" section with this
# ============================================================


# ============================================================
# BUILDING HELPERS
# Ask questions about what buildings a tile has
# ============================================================

func has_building(building_name: String) -> bool:
	# Does this tile have this building at all?
	# Example: tile.has_building("barracks")
	return buildings.has(building_name.to_lower())

func get_building_level(building_name: String) -> int:
	# What level is this building? Returns 0 if not present
	# Example: tile.get_building_level("farm")
	return buildings.get(building_name.to_lower(), 0)

func has_building_at_level(building_name: String, min_level: int) -> bool:
	# Does this tile have this building at or above a minimum level?
	# Example: tile.has_building_at_level("barracks", 2)
	# Use this for: unlocking units, triggering events, AI decisions
	return get_building_level(building_name) >= min_level

func has_dock() -> bool:
	return has_building("dock")

func get_dock_level() -> int:
	return get_building_level("dock")

func has_barracks() -> bool:
	return has_building("barracks")

func get_barracks_level() -> int:
	return get_building_level("barracks")

func has_fort() -> bool:
	return has_building("fortress") or has_building("fort")

func get_fortification_level() -> int:
	# Returns the highest fort level between fortress and fort buildings
	return max(get_building_level("fortress"), get_building_level("fort"))

func has_market() -> bool:
	return has_building("market")

func has_library() -> bool:
	return has_building("library")

func has_farm() -> bool:
	return has_building("farm")

func has_mine() -> bool:
	return has_building("mine")

func total_buildings() -> int:
	# How many different building types does this tile have?
	# Use this for: development scoring, UI display, AI value assessment
	return buildings.size()


# ============================================================
# MILITARY HELPERS
# Useful for siege calculations, army movement, AI decisions
# ============================================================

func is_fortified() -> bool:
	# Is this tile meaningfully defended?
	# Use this for: increasing maxSiegeProgress, AI attack decisions
	return get_fortification_level() >= 1

func is_heavily_fortified() -> bool:
	# High level fortification - major military target
	# Use this for: AI avoiding tile, special siege events
	return get_fortification_level() >= 3

func is_military_hub() -> bool:
	# Has significant barracks AND fortification
	# Use this for: spawning garrison armies, UK stronghold events
	return get_barracks_level() >= 2 and has_fort()

func is_port() -> bool:
	# Can this tile support naval operations?
	# Use this for: spawning navies, naval supply lines, dock events
	return has_dock()

func get_siege_difficulty() -> float:
	# Returns a multiplier for how hard this tile is to siege
	# Use this in siegeCalculate() to scale maxSiegeProgress
	var base: float = 1.0
	base += get_fortification_level() * 0.5
	base += get_barracks_level() * 0.25
	if corruption >= 60:
		base *= 0.7  # corrupted tiles are easier to take
	return base


# ============================================================
# ECONOMIC HELPERS
# Useful for census, resource calculations, UI display
# ============================================================

func is_corrupted() -> bool:
	# Is corruption meaningfully affecting this tile?
	# Use this for: applying penalties in censusTile, UI warnings
	return corruption >= 40

func is_heavily_corrupted() -> bool:
	# Severe corruption
	# Use this for: triggering rebellion events, AI abandoning tile
	return corruption >= 70

func is_prosperous() -> bool:
	# Well developed economic tile
	# Use this for: positive events, bonus yields, AI prioritizing defense
	return has_farm() and has_market() and corruption < 30

func is_agricultural() -> bool:
	# Primary food producer
	# Use this for: food supply calculations, famine events
	return has_building_at_level("farm", 2)

func is_industrial() -> bool:
	# Has significant production infrastructure
	# Use this for: weapons output, supply events
	return has_building("forge") or has_building("mine")

func get_economic_value() -> int:
	# Rough score of how economically valuable this tile is
	# Use this for: AI prioritization, victory point calculations
	var value: int = 0
	value += get_building_level("market") * 3
	value += get_building_level("farm") * 2
	value += get_building_level("forge") * 2
	value += get_building_level("mine") * 2
	value += get_building_level("library") * 1
	value -= int(corruption * 0.1)
	return max(value, 0)


# ============================================================
# CULTURAL & POLITICAL HELPERS
# Useful for your liberty/liberalism themes
# ============================================================

func is_capital() -> bool:
	# Is this tile a country capital?
	# Use this for: capital capture events, war endings, special UI
	return countryCapital

func is_liberated() -> bool:
	# Is this tile owned by USA (the rebellion)?
	# Use this for: liberation events, commander story arcs,
	# the core victory condition of your game
	return tileOwner == "USA"

func is_occupied() -> bool:
	# Is this tile held by the King's forces?
	# Use this for: occupation events, triggering resistance mechanics
	return tileOwner == "UK"

func is_canadian() -> bool:
	# Is this tile Canadian faction?
	return tileOwner == "CA"

func is_contested() -> bool:
	# Is there an active siege happening?
	# Use this for: UI indicators, army AI, event triggers
	return currentSiegeProgress > 0 and currentSiegeProgress < maxSiegeProgress

func has_monument() -> bool:
	# Does this tile have cultural/historical significance?
	# Use this for: morale bonuses, special events, commander arcs
	return has_building("monument")

func has_university() -> bool:
	# High level library = university
	# Use this for: science bonuses, commander recruitment events
	return has_building_at_level("library", 3)

func is_resort() -> bool:
	# Tourism tile
	# Use this for: gold income bonuses, civilian happiness events
	return has_building("resort")

func has_special_feature(feature_name: String) -> bool:
	# Does this tile have a specific special feature?
	# Use this for: unique events tied to real locations
	# Example: tile.has_special_feature("Gettysburg Memorial")
	# Example: tile.has_special_feature("Naval Station Norfolk")
	return tileSpecialFeatures.has(feature_name)

func get_liberty_score() -> int:
	var score: int = 0
	if is_liberated():
		score += 50
	if has_monument():
		score += 10
	if has_university():
		score += 15
	if has_market():
		score += 10
	if is_historically_significant():
		score += 10
	# Fresh conquest by UK breeds radical resistance
	score += get_conquest_liberty_boost()
	score -= int(corruption * 0.5)
	return max(score, 0)

# ============================================================
# CROP HELPERS
# Useful for food events, seasonal mechanics, flavor text
# ============================================================

func get_crop() -> String:
	return tileCrop

func is_breadbasket() -> bool:
	# Major food producing tile
	# Use this for: food supply events, army supply lines
	return tileCrop in ["corn", "soybeans"] and has_building_at_level("farm", 2)

func has_rare_crop() -> bool:
	# Special crop tile - mushrooms or cannabis
	# Use this for: unique events, special resource bonuses
	return tileCrop in ["mushrooms", "cannabis"]

# ============================================================
# WIZARD HELPERS (updated to match has_building() style)
# Kept from original - will be more relevant for DODK
# ============================================================

func has_wizard() -> bool:
	# Does this tile have an assigned wizard?
	# Use this for: magic output calculations, tower events
	return tileWizard != null

func get_wizard_type() -> String:
	# What kind of wizard is here?
	# Returns empty string if no wizard
	if not has_wizard():
		return ""
	return tileWizard.wizardType

func is_magic_tile() -> bool:
	# Has wizard AND tower
	# Use this for: spell range calculations, magic events
	return has_wizard() and has_building("tower")

func get_magic_school() -> String:
	# What magic school does this tile produce?
	return get_wizard_type()

func calculateWinterModifier() -> void:
	# Called at end of calculateTerrain() — adds winter eco modifier
	# Remove any existing winter modifier first so recalculation is clean
	tileEcoModifiers = tileEcoModifiers.filter(
		func(mod): return not mod.modName.begins_with("Winter_")
	)
	var winterMod = tileEcoModifier.new()
	if winterScore <= -80:
		winterMod.modName = "Winter_ExtremeHurricane"
	elif winterScore <= -60:
		winterMod.modName = "Winter_HurricaneTerritory"
	elif winterScore <= -20:
		winterMod.modName = "Winter_StormProne"
	elif winterScore < 20:
		winterMod.modName = "Winter_Mild"
	elif winterScore < 60:
		winterMod.modName = "Winter_Cold"
	elif winterScore < 80:
		winterMod.modName = "Winter_Harsh"
	else:
		winterMod.modName = "Winter_Blizzard"
	winterMod.buildTileEcoMod()
	tileEcoModifiers.append(winterMod)
 
func has_occupying_army_commander() -> bool:
	# Does the army stationed here have a named commander?
	# Use for: commander-specific story events, special siege modifiers,
	# Nzinga in Vermont behaves differently than a generic unit
	if stationedArmy == null:
		return false
	# Checks if the army has a commander assigned
	# Assumes army has a 'commander' variable — adjust if yours differs
	return stationedArmy.get("commander") != null if stationedArmy.has_method("get") else false
 
func get_occupying_commander():
	# Returns the commander node/object, or null
	if not has_occupying_army_commander():
		return null
	return stationedArmy.commander
 
 
# --- HELPER 14: has_max_corruption ---
func has_max_corruption() -> bool:
	# Is this tile in total collapse? (corruption >= 80)
	# Use for: bandit spawns, civilian exodus, buildings stop producing,
	# revolution events, AI abandoning tile
	return corruption >= 80
 
func get_corruption_tier() -> String:
	# Human-readable corruption state for events and UI
	if corruption >= 80:
		return "Collapsed"
	elif corruption >= 60:
		return "Severe"
	elif corruption >= 40:
		return "Moderate"
	elif corruption >= 20:
		return "Light"
	else:
		return "Clean"
 
 
# --- HELPER 15: is_neighbor_of_capital ---
func is_neighbor_of_capital() -> bool:
	# Is this tile adjacent to any country's capital?
	# Use for: king's reinforcement events, propaganda events,
	# special siege modifiers near capitals
	for neighbor in TileNeighbors:
		if neighbor.countryCapital == true:
			return true
	return false
 
func get_neighboring_capital() -> Tile:
	# Returns the capital tile if adjacent, null otherwise
	for neighbor in TileNeighbors:
		if neighbor.countryCapital == true:
			return neighbor
	return null
 
 
# --- HELPER 16: is_recently_liberated ---
func is_recently_liberated() -> bool:
	# Was this tile UK-owned and flipped to USA recently?
	# Use for: jubilee event, temporary morale boost, Loyalist resistance
	# "Recently" = within conquestThreshold months
	return is_liberated() and lastConqueror == "UK" and turnsSinceConquest <= conquestThreshold
 
func get_turns_since_liberation() -> int:
	# How many months since this tile was liberated?
	# Use for: scaling event intensity (fresh liberation = bigger celebration)
	if not is_recently_liberated():
		return 999
	return turnsSinceConquest
 
 
# --- HELPER 17: has_ideological_conflict ---
func has_ideological_conflict() -> bool:
	# Is this tile on the front line between USA and UK?
	# Use for: debate events, defector events, spy events,
	# the most politically charged tiles on the map
	var hasUSA = false
	var hasUK = false
	for neighbor in TileNeighbors:
		if neighbor.tileOwner == "USA":
			hasUSA = true
		if neighbor.tileOwner == "UK":
			hasUK = true
	return hasUSA and hasUK
 
func get_faction_neighbor_count(factionCID: String) -> int:
	# How many neighbors belong to a specific faction?
	# Use for: measuring how surrounded/isolated a tile is
	var count = 0
	for neighbor in TileNeighbors:
		if neighbor.tileOwner == factionCID:
			count += 1
	return count
 
 
# --- HELPER 18: is_historically_significant ---
func is_historically_significant() -> bool:
	# Does this tile have a monument AND a named historical specialFeature?
	# Use for: speech events, rally events, commander inspiration arc triggers
	if not has_monument():
		return false
	# Check if any special feature sounds historical (not just geographic)
	var historical_keywords = [
		"Memorial", "Arsenal", "Battle", "College", "University",
		"Birthplace", "Capital", "Historic", "Fort", "Naval"
	]
	for feature in tileSpecialFeatures:
		for keyword in historical_keywords:
			if feature.contains(keyword):
				return true
	return false
 
func get_historical_features() -> Array:
	# Returns only the historically significant special features
	var historical_keywords = [
		"Memorial", "Arsenal", "Battle", "College", "University",
		"Birthplace", "Capital", "Historic", "Fort", "Naval"
	]
	var result = []
	for feature in tileSpecialFeatures:
		for keyword in historical_keywords:
			if feature.contains(keyword):
				result.append(feature)
				break
	return result

# ============================================================
#Governor Helpers
# ============================================================

func has_governor() -> bool:
	# Does this tile have a governor assigned?
	return filledGovernorSlot and tileGovernor != null
 
func has_governor_at_level(min_level: int) -> bool:
	# Is the governor at or above a minimum level?
	# Use for: unlocking advanced events, bonus modifiers,
	# governor-gated building upgrades
	# Example: tile.has_governor_at_level(2)
	if not has_governor():
		return false
	return tileGovernor.governorLevel >= min_level
 
func get_governor_level() -> int:
	# What level is the governor? Returns 0 if no governor
	if not has_governor():
		return 0
	return tileGovernor.governorLevel
 
func has_governor_faction(factionCID: String) -> bool:
	# Is the governor aligned with a specific faction?
	# Use for: loyalty events, defection risk, faction-specific bonuses
	# Checks governorType against faction — adjust match logic
	# if your governors store faction differently
	if not has_governor():
		return false
	# Governor faction is inferred from governorType or a faction variable
	# For now checks if the tile owner matches the faction
	# TODO: add a governorFaction variable to governor.gd for more precision
	return tileOwner == factionCID
 
func get_governor_type() -> String:
	# What type is the governor? Returns "" if none
	if not has_governor():
		return ""
	return tileGovernor.governorType
 
func is_governor_loyal() -> bool:
	# Is the governor loyal to the current tile owner?
	# Use for: preventing defection events, stability bonuses
	if not has_governor():
		return false
	return has_governor_faction(tileOwner)
 
func is_governor_hostile() -> bool:
	# Is the governor from a rival faction?
	# Use for: sabotage events, corruption increase, spy vulnerability
	if not has_governor():
		return false
	return not has_governor_faction(tileOwner)

#===================================
#FactionHelpers 
#===========================
func get_dominant_faction(playerCountry) -> String:
	# Which faction has highest loyalty in this country?
	# Use for: event flavor text, determining which reward fires
	var highestLoyalty = 0
	var dominantFaction = ""
	for f in playerCountry.countryFactionList:
		if f.factionLoyalty > highestLoyalty:
			highestLoyalty = f.factionLoyalty
			dominantFaction = f.factionName
	return dominantFaction
 
func is_abolitionist_territory() -> bool:
	# Is this tile significant to the abolitionist cause?
	# Use for: Underground Railroad events, freedom paper events
	# Tiles with monuments in formerly-slave states
	return has_monument() and tileContinent in ["VA", "NC", "SC", "GA", "AL", "FL"]
 
func is_labor_territory() -> bool:
	# Is this tile significant to the Free Workers Union?
	# Use for: guild charter events, strike events
	# Industrial tiles with forges or workshops
	return is_industrial() and (
		has_special_feature("Gun Valley") or
		has_special_feature("Chesapeake Shipyards") or
		has_special_feature("Carpet Capital of the World")
	)

# ============================================================
# MOVEMENT COST
# ============================================================
#
# Civ-style tile entry cost consumed from an army's currentMovementPoints.
#
# Base costs by terrain:
#   Metro / Fort / Suburbs / Farmlands  →  1
#   Woods / Foothills / Wetlands        →  2
#
# Roads reduce the base cost (min 1):
#   road_level 1 (dirt road)     → −1
#   road_level 2 (post road)     → −2
#   road_level 3 (king's highway)→ −3  (always floored at 1)
#
# Metro tiles have an implicit road_level bonus of 2 (they're already paved).
#
# Winter amplification — applied only to cold-terrain tiles (winterScore > 0)
# and only for armies that do NOT carry the "Cold Weather" armyTag.
#   factor = 1.0 + (1.0 − get_winter_army_modifier()) × 1.0
#   Examples: cold (0.85) → ×1.15, harsh (0.65) → ×1.35, blizzard (0.40) → ×1.60
#   Result is always ceiled to the next integer.
#
# The "Cold Weather" tag means armies from winter-adapted regions (Canadian
# rangers, Indigenous winter warriors, fur-trade militias) pay no winter surcharge.
func get_move_cost(army = null) -> int:
	# 1 — Base terrain cost
	var base: int
	match terrain:
		"Metro":     base = 1
		"Fort":      base = 1
		"Suburbs":   base = 1
		"Farmlands": base = 1
		"Woods":     base = 2
		"Foothills": base = 2
		"Wetlands":  base = 2
		_:           base = 1   # safe default for any future terrain
	# 2 — Road reduction (Metro already acts as road_level 2)
	var effective_road: int = road_level
	if terrain == "Metro":
		effective_road = max(effective_road, 2)
	base = max(1, base - effective_road)
	# 3 — Winter amplification for non-adapted armies on cold tiles
	if winterScore > 0 and army != null and not army.armyTags.has("Cold Weather"):
		var modifier: float = get_winter_army_modifier()
		if modifier < 1.0:
			var factor: float = 1.0 + (1.0 - modifier) * 1.0
			base = int(ceil(float(base) * factor))
	return base

# ============================================================
# WINTER HELPERS
# ============================================================

func get_winter_score() -> int:
	return winterScore
 
func is_hurricane_territory() -> bool:
	return winterScore <= -60
 
func is_storm_prone() -> bool:
	return winterScore <= -20
 
func is_mild_winter() -> bool:
	return winterScore > -20 and winterScore < 20
 
func is_cold_winter() -> bool:
	return winterScore >= 20 and winterScore < 60
 
func is_harsh_winter() -> bool:
	return winterScore >= 60 and winterScore < 80
 
func is_blizzard_territory() -> bool:
	return winterScore >= 80
 
func get_winter_category() -> String:
	if winterScore <= -80:
		return "Extreme Hurricane Zone"
	elif winterScore <= -60:
		return "Hurricane Territory"
	elif winterScore <= -20:
		return "Storm Prone"
	elif winterScore < 20:
		return "Mild Winter"
	elif winterScore < 60:
		return "Cold Winter"
	elif winterScore < 80:
		return "Harsh Winter"
	else:
		return "Blizzard Territory"
 
func get_winter_army_modifier() -> float:
	# Movement/supply multiplier for winter army operations
	# Placeholder values — tune percentages later
	if winterScore <= -80:
		return 0.5   # hurricane chaos disrupts both sides
	elif winterScore <= -60:
		return 0.7   # serious storm disruption
	elif winterScore <= -20:
		return 0.9   # mild storm risk
	elif winterScore < 20:
		return 1.0   # no modifier
	elif winterScore < 60:
		return 0.85  # cold slows movement
	elif winterScore < 80:
		return 0.65  # harsh winter, army suffers
	else:
		return 0.4   # blizzard, near-impassable
 
func get_winter_badge_color() -> String:
	# Returns color hint for the winter badge art
	# Top half of badge = category color, bottom = intensity shade
	if winterScore <= -60:
		return "coral"    # hurricane — warm danger color
	elif winterScore <= -20:
		return "amber"    # storm prone — warning color
	elif winterScore < 20:
		return "teal"     # mild — calm neutral
	elif winterScore < 60:
		return "blue"     # cold — cool color
	else:
		return "purple"   # blizzard — deep cold


# ============================================================
# Recently Conquered
# ============================================================
func recently_conquered() -> bool:
	# Was this tile conquered within the last conquestThreshold months?
	# Use for: increasing liberty score, radical resistance events,
	# fresh occupation instability
	return turnsSinceConquest <= conquestThreshold and lastConqueror != ""
 
func recently_conquered_by(factionCID: String) -> bool:
	# Was this tile specifically conquered by this faction recently?
	# Example: tile.recently_conquered_by("UK") = loyalist crackdown event
	# Example: tile.recently_conquered_by("USA") = jubilee/liberation event
	return recently_conquered() and lastConqueror == factionCID
 
func record_conquest(conquering_faction: String) -> void:
	lastConqueror = conquering_faction
	turnsSinceConquest = 0
	tileOwner = conquering_faction
	tileMoralDecay = 0   # new administration resets political corruption
	calculateCorruption()
 
func tick_conquest_timer() -> void:
	if turnsSinceConquest <= conquestThreshold + 24:
		turnsSinceConquest += 1
	if presidentFailedTimer > 0:
		presidentFailedTimer -= 1
	var re_enable: Array = []
	for btype in disabled_buildings.keys():
		disabled_buildings[btype] -= 1
		if disabled_buildings[btype] <= 0:
			re_enable.append(btype)
	for btype in re_enable:
		disabled_buildings.erase(btype)
		for b in tileBuildingsList:
			if b.buildingType == btype:
				b.enabled = true
				break
	# Courthouse tiles accumulate moral decay over time; Eliza Hamilton doctrine reduces it
	if tileMoralDecay < 100:
		for b in tileBuildingsList:
			if b.buildingType == "Courthouse":
				tileMoralDecay = clampi(tileMoralDecay + 1 - buildingMoralDecayReduction, 0, 100)
				break

func _apply_output_reductions() -> void:
	if corruption == 0 and tileMoralDecay == 0:
		return
	var multiplier: float = (1.0 - float(corruption) / 100.0) * (1.0 - float(tileMoralDecay) / 100.0)
	if buildingFoodOutput    > 0: buildingFoodOutput    = int(float(buildingFoodOutput)    * multiplier)
	if buildingWoodOutput    > 0: buildingWoodOutput    = int(float(buildingWoodOutput)    * multiplier)
	if buildingDollarsOutput > 0: buildingDollarsOutput = buildingDollarsOutput            * multiplier
	if buildingMetalOutput   > 0: buildingMetalOutput   = int(float(buildingMetalOutput)   * multiplier)
	if buildingWeaponsOutput > 0: buildingWeaponsOutput = int(float(buildingWeaponsOutput) * multiplier)
	if buildingScienceOutput > 0: buildingScienceOutput = int(float(buildingScienceOutput) * multiplier)
	if buildingMagicOutput   > 0: buildingMagicOutput   = int(float(buildingMagicOutput)   * multiplier)
	if buildingCultureOutput > 0: buildingCultureOutput = int(float(buildingCultureOutput) * multiplier)
	if buildingMandateOutput > 0: buildingMandateOutput = int(float(buildingMandateOutput) * multiplier)
	if buildingHappinessOutput > 0: buildingHappinessOutput = int(float(buildingHappinessOutput) * multiplier)
	if buildingManpowerOutput  > 0: buildingManpowerOutput  = int(float(buildingManpowerOutput)  * multiplier)
	if buildingInfluenceOutput > 0: buildingInfluenceOutput = int(float(buildingInfluenceOutput) * multiplier)

func disable_building(type: String, turns: int) -> void:
	for b in tileBuildingsList:
		if b.buildingType == type:
			b.enabled = false
			disabled_buildings[type] = turns
			return
	push_warning("[Tile] disable_building: no building of type '" + type + "' at " + tileName)

func is_building_disabled(type: String) -> bool:
	return disabled_buildings.has(type)

func has_neighbor_owned_by(cid: String) -> bool:
	for n in TileNeighbors:
		if n.tileOwner == cid:
			return true
	return false

func has_neighbor_with_espionage() -> bool:
	for n in TileNeighbors:
		if n.espionageActive:
			return true
	return false

func get_conquest_liberty_boost() -> int:
	# How much liberty bonus does recent conquest give?
	# Fresh UK conquest of a tile = high resistance energy
	# Use this in get_liberty_score() or event calculations
	if not recently_conquered_by("UK"):
		return 0
	# Boost fades over time — strong at first, gone after threshold
	var freshness = 1.0 - (float(turnsSinceConquest) / float(conquestThreshold))
	return int(25 * freshness)  # up to +25 liberty from fresh conquest rage




func calculateDynamicModifiers() -> void:
	# Removes and recalculates the three dynamic eco modifiers
	# Called at end of calculateTerrain() so it runs in the eco chain
 
	# Clear previous dynamic modifiers
	tileEcoModifiers = tileEcoModifiers.filter(
		func(mod): return not mod.modName in [
			"RevolutionaryHotbed",
			"OccupiedTerritory",
			"SunbeltHeat",
			"MysteriousShipRaids"
		]
	)
 
	# --- REVOLUTIONARY HOTBED ---
	# Pink/blue badge: high liberty score + UK owned
	# Represents a restless occupied tile where ideas are spreading
	isRevolutionaryHotbed = is_occupied() and get_liberty_score() >= 30
	if isRevolutionaryHotbed:
		var hotbedMod = tileEcoModifier.new()
		hotbedMod.modName = "RevolutionaryHotbed"
		hotbedMod.buildTileEcoMod()
		tileEcoModifiers.append(hotbedMod)
 
	# --- OCCUPIED TERRITORY ---
	# Amber/red badge: UK-owned tile that was recently taken OR has active resistance
	# Represents simmering resentment under occupation
	isOccupiedTerritory = is_occupied() and (
		recently_conquered() or
		corruption >= 40 or
		has_building_at_level("monument", 1)  # monuments inspire resistance
	)
	if isOccupiedTerritory:
		var occupiedMod = tileEcoModifier.new()
		occupiedMod.modName = "OccupiedTerritory"
		occupiedMod.buildTileEcoMod()
		tileEcoModifiers.append(occupiedMod)
 
	# --- SUNBELT HEAT ---
	# Coral badge: tiles with Sunbelt specialFeature
	# Already tagged on dozens of southern tiles
	isSunbeltHeat = tileSpecialFeatures.has("Sunbelt")
	if isSunbeltHeat:
		var sunbeltMod = tileEcoModifier.new()
		sunbeltMod.modName = "SunbeltHeat"
		sunbeltMod.buildTileEcoMod()
		tileEcoModifiers.append(sunbeltMod)

	# --- MYSTERIOUS SHIP RAIDS ---
	# Coastal MA/RI tiles set hasMysteriousShipRaids = true in the editor;
	# cleared when Old Ironsides is tamed (PROT_08_TAME fires)
	if hasMysteriousShipRaids:
		var shipMod = tileEcoModifier.new()
		shipMod.modName = "MysteriousShipRaids"
		shipMod.buildTileEcoMod()
		tileEcoModifiers.append(shipMod)

	# --- MYSTERIOUS ORATIONS ---
	# Washington DC (tile 188) sets hasMysteriousOrations = true in the editor;
	# cleared when Lincoln's Ghost is summoned via DMA investigation (PROT_17_SUMMON fires)
	if hasMysteriousOrations:
		var orationMod = tileEcoModifier.new()
		orationMod.modName = "MysteriousOrations"
		orationMod.buildTileEcoMod()
		tileEcoModifiers.append(orationMod)


#===============
#Espionage Helpers
#===============

func has_recent_espionage() -> bool:
	# Has a spy operated in this tile recently?
	# Use for: preventing new spy infiltration (cooldown),
	# counterintelligence events, tile is "burned" to spies
	# Requires world to pass current turn — see record_espionage()
	return espionageActive or (
		lastEspionageTurn >= 0 and
		_get_world_turn() - lastEspionageTurn < espionageCooldown
	)
 
func _get_world_turn() -> int:
	# Helper to safely get the current world turn
	# Assumes world.gd has a 'day' variable accessible via get_tree()
	var world = get_tree().get_root().get_node_or_null("World")
	if world:
		return world.day
	return 0
 
func record_espionage(spy_faction: String) -> void:
	# Call this when a spy successfully infiltrates this tile
	# spy_faction = CID of the country running the spy
	lastEspionageTurn = _get_world_turn()
	espionageActive = true
	# You can store the spy faction for counterintelligence events later
	# TODO: add var activeSpyFaction: String when spy system is built
 
func clear_espionage() -> void:
	# Call this when a spy is caught or extracted
	espionageActive = false
	# lastEspionageTurn stays set — tile is still "burned" for cooldown period
 
func get_espionage_cooldown_remaining() -> int:
	# How many more months until this tile can be infiltrated again?
	if not has_recent_espionage():
		return 0
	var elapsed = _get_world_turn() - lastEspionageTurn
	return max(0, espionageCooldown - elapsed)
 
func is_spy_vulnerable() -> bool:
	# Is this tile currently easy to infiltrate?
	# High corruption + no recent espionage + no governor = easy target
	# Use for: AI spy decisions, event triggers
	return not has_recent_espionage() and corruption >= 40 and not has_governor()
 
func is_counterintelligence_ready() -> bool:
	# Can this tile catch a spy?
	# Has barracks + governor + recent espionage activity
	# Use for: spy capture events
	return has_governor() and has_barracks() and espionageActive
