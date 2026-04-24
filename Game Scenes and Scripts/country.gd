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
var countryBanner #banner used for determining the banner that hangs from the top left
var countryUnitBanner #banner used for this country's units
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

func NewGameBuild():
	#completely dynamically created by the World.  if its a new game, will use the new game stats, otherwise,
	#will use the func LoadGameBuild():
	$religionData.buildSelf()
	match CID:
		"PDT":
			#capitalPathPointButton = $PathControl/PathPointsControl/PDT1
			spellBaseCost = 15
			spellCostModifier = 0
			spellDiscountModifier = 0
			#starting resources
			TotalGold += 50
			TotalFood += 75
			TotalWood += 60
			TotalFaith += 80
			TotalScience += 20
			TotalMagic += 30
			TotalWeapons += 20
			TotalMetal += 30
			TotalCulture += 10
			TotalHarmony += 5
			TotalMandate += 15
			TotalInfluence += 0
			TotalManpower += 1000
			setStartingMagic()
			mandateThreshold = 50
			foodStorageMax = 1000
			#DON"T TRY AND ADD NEW TYPES OF UNLOCKABLES UNTIL YOU FIGURE OUT HOW TO GET AN INFO PANEL TO APPEAR WITH MOUSE
			#OVER.  SHOULD BE A DYNAMICALLY SIZED PANEL.
			var newOre = ore.new()
			newOre.oreType = "Wood"
			newOre.updateSelf("Wood")
			availableOres.append(newOre)
			var goldOre = ore.new()
			goldOre.oreType = "Gold"
			goldOre.updateSelf("Gold")
			availableOres.append(goldOre)
			var floodstoneOre = ore.new()
			floodstoneOre.oreType = "Floodstone"
			floodstoneOre.updateSelf("Floodstone")
			availableOres.append(floodstoneOre)
			addTechnologicalDiscovery("Language")
			addTechnologicalDiscovery("Agriculture")
			addTechnologicalDiscovery("Copper Working")
			addTechnologicalDiscovery("Artistry")
			loadBeliefsList("GenericDoc1")
			loadBeliefsList("GenericDoc2")
			loadBeliefsList("GenericGods1")
			loadBeliefsList("GenericGods2")
			loadBeliefsList("PDTDoc1")
			#addReligiousBelief("Tower Control")
			addReligiousBelief("Tyla-Dyn")
			addCulturalTradition("Humble Folk")
			addCulturalTradition("Guardian Cats")
			addGovernmentLaw("Mercantilism")
			addGovernmentLaw("Citizen Militia")
			#calculateToolsAndKits()
			calculateTaxationAmounts()
			addFaction("Vargo-Tal", 50) # Traditionalists
			addFaction("Wixinx", 10) # Liberators
			addFaction("Elto-Tal", 20) # Moderates
			updateUnlockableAttributes()
			addMilMod("Berserkers")
			addArmy("Palace Guards", 3)
			addGovernorToGovernorPool("Wolverina Gundo", 1)
			armyReinforceRate = 3 #add a function to determin reinforce rate
			#for Tile in OwnedTileList:
				
			updateDiscoveredByPlayer()
			for Army in countryArmyList:
				if Army.ArmyName == "Palace Guards":
					addNewUnit(Army, "Infantry", 4, "Macuahuitl", "Copper", "Scale", 1000, 1000)
					addNewUnit(Army, "Ranged", 2, "Atlatl", "Copper", "Cast", 200, 200)
					addNewUnit(Army, "Infantry", 5, "Club", "Wood", "Scout", 1000, 1000)
					addNewUnit(Army, "Infantry", 3, "Pike", "Iron", "Cast", 300, 300)
					addNewUnit(Army, "Infantry", 3, "Club", "Iron", "Point", 300, 300)
		"DUM": #dummytest
			spellBaseCost = 15
			spellCostModifier = 0
			spellDiscountModifier = 0
			#starting resources
			TotalGold += 50
			TotalFood += 75
			TotalWood += 60
			TotalFaith += 80
			TotalScience += 20
			TotalMagic += 30
			TotalWeapons += 20
			TotalMetal += 30
			TotalCulture += 10
			TotalHarmony += 5
			TotalMandate += 15
			TotalInfluence += 0
			TotalManpower += 1000
			setStartingMagic()
			mandateThreshold = 50
			foodStorageMax = 1000
			#DON"T TRY AND ADD NEW TYPES OF UNLOCKABLES UNTIL YOU FIGURE OUT HOW TO GET AN INFO PANEL TO APPEAR WITH MOUSE
			#OVER.  SHOULD BE A DYNAMICALLY SIZED PANEL.
			addTechnologicalDiscovery("Language")
			addTechnologicalDiscovery("Agriculture")
			addTechnologicalDiscovery("Copper Working")
			addTechnologicalDiscovery("Artistry")
			loadBeliefsList("GenericDoc1")
			loadBeliefsList("GenericGods1")
			#calculateToolsAndKits()
			calculateTaxationAmounts()
			updateUnlockableAttributes()
			addArmy("Dummy Guards", 10)
			addGovernorToGovernorPool("Wolverina Gundo", 1)
			armyReinforceRate = 3 #add a function to determin reinforce rate
			#for Tile in OwnedTileList:
			updateDiscoveredByPlayer()
			for Army in countryArmyList:
				if Army.ArmyName == "Dummy Guards":
					addNewUnit(Army, "Infantry", 4, "Macuahuitl", "Copper", "Scale", 400, 400)
					addNewUnit(Army, "Ranged", 2, "Atlatl", "Copper", "Cast", 200, 200)
					addNewUnit(Army, "Infantry", 3, "Pike", "Iron", "Cast", 300, 300)
		"ANL":
			#capitalPathPointButton = $PathControl/PathPointsControl/PDT1
			spellBaseCost = 15
			spellCostModifier = 0
			spellDiscountModifier = 0
			#starting resources
			TotalGold += 50
			TotalFood += 75
			TotalWood += 60
			TotalFaith += 80
			TotalScience += 20
			TotalMagic += 30
			TotalWeapons += 20
			TotalMetal += 30
			TotalCulture += 10
			TotalHarmony += 5
			TotalMandate += 15
			TotalInfluence += 0
			TotalManpower += 1000
			setStartingMagic()
			mandateThreshold = 50
			foodStorageMax = 1000
			#DON"T TRY AND ADD NEW TYPES OF UNLOCKABLES UNTIL YOU FIGURE OUT HOW TO GET AN INFO PANEL TO APPEAR WITH MOUSE
			#OVER.  SHOULD BE A DYNAMICALLY SIZED PANEL.
			var newOre = ore.new()
			newOre.oreType = "Wood"
			newOre.updateSelf("Wood")
			availableOres.append(newOre)
			var goldOre = ore.new()
			goldOre.oreType = "Gold"
			goldOre.updateSelf("Gold")
			availableOres.append(goldOre)
			var floodstoneOre = ore.new()
			floodstoneOre.oreType = "Floodstone"
			floodstoneOre.updateSelf("Floodstone")
			availableOres.append(floodstoneOre)
			addTechnologicalDiscovery("Language")
			addTechnologicalDiscovery("Agriculture")
			addTechnologicalDiscovery("Copper Working")
			addTechnologicalDiscovery("Artistry")
			loadBeliefsList("GenericDoc1")
			loadBeliefsList("GenericDoc2")
			loadBeliefsList("GenericGods1")
			loadBeliefsList("GenericGods2")
			#loadBeliefsList("PDTDoc1")
			addReligiousBelief("Tower Control")
			#addReligiousBelief("TYLA DYN")
			#addCulturalTradition("Humble Folk")
			addCulturalTradition("Guardian Cats")
			addGovernmentLaw("Mercantilism")
			#addGovernmentLaw("Citizen Militia")
			#calculateToolsAndKits()
			calculateTaxationAmounts()
			addFaction("Vargo-Tal", 50) # Traditionalists
			addFaction("Wixinx", 10) # Liberators
			addFaction("Elto-Tal", 20) # Moderates
			updateUnlockableAttributes()
			addMilMod("Berserkers")
			#addArmy("Palace Guards", 3)
			addGovernorToGovernorPool("Wolverina Gundo", 1)
			armyReinforceRate = 3 #add a function to determin reinforce rate
			updateDiscoveredByPlayer()
		"ANL":
			#capitalPathPointButton = $PathControl/PathPointsControl/PDT1
			spellBaseCost = 15
			spellCostModifier = 0
			spellDiscountModifier = 0
			#starting resources
			TotalGold += 50
			TotalFood += 75
			TotalWood += 60
			TotalFaith += 80
			TotalScience += 20
			TotalMagic += 30
			TotalWeapons += 20
			TotalMetal += 30
			TotalCulture += 10
			TotalHarmony += 5
			TotalMandate += 15
			TotalInfluence += 0
			TotalManpower += 1000
			setStartingMagic()
			mandateThreshold = 50
			foodStorageMax = 1000
			#DON"T TRY AND ADD NEW TYPES OF UNLOCKABLES UNTIL YOU FIGURE OUT HOW TO GET AN INFO PANEL TO APPEAR WITH MOUSE
			#OVER.  SHOULD BE A DYNAMICALLY SIZED PANEL.
			var newOre = ore.new()
			newOre.oreType = "Wood"
			newOre.updateSelf("Wood")
			availableOres.append(newOre)
			var goldOre = ore.new()
			goldOre.oreType = "Gold"
			goldOre.updateSelf("Gold")
			availableOres.append(goldOre)
			var floodstoneOre = ore.new()
			floodstoneOre.oreType = "Floodstone"
			floodstoneOre.updateSelf("Floodstone")
			availableOres.append(floodstoneOre)
			addTechnologicalDiscovery("Language")
			addTechnologicalDiscovery("Agriculture")
			addTechnologicalDiscovery("Copper Working")
			addTechnologicalDiscovery("Artistry")
			loadBeliefsList("GenericDoc1")
			loadBeliefsList("GenericDoc2")
			loadBeliefsList("GenericGods1")
			loadBeliefsList("GenericGods2")
			#loadBeliefsList("PDTDoc1")
			addReligiousBelief("Tower Control")
			#addReligiousBelief("TYLA DYN")
			#addCulturalTradition("Humble Folk")
			addCulturalTradition("Guardian Cats")
			addGovernmentLaw("Mercantilism")
			#addGovernmentLaw("Citizen Militia")
			#calculateToolsAndKits()
			calculateTaxationAmounts()
			addFaction("Vargo-Tal", 50) # Traditionalists
			addFaction("Wixinx", 10) # Liberators
			addFaction("Elto-Tal", 20) # Moderates
			updateUnlockableAttributes()
			addMilMod("Berserkers")
			#addArmy("Palace Guards", 3)
			addGovernorToGovernorPool("Wolverina Gundo", 1)
			armyReinforceRate = 3 #add a function to determin reinforce rate
			updateDiscoveredByPlayer()
		"VTO":
			#capitalPathPointButton = $PathControl/PathPointsControl/PDT1
			spellBaseCost = 15
			spellCostModifier = 0
			spellDiscountModifier = 0
			#starting resources
			TotalGold += 50
			TotalFood += 75
			TotalWood += 60
			TotalFaith += 80
			TotalScience += 20
			TotalMagic += 30
			TotalWeapons += 20
			TotalMetal += 30
			TotalCulture += 10
			TotalHarmony += 5
			TotalMandate += 15
			TotalInfluence += 0
			TotalManpower += 1000
			setStartingMagic()
			mandateThreshold = 50
			foodStorageMax = 1000
			#DON"T TRY AND ADD NEW TYPES OF UNLOCKABLES UNTIL YOU FIGURE OUT HOW TO GET AN INFO PANEL TO APPEAR WITH MOUSE
			#OVER.  SHOULD BE A DYNAMICALLY SIZED PANEL.
			var newOre = ore.new()
			newOre.oreType = "Wood"
			newOre.updateSelf("Wood")
			availableOres.append(newOre)
			var goldOre = ore.new()
			goldOre.oreType = "Gold"
			goldOre.updateSelf("Gold")
			availableOres.append(goldOre)
			var floodstoneOre = ore.new()
			floodstoneOre.oreType = "Floodstone"
			floodstoneOre.updateSelf("Floodstone")
			availableOres.append(floodstoneOre)
			addTechnologicalDiscovery("Language")
			addTechnologicalDiscovery("Agriculture")
			addTechnologicalDiscovery("Copper Working")
			addTechnologicalDiscovery("Artistry")
			loadBeliefsList("GenericDoc1")
			loadBeliefsList("GenericDoc2")
			loadBeliefsList("GenericGods1")
			loadBeliefsList("GenericGods2")
			#loadBeliefsList("PDTDoc1")
			addReligiousBelief("Tower Control")
			#addReligiousBelief("TYLA DYN")
			#addCulturalTradition("Humble Folk")
			addCulturalTradition("Guardian Cats")
			addGovernmentLaw("Mercantilism")
			#addGovernmentLaw("Citizen Militia")
			#calculateToolsAndKits()
			calculateTaxationAmounts()
			addFaction("Vargo-Tal", 50) # Traditionalists
			addFaction("Wixinx", 10) # Liberators
			addFaction("Elto-Tal", 20) # Moderates
			updateUnlockableAttributes()
			addMilMod("Berserkers")
			#addArmy("Palace Guards", 3)
			addGovernorToGovernorPool("Wolverina Gundo", 1)
			armyReinforceRate = 3 #add a function to determin reinforce rate
			updateDiscoveredByPlayer()
		"DEM":
			#capitalPathPointButton = $PathControl/PathPointsControl/PDT1
			spellBaseCost = 15
			spellCostModifier = 0
			spellDiscountModifier = 0
			#starting resources
			TotalGold += 50
			TotalFood += 75
			TotalWood += 60
			TotalFaith += 80
			TotalScience += 20
			TotalMagic += 30
			TotalWeapons += 20
			TotalMetal += 30
			TotalCulture += 10
			TotalHarmony += 5
			TotalMandate += 15
			TotalInfluence += 0
			TotalManpower += 1000
			setStartingMagic()
			mandateThreshold = 50
			foodStorageMax = 1000
			#DON"T TRY AND ADD NEW TYPES OF UNLOCKABLES UNTIL YOU FIGURE OUT HOW TO GET AN INFO PANEL TO APPEAR WITH MOUSE
			#OVER.  SHOULD BE A DYNAMICALLY SIZED PANEL.
			var newOre = ore.new()
			newOre.oreType = "Wood"
			newOre.updateSelf("Wood")
			availableOres.append(newOre)
			var goldOre = ore.new()
			goldOre.oreType = "Gold"
			goldOre.updateSelf("Gold")
			availableOres.append(goldOre)
			var floodstoneOre = ore.new()
			floodstoneOre.oreType = "Floodstone"
			floodstoneOre.updateSelf("Floodstone")
			availableOres.append(floodstoneOre)
			addTechnologicalDiscovery("Language")
			addTechnologicalDiscovery("Agriculture")
			addTechnologicalDiscovery("Copper Working")
			addTechnologicalDiscovery("Artistry")
			loadBeliefsList("GenericDoc1")
			loadBeliefsList("GenericDoc2")
			loadBeliefsList("GenericGods1")
			loadBeliefsList("GenericGods2")
			#loadBeliefsList("PDTDoc1")
			addReligiousBelief("Tower Control")
			#addReligiousBelief("TYLA DYN")
			#addCulturalTradition("Humble Folk")
			addCulturalTradition("Guardian Cats")
			addGovernmentLaw("Mercantilism")
			#addGovernmentLaw("Citizen Militia")
			#calculateToolsAndKits()
			calculateTaxationAmounts()
			addFaction("Vargo-Tal", 50) # Traditionalists
			addFaction("Wixinx", 10) # Liberators
			addFaction("Elto-Tal", 20) # Moderates
			updateUnlockableAttributes()
			addMilMod("Berserkers")
			#addArmy("Palace Guards", 3)
			addGovernorToGovernorPool("Wolverina Gundo", 1)
			armyReinforceRate = 3 #add a function to determin reinforce rate
			updateDiscoveredByPlayer()
		"EIG":
			#capitalPathPointButton = $PathControl/PathPointsControl/PDT1
			spellBaseCost = 15
			spellCostModifier = 0
			spellDiscountModifier = 0
			#starting resources
			TotalGold += 50
			TotalFood += 75
			TotalWood += 60
			TotalFaith += 80
			TotalScience += 20
			TotalMagic += 30
			TotalWeapons += 20
			TotalMetal += 30
			TotalCulture += 10
			TotalHarmony += 5
			TotalMandate += 15
			TotalInfluence += 0
			TotalManpower += 1000
			setStartingMagic()
			mandateThreshold = 50
			foodStorageMax = 1000
			#DON"T TRY AND ADD NEW TYPES OF UNLOCKABLES UNTIL YOU FIGURE OUT HOW TO GET AN INFO PANEL TO APPEAR WITH MOUSE
			#OVER.  SHOULD BE A DYNAMICALLY SIZED PANEL.
			var newOre = ore.new()
			newOre.oreType = "Wood"
			newOre.updateSelf("Wood")
			availableOres.append(newOre)
			var goldOre = ore.new()
			goldOre.oreType = "Gold"
			goldOre.updateSelf("Gold")
			availableOres.append(goldOre)
			var floodstoneOre = ore.new()
			floodstoneOre.oreType = "Floodstone"
			floodstoneOre.updateSelf("Floodstone")
			availableOres.append(floodstoneOre)
			addTechnologicalDiscovery("Language")
			addTechnologicalDiscovery("Agriculture")
			addTechnologicalDiscovery("Copper Working")
			addTechnologicalDiscovery("Artistry")
			loadBeliefsList("GenericDoc1")
			loadBeliefsList("GenericDoc2")
			loadBeliefsList("GenericGods1")
			loadBeliefsList("GenericGods2")
			loadBeliefsList("PDTDoc1")
			addReligiousBelief("Tower Control")
			addReligiousBelief("TYLA DYN")
			addCulturalTradition("Humble Folk")
			addCulturalTradition("Guardian Cats")
			addGovernmentLaw("Mercantilism")
			addGovernmentLaw("Citizen Militia")
			#calculateToolsAndKits()
			calculateTaxationAmounts()
			addFaction("Vargo-Tal", 50) # Traditionalists
			addFaction("Wixinx", 10) # Liberators
			addFaction("Elto-Tal", 20) # Moderates
			updateUnlockableAttributes()
			addMilMod("Berserkers")
			#addArmy("Palace Guards", 3)
			addGovernorToGovernorPool("Wolverina Gundo", 1)
			armyReinforceRate = 3 #add a function to determin reinforce rate
			updateDiscoveredByPlayer()
			
	pass

func discoverTile(pathPointButton):
	discoveredTilesList.append(pathPointButton)
	pass

signal updateDiscoveredTiles
func updateDiscoveredByPlayer():
	emit_signal("updateBeliefsSignal", discoveredTilesList)
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

func prospectForOres():
	for Tile in OwnedTileList:
		if Tile.oreSlot != null:
			var newOre = ore.new()
			newOre.updateSelf(Tile.oreSlot.oreType)
			var oreCheck: bool =  false
			if availableOres != null:
				for ore in availableOres:
					if newOre.oreType == ore.oreType:
						oreCheck = true
			if oreCheck == true:
				newOre.queue_free()
			else:
				availableOres.append(newOre)
			print("availableOres", availableOres, "DEBUG")
	pass

func addMilMod(Type):
	var milModInstance = milModScene.instantiate()
	milModInstance.buildSelf(Type)
	countryMilModList.append(milModInstance)
	pass

signal raiseThisArmySignal
func raiseThisArmy(Army, country, Tile):
	emit_signal("raiseThisArmySignal", Army, country, Tile)
	pass

func addArmy (Name, TileNumber):
	var armyInstance = load("res://Game Scenes and Scripts/army.tscn").instantiate()
	armyInstance.buildSelf(Name, self, TileNumber)
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

func addFaction(Name, Loyalty):
	var newFaction = faction.new()
	newFaction.factionName = Name
	newFaction.factionLoyalty = Loyalty
	countryFactionList.append(newFaction)
	pass

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
	MAN =0
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
		Army.surveySelf()
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

func calculateTurn():
	
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
