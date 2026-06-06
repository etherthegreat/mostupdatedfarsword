extends Node2D

class_name country

#MetaData
var CID: String #CountryID, three letter identification
var NatColor #Country border colors
var NatName #name used by the game to determine name placed over the country
var NatAdj #Adjective used by the game to describe country units, buildings, events, etc.
var NatLeader #Current Leader of the Country
var NatFaith #Religion of the country
var ToleratedPeoples: Array = [] #list of all accepted cultures in the country
var isAlive: bool
var Player: bool
var AIPersonality

var isPuppet #determines if this country is a Puppet of another country

var primaryCapital #tile that acts as this country's capital city


var countryFactionList: Array = []

#Resources - How much they have currently
var TotalGold: float
var TotalMetal: int
var TotalWood: int
var TotalFood: int
var TotalMagic: int
var TotalFaith: int
var TotalCulture: int
var TotalHarmony: float
var TotalMandate: int
var TotalScience: int
var TotalWeapons: int
var TotalInfluence: int
var TotalManpower: int

var armyReinforceRate: int

#storage
var foodStorageMax: int
var currentFoodStockpile: int
var mandateFromGranaries: bool
var mandateThreshold: int #can be 0 to 100.  almost always starts at 50 for every country.  certain modifiers 
#increase and decrease. at 50, the currentFoodStockPile has to be be 50% or higher for the 
#mandateFromGranaries bool to be set to true (giving mandate from granaries).  at 40, the currentFoodStockpile
#only has to be 40% of the foodStorageMax for the mandateFromGranaries bool to be set to true

#gains per month
var GPM: int #gold per month
var MPM: int #metal per month
var WPM: int #wood per month
var FPM: int #food per month
var APM: int #magic per month
var IPM: int #Faith per month
var CPM: int #Culture per month
var HPM: int #Harmony per month
var NDT: int #Mandate per month
var SPM: int #science per month
var PPM: int #weapons per month
var NPM: int #influence per month
var MAN: int #manpower per month

#expenses per month
var goldEXPM: int
var metalEXPM: int
var woodEXPM: int
var foodEXPM: int
var magicEXPM: int
var faithEXPM: int
var cultureEXPM: int
var harmonyEXPM: int
var mandateEXPM: int
var scienceEXPM: int
var weaponsEXPM: int
var influenceEXPM: int
var manpowerEXPM: int

#Tiles
var OwnedTileList: Array = []
var discoveredTilesList: Array = []

#Unlockables
var unlockedTechnologies: Array = []
var unlockedUnits: Array = []
var unlockedAgriculture: Array = []
var unlockedGovernors: Array = []
var unlockedSpells: Array = []
var unlockedBuildings: Array = []
var domesticatedMonsters: Array = []
var unlockedTraditions: Array = []

#Country Flags, used for determining events and lots of other things
var CountryFlags: Array = []

#Country Laws are basically buffs you can set as active, they are unlocked by Government Policies
#Pretty much all cost Mandate per month, as well as a second resource per month
#revoking a law causes a temporary debuff for a unique amount of time
var unlockedLaws: Array = []
var lawsInConstitution: Array = []
var lawsRecentlyRevoked: Array = []

#Country Religion and Faith
var selectedBeliefs: Array = []
var churchLevel: int #ranges from -3 to 3.  is calculated by finding the church beliefs by faith beliefs
var faithBeliefs: int
var churchBeliefs: int
var availableDocs: Array = []
var availableGods: Array = []

#Country Armies, a place to store all armies
var countryMaxArmySize
var countryArmyList: Array = []
var armyModList: Array = []
var countryMaxNavySize
var countryNavyList: Array = []
var navyModList: Array = []

var armyBannersList: Array = []

#Diplomatic Actions
var countryAllies: Array = [] #countries allied to this country
var countryPuppets: Array = [] #countries puppeted by this country
var countryMaster #country that is this country's master
var countryEnemies: Array = [] #countries this country is at war with
var countryAccess: Array = [] #countries allowing access to this country's troops
var countryWars: Array = [] #an array containing all Wars this country is participating in, wars are classes

#internation relationships, from a scale of -100 to 100
var rPDT #this country's attitude toward Pender Tal
var rVTO #this country's attitude toward Vitherian Order
var rEIG #this country's attitude toward Eighth House
var rDEM #this country's attitude toward the Demon Empire
var rANL #this country's attitude toward Anlaxia
#eventually, fill with every country in the game

#MagicSchools
var alcPoints: int #alchemy
var illPoints: int #illusion
var sumPoints: int #summoning
var druPoints: int #druidism
var elePoints: int #elementalism
var divPoints: int #divination

var alcLevel: int
var illLevel: int
var sumLevel: int
var druLevel: int
var eleLevel: int
var divLevel: int

var spellBaseCost: int #used to calculate the base cost of all spells
var spellCostModifier: int #used when debuffs are applied for spell costs
var spellDiscountModifier: int #used as a reward to discount spell costs

#CountryModifiers
var ecoModList: Array = [] #all economic modifiers
var diploModList: Array = [] #all diplomatic modifiers
var sciModList: Array = [] #all scienctific modifiers
var magModList: Array = [] #all magic modifiers
var faithModList: Array = [] #all faith modifiers

#Enemy Country Armies
var enemyCombatantArmiesList: Array = [] #contains all armies which, upon being in the same tile as one of this
#country's armies, will trigger combat
var rebelCombatantArmiesList: Array = [] #same thing as enemycombatantarmieslist, just for this country's rebel armies

#CountryGovernmentPolicies
var GovernmentBase #can be one of five types: monarchy, republic, theocracy, wizard council, tribe
var GovPoliciesList: Array = [] #can spend Mandate on new Gov policies, or receive them from events, or spawn with them

#buildingLevelList stores buildingLevel nodes, which store information on which buildings and max level those buildings can be build to
var buildingLevelList: Array = []
#unitTemplateList contains a list of all UnitTemplates this country has access to
var unitTemplateList: Array = []
var weaponTemplateList: Array = []
var countryBuildingList: Array = []
var countryMilModList: Array = []

var armyIconList: Array = []
var armyIcon: Texture2D

const armyScene = preload("res://Game Scenes and Scripts/army.tscn")
const milModScene = preload("res://mil_mod.tscn")
const unitScene = preload("res://unit.tscn")
const unitUIScene = preload("res://unit_ui.tscn")

var availableOres: Array
var religionControl = load("res://religion_data.gd")

var availableTools: Array
var availableKits: Array

var countryConstructionCostMod: float = 1 # 1 = 100%, .9 would be 90 % of cost, etc.

#this should literally be max but I'm stupid and don't wanna change it
var minPosTaxationAmount: int  = 0#used to calculate 'all building' taxation figures
var minFarmTaxAmount: int = 0
var minCampTaxAmount: int = 0
var minMineTaxAmount: int = 0
var minLibraryTaxAmount: int = 0
var minTempleTaxAmount: int = 0
var minTowerTaxAmount: int = 0
var minForgeTaxAmount: int = 0
var minWorkshopTaxAmount: int = 0
var minBathTaxAmount: int = 0

var setFarmTaxAmount: int = 0
var setCampTaxAmount: int = 0
var setMineTaxAmount: int = 0
var setLibraryTaxAmount: int = 0
var setTempleTaxAmount: int = 0
var setTowerTaxAmount: int = 0
var setForgeTaxAmount: int = 0
var setWorkshopTaxAmount: int = 0
var setBathTaxAmount: int = 0

var capitalPathPointButton: pathPointButton

func NewGameBuild() -> void:
	# Loads all starting data from CountryDatabase (countries.csv)
	# Replaces the old massive match statement
	var data = CountryDatabase.get_country(CID)
	if data.is_empty():
		push_error("Country: No CSV data found for CID: " + CID)
		return
 
	$religionData.buildSelf()
 
	# Identity
	NatName   = data.get("NatName", CID)
	NatAdj    = data.get("NatAdj", "Unknown")
	GovernmentBase = data.get("GovernmentBase", "Republic")
	AIPersonality  = data.get("AIPersonality", "Neutral")
	isAlive   = true
 
	# Economy settings
	spellBaseCost      = data.get("spellBaseCost", 15)
	spellCostModifier  = 0
	spellDiscountModifier = 0
	armyReinforceRate  = data.get("armyReinforceRate", 10)
	mandateThreshold   = data.get("mandateThreshold", 50)
	foodStorageMax     = data.get("foodStorageMax", 500)
 
	# Starting resources
	TotalGold     += data.get("startGold", 50.0)
	TotalFood     += data.get("startFood", 50)
	TotalWood     += data.get("startWood", 50)
	TotalMetal    += data.get("startMetal", 20)
	TotalFaith    += data.get("startFaith", 30)
	TotalMagic    += data.get("startMagic", 10)
	TotalWeapons  += data.get("startWeapons", 10)
	TotalScience  += data.get("startScience", 10)
	TotalCulture  += data.get("startCulture", 5)
	TotalHarmony  += data.get("startHarmony", 5.0)
	TotalMandate  += data.get("startMandate", 10)
	TotalInfluence+= data.get("startInfluence", 0)
	TotalManpower += data.get("startManpower", 500)
 
	# Magic schools always start at zero
	setStartingMagic()
 
	# Starting technologies
	for tech in data.get("startingTechs", []):
		addTechnologicalDiscovery(tech)
 
	# Starting beliefs (load belief lists then add selected)
	loadBeliefsList("GenericDoc1")
	loadBeliefsList("GenericDoc2")
	loadBeliefsList("GenericGods1")
	loadBeliefsList("GenericGods2")
	for belief in data.get("startingBeliefs", []):
		addReligiousBelief(belief)
 
	# Starting traditions
	for tradition in data.get("startingTraditions", []):
		addCulturalTradition(tradition)
 
	# Starting laws
	for law in data.get("startingLaws", []):
		addGovernmentLaw(law)
 
	# Starting mil mods
	for milMod in data.get("startingMilMods", []):
		addMilMod(milMod)
 
	# Starting governors — build pool then create factions
	var governorPool: Dictionary = {}
	for govData in data.get("startingGovernors", []):
		var newGov = governor.new()
		newGov.buildSelf(govData["type"], govData["level"])
		unlockedGovernors.append(newGov)
		governorPool[govData["type"]] = newGov
 
	# Starting factions — needs governors already created
	for factionData in data.get("startingFactions", []):
		# Try to find a matching governor as faction leader
		# Falls back to first available governor or placeholder
		var leader = _find_faction_leader(factionData["name"], governorPool)
		addFaction(factionData["name"], factionData["loyalty"], leader.governorType)
 
	# Taxation and unlockables
	calculateTaxationAmounts()
	updateUnlockableAttributes()
	updateDiscoveredByPlayer()
 
	# Starting army — build after everything else is set up
	var armyName = data.get("startingArmyName", "")
	var armyTile = data.get("startingArmyTile", 0)
	if armyName != "" and armyTile != 0:
		var armyIcon = _get_default_army_icon()
		addArmy(armyName, armyTile, armyIcon)
 
 
func _find_faction_leader(factionName: String, governorPool: Dictionary) -> governor:
	# Match faction to its natural leader from the governor pool
	# Falls back gracefully if no match found
	var factionLeaderMap = {
		"Sons of Liberty":      "Patrick Henry",
		"Continental Congress": "Abigail Adams",
		"Common Cause":         "Daniel Shays",
		"Abolitionist League":  "Mercy Otis Warren",
		"Free Workers Union":   "Thomas Paine",
		"Crown Loyalists":      "Lord Cornwallis",
		"Tory Merchants":       "General Howe",
		"Military Command":     "General Howe",
		"French Habitants":     "Governor Carleton",
		"British Settlers":     "Governor Carleton",
		"Indigenous Allies":    "Governor Carleton",
		"Nassau Pirates":       "Calico Jack",
		"Loyalist Refugees":    "Calico Jack",
	}
	var leaderName = factionLeaderMap.get(factionName, "")
	if leaderName != "" and governorPool.has(leaderName):
		return governorPool[leaderName]
	# Fallback — use first available governor or placeholder
	if not governorPool.is_empty():
		return governorPool.values()[0]
	var placeholder = governor.new()
	placeholder.buildSelf("Unknown Leader", 1)
	return placeholder
 
 
func _get_default_army_icon() -> Texture2D:
	# Returns a default army icon based on CID
	match CID:
		"USA":
			return load("res://art assets/finishedAssets/armyicons/finished/heart.png")
		"UK":
			return load("res://art assets/finishedAssets/armyicons/finished/horse.png")
		_:
			return load("res://art assets/finishedAssets/armyicons/finished/circle.png")

func discoverTile(pathPointButton):
	discoveredTilesList.append(pathPointButton)
	pass

signal updateDiscoveredTiles
func updateDiscoveredByPlayer():
	emit_signal("updateDiscoveredTiles", discoveredTilesList)
	pass

func setStartingMagic():
	alcPoints = 0
	illPoints = 0
	sumPoints = 0
	druPoints = 0
	elePoints = 0
	divPoints = 0
	alcLevel = 0
	illLevel = 0
	sumLevel = 0
	druLevel = 0
	eleLevel = 0
	divLevel = 0
	pass

func connectBuilding(building):
	countryBuildingList.append(building)
	building.towerBuilding.connect(assignTower)
	pass

func assignTower():
	print("ddd")
	pass

func createFactionReward(rewardType):
	match rewardType:
		"Local Elections":
			addGovernmentLaw("Local Elections")
			addGovernmentLaw("Democratic Mandate")
		"Equality Starts Here":
			addGovernmentLaw("Universal Citizenship")
			addGovernmentLaw("Disability Care")
			addGovernorToGovernorPool("Wello Jenni-Tur", 1)
		"Citizen Militias":
			addGovernmentLaw("Armed Peasantry")
			addGovernmentLaw("Homeland Defense")
	pass

func addGovernorToGovernorPool(governorType, governorLevel):
	var newGovernor = governor.new()
	newGovernor.buildSelf(governorType, governorLevel)
	unlockedGovernors.append(newGovernor)
	pass

signal displayCommander
func showCommander(commander):
	emit_signal("displayCommander", commander)
	pass

func addNewUnit(Army, UnitType, Level, WeaponType, OreType, ArmorType, curMen, curWeapons):
	var newUnit = Unit.new()
	newUnit.getUnitInfo.connect(updateUnit)
	newUnit.buildSelf(self, UnitType, Level, WeaponType, OreType, ArmorType, curMen, curWeapons)
	Army.addUnitToArmy(newUnit)
	Army.updateArmyUI()
	pass

func updateUnit(type, unitNode):
	for MilMod in countryMilModList:
		if MilMod.infantryMod == true && type == "Infantry":
			unitNode.addMilMod(MilMod)
		if MilMod.rangedMod == true && type == "Ranged":
			unitNode.addMilMod(MilMod)
		if MilMod.siegeMod == true && type == "Siege":
			unitNode.addMilMod(MilMod)
	pass

func prospectForOres() -> void:
	# Scans OwnedTileList for geological resources in mine-eligible tiles
	# Populates availableOres array with resource type strings
	# No longer uses Tile.oreSlot — uses Tile.geologicResource instead
 
	for Tile in OwnedTileList:
		# Only tiles with mines or foothills/fortress terrain are worth prospecting
		if not Tile.has_mine() and Tile.terrain not in ["Foothills", "Fortress"]:
			continue
 
		var resource = Tile.geologicResource
		if resource == "" or resource == "None":
			continue
 
		# Check if we already have this resource type
		var alreadyHave = false
		for existingOre in availableOres:
			# availableOres stores ore objects — check their oreType
			if existingOre.oreType == resource:
				alreadyHave = true
				break
 
		if not alreadyHave:
			var newOre = ore.new()
			newOre.updateSelf(resource)
			availableOres.append(newOre)
 
	# Uprisings-specific: certain special features grant resources directly
	for Tile in OwnedTileList:
		if Tile.has_special_feature("Harper's Ferry Arsenal"):
			# Harper's Ferry was chosen for its iron and water power
			_add_ore_if_missing("Iron")
		if Tile.has_special_feature("Chesapeake Shipyards"):
			_add_ore_if_missing("Wood")  # treated as ore for shipbuilding
		if Tile.has_special_feature("Gun Valley"):
			_add_ore_if_missing("Iron")
 
 
func _add_ore_if_missing(oreType: String) -> void:
	for existingOre in availableOres:
		if existingOre.oreType == oreType:
			return
	var newOre = ore.new()
	newOre.updateSelf(oreType)
	availableOres.append(newOre)

func addMilMod(Type):
	var milModInstance = milModScene.instantiate()
	milModInstance.buildSelf(Type)
	countryMilModList.append(milModInstance)
	pass

signal raiseThisArmySignal
func raiseThisArmy(Army, country, Tile):
	emit_signal("raiseThisArmySignal", Army, country, Tile)
	pass

func addArmy (Name, TileNumber, icon):
	var armyInstance = load("res://Game Scenes and Scripts/army.tscn").instantiate()
	armyInstance.buildSelf(Name, self, TileNumber, icon)
	armyInstance.raisingArmy.connect(raiseThisArmy)
	armyInstance.commanderButtonPressed.connect(showCommander)
	#print("little things")
	#print(OwnedTileList, "OwnedTiles")
	for Tile in OwnedTileList:
		print("TileNumber1 ", Tile.tileNumber, " tilenumber2 ", TileNumber)
		if Tile.tileNumber == TileNumber:
			Tile.addStationedArmy(armyInstance)
			print("tile.stationedarmy", Tile.stationedArmy)
			armyInstance.inTile = Tile
	countryArmyList.append(armyInstance)
	pass
var factionScene = load("res://faction.tscn")
func addFaction(Name: String, Loyalty: int, factionLeader: String) -> void:
	# If no leader provided, create a placeholder so faction.visualizeSelf() doesn't crash
	var leader: governor
	for governor in unlockedGovernors:
		if governor.governorType == factionLeader:
			leader = governor
	if leader == null:
		leader = governor.new()
		leader.buildSelf("Unknown Leader", 1)
	var newFaction = factionScene.instantiate()
	newFaction.buildSelf(Name, Loyalty, leader)
	countryFactionList.append(newFaction)

func changeFactionLoyalty(factionName: String, amount: int) -> void:
	for fac in countryFactionList:
		if fac.factionName == factionName:
			fac.upgradeFaction(amount)
			return
	push_warning("changeFactionLoyalty: faction '" + factionName + "' not found")

func addReligiousBelief(Name):
	var newBelief = belief.new()
	newBelief.beliefType = Name
	newBelief.buildBelief(Name)
	selectedBeliefs.append(newBelief)
	for String in availableDocs:
		if String == Name:
			availableDocs.erase(String)
	for String in availableGods:
		if String == Name:
			availableGods.erase(String)


signal updateBeliefsSignal
func loadBeliefsList(listTitle):
	match listTitle:
		"GenericDoc1":
			var genericDoc1Array: Array = $religionData.genericDoc1
			for String in genericDoc1Array:
				availableDocs.append(String)
		"GenericDoc2":
			var genericDoc2Array: Array = $religionData.genericDoc2
			for String in genericDoc2Array:
				availableDocs.append(String)
		"PDTDoc1":
			var PDTDoc1Array: Array = $religionData.PDTDoc1
			for String in PDTDoc1Array:
				availableDocs.append(String)
		"GenericGods1":
			var genericGods1Array: Array = $religionData.genericGods1
			for String in genericGods1Array:
				availableGods.append(String)
		"GenericGods2":
			var genericGods2Array: Array = $religionData.genericGods2
			for String in genericGods2Array:
				availableGods.append(String)
		"PDTGods1":
			var PDTGods1Array: Array = $religionData.PDTGods1
			for String in PDTGods1Array:
				availableGods.append(String)
	pass

func addGovernmentLaw(Name):
	var newLaw = law.new()
	newLaw.lawType = Name
	unlockedLaws.append(newLaw)
	pass

func addLawToConstitution(newLaw):
	for law in unlockedLaws:
		if law.lawType == newLaw:
			unlockedLaws.erase(law)
	var newSelection = law.new()
	newSelection.lawType = newLaw
	lawsInConstitution.append(newSelection)
	calculateTaxationAmounts()
	pass

func addCulturalTradition(Name):
	var newTradition = tradition.new()
	newTradition.traditionType = Name
	unlockedTraditions.append(newTradition)
	pass
	
var spellScene = load("res://spell.tscn")
func addSpellToSpellbook(Name, Level, Experience):
	var newSpell = spellScene.instantiate()
	newSpell.spellType = Name
	newSpell.spellLevel = Level
	newSpell.experience = Experience
	newSpell.newGameSpellAssignment()
	unlockedSpells.append(newSpell)
	#print ("country is", CID, "Spells are:", unlockedSpells)
	pass

func levelUpSchool(type):
	match type:
		"alchemy":
			alcLevel += 1
		"elementalist":
			eleLevel += 1
		"druid":
			druLevel += 1
		"diviner":
			divLevel += 1
		"summoner":
			sumLevel += 1
		"illusionist":
			illLevel += 1
	pass

func addTechnologicalDiscovery(Name):
	var newTech = Technology.new()
	newTech.techName = Name
	newTech.buildSelf()
	unlockedTechnologies.append(newTech)
	pass

func addWeaponTemplate(Name):
	var newWeaponTemplate = WeaponTemplate.new()
	newWeaponTemplate.weaponType = str(Name)
	newWeaponTemplate.buildSelf()
	weaponTemplateList.append(newWeaponTemplate)
	pass


func updateUnlockableAttributes():
	if unlockedTechnologies == null:
		print("no Technologies found in UnlockedTechnologist")
	else:
		#print("We're toally rocking out with our cocks out and everything")
		var farmBuildingLevel = buildingLevel.new()
		farmBuildingLevel.buildingType = "Farm"
		farmBuildingLevel.maxLevel = 0
		buildingLevelList.append(farmBuildingLevel)
		var campBuildingLevel = buildingLevel.new()
		campBuildingLevel.buildingType = "Camp"
		campBuildingLevel.maxLevel = 0
		buildingLevelList.append(campBuildingLevel)
		var mineBuildingLevel = buildingLevel.new()
		mineBuildingLevel.buildingType = "Mine"
		mineBuildingLevel.maxLevel = 0
		buildingLevelList.append(mineBuildingLevel)
		var libraryBuildingLevel = buildingLevel.new()
		libraryBuildingLevel.buildingType = "Library"
		libraryBuildingLevel.maxLevel = 0
		buildingLevelList.append(libraryBuildingLevel)
		var towerBuildingLevel = buildingLevel.new()
		towerBuildingLevel.buildingType = "Tower"
		towerBuildingLevel.maxLevel = 0
		buildingLevelList.append(towerBuildingLevel)
		var forgeBuildingLevel = buildingLevel.new()
		forgeBuildingLevel.buildingType = "Forge"
		forgeBuildingLevel.maxLevel = 0
		buildingLevelList.append(forgeBuildingLevel)
		var workshopBuildingLevel = buildingLevel.new()
		workshopBuildingLevel.buildingType = "Workshop"
		workshopBuildingLevel.maxLevel = 0
		buildingLevelList.append(workshopBuildingLevel)
		var governorBuildingLevel = buildingLevel.new()
		governorBuildingLevel.buildingType = "Governor's Mansion"
		governorBuildingLevel.maxLevel = 0
		buildingLevelList.append(governorBuildingLevel)
		var palaceBuildingLevel = buildingLevel.new()
		palaceBuildingLevel.buildingType = "Palace"
		palaceBuildingLevel.maxLevel = 0
		buildingLevelList.append(palaceBuildingLevel)
		var faireBuildingLevel = buildingLevel.new()
		faireBuildingLevel.buildingType = "Faire"
		faireBuildingLevel.maxLevel = 0
		buildingLevelList.append(faireBuildingLevel)
		var embassyBuildingLevel = buildingLevel.new()
		embassyBuildingLevel.buildingType = "Embassy"
		embassyBuildingLevel.maxLevel = 0
		buildingLevelList.append(embassyBuildingLevel)
		var dockBuildingLevel = buildingLevel.new()
		dockBuildingLevel.buildingType = "Dock"
		dockBuildingLevel.maxLevel = 0
		buildingLevelList.append(dockBuildingLevel)
		var harborBuildingLevel = buildingLevel.new()
		harborBuildingLevel.buildingType = "Harbor"
		harborBuildingLevel.maxLevel = 0
		buildingLevelList.append(harborBuildingLevel)
		var barracksBuildingLevel = buildingLevel.new()
		barracksBuildingLevel.buildingType = "Barracks"
		barracksBuildingLevel.maxLevel = 4
		buildingLevelList.append(barracksBuildingLevel)
		var granaryBuildingLevel = buildingLevel.new()
		granaryBuildingLevel.buildingType = "Granary"
		granaryBuildingLevel.maxLevel = 0
		buildingLevelList.append(granaryBuildingLevel)
		var templeBuildingLevel = buildingLevel.new()
		templeBuildingLevel.buildingType = "Temple"
		templeBuildingLevel.maxLevel = 0
		buildingLevelList.append(templeBuildingLevel)
		var rangedTemplate = UnitTemplate.new()
		rangedTemplate.unitType = "Ranged"
		rangedTemplate.unitDefensiveScore = 0
		rangedTemplate.unitOffensiveScore = 0
		rangedTemplate.unitImage = load("res://art assets/Placeholder Art/rang.png")
		unitTemplateList.append(rangedTemplate)
		var infantryTemplate = UnitTemplate.new()
		infantryTemplate.unitType = "Infantry"
		infantryTemplate.unitDefensiveScore = 0
		infantryTemplate.unitOffensiveScore = 0
		infantryTemplate.unitImage = load("res://art assets/Placeholder Art/inf.png")
		unitTemplateList.append(infantryTemplate)
		var siegeTemplate = UnitTemplate.new()
		siegeTemplate.unitType = "Siege"
		siegeTemplate.unitDefensiveScore = 0
		siegeTemplate.unitOffensiveScore = 0
		siegeTemplate.unitImage = load("res://art assets/Placeholder Art/sig.png")
		unitTemplateList.append(siegeTemplate)
		for Technology in unlockedTechnologies:
			if Technology.techName == "Language":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Palace":
						buildingLevel.maxLevel += 3
				for UnitTemplate in unitTemplateList:
					if UnitTemplate.unitType == "Infantry":
						UnitTemplate.unitDefensiveScore += 3
						UnitTemplate.unitOffensiveScore += 3
					if UnitTemplate.unitType == "Ranged":
						UnitTemplate.unitDefensiveScore += 3
						UnitTemplate.unitOffensiveScore += 3
				addWeaponTemplate("Atlatl")
				addWeaponTemplate("Club")
				addKit("Adventurer")
				addKit("Homesteader")
				addTool("Wooden Tools")
				addBuilding("Camp")
			if Technology.techName == "Agriculture":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Farm":
						buildingLevel.maxLevel += 5
					if buildingLevel.buildingType == "Granary":
						buildingLevel.maxLevel += 3
				addKit("Harvester")
				addBuilding("Agriculture")
				addBuilding("Granary")
			if Technology.techName == "Copper Working":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Mine":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Camp":
						buildingLevel.maxLevel += 3
				addKit("Prospector")
				addBuilding("Mine")
			if Technology.techName == "Artistry":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Workshop":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Temple":
						buildingLevel.maxLevel += 3
				addBuilding("Temple")
				addBuilding("Workshop")
			if Technology.techName == "Sailing":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Dock":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Harbor":
						buildingLevel.maxLevel += 3
			if Technology.techName == "Organization":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Barracks":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Forge":
						buildingLevel.maxLevel += 3
				addBuilding("Barracks")
				for UnitTemplate in unitTemplateList:
					if UnitTemplate.unitType == "Infantry":
						UnitTemplate.unitDefensiveScore += 3
						UnitTemplate.unitOffensiveScore += 3
					if UnitTemplate.unitType == "Ranged":
						UnitTemplate.unitDefensiveScore += 3
						UnitTemplate.unitOffensiveScore += 3
			if Technology.techName == "Writing":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Library":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Tower":
						buildingLevel.maxLevel += 3
				addKit("Scholar")
				addBuilding("Library")
				addBuilding("Tower")
			if Technology.techName == "Calendar":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Farm":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Granary":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Faire":
						buildingLevel.maxLevel += 3
				addTool("Seed Bag")
			if Technology.techName == "Bronze Working":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Camp":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Mine":
						buildingLevel.maxLevel += 3
				addTool("Metal Tools")
				addBuilding("Forge")
			if Technology.techName == "Masonry":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Workshop":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Temple":
						buildingLevel.maxLevel += 3
				addKit("Constructor")
				addBuilding("Bath")
			if Technology.techName == "Statecraft":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Governor's Mansion":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Palace":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Embassy":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Dock":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Harbor":
						buildingLevel.maxLevel += 3
				addKit("Entertainer")
			if Technology.techName == "Logistics":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Barracks":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Forge":
						buildingLevel.maxLevel += 3
				for UnitTemplate in unitTemplateList:
					if UnitTemplate.unitType == "Infantry":
						UnitTemplate.unitDefensiveScore += 3
						UnitTemplate.unitOffensiveScore += 3
					if UnitTemplate.unitType == "Ranged":
						UnitTemplate.unitDefensiveScore += 3
						UnitTemplate.unitOffensiveScore += 3
					if UnitTemplate.unitType == "Siege":
						UnitTemplate.unitDefensiveScore += 3
						UnitTemplate.unitOffensiveScore += 3
			if Technology.techName == "Administration":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Palace":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Embassy":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Governor's Mansion":
						buildingLevel.maxLevel +=3
			if Technology.techName == "Alphabet":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Library":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Tower":
						buildingLevel.maxLevel += 3
				addTool("Dictionary")
			if Technology.techName == "Irrigation":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Farm":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Granary":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Faire":
						buildingLevel.maxLevel +=3
			if Technology.techName == "Tempuring":
				addTool("Steel Tools")
	var thingForPrint: String
	for buildingLevel in buildingLevelList:
		thingForPrint = str("buildingType", buildingLevel.buildingType, "buildingLevel", buildingLevel.maxLevel)
		print(thingForPrint)
	pass

var outputsDict: Dictionary = {}


func surveyResources():
	calculateUniqueBuildingAttributes()
	FPM = 0
	WPM = 0
	GPM = 0
	PPM = 0
	APM = 0
	IPM = 0
	SPM = 0
	MPM = 0
	CPM = 0
	HPM = 0
	NDT = 0
	NPM = 0
	MAN = 0
	alcPoints = 0
	sumPoints = 0
	elePoints = 0
	illPoints = 0
	divPoints = 0
	druPoints = 0
	for Tile in OwnedTileList:
		Tile.surveyTile(self)
		Tile.calculateSpellChanges()
		FPM += Tile.buildingFoodOutput
		WPM += Tile.buildingWoodOutput
		MPM += Tile.buildingMetalOutput
		GPM += Tile.buildingGoldOutput
		IPM += Tile.buildingFaithOutput
		PPM += Tile.buildingWeaponsOutput
		APM += Tile.buildingMagicOutput
		SPM += Tile.buildingScienceOutput
		CPM += Tile.buildingCultureOutput
		HPM += Tile.buildingHarmonyOutput
		NDT += Tile.buildingMandateOutput
		NPM += Tile.buildingInfluenceOutput
		MAN += Tile.buildingManpowerOutput
		alcPoints += Tile.alcPointsOutput
		sumPoints += Tile.sumPointsOutput
		elePoints += Tile.elePointsOutput
		illPoints += Tile.illPointsOutput
		divPoints += Tile.divPointsOutput
		druPoints += Tile.druPointsOutput
	collectTaxes()
	payUnitMaintenance()
	pass

signal checkingOutput
var tempFPM = 0
var tempWPM = 0
var tempGPM = 0
var tempPPM = 0
var tempAPM = 0
var tempIPM = 0
var tempSPM = 0
var tempMPM = 0
var tempCPM = 0
var tempHPM = 0
var tempNDT = 0
var tempNPM = 0
var tempMAN =0
var tempAlcPoints = 0
var tempSumPoints = 0
var tempElePoints = 0
var tempIllPoints = 0
var tempDivPoints = 0
var tempDruPoints = 0

func outputCheck(caller):
	calculateUniqueBuildingAttributes()
	#this function starts the process of getting all the information of the resources in your lands
	outputsDict.clear()
	tempFPM = 0
	tempWPM = 0
	tempGPM = 0
	tempPPM = 0	
	tempAPM = 0
	tempIPM = 0
	tempSPM = 0
	tempMPM = 0
	tempCPM = 0
	tempHPM = 0
	tempNDT = 0
	tempNPM = 0
	tempMAN =0
	tempAlcPoints = 0
	tempSumPoints = 0
	tempElePoints = 0
	tempIllPoints = 0
	tempDivPoints = 0
	tempDruPoints = 0
	for Tile in OwnedTileList:
		Tile.surveyTile(self)
		Tile.calculateSpellChanges()
		tempFPM += Tile.buildingFoodOutput
		tempWPM += Tile.buildingWoodOutput
		tempMPM += Tile.buildingMetalOutput
		tempGPM += Tile.buildingGoldOutput
		tempIPM += Tile.buildingFaithOutput
		tempPPM += Tile.buildingWeaponsOutput
		tempAPM += Tile.buildingMagicOutput
		tempSPM += Tile.buildingScienceOutput
		tempCPM += Tile.buildingCultureOutput
		tempHPM += Tile.buildingHarmonyOutput
		tempNDT += Tile.buildingMandateOutput
		tempNPM += Tile.buildingInfluenceOutput
		tempMAN += Tile.buildingManpowerOutput
		tempAlcPoints += Tile.alcPointsOutput
		tempSumPoints += Tile.sumPointsOutput
		tempElePoints += Tile.elePointsOutput
		tempIllPoints += Tile.illPointsOutput
		tempDivPoints += Tile.divPointsOutput
		tempDruPoints += Tile.druPointsOutput
		print("points", alcPoints, sumPoints, elePoints, illPoints, divPoints, druPoints)
	outputsDict = {
		"FPM" : tempFPM,
		"WPM" : tempWPM,
		"GPM" : tempGPM,
		"PPM" : tempPPM,
		"APM" : tempAPM,
		"IPM" :tempIPM,
		"SPM" :tempSPM,
		"MPM" :tempMPM,
		"CPM" :tempCPM,
		"HPM" :tempHPM,
		"NDT" :tempNDT,
		"NPM" :tempNPM,
		"MAN" :tempMAN,
		"ALC" :tempAlcPoints,
		"SUM" :tempSumPoints,
		"ELE" :tempElePoints,
		"ILL" :tempIllPoints,
		"DIV" :tempDivPoints,
		"DRU" :tempDruPoints,
	}
	emit_signal("checkingOutput", outputsDict, caller)
	pass

func payUnitMaintenance():
	for Army in countryArmyList:
		Army.onTurnEnd()
		FPM += Army.armyFoodCost
		WPM += Army.armyWoodCost
		MPM += Army.armyMetalCost
		GPM += Army.armyGoldCost
		IPM += Army.armyFaithCost
		PPM += Army.armyWeaponsCost
		APM += Army.armyMagicCost
		SPM += Army.armyScienceCost
		CPM += Army.armyCultureCost
		HPM += Army.armyHarmonyCost
		NDT += Army.armyMandateCost
		NPM += Army.armyInfluenceCost
		MAN += Army.armyManpowerCost
	pass

func collectTaxes():
	TotalGold += GPM
	if TotalFood >= foodStorageMax:
		TotalFood = foodStorageMax
	else:
		TotalFood += FPM
	TotalWood += WPM
	TotalMetal += MPM
	TotalWeapons += PPM
	TotalFaith += IPM
	TotalMagic += APM
	TotalScience += SPM
	TotalCulture += CPM
	TotalHarmony += HPM
	TotalMandate += NDT
	TotalInfluence += NPM
	TotalManpower += MAN
	pass

func calculateUniqueBuildingAttributes():
	currentFoodStockpile = TotalFood
	foodStorageMax = 200
	mandateThreshold = 50
	for building in countryBuildingList:
		if building.buildingType == "Granary":
			foodStorageMax += (100 * building.buildingLevel)
			for Technology in unlockedTechnologies:
				if Technology.techName == "Agriculture":
					foodStorageMax += (100 * building.buildingLevel)
				if Technology.techName == "Irrigation":
					foodStorageMax += (100 * building.buildingLevel)
	for tradition in unlockedTraditions:
		if tradition.traditionType == "Guardian Cats":
			mandateThreshold -= 5
	for belief in selectedBeliefs:
		if belief.beliefType == "Days of Fast":
			mandateThreshold -= 5
	if currentFoodStockpile >= (foodStorageMax * (mandateThreshold * 0.01)):
		mandateFromGranaries = true
	else:
		mandateFromGranaries = false
	print(currentFoodStockpile, "currentFoodStockpile", foodStorageMax, "foodStorageMax ", mandateThreshold," mandateThreshold ", mandateFromGranaries," mandateFromGranaries")
	churchBeliefs = 0
	faithBeliefs = 0
	for belief in selectedBeliefs:
		if belief.faithBelief == false:
			churchBeliefs +=1
		elif belief.faithBelief == true:
			faithBeliefs +=1
	#print("faith beliefs:", faithBeliefs, "church beliefs", churchBeliefs)
	var beliefDifference = (churchBeliefs - faithBeliefs)
	if beliefDifference >= -1 && beliefDifference <= 1:
		churchLevel = 0
	elif beliefDifference >= 2 && beliefDifference <= 3:
		churchLevel = 1
	elif beliefDifference >= 4 && beliefDifference <= 5:
		churchLevel = 2
	elif beliefDifference >= 6:
		churchLevel = 3
	elif beliefDifference >= -3 && beliefDifference <= -2:
		churchLevel = -1
	elif beliefDifference >= -5 && beliefDifference <= 4:
		churchLevel = -2
	elif beliefDifference <= -6:
		churchLevel = -3  
	#print("beliefDifference", beliefDifference, "church Level", churchLevel)
	#here is where the modifier for 
	pass

func calculateTaxationAmounts():
	minFarmTaxAmount = 0
	minCampTaxAmount = 0
	minMineTaxAmount = 0
	minLibraryTaxAmount = 0
	minTempleTaxAmount = 0
	minTowerTaxAmount = 0
	minForgeTaxAmount = 0
	minWorkshopTaxAmount = 0
	minBathTaxAmount = 0
	for law in lawsInConstitution:
		match law.lawType:
			"Mercantilism":
				minPosTaxationAmount += 10
			"Homeland Defence":
				minForgeTaxAmount += 20
	minPosTaxationAmount += 15
	minFarmTaxAmount += minPosTaxationAmount
	minCampTaxAmount += minPosTaxationAmount
	minMineTaxAmount += minPosTaxationAmount
	minLibraryTaxAmount += minPosTaxationAmount
	minTempleTaxAmount += minPosTaxationAmount
	minTowerTaxAmount += minPosTaxationAmount
	minForgeTaxAmount += minPosTaxationAmount
	minWorkshopTaxAmount += minPosTaxationAmount
	minBathTaxAmount += minPosTaxationAmount
	pass

func calculateTurn() -> void:
	match CID:
		"UK":
			_uk_calculate_turn()
		"CA":
			pass  # CA is neutral for July 4th
		"BA":
			pass  # BA is opportunist — TODO DODK


# ============================================================
# UK AI — SUPPLY CHAIN SYSTEM
# BFS from army tile through contiguous CID-owned tiles to a dock.
# Unsupplied armies take 5% manpower attrition (bypasses armor).
# ============================================================

func _calculate_supply_from_owned() -> void:
	for army in countryArmyList:
		if army.inTile == null:
			army.set_meta("supplied", false)
			continue
		var supplied = _trace_supply_to_port(army.inTile)
		army.set_meta("supplied", supplied)
		if not supplied:
			_apply_supply_attrition(army)


func _trace_supply_to_port(startTile) -> bool:
	if startTile == null:
		return false
	var visited: Dictionary = {}
	var queue: Array = [startTile]
	visited[startTile.tileNumber] = true
	while queue.size() > 0:
		var current = queue.pop_front()
		if current.has_dock() and current.tileOwner == CID:
			return true
		for neighbor in current.TileNeighbors:
			if visited.has(neighbor.tileNumber):
				continue
			if neighbor.tileOwner != CID:
				continue
			visited[neighbor.tileNumber] = true
			queue.append(neighbor)
	return false


func _apply_supply_attrition(army: Army) -> void:
	var attrition_rate = 0.05
	for unit in army.unitsList:
		var loss = int(unit.unitCurrentManpower * attrition_rate)
		unit.unitCurrentManpower = max(0, unit.unitCurrentManpower - loss)
	army.surveySelf()
	print(CID, " army ", army.ArmyName, " unsupplied — attrition applied")


func is_army_supplied(army: Army) -> bool:
	return army.get_meta("supplied", true)


# ============================================================
# UK AI — ZOMBIE HORDE MODEL
# Pure military. No economy. No buildings.
# ============================================================

func _uk_calculate_turn() -> void:
	_calculate_supply_from_owned()
	for army in countryArmyList:
		if army.inTile == null:
			continue
		if army.deleteMode:
			continue
		var supplied = is_army_supplied(army)
		if not supplied:
			_uk_retreat_to_supply(army)
		else:
			var target = _find_attack_target(army)
			if target != null:
				_uk_attack_tile(army, target)
			else:
				_uk_reinforce(army)


func _find_attack_target(army: Army):
	if army.inTile == null:
		return null
	var best_target = null
	var lowest_defender_strength = INF
	for neighbor in army.inTile.TileNeighbors:
		if neighbor.tileOwner != "USA":
			continue
		var defender_strength = 0
		if neighbor.stationedArmy != null:
			defender_strength = neighbor.stationedArmy.manpowerInArmy
		else:
			defender_strength = int(neighbor.get_siege_difficulty() * 50)
		if army.manpowerInArmy > defender_strength:
			if defender_strength < lowest_defender_strength:
				lowest_defender_strength = defender_strength
				best_target = neighbor
	return best_target


func _uk_attack_tile(army: Army, targetTile) -> void:
	if targetTile == null:
		return
	targetTile.siegeCalculate(army)
	if targetTile.stationedArmy != null:
		_resolve_ai_battle(army, targetTile.stationedArmy, targetTile)
	print("UK ", army.ArmyName, " attacks ", targetTile.tileName)


func _resolve_ai_battle(attacker: Army, defender: Army, _tile) -> void:
	var raw_attack = float(attacker.armyPunch)
	var block_ratio = clamp(
		float(defender.armyBlock) / max(1.0, float(defender.unitsList.size())),
		0.0, 0.9)
	var defender_loss = int(raw_attack * (1.0 - block_ratio))

	var counter = float(defender.armyPunch)
	var attacker_block = clamp(
		float(attacker.armyBlock) / max(1.0, float(attacker.unitsList.size())),
		0.0, 0.9)
	var attacker_loss = int(counter * (1.0 - attacker_block))

	defender.calculateDefenderResults("melee", defender_loss)
	attacker.calculateDefenderResults("melee", attacker_loss)
	print("UK battle: attacker loses ", attacker_loss, " defender loses ", defender_loss)


func _uk_retreat_to_supply(army: Army) -> void:
	if army.inTile == null:
		return
	for tile in OwnedTileList:
		if not tile.has_dock():
			continue
		for neighbor in army.inTile.TileNeighbors:
			if neighbor == tile and neighbor.tileOwner == CID:
				army.inTile = neighbor
				print("UK ", army.ArmyName, " retreats to supply at ", neighbor.tileName)
				return


func _uk_reinforce(_army: Army) -> void:
	pass

func setNewTaxAmount(amount, type):
	match type:
		"Farm":
			setFarmTaxAmount = amount
		"Camp":
			setCampTaxAmount = amount
		"Mine":
			setMineTaxAmount = amount
		"Library":
			setLibraryTaxAmount = amount
		"Temple":
			setTempleTaxAmount = amount
		"Tower":
			setTowerTaxAmount = amount
		"Forge":
			setTowerTaxAmount = amount
		"Workshop":
			setWorkshopTaxAmount = amount
		"Bath":
			setBathTaxAmount = amount
	print(type," changed to ", amount, "DEBUG")
	pass

func payBill(type, amount):
	match type:
		"faith":
			TotalFaith -= amount
			print("debug")
	pass

var newToolScene = load("res://tool.tscn")

func addTool(type):
	var newToolType = newToolScene.instantiate()
	newToolType.buildSelf(type)
	availableTools.append(newToolType)
	pass

var newKitScene = load("res://kit.tscn")

var newBuildingScene = load("res://Game Scenes and Scripts/building.tscn")
func addBuilding(type):
	var newBuilding = newBuildingScene.instantiate()
	newBuilding.buildingType = type
	newBuilding.buildBuilding()
	unlockedBuildings.append(newBuilding)
	pass

func addKit(type):
	var newKitType = newKitScene.instantiate()
	newKitType.buildSelf(type)
	availableKits.append(newKitType)
	pass

func addTile(tileToAdd):
	OwnedTileList.append(tileToAdd)
	pass

func unlockArmyIcon(icon):
	armyIconList.append(icon)
	pass

#=============================================
#Save Functions
#=============================================

func save_state() -> Dictionary:
	var state = {
		"CID": CID,
		"isAlive": isAlive,
 
		# Current resources
		"TotalGold":     TotalGold,
		"TotalFood":     TotalFood,
		"TotalWood":     TotalWood,
		"TotalMetal":    TotalMetal,
		"TotalFaith":    TotalFaith,
		"TotalMagic":    TotalMagic,
		"TotalWeapons":  TotalWeapons,
		"TotalScience":  TotalScience,
		"TotalCulture":  TotalCulture,
		"TotalHarmony":  TotalHarmony,
		"TotalMandate":  TotalMandate,
		"TotalInfluence":TotalInfluence,
		"TotalManpower": TotalManpower,
 
		# Magic schools
		"alcPoints": alcPoints, "alcLevel": alcLevel,
		"illPoints": illPoints, "illLevel": illLevel,
		"sumPoints": sumPoints, "sumLevel": sumLevel,
		"druPoints": druPoints, "druLevel": druLevel,
		"elePoints": elePoints, "eleLevel": eleLevel,
		"divPoints": divPoints, "divLevel": divLevel,
 
		# Economy settings that can change
		"armyReinforceRate": armyReinforceRate,
		"mandateThreshold":  mandateThreshold,
		"foodStorageMax":    foodStorageMax,
		"spellBaseCost":     spellBaseCost,
 
		# Unlockables — save names only, rebuild objects on load
		"unlockedTechs": _save_tech_list(),
		"selectedBeliefs": _save_belief_list(),
		"lawsInConstitution": _save_law_list(),
		"unlockedLaws": _save_unlocked_law_list(),
		"unlockedTraditions": _save_tradition_list(),
 
		# Factions — save name + loyalty
		"factions": _save_faction_list(),
 
		# Governors — save type + level + hired status
		"governors": _save_governor_list(),
 
		# Armies — save name + tile number + unit composition
		"armies": _save_army_list(),
 
		# Diplomacy
		"countryEnemies": countryEnemies.map(func(c): return c.CID if c else ""),
		"countryAllies":  countryAllies.map(func(c): return c.CID if c else ""),
	}
	return state
 
 
func _save_tech_list() -> Array:
	var result = []
	for tech in unlockedTechnologies:
		result.append(tech.techName)
	return result
 
func _save_belief_list() -> Array:
	var result = []
	for belief in selectedBeliefs:
		result.append(belief.beliefType)
	return result
 
func _save_law_list() -> Array:
	var result = []
	for law in lawsInConstitution:
		result.append(law.lawType)
	return result
 
func _save_unlocked_law_list() -> Array:
	var result = []
	for law in unlockedLaws:
		result.append(law.lawType)
	return result
 
func _save_tradition_list() -> Array:
	var result = []
	for tradition in unlockedTraditions:
		result.append(tradition.traditionType)
	return result
 
func _save_faction_list() -> Array:
	var result = []
	for f in countryFactionList:
		result.append({
			"name": f.factionName,
			"loyalty": f.factionLoyalty
		})
	return result
 
func _save_governor_list() -> Array:
	var result = []
	for gov in unlockedGovernors:
		result.append({
			"type": gov.governorType,
			"level": gov.governorLevel,
			"hired": gov.hired
		})
	return result
 
func _save_army_list() -> Array:
	var result = []
	for army in countryArmyList:
		var units = []
		for unit in army.unitsList:
			units.append({
				"unitType": unit.unitType,
				"level": unit.unitLevel,
				"weaponType": unit.unitWeapon.weaponType if unit.unitWeapon else "",
				"oreType": unit.unitOre.oreType if unit.unitOre else "",
				"armorType": unit.unitArmor.armorType if unit.unitArmor else "",
				"curMen": unit.unitCurrentManpower,
				"curWeapons": unit.unitCurrentWeapons
			})
		result.append({
			"name": army.ArmyName,
			"tileNumber": army.inTile.tileNumber if army.inTile else 0,
			"units": units
		})
	return result

#===================
#Load System
#==================
func build_from_save(save_data: Dictionary) -> void:
	# Static identity already set by NewGameBuild from CSV
	# This only restores the dynamic runtime state
 
	isAlive = save_data.get("isAlive", true)
 
	# Restore resources
	TotalGold      = save_data.get("TotalGold", TotalGold)
	TotalFood      = save_data.get("TotalFood", TotalFood)
	TotalWood      = save_data.get("TotalWood", TotalWood)
	TotalMetal     = save_data.get("TotalMetal", TotalMetal)
	TotalFaith     = save_data.get("TotalFaith", TotalFaith)
	TotalMagic     = save_data.get("TotalMagic", TotalMagic)
	TotalWeapons   = save_data.get("TotalWeapons", TotalWeapons)
	TotalScience   = save_data.get("TotalScience", TotalScience)
	TotalCulture   = save_data.get("TotalCulture", TotalCulture)
	TotalHarmony   = save_data.get("TotalHarmony", TotalHarmony)
	TotalMandate   = save_data.get("TotalMandate", TotalMandate)
	TotalInfluence = save_data.get("TotalInfluence", TotalInfluence)
	TotalManpower  = save_data.get("TotalManpower", TotalManpower)
 
	# Restore magic schools
	alcPoints = save_data.get("alcPoints", 0)
	alcLevel  = save_data.get("alcLevel", 0)
	illPoints = save_data.get("illPoints", 0)
	illLevel  = save_data.get("illLevel", 0)
	sumPoints = save_data.get("sumPoints", 0)
	sumLevel  = save_data.get("sumLevel", 0)
	druPoints = save_data.get("druPoints", 0)
	druLevel  = save_data.get("druLevel", 0)
	elePoints = save_data.get("elePoints", 0)
	eleLevel  = save_data.get("eleLevel", 0)
	divPoints = save_data.get("divPoints", 0)
	divLevel  = save_data.get("divLevel", 0)
 
	# Restore economy settings
	armyReinforceRate = save_data.get("armyReinforceRate", armyReinforceRate)
	mandateThreshold  = save_data.get("mandateThreshold", mandateThreshold)
	foodStorageMax    = save_data.get("foodStorageMax", foodStorageMax)
 
	# Restore technologies (clear defaults then rebuild from save)
	unlockedTechnologies.clear()
	for techName in save_data.get("unlockedTechs", []):
		addTechnologicalDiscovery(techName)
 
	# Restore beliefs
	selectedBeliefs.clear()
	for beliefName in save_data.get("selectedBeliefs", []):
		addReligiousBelief(beliefName)
 
	# Restore laws
	lawsInConstitution.clear()
	for lawName in save_data.get("lawsInConstitution", []):
		var newLaw = law.new()
		newLaw.lawType = lawName
		lawsInConstitution.append(newLaw)
 
	unlockedLaws.clear()
	for lawName in save_data.get("unlockedLaws", []):
		addGovernmentLaw(lawName)
 
	# Restore traditions
	unlockedTraditions.clear()
	for tradName in save_data.get("unlockedTraditions", []):
		addCulturalTradition(tradName)
 
	# Restore factions — update loyalty on existing factions
	for savedFaction in save_data.get("factions", []):
		for existingFaction in countryFactionList:
			if existingFaction.factionName == savedFaction["name"]:
				existingFaction.factionLoyalty = savedFaction["loyalty"]
				break
 
	# Restore governors — update levels and hired status
	for savedGov in save_data.get("governors", []):
		for existingGov in unlockedGovernors:
			if existingGov.governorType == savedGov["type"]:
				existingGov.governorLevel = savedGov["level"]
				existingGov.hired = savedGov.get("hired", false)
				break
 
	# Recalculate derived values
	calculateTaxationAmounts()
	updateUnlockableAttributes()


# func build_starting_armies() -> void:
#     # Called from NewGameBuild() after tiles are assigned
#     # Replaces the hardcoded addArmy() calls
#     var templates = ArmyDatabase.get_templates_for_country(CID)
#     for template in templates:
#         var icon = _get_default_army_icon()
#         addArmy(template["armyName"], template["spawnTile"], icon)
#         # Find the army we just added and populate its units
#         for army in countryArmyList:
#             if army.ArmyName == template["armyName"]:
#                 _populate_army_units(army, template["units"])
#                 # Apply army mods from template
#                 for modName in template["armyMods"]:
#                     addMilMod(modName)
#                 break
#
# func _populate_army_units(army: Army, unitTemplates: Array) -> void:
#     for unitData in unitTemplates:
#         addNewUnit(
#             army,
#             unitData["unitType"],
#             unitData["level"],
#             unitData["weaponType"],
#             "Iron",                   # default ore — can extend CSV later
#             unitData["uniformType"],
#             unitData["manpower"],
#             unitData["weapons"]
#         )
#
# func restore_army_from_save(armyState: Dictionary, allTiles: Array) -> void:
#     # Called during load game — rebuilds army from saved JSON state
#     var icon = _get_default_army_icon()
#     addArmy(armyState["armyName"], armyState["inTileNumber"], icon)
#     for army in countryArmyList:
#         if army.ArmyName == armyState["armyName"]:
#             # Restore units
#             for unitData in armyState.get("units", []):
#                 addNewUnit(
#                     army,
#                     unitData["unitType"],
#                     unitData["unitLevel"],
#                     unitData["weaponType"],
#                     unitData["oreType"],
#                     unitData["uniformType"],
#                     unitData["currentManpower"],
#                     unitData["currentWeapons"]
#                 )
#                 # Restore per-unit dynamic state
#                 var unit = army.unitsList.back()
#                 unit.unitShield    = unitData.get("currentShield", unit.unitMaxShield)
#                 unit.reloadCounter = unitData.get("reloadCounter", 0)
#             # Restore army-level state
#             army.inRetreat  = armyState.get("inRetreat", false)
#             army.raised     = armyState.get("raised", false)
#             army.deleteMode = armyState.get("deleteMode", false)
#             # Restore spell if active
#             var spellName = armyState.get("armySpell", "")
#             if spellName != "":
#                 var savedSpell = spell.new()
#                 savedSpell.spellType = spellName
#                 army.armySpell = savedSpell
#                 army.armySpellDuration = armyState.get("armySpellDuration", 0)
#             break
