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

var presidentialClaim: float = 0.0  # USA only: –10 to +10 political legitimacy


var isPuppet #determines if this country is a Puppet of another country

var primaryCapital #tile that acts as this country's capital city


var countryFactionList: Array = []

#Resources - How much they have currently
var TotalDollars: float   # renamed from TotalGold
var TotalMetal: int
var TotalWood: int
var TotalFood: int
var TotalMagic: int
var cherry_blossom_magic_acc: float = 0.0
var pioneer_heritage_corrupt_acc: Dictionary = {}
var nature_conservationists_corrupt_acc: Dictionary = {}
var civic_pride_mandate_acc: float = 0.0
var TotalCulture: int     # now covers both Culture and old Faith
var TotalHappiness: float # renamed from TotalHarmony
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
var DPM: int #dollars per month (renamed from DPM)
var MPM: int #metal per month
var WPM: int #wood per month
var FPM: int #food per month
var APM: int #magic per month
# IPM (Faith per month) removed — faith merged into Culture
var CPM: int #Culture per month (now covers Faith + Culture)
var HPM: int #Happiness per month (renamed from Harmony)
var NDT: int #Mandate per month
var SPM: int #science per month
var PPM: int #weapons per month
var NPM: int #influence per month
var MAN: int #manpower per month

#expenses per month
var dollarsEXPM: int  # renamed from goldEXPM
var metalEXPM: int
var woodEXPM: int
var foodEXPM: int
var magicEXPM: int
# faithEXPM removed — merged into cultureEXPM
var cultureEXPM: int
var happinessEXPM: int  # renamed from harmonyEXPM
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
var CountryFlags: Dictionary = {}

# Countries formally allied with this one — allows tile entry and shared visibility
var ALLIED: Array = []

#Country Laws are basically buffs you can set as active, they are unlocked by Government Policies
#Pretty much all cost Mandate per month, as well as a second resource per month
#revoking a law causes a temporary debuff for a unique amount of time
var unlockedLaws: Array = []
var lawsInConstitution: Array = []
var lawsRecentlyRevoked: Array = []
# Political compass position derived from enacted laws.
# X: Reformatory(+1) vs Conservatory(-1)   Y: Revolutionary(+1) vs Liberator(-1)
var lawQuadrantX: float = 0.0
var lawQuadrantY: float = 0.0

#Country Religion and Faith
var selectedBeliefs: Array = []
var churchLevel: int #ranges from -3 to 3.  is calculated by finding the church beliefs by faith beliefs
var faithBeliefs: int
var churchBeliefs: int
var beliefPurchaseCount: int = 0   # escalating cost: cost = max(10, int(10 * 1.2^count))
var availableDocs: Array = []
var availableGods: Array = []

#Country Armies, a place to store all armies
var countryMaxArmySize
var countryArmyList: Array = []
var purchasedArmyCount: int = 0   # armies bought mid-game; excludes game-start spawns
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
var manifestPoints: int #alchemy
var spectralPoints: int #illusion
var cryptidPoints: int #summoning
var stormPoints: int #druidism
var ironPoints: int #elementalism
var libertyPoints: int #divination

var manifestLevel: int
var spectralLevel: int
var cryptidLevel: int
var stormLevel: int
var ironLevel: int
var libertyLevel: int

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
	TotalDollars   += data.get("startGold", 50.0)     # "startGold" key kept for save compat
	TotalFood      += data.get("startFood", 50)
	TotalWood      += data.get("startWood", 50)
	TotalMetal     += data.get("startMetal", 20)
	# startFaith merged into startCulture — combine both defaults into TotalCulture
	TotalCulture   += data.get("startCulture", 5) + data.get("startFaith", 0)
	TotalMagic     += data.get("startMagic", 10)
	TotalWeapons   += data.get("startWeapons", 10)
	TotalScience   += data.get("startScience", 10)
	TotalHappiness += data.get("startHarmony", 5.0)   # "startHarmony" key kept for compat
	TotalMandate   += data.get("startMandate", 10)
	TotalInfluence += data.get("startInfluence", 0)
	TotalManpower  += data.get("startManpower", 500)
 
	# Magic schools always start at zero
	setStartingMagic()
 
	# Starting technologies
	for tech in data.get("startingTechs", []):
		addTechnologicalDiscovery(tech)
 
	# Starting beliefs (load belief lists then add selected)
	match CID:
		"USA":
			loadBeliefsList("GenericDoc1")
			loadBeliefsList("GenericDoc2")
			loadBeliefsList("PDTDoc1")
			loadBeliefsList("GenericGods1")
			loadBeliefsList("GenericGods2")
		"CA":
			loadBeliefsList("CADoc1")
			loadBeliefsList("CADoc2")
			loadBeliefsList("CADocSpecial")
			loadBeliefsList("CAGods1")
			loadBeliefsList("CAGods2")
		_:
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
	_initialize_purchasable_laws()

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

signal updateDiscoveredTiles
func updateDiscoveredByPlayer():
	emit_signal("updateDiscoveredTiles", discoveredTilesList)

func setStartingMagic():
	manifestPoints = 0
	spectralPoints = 0
	cryptidPoints = 0
	stormPoints = 0
	ironPoints = 0
	libertyPoints = 0
	manifestLevel = 0
	spectralLevel = 0
	cryptidLevel = 0
	stormLevel = 0
	ironLevel = 0
	libertyLevel = 0

func connectBuilding(building):
	countryBuildingList.append(building)
	building.towerBuilding.connect(assignTower)

func assignTower():
	print("ddd")

func createFactionReward(rewardType):
	match rewardType:
		# Sons of Liberty
		"Militia Muster":
			addGovernmentLaw("Second Amendment")
			addGovernmentLaw("National Security Act")
		"Merchant Networks":
			addGovernmentLaw("Merchant Marine Act")
		"Letters of Marque":
			addGovernorToGovernorPool("Calico Jack", 1)
		# Continental Congress
		"Articles of Confederation":
			addGovernmentLaw("Municipal Reform Act")
			addGovernmentLaw("Voting Rights Act")
		"Foreign Diplomacy":
			pass
		"Constitutional Convention":
			addGovernmentLaw("Voting Rights Act")
		# Common Cause
		"Frontier Homesteads":
			addGovernmentLaw("Second Amendment")
		"The People's Assembly":
			addGovernmentLaw("Civil Rights Act")
		"Land Reform":
			pass
		# Abolitionist League
		"Freedom Papers":
			addGovernmentLaw("Civil Rights Act")
			addGovernmentLaw("Americans with Disabilities Act")
		"Underground Railroad":
			addGovernorToGovernorPool("Phillis Wheatley", 1)
		"Universal Emancipation":
			addGovernmentLaw("Voting Rights Act")
		# Free Workers Union
		"Guild Charters":
			pass
		"General Strike":
			addGovernmentLaw("Americans with Disabilities Act")
		"Workers Commonwealth":
			addGovernmentLaw("Civil Rights Act")
		# French Habitants
		"Quebec Act Recognition":
			addGovernmentLaw("Municipal Elections Act")
		"Habitants Alliance":
			addGovernorToGovernorPool("Pierre Renard", 1)
		"Republic of Quebec":
			addGovernmentLaw("Canadian Citizenship Act")
			addGovernmentLaw("Dominion Elections Act")
		# Loyalist Settlers
		"Crown Defectors":
			addGovernmentLaw("National Defence Act")
		"Pragmatic Compact":
			addGovernorToGovernorPool("Benjamin Tallmadge", 2)
		"New Republic Converts":
			addGovernmentLaw("Canada Shipping Act")
			addGovernmentLaw("Dominion Elections Act")
		# Haudenosaunee Confederacy
		"Treaty of Friendship":
			addGovernmentLaw("Canadian Citizenship Act")
		"Haudenosaunee Alliance":
			pass
		"Sovereign Partnership":
			addGovernmentLaw("Canadian Citizenship Act")
			addGovernmentLaw("Accessible Canada Act")
		# Coureurs des Bois
		"Trade Routes":
			pass
		"Frontier Network":
			addGovernorToGovernorPool("Louis Tremblant", 1)
		"Continental Reach":
			pass
		# Maritime Patriots
		"Port Alliance":
			pass
		"Atlantic Commerce":
			addGovernmentLaw("Merchant Marine Act")
		"Maritime Union":
			pass

func addGovernorToGovernorPool(governorType, governorLevel):
	var newGovernor = governor.new()
	newGovernor.buildSelf(governorType, governorLevel)
	unlockedGovernors.append(newGovernor)

signal displayCommander
func showCommander(commander, army):
	emit_signal("displayCommander", commander, army)

func addNewUnit(Army, UnitType, Level, WeaponType, OreType, ArmorType, curMen, curWeapons):
	var newUnit = Unit.new()
	newUnit.getUnitInfo.connect(updateUnit)
	newUnit.buildSelf(self, UnitType, Level, WeaponType, OreType, ArmorType, curMen, curWeapons)
	Army.addUnitToArmy(newUnit)
	Army.updateArmyUI()

func updateUnit(type, unitNode):
	for MilMod in countryMilModList:
		if MilMod.infantryMod == true && type == "Infantry":
			unitNode.addMilMod(MilMod)
		if MilMod.rangedMod == true && type == "Ranged":
			unitNode.addMilMod(MilMod)
		if MilMod.siegeMod == true && type == "Siege":
			unitNode.addMilMod(MilMod)

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

signal raiseThisArmySignal
func raiseThisArmy(Army, country, Tile):
	emit_signal("raiseThisArmySignal", Army, country, Tile)

func addArmy(Name, TileNumber, icon = null, tags: Array = []):
	# icon is optional — defaults to CID-based icon if not provided
	if icon == null:
		icon = _get_default_army_icon()
	var armyInstance = load("res://Game Scenes and Scripts/army.tscn").instantiate()
	armyInstance.buildSelf(Name, self, TileNumber, icon)
	armyInstance.raisingArmy.connect(raiseThisArmy)
	armyInstance.commanderButtonPressed.connect(showCommander)
	# ── Template lookup: populate armyTags AND units from army_templates.csv ──
	# Tags: caller-supplied tags take priority; otherwise read from CSV armyMods
	if not tags.is_empty():
		armyInstance.armyTags = tags
	var templates = ArmyDatabase.get_templates_for_country(CID)
	for template in templates:
		if template.get("armyName", "") == Name:
			if tags.is_empty():
				armyInstance.armyTags = template.get("armyMods", [])
			# Spawn every unit defined in the CSV into the army
			for unitData in template.get("units", []):
				addNewUnit(
					armyInstance,
					unitData.get("unitType",    "Infantry"),
					unitData.get("level",       1),
					unitData.get("weaponType",  "Flintlock"),
					"Iron",                              # OreType — default for all starting armies
					unitData.get("uniformType", "Cloth"),# ArmorType maps to uniform cosmetic
					unitData.get("manpower",    100),
					unitData.get("weapons",     100)
				)
			break
	# ── Tile placement ────────────────────────────────────────────────────────
	for Tile in OwnedTileList:
		if Tile.tileNumber == TileNumber:
			Tile.addStationedArmy(armyInstance)
			armyInstance.inTile = Tile
	armyInstance.armyDestroyed.connect(_on_army_destroyed)
	countryArmyList.append(armyInstance)

signal commanderFallen(commander, army_name: String, tile)
signal countryArmyDestroyed(lost_army: Army)

func _on_army_destroyed(army: Army) -> void:
	if army.commander != null:
		emit_signal("commanderFallen", army.commander, army.ArmyName, army.inTile)
	countryArmyList.erase(army)
	if army.inTile != null:
		army.inTile.stationedArmy = null
	emit_signal("countryArmyDestroyed", army)
	army.queue_free()

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
		"CADoc1":
			var CADoc1Array: Array = $religionData.CADoc1
			for String in CADoc1Array:
				availableDocs.append(String)
		"CADoc2":
			var CADoc2Array: Array = $religionData.CADoc2
			for String in CADoc2Array:
				availableDocs.append(String)
		"CADocSpecial":
			var CADocSpecialArray: Array = $religionData.CADocSpecial
			for String in CADocSpecialArray:
				availableDocs.append(String)
		"CAGods1":
			var CAGods1Array: Array = $religionData.CAGods1
			for String in CAGods1Array:
				availableGods.append(String)
		"CAGods2":
			var CAGods2Array: Array = $religionData.CAGods2
			for String in CAGods2Array:
				availableGods.append(String)

const FACTION_GATED_LAWS: Array = [
	"Voting Rights Act",
	"Civil Rights Act",
	"Americans with Disabilities Act",
	"Dominion Elections Act",
	"Canadian Citizenship Act",
	"Accessible Canada Act",
]

func _initialize_purchasable_laws() -> void:
	match CID:
		"USA":
			addGovernmentLaw("Second Amendment")
			addGovernmentLaw("Merchant Marine Act")
			addGovernmentLaw("National Security Act")
			addGovernmentLaw("Municipal Reform Act")
		"CA":
			addGovernmentLaw("National Defence Act")
			addGovernmentLaw("Municipal Elections Act")
			addGovernmentLaw("Militia Act")

func recalculateLawQuadrant() -> void:
	var rev := 0
	var ref := 0
	var con := 0
	var lib := 0
	for l in lawsInConstitution:
		var tempLaw = law.new()
		tempLaw.lawType = l.lawType
		tempLaw.buildSelf(l.lawType, true)
		match tempLaw.quadrant:
			"Revolutionary": rev += 1
			"Reformatory":   ref += 1
			"Conservatory":  con += 1
			"Liberator":     lib += 1
	var total := float(rev + ref + con + lib)
	if total == 0:
		lawQuadrantX = 0.0
		lawQuadrantY = 0.0
	else:
		lawQuadrantX = (ref - con) / total
		lawQuadrantY = (rev - lib) / total

func addGovernmentLaw(Name):
	for existing in unlockedLaws:
		if existing.lawType == Name:
			return
	for enacted in lawsInConstitution:
		if enacted.lawType == Name:
			return
	var newLaw = law.new()
	newLaw.lawType = Name
	unlockedLaws.append(newLaw)

func addLawToConstitution(newLaw):
	for law in unlockedLaws:
		if law.lawType == newLaw:
			unlockedLaws.erase(law)
	var newSelection = law.new()
	newSelection.lawType = newLaw
	lawsInConstitution.append(newSelection)
	recalculateLawQuadrant()

func addCulturalTradition(Name):
	var newTradition = tradition.new()
	newTradition.traditionType = Name
	unlockedTraditions.append(newTradition)
	
var spellScene = load("res://spell.tscn")
func addSpellToSpellbook(Name, Level, Experience):
	var newSpell = spellScene.instantiate()
	newSpell.spellType = Name
	newSpell.spellLevel = Level
	newSpell.experience = Experience
	newSpell.newGameSpellAssignment()
	unlockedSpells.append(newSpell)
	#print ("country is", CID, "Spells are:", unlockedSpells)

func levelUpSchool(type):
	match type:
		"manifest", "alchemy":    manifestLevel += 1
		"iron", "elementalist":   ironLevel     += 1
		"storm", "druid":         stormLevel    += 1
		"liberty", "diviner":     libertyLevel  += 1
		"cryptid", "summoner":    cryptidLevel  += 1
		"spectral", "illusionist":spectralLevel += 1

func addTechnologicalDiscovery(Name):
	var newTech = Technology.new()
	newTech.techName = Name
	newTech.buildSelf()
	unlockedTechnologies.append(newTech)

func addWeaponTemplate(Name):
	var newWeaponTemplate = WeaponTemplate.new()
	newWeaponTemplate.weaponType = str(Name)
	newWeaponTemplate.buildSelf()
	weaponTemplateList.append(newWeaponTemplate)


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

var outputsDict: Dictionary = {}


func surveyResources():
	calculateUniqueBuildingAttributes()
	FPM = 0
	WPM = 0
	DPM = 0
	PPM = 0
	APM = 0
	# IPM removed — faith merged into Culture/CPM
	SPM = 0
	MPM = 0
	CPM = 0
	HPM = 0
	NDT = 0
	NPM = 0
	MAN = 0
	manifestPoints = 0
	cryptidPoints = 0
	ironPoints = 0
	spectralPoints = 0
	libertyPoints = 0
	stormPoints = 0
	for Tile in OwnedTileList:
		Tile.surveyTile(self)
		Tile.calculateSpellChanges()
		FPM += Tile.buildingFoodOutput
		WPM += Tile.buildingWoodOutput
		MPM += Tile.buildingMetalOutput
		DPM += Tile.buildingDollarsOutput    # renamed from buildingGoldOutput
		# buildingFaithOutput removed — faith merged into culture
		PPM += Tile.buildingWeaponsOutput
		APM += Tile.buildingMagicOutput
		SPM += Tile.buildingScienceOutput
		CPM += Tile.buildingCultureOutput    # covers both old faith and culture
		HPM += Tile.buildingHappinessOutput  # renamed from buildingHarmonyOutput
		NDT += Tile.buildingMandateOutput
		NPM += Tile.buildingInfluenceOutput
		MAN += Tile.buildingManpowerOutput
		manifestPoints += Tile.manifestPointsOutput
		cryptidPoints += Tile.cryptidPointsOutput
		ironPoints += Tile.ironPointsOutput
		spectralPoints += Tile.spectralPointsOutput
		libertyPoints += Tile.libertyPointsOutput
		stormPoints += Tile.stormPointsOutput
	collectTaxes()
	payUnitMaintenance()

signal checkingOutput
var tempFPM = 0
var tempWPM = 0
var tempDPM = 0
var tempPPM = 0
var tempAPM = 0
# tempIPM removed — faith merged into culture
var tempSPM = 0
var tempMPM = 0
var tempCPM = 0
var tempHPM = 0
var tempNDT = 0
var tempNPM = 0
var tempMAN = 0
var tempManifestPoints = 0
var tempCryptidPoints = 0
var tempIronPoints = 0
var tempSpectralPoints = 0
var tempLibertyPoints = 0
var tempStormPoints = 0

func outputCheck(caller):
	calculateUniqueBuildingAttributes()
	#this function starts the process of getting all the information of the resources in your lands
	outputsDict.clear()
	tempFPM = 0
	tempWPM = 0
	tempDPM = 0
	tempPPM = 0
	tempAPM = 0
	# tempIPM removed — faith merged into culture
	tempSPM = 0
	tempMPM = 0
	tempCPM = 0
	tempHPM = 0
	tempNDT = 0
	tempNPM = 0
	tempMAN = 0
	tempManifestPoints = 0
	tempCryptidPoints = 0
	tempIronPoints = 0
	tempSpectralPoints = 0
	tempLibertyPoints = 0
	tempStormPoints = 0
	for Tile in OwnedTileList:
		Tile.surveyTile(self)
		Tile.calculateSpellChanges()
		tempFPM += Tile.buildingFoodOutput
		tempWPM += Tile.buildingWoodOutput
		tempMPM += Tile.buildingMetalOutput
		tempDPM += Tile.buildingDollarsOutput    # renamed from buildingGoldOutput
		# buildingFaithOutput removed — faith merged into culture
		tempPPM += Tile.buildingWeaponsOutput
		tempAPM += Tile.buildingMagicOutput
		tempSPM += Tile.buildingScienceOutput
		tempCPM += Tile.buildingCultureOutput    # covers old faith + culture
		tempHPM += Tile.buildingHappinessOutput  # renamed from buildingHarmonyOutput
		tempNDT += Tile.buildingMandateOutput
		tempNPM += Tile.buildingInfluenceOutput
		tempMAN += Tile.buildingManpowerOutput
		tempManifestPoints += Tile.manifestPointsOutput
		tempCryptidPoints += Tile.cryptidPointsOutput
		tempIronPoints += Tile.ironPointsOutput
		tempSpectralPoints += Tile.spectralPointsOutput
		tempLibertyPoints += Tile.libertyPointsOutput
		tempStormPoints += Tile.stormPointsOutput
		print("points", manifestPoints, cryptidPoints, ironPoints, spectralPoints, libertyPoints, stormPoints)
	outputsDict = {
		"FPM" : tempFPM,
		"WPM" : tempWPM,
		"DPM" : tempDPM,
		"PPM" : tempPPM,
		"APM" : tempAPM,
		# IPM removed from dict
		"SPM" : tempSPM,
		"MPM" : tempMPM,
		"CPM" : tempCPM,
		"HPM" : tempHPM,
		"NDT" : tempNDT,
		"NPM" : tempNPM,
		"MAN" : tempMAN,
		"MANIFEST" : tempManifestPoints,
		"CRYPTID"  : tempCryptidPoints,
		"IRON"     : tempIronPoints,
		"SPECTRAL" : tempSpectralPoints,
		"LIBERTY"  : tempLibertyPoints,
		"STORM"    : tempStormPoints,
	}
	emit_signal("checkingOutput", outputsDict, caller)

func payUnitMaintenance():
	for Army in countryArmyList:
		Army.onTurnEnd()
		FPM += Army.armyFoodCost
		WPM += Army.armyWoodCost
		MPM += Army.armyMetalCost
		DPM += Army.armyGoldCost     # armyGoldCost still works (dollars cost)
		# armyFaithCost removed — faith merged into culture
		PPM += Army.armyWeaponsCost
		APM += Army.armyMagicCost
		SPM += Army.armyScienceCost
		CPM += Army.armyCultureCost
		HPM += Army.armyHarmonyCost  # still valid var name in army.gd (cost rename deferred)
		NDT += Army.armyMandateCost
		NPM += Army.armyInfluenceCost
		MAN += Army.armyManpowerCost

func collectTaxes():
	TotalDollars += DPM
	if TotalFood >= foodStorageMax:
		TotalFood = foodStorageMax
	else:
		TotalFood += FPM
	TotalWood += WPM
	TotalMetal += MPM
	TotalWeapons += PPM
	# IPM removed — faith merged into culture; CPM covers both
	TotalMagic += APM
	TotalScience += SPM
	TotalCulture += CPM   # covers old Faith + Culture outputs
	TotalHappiness += HPM # renamed from TotalHarmony
	TotalMandate += NDT
	TotalInfluence += NPM
	TotalManpower += MAN

func calculateUniqueBuildingAttributes():
	currentFoodStockpile = TotalFood
	foodStorageMax = 200
	mandateThreshold = 50
	for building in countryBuildingList:
		if building.buildingType == "Granary":
			foodStorageMax += (100 * building.buildingLevel)
		if building.buildingType == "Dock":
			foodStorageMax += (200 * building.buildingLevel)
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
	elif beliefDifference >= -5 && beliefDifference <= -4:
		churchLevel = -2
	elif beliefDifference <= -6:
		churchLevel = -3  
	#print("beliefDifference", beliefDifference, "church Level", churchLevel)
	#here is where the modifier for 

func calculateTurn() -> void:
	match CID:
		"UK":
			_uk_calculate_turn()
		"CA":
			_ca_calculate_turn()
		"BA":
			pass  # BA is opportunist — TODO DODK
		_:
			# Generic passive AI for all state countries spawned at runtime.
			# To add per-state behaviour later, insert a match arm above this one:
			#   "PA": _pennsylvania_calculate_turn()
			#   "VA": _virginia_calculate_turn()
			if not Player and isAlive:
				_generic_calculate_turn()


# ============================================================
# CANADA AI — DEFENSIVE MILITIA
# Reinforces armies each turn via _passive_hold(), then presses any
# adjacent UK tiles where CA has a manpower advantage.
# Respects formal alliances — never enters allied-country tiles.
# ============================================================

func _ca_calculate_turn() -> void:
	_passive_hold()
	_ca_press_uk_borders()


func _ca_press_uk_borders() -> void:
	if CountryFlags.has("uk_ca_peace"):
		return
	var allied_cids: Array = []
	for ally in ALLIED:
		if is_instance_valid(ally):
			allied_cids.append(ally.CID)

	for army in countryArmyList:
		if not is_instance_valid(army):
			continue
		if army.deleteMode or army.inTile == null:
			continue

		var best_target = null
		var lowest_strength: float = INF
		for neighbor in army.inTile.TileNeighbors:
			if neighbor.tileOwner != "UK":
				continue
			if neighbor.tileOwner in allied_cids:
				continue
			var def_str: float = 0.0
			if neighbor.stationedArmy != null:
				def_str = float(neighbor.stationedArmy.manpowerInArmy)
			else:
				def_str = float(neighbor.get_siege_difficulty()) * 30.0
			if float(army.manpowerInArmy) > def_str * 1.2:
				if def_str < lowest_strength:
					lowest_strength = def_str
					best_target = neighbor

		if best_target != null:
			best_target.siegeCalculate(army)
			if best_target.stationedArmy != null:
				_resolve_ai_battle(army, best_target.stationedArmy, best_target)
			print("CA ", army.ArmyName, " presses UK at ", best_target.tileName)


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
	# Respect the post-collapse peace treaty — UK stops pressing into USA territory
	if CountryFlags.has("uk_usa_peace"):
		return null
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


# ============================================================
# GENERIC STATE-COUNTRY AI
# Passive hold: reinforces existing armies, does not expand.
#
# Per-country overrides: add a match arm in calculateTurn()
# above the "_:" default, then implement _<cid>_calculate_turn().
# ============================================================

func _generic_calculate_turn() -> void:
	_passive_hold()


func _passive_hold() -> void:
	# Trickle manpower from the country reserve into stationed armies.
	for army in countryArmyList:
		if not is_instance_valid(army):
			continue
		if army.inTile == null or army.deleteMode:
			continue
		var reinforce: int = mini(armyReinforceRate, TotalManpower)
		if reinforce > 0:
			army.manpowerInArmy += reinforce
			TotalManpower -= reinforce


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

func payBill(type, amount):
	match type:
		"faith", "culture":  # "faith" kept for backward compat with existing call sites
			TotalCulture -= amount
		"dollars", "gold":   # "gold" kept for backward compat
			TotalDollars -= amount
		"happiness", "harmony":  # "harmony" kept for backward compat
			TotalHappiness -= amount

var newToolScene = load("res://tool.tscn")

func addTool(type):
	var newToolType = newToolScene.instantiate()
	newToolType.buildSelf(type)
	availableTools.append(newToolType)

var newKitScene = load("res://kit.tscn")

var newBuildingScene = load("res://Game Scenes and Scripts/building.tscn")
func addBuilding(type):
	var newBuilding = newBuildingScene.instantiate()
	newBuilding.buildingType = type
	newBuilding.buildBuilding()
	unlockedBuildings.append(newBuilding)

func addKit(type):
	var newKitType = newKitScene.instantiate()
	newKitType.buildSelf(type)
	availableKits.append(newKitType)

func addTile(tileToAdd):
	OwnedTileList.append(tileToAdd)

func unlockArmyIcon(icon):
	armyIconList.append(icon)

#=============================================
#Save Functions
#=============================================

func save_state() -> Dictionary:
	var state = {
		"CID": CID,
		"isAlive": isAlive,
 
		# Current resources
		"TotalDollars":   TotalDollars,
		"TotalFood":      TotalFood,
		"TotalWood":      TotalWood,
		"TotalMetal":     TotalMetal,
		"TotalCulture":   TotalCulture,   # covers old Faith + Culture
		"TotalMagic":              TotalMagic,
		"cherry_blossom_magic_acc": cherry_blossom_magic_acc,
		"pioneer_heritage_corrupt_acc": pioneer_heritage_corrupt_acc,
		"nature_conservationists_corrupt_acc": nature_conservationists_corrupt_acc,
		"civic_pride_mandate_acc": civic_pride_mandate_acc,
		"TotalWeapons":            TotalWeapons,
		"TotalScience":   TotalScience,
		"TotalHappiness": TotalHappiness,
		"TotalMandate":   TotalMandate,
		"TotalInfluence": TotalInfluence,
		"TotalManpower":  TotalManpower,
 
		# Magic schools
		"manifestPoints": manifestPoints, "manifestLevel": manifestLevel,
		"spectralPoints": spectralPoints, "spectralLevel": spectralLevel,
		"cryptidPoints": cryptidPoints, "cryptidLevel": cryptidLevel,
		"stormPoints": stormPoints, "stormLevel": stormLevel,
		"ironPoints": ironPoints, "ironLevel": ironLevel,
		"libertyPoints": libertyPoints, "libertyLevel": libertyLevel,
 
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
	TotalDollars   = save_data.get("TotalDollars",   TotalDollars)
	TotalFood      = save_data.get("TotalFood",      TotalFood)
	TotalWood      = save_data.get("TotalWood",      TotalWood)
	TotalMetal     = save_data.get("TotalMetal",     TotalMetal)
	TotalCulture   = save_data.get("TotalCulture",   TotalCulture)  # covers old Faith + Culture
	TotalMagic             = save_data.get("TotalMagic",              TotalMagic)
	cherry_blossom_magic_acc = save_data.get("cherry_blossom_magic_acc", 0.0)
	pioneer_heritage_corrupt_acc = save_data.get("pioneer_heritage_corrupt_acc", {})
	nature_conservationists_corrupt_acc = save_data.get("nature_conservationists_corrupt_acc", {})
	civic_pride_mandate_acc = save_data.get("civic_pride_mandate_acc", 0.0)
	TotalWeapons           = save_data.get("TotalWeapons",            TotalWeapons)
	TotalScience   = save_data.get("TotalScience",   TotalScience)
	TotalHappiness = save_data.get("TotalHappiness", TotalHappiness)
	TotalMandate   = save_data.get("TotalMandate",   TotalMandate)
	TotalInfluence = save_data.get("TotalInfluence", TotalInfluence)
	TotalManpower  = save_data.get("TotalManpower",  TotalManpower)
 
	# Restore magic schools
	manifestPoints = save_data.get("manifestPoints", 0)
	manifestLevel  = save_data.get("manifestLevel", 0)
	spectralPoints = save_data.get("spectralPoints", 0)
	spectralLevel  = save_data.get("spectralLevel", 0)
	cryptidPoints = save_data.get("cryptidPoints", 0)
	cryptidLevel  = save_data.get("cryptidLevel", 0)
	stormPoints = save_data.get("stormPoints", 0)
	stormLevel  = save_data.get("stormLevel", 0)
	ironPoints = save_data.get("ironPoints", 0)
	ironLevel  = save_data.get("ironLevel", 0)
	libertyPoints = save_data.get("libertyPoints", 0)
	libertyLevel  = save_data.get("libertyLevel", 0)
 
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
