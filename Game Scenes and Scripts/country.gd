extends Node2D

class_name country

#MetaData
var CID #CountryID, three letter identification
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

var spellCostDiscount: int = 0

var countryFactionList: Array = []

#Resources - How much they have currently
var TotalGold: int
var TotalMetal: int
var TotalWood: int
var TotalFood: int
var TotalMagic: int
var TotalFaith: int
var TotalCulture: int
var TotalHarmony: int
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

func NewGameBuild():
	#completely dynamically created by the World.  if its a new game, will use the new game stats, otherwise,
	#will use the func LoadGameBuild():
	if CID == "PDT":
		
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
		
		mandateThreshold = 50
		foodStorageMax = 1000
		#DON"T TRY AND ADD NEW TYPES OF UNLOCKABLES UNTIL YOU FIGURE OUT HOW TO GET AN INFO PANEL TO APPEAR WITH MOUSE
		#OVER.  SHOULD BE A DYNAMICALLY SIZED PANEL.
		var newOre = ore.new()
		newOre.oreType = "Wood"
		newOre.buildSelf()
		availableOres.append(newOre)
		var goldOre = ore.new()
		goldOre.oreType = "Gold"
		goldOre.buildSelf()
		availableOres.append(goldOre)
		var floodstoneOre = ore.new()
		floodstoneOre.oreType = "Floodstone"
		floodstoneOre.buildSelf()
		availableOres.append(floodstoneOre)
		addTechnologicalDiscovery("Language")
		addTechnologicalDiscovery("Agriculture")
		addTechnologicalDiscovery("Copper Working")
		addTechnologicalDiscovery("Artistry")
		addSpellToSpellbook("Plentify", 1, 0)
		addReligiousBelief("Benaxtara")
		addReligiousBelief("TYLA DYN")
		addCulturalTradition("Humble Folk")
		addCulturalTradition("Guardian Cats")
		addGovernmentLaw("Mercantilism")
		addGovernmentLaw("Citizen Militia")
		addFaction("Vargo-Tal", 50) # Traditionalists
		addFaction("Wixinx", 10) # Liberators
		addFaction("Elto-Tal", 20) # Moderates
		updateUnlockableAttributes()
		addMilMod("Berserkers")
		addArmy("Palace Guards", 3)
		addGovernorToGovernorPool("Wolverina Gundo", 1)
		addGovernorToGovernorPool("Wello Jenni-Tur", 1)
		armyReinforceRate = 3 #add a function to determin reinforce rate
			
		for Army in countryArmyList:
			if Army.ArmyName == "Palace Guards":
				addNewUnit(Army, "Infantry", 1, "Club", "Copper")
				addNewUnit(Army, "Ranged", 2, "Atlatl", "Wood")
				addNewUnit(Army, "Infantry", 1, "Club", "Wood")
	if Player == true:
		pass
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

func addNewUnit(Army, UnitType, Level, WeaponType, OreType):
	var newUnit = unitScene.instantiate()
	newUnit.playerCountry = self
	newUnit.unitType = str(UnitType)
	newUnit.unitLevel = Level
	var newWeapon = Weapon.new()
	newWeapon.weaponType = str(WeaponType)
	newWeapon.buildSelf()
	newUnit.unitWeapon = newWeapon
	var newOre = ore.new()
	newOre.oreType = str(OreType)
	newOre.buildSelf()
	newUnit.unitMetal = newOre
	newUnit.calculateOreMilMod()
	newUnit.getUnitInfo.connect(updateUnit)
	newUnit.buildSelf()
	Army.addUnitToArmy(newUnit)
	Army.updateSelf(Army.ArmyName, self, 0)
	pass

func updateUnit(type, unitNode):
	#for MilMod in countryMilModList:
		#var thingToPrint = str("country mil mods", MilMod.milModType, "infantry?", MilMod.infantryMod)
		#print(thingToPrint)
	for UnitTemplate in unitTemplateList:
		if UnitTemplate.unitType == type:
			unitNode.unitOffensiveScore = UnitTemplate.unitOffensiveScore
			unitNode.unitDefensiveScore = UnitTemplate.unitDefensiveScore
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
			newOre.oreType = Tile.oreSlot.oreType
			newOre.buildSelf()
			var oreCheck: bool =  false
			if availableOres != null:
				for ore in availableOres:
					if newOre.oreType == ore.oreType:
						oreCheck = true
			if oreCheck == true:
				newOre.queue_free()
			else:
				availableOres.append(newOre)
			#print("availableOres", availableOres)
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
	armyInstance.updateSelf(Name, self, TileNumber)
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
	newBelief.buildBelief()
	selectedBeliefs.append(newBelief)

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
	pass

func addCulturalTradition(Name):
	var newTradition = tradition.new()
	newTradition.traditionType = Name
	unlockedTraditions.append(newTradition)
	pass

func addSpellToSpellbook(Name, Level, Experience):
	var newSpell = spell.new()
	newSpell.spellType = Name
	newSpell.spellLevel = Level
	newSpell.experience = Experience
	newSpell.newGameSpellAssignment()
	unlockedSpells.append(newSpell)
	#print ("country is", CID, "Spells are:", unlockedSpells)
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
			if Technology.techName == "Agriculture":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Farm":
						buildingLevel.maxLevel += 5
					if buildingLevel.buildingType == "Granary":
						buildingLevel.maxLevel += 3
			if Technology.techName == "Copper Working":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Mine":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Camp":
						buildingLevel.maxLevel += 3
			if Technology.techName == "Artistry":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Workshop":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Temple":
						buildingLevel.maxLevel += 3
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
			if Technology.techName == "Calendar":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Farm":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Granary":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Faire":
						buildingLevel.maxLevel += 3
			if Technology.techName == "Bronze Working":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Camp":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Mine":
						buildingLevel.maxLevel += 3
			if Technology.techName == "Masonry":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Workshop":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Temple":
						buildingLevel.maxLevel += 3
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
			if Technology.techName == "Irrigation":
				for buildingLevel in buildingLevelList:
					if buildingLevel.buildingType == "Farm":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Granary":
						buildingLevel.maxLevel += 3
					if buildingLevel.buildingType == "Faire":
						buildingLevel.maxLevel +=3
	var thingForPrint: String
	for buildingLevel in buildingLevelList:
		thingForPrint = str("buildingType", buildingLevel.buildingType, "buildingLevel", buildingLevel.maxLevel)
		print(thingForPrint)
	pass

func surveyResources():
	calculateUniqueBuildingAttributes()
	#this function starts the process of getting all the information of the resources in your lands
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
	if beliefDifference == 0:
		churchLevel = 0
	elif beliefDifference == 1:
		churchLevel = 1
	elif beliefDifference == 2:
		churchLevel = 2
	elif beliefDifference >= 3:
		churchLevel = 3
	elif beliefDifference == -1:
		churchLevel = -1
	elif beliefDifference == -2:
		churchLevel = -2
	elif beliefDifference <= -3:
		churchLevel = -3  
	#print("beliefDifference", beliefDifference, "church Level", churchLevel)
	#here is where the modifier for 
	pass
