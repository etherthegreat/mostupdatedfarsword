extends Node2D
class_name building

var worldCreated: bool

var tile: Tile #used to determine where this building is
var number: int
var buildingType: String #Building ID.  When initializing, game will determine calculations based on the type.
var buildingLevel: int #another way to calculate yields from buildings.  Also determines buildingKind.
var BuildingKind #sort of complicated, but there is a building type, like Farm.  If Building Level is 1-3, Farm’s Building Kind will be Fields, Level 4-6 will be Farms, Level 6-9 will be Plantations.  Mine could be Pit, Mine, Excavation.  Can have LVL 0 kinds of buildings, which produce nothing valuable, or something negative.  These buildings, like the Breeding Pits, can be upgraded out of their LVL 0 negative state.
var buildingSprite: Texture #not sure about this one yet.  Maybe Sprite will be determined in this node, but I think maybe it will be in the building container node.
var wonder: bool
var fortification: bool
var playerTechnologies: Array = [] #add all technologies so game can calculate building outputs and whether or not max possible level is reached.
var pillaged: bool #maybe we could add a pillaging system where resources need to be provided to get the building back up and running again.
var wizardSlot: wizard #not sure how this will work out yet.  But basically, if the building type is a Tower, a wizard can be placed in charge which will modify the output of the Tower.
var tileTowerLevel #used to calculate effect of tower level on buildings
var cropSlot: crop #special variable for farms.  Basically the type of crop the farm is building.  Almost all farms in Anlaxia start with Razorberry.  This will allow for fun Agriculture quests, something I would have a blast writing.
var oreSlot: ore #special variable for mines.  the type of ore the mine digs up
var enabled: bool #Some buildings can become Disabled, like breeding pits if you flip to a non-Corrupt Ideology.  Buildings are also Disabled if the province goes into revolt.
var buildingModifiers: Array = []
var playerCountry: country #the country that controls this building
var playerPolicies: Array = [] #government upgrades
var tileSpell: spellArt # the spell affecting this tile 
var religiousBeliefs: Array = [] #used to determine religious beliefs in calculations
var traditionsList: Array = [] #used to determine cultural traditions in calculations
var Governor: governor
var faithChurchLevel: int
#Resources
#each month, this building produces this amount of resources
var foodPerLevel: int = 0
var dollarsPerLevel: float = 0   # renamed from dollarsPerLevel
var woodPerLevel: int = 0
var magicPerLevel: int = 0
# culturePerLevel removed — faith merged into culture
var weaponsPerLevel: int = 0
var metalPerLevel: int = 0
var sciencePerLevel: int = 0
var culturePerLevel: int = 0     # now covers both Culture and old Faith outputs
var mandatePerLevel: int = 0
var happinessPerLevel: float = 0 # renamed from happinessPerLevel
var manpowerPerLevel: int = 0
var influencePerLevel: int = 0
var corruptionLossPerLevel: int = 0
var defensivenessPerLevel: int = 0  # for Fortress building
#each month this building costs this amount of resources
var foodCostPerLevel: int = 0
var dollarsCostPerLevel: float = 0   # renamed from dollarsCostPerLevel
var woodCostPerLevel: int = 0
var magicCostPerLevel: int = 0
# cultureCostPerLevel removed — faith merged into culture
var weaponsCostPerLevel: int = 0
var metalCostPerLevel: int = 0
var scienceCostPerLevel: int = 0
var cultureCostPerLevel: int = 0
var mandateCostPerLevel: int = 0
var happinessCostPerLevel: float = 0 # renamed from happinessCostPerLevel
var manpowerCostPerLevel: int = 0
var influenceCostPerLevel: int = 0
var corruptionGainPerLevel: int = 0

#the balance of resourcePerLevel - resourceCostPerLevel
var totalBuildingFood: int = 0
var totalBuildingDollars: float = 0   # renamed from totalBuildingDollars
var totalBuildingWood: int = 0
var totalBuildingMagic: int = 0
# totalBuildingCulture removed — merged into totalBuildingCulture
var totalBuildingWeapons: int = 0
var totalBuildingScience: int = 0
var totalBuildingCulture: int = 0     # now covers both Culture and old Faith
var totalBuildingMetal: int = 0
var totalBuildingMandate: int = 0
var totalBuildingInfluence: int = 0
var totalBuildingManpower: int = 0
var totalBuildingHappiness: float = 0 # renamed from totalBuildingHappiness
var totalBuildingDefensiveness: int = 0  # how much defensiveness this building gives the province
var corruptionChange: int #corruption difference
#storage capacity buildings - used to increase max national storage capacity of resource
var foodStorageIncrease: int #granaries
var woodStorageIncrease: int #warehouse
var dollarsStorageIncrease: int #banks (renamed from goldStorageIncrease)
var magicStorageIncrease: int #towers
# faithStorageIncrease removed — merged into cultureStorageIncrease
var weaponsStorageIncrease: int #barracks
var scienceStorageIncrease: int #libraries
var cultureStorageIncrease: int #monuments (now covers old faith temple storage too)
var metalStorageIncrease: int #warehouse

var magicOutput: String

var foodPurchaseCost: float
var goldPurchaseCost: float
var woodPurchaseCost: float
var metalPurchaseCost: float

var dollarsDic: Dictionary   # renamed from dollarsDic
var foodDic: Dictionary
var woodDic: Dictionary
var metalDic: Dictionary

var manpowerDic: Dictionary
var weaponsDic: Dictionary

var scienceDic: Dictionary
# cultureDic removed — faith merged into cultureDic
var magicDic: Dictionary
var cultureDic: Dictionary   # now covers old Faith and Culture outputs

var mandateDic: Dictionary
var happinessDic: Dictionary # renamed from happinessDic
var influenceDic: Dictionary
var corruptionDic: Dictionary

signal towerBuilding

# Applies building output bonuses based on the assigned governor's archetype position.
# Covers all 18 building types and all canonical positions from both named and procedural governors.
# Automatically writes Dic entries for any resource that changes so the tile info panel can show it.
func _apply_governor_archetype_bonus(bType: String) -> void:
	if tile.tileGovernor == null:
		return
	var pos: String = tile.tileGovernor.governorPosition
	var lvl: int    = tile.tileGovernor.governorLevel
	var arc: String = tile.tileGovernor.governorArchetypeId
	# ARC_01 (Wetlands Fisher): flat +50 manpower from every building at lvl 3
	if arc == "ARC_01" and lvl == 3:
		manpowerPerLevel += 50
	# ARC_12 (Continental Surgeon): medical_science perk → +1 science from every building
	if arc == "ARC_12" and tile.tileGovernor.governor_perks.has("medical_science"):
		sciencePerLevel += 1

	var f0   := foodPerLevel;     var d0   := dollarsPerLevel
	var w0   := woodPerLevel;     var m0   := metalPerLevel
	var mg0  := magicPerLevel;    var sc0  := sciencePerLevel
	var cu0  := culturePerLevel;  var mn0  := mandatePerLevel
	var hp0  := happinessPerLevel; var mp0  := manpowerPerLevel
	var inf0 := influencePerLevel; var wp0  := weaponsPerLevel

	match bType:
		"Farm":
			match pos:
				"FARMER":
					match lvl:
						1: foodPerLevel += 1
						2: foodPerLevel += 2; woodPerLevel += 1
						3: foodPerLevel += 3; woodPerLevel += 2; dollarsPerLevel += 1
				"SCOUT":
					match lvl:
						1: foodPerLevel += 1
						2: foodPerLevel += 2; manpowerPerLevel += 50
						3: foodPerLevel += 3; manpowerPerLevel += 100
				"HEALER":
					match lvl:
						2: foodPerLevel += 1
						3: foodPerLevel += 2; happinessPerLevel += 1
				"WARRIOR":
					manpowerPerLevel += 100 * lvl
				"ORATOR", "HERALD", "CIRCUIT PREACHER":
					match lvl:
						2: culturePerLevel += 1
						3: culturePerLevel += 2; mandatePerLevel += 1
		"Granary":
			match pos:
				"FARMER":
					match lvl:
						1: foodPerLevel += 1
						2: foodPerLevel += 2; mandatePerLevel += 1
						3: foodPerLevel += 3; mandatePerLevel += 2; happinessPerLevel += 1
				"BUREAUCRAT", "DEPUTY GOVERNOR":
					match lvl:
						1: mandatePerLevel += 1
						2: mandatePerLevel += 2; influencePerLevel += 1
						3: mandatePerLevel += 3; influencePerLevel += 2
				"HEALER":
					match lvl:
						2: foodPerLevel += 1
						3: foodPerLevel += 2; happinessPerLevel += 1
		"Mine":
			# ARC_16 Community Steel: +1 metal/turn per building level when perk is unlocked
			if arc == "ARC_16" and tile.tileGovernor.governor_perks.has("community_steel"):
				metalPerLevel += 1
			# ARC_02 (Appalachian Miner): scaling metal bonus; lvl 3 removes resource input costs
			if arc == "ARC_02":
				match lvl:
					1: metalPerLevel += 1
					2: metalPerLevel += 2
					3:
						metalPerLevel += 3
						foodCostPerLevel = 0
						woodCostPerLevel = 0
			match pos:
				"ENGINEER":
					match lvl:
						1: metalPerLevel += 1
						2: metalPerLevel += 2; dollarsPerLevel += 1
						3: metalPerLevel += 3; dollarsPerLevel += 2; woodPerLevel += 1
				"WARRIOR":
					match lvl:
						1: metalPerLevel += 1
						2: metalPerLevel += 2; dollarsPerLevel += 1
						3: metalPerLevel += 3; dollarsPerLevel += 1; weaponsPerLevel += 1
				"SOLDIER":
					match lvl:
						2: metalPerLevel += 1
						3: metalPerLevel += 2; dollarsPerLevel += 1
		"Temple":
			match pos:
				"ORATOR", "HERALD", "CIRCUIT PREACHER":
					match lvl:
						1: culturePerLevel += 1
						2: culturePerLevel += 2; happinessPerLevel += 1
						3: culturePerLevel += 3; happinessPerLevel += 2; mandatePerLevel += 1
				"DIPLOMAT":
					match lvl:
						2: culturePerLevel += 1; happinessPerLevel += 1
						3: culturePerLevel += 2; happinessPerLevel += 2; mandatePerLevel += 1
				"MAGE":
					match lvl:
						2: magicPerLevel += 1; culturePerLevel += 1
						3: magicPerLevel += 2; culturePerLevel += 2; mandatePerLevel += 1
		"Camp":
			# ARC_02 (Appalachian Miner): culture from camps at lvl 2+
			if arc == "ARC_02":
				match lvl:
					2: culturePerLevel += 1
					3: culturePerLevel += 2
			match pos:
				"SCOUT":
					if arc == "ARC_01":
						match lvl:
							1: foodPerLevel += 1
							2: foodPerLevel += 2
							3: foodPerLevel += 3
					else:
						match lvl:
							1: woodPerLevel += 2
							2: woodPerLevel += 3; foodPerLevel += 1
							3: woodPerLevel += 4; foodPerLevel += 2; culturePerLevel += 1
				"ENGINEER":
					match lvl:
						1: woodPerLevel += 1
						2: woodPerLevel += 2; metalPerLevel += 1
						3: woodPerLevel += 3; metalPerLevel += 2
				"FARMER":
					match lvl:
						2: foodPerLevel += 1; woodPerLevel += 1
						3: foodPerLevel += 2; woodPerLevel += 2; culturePerLevel += 1
		"Tower":
			match pos:
				"MAGE":
					match lvl:
						1: magicPerLevel += 1
						2: magicPerLevel += 2; sciencePerLevel += 1
						3: magicPerLevel += 3; sciencePerLevel += 2; culturePerLevel += 1
				"SCHOLAR":
					match lvl:
						1: sciencePerLevel += 1; magicPerLevel += 1
						2: sciencePerLevel += 2; magicPerLevel += 1
						3: sciencePerLevel += 3; magicPerLevel += 2; culturePerLevel += 1
				"SPY", "SPYMASTER":
					match lvl:
						2: sciencePerLevel += 1; magicPerLevel += 1
						3: sciencePerLevel += 2; magicPerLevel += 1; culturePerLevel += 1
		"Library":
			# ARC_03 (Ivy League Dropout): manpower + culture per governor level
			if arc == "ARC_03":
				match lvl:
					1: manpowerPerLevel += 100
					2: manpowerPerLevel += 175
					3: manpowerPerLevel += 250; culturePerLevel += 1
			match pos:
				"SCHOLAR":
					match lvl:
						1: sciencePerLevel += 1
						2: sciencePerLevel += 2; magicPerLevel += 1
						3: sciencePerLevel += 3; magicPerLevel += 2; culturePerLevel += 1
				"MAGE":
					match lvl:
						1: magicPerLevel += 1; sciencePerLevel += 1
						2: magicPerLevel += 2; sciencePerLevel += 1
						3: magicPerLevel += 3; sciencePerLevel += 2; culturePerLevel += 1
				"BUREAUCRAT":
					match lvl:
						1: sciencePerLevel += 1
						2: sciencePerLevel += 2; mandatePerLevel += 1
						3: sciencePerLevel += 3; mandatePerLevel += 2; influencePerLevel += 1
				"SPY", "SPYMASTER":
					match lvl:
						2: sciencePerLevel += 1; influencePerLevel += 1
						3: sciencePerLevel += 2; influencePerLevel += 2; mandatePerLevel += 1
		"Workshop", "Market":
			# ARC_16 Community Steel: +1 metal/turn per building level when perk is unlocked
			if bType == "Market" and arc == "ARC_16" and tile.tileGovernor.governor_perks.has("community_steel"):
				metalPerLevel += 1
			# ARC_01 (Wetlands Fisher): market yields culture instead of dollars
			if bType == "Market" and arc == "ARC_01":
				match lvl:
					2: culturePerLevel += 1
					3: culturePerLevel += 2
			else:
				match pos:
					"ENGINEER":
						match lvl:
							1: dollarsPerLevel += 1
							2: dollarsPerLevel += 2; culturePerLevel += 1
							3: dollarsPerLevel += 3; culturePerLevel += 2; mandatePerLevel += 1
					"SOLDIER":
						match lvl:
							2: dollarsPerLevel += 1
							3: dollarsPerLevel += 2; manpowerPerLevel += 100
					"WARRIOR":
						match lvl:
							2: dollarsPerLevel += 1; weaponsPerLevel += 1
							3: dollarsPerLevel += 2; weaponsPerLevel += 2
		"Bath":
			match pos:
				"HEALER":
					match lvl:
						1: happinessPerLevel += 1; corruptionLossPerLevel += 1
						2: happinessPerLevel += 2; corruptionLossPerLevel += 2
						3: happinessPerLevel += 3; corruptionLossPerLevel += 3; culturePerLevel += 1
				"DIPLOMAT":
					match lvl:
						2: happinessPerLevel += 1; culturePerLevel += 1
						3: happinessPerLevel += 2; culturePerLevel += 2; mandatePerLevel += 1
		"Faire":
			match pos:
				"ORATOR", "HERALD":
					match lvl:
						1: happinessPerLevel += 1
						2: happinessPerLevel += 2; culturePerLevel += 1
						3: happinessPerLevel += 3; culturePerLevel += 2; dollarsPerLevel += 1
				"DIPLOMAT":
					match lvl:
						2: happinessPerLevel += 1; dollarsPerLevel += 1
						3: happinessPerLevel += 2; dollarsPerLevel += 2; culturePerLevel += 1
				"WARRIOR":
					match lvl:
						1: manpowerPerLevel += 100
						2: manpowerPerLevel += 200; weaponsPerLevel += 1
						3: manpowerPerLevel += 300; weaponsPerLevel += 2; culturePerLevel += 1
		"Forge":
			match pos:
				"ENGINEER":
					match lvl:
						1: weaponsPerLevel += 1
						2: weaponsPerLevel += 2
						3: weaponsPerLevel += 3; dollarsPerLevel += 1
				"WARRIOR":
					weaponsPerLevel   += lvl
					metalCostPerLevel += lvl
				"SOLDIER":
					match lvl:
						1: weaponsPerLevel += 1; manpowerPerLevel += 100
						2: weaponsPerLevel += 2; manpowerPerLevel += 200
						3: weaponsPerLevel += 3; manpowerPerLevel += 300
		"Barracks":
			# ARC_03 (Ivy League Dropout): science from barracks at governor level 2+
			if arc == "ARC_03":
				match lvl:
					2: sciencePerLevel += 1
					3: sciencePerLevel += 2
			match pos:
				"WARRIOR":
					match lvl:
						1: manpowerPerLevel += 200
						2: manpowerPerLevel += 400; weaponsPerLevel += 1
						3: manpowerPerLevel += 600; weaponsPerLevel += 2
				"SOLDIER":
					match lvl:
						1: manpowerPerLevel += 150; mandatePerLevel += 1
						2: manpowerPerLevel += 300; mandatePerLevel += 2
						3: manpowerPerLevel += 450; mandatePerLevel += 3; influencePerLevel += 1
				"SCOUT":
					match lvl:
						1: manpowerPerLevel += 100
						2: manpowerPerLevel += 200; foodPerLevel += 1
						3: manpowerPerLevel += 300; foodPerLevel += 2
				"ENGINEER":
					match lvl:
						2: manpowerPerLevel += 200; defensivenessPerLevel += 1
						3: manpowerPerLevel += 400; defensivenessPerLevel += 2
		"Dock":
			match pos:
				"ADMIRAL":
					match lvl:
						1: manpowerPerLevel += 100
						2: manpowerPerLevel += 200; dollarsPerLevel += 1
						3: manpowerPerLevel += 300; dollarsPerLevel += 2
				"ENGINEER":
					match lvl:
						2: metalPerLevel += 1
						3: metalPerLevel += 2
				"SCOUT":
					match lvl:
						2: culturePerLevel += 1
						3: culturePerLevel += 2
		"Courthouse":
			match pos:
				"BUREAUCRAT", "DEPUTY GOVERNOR":
					match lvl:
						1: mandatePerLevel += 1
						2: mandatePerLevel += 2; influencePerLevel += 1
						3: mandatePerLevel += 3; influencePerLevel += 2; happinessPerLevel += 1
				"DIPLOMAT":
					match lvl:
						2: mandatePerLevel += 1; influencePerLevel += 1
						3: mandatePerLevel += 2; influencePerLevel += 2; culturePerLevel += 1
				"ORATOR":
					match lvl:
						1: mandatePerLevel += 1
						2: mandatePerLevel += 2; culturePerLevel += 1
						3: mandatePerLevel += 3; culturePerLevel += 2; happinessPerLevel += 1
				"SPY", "SPYMASTER":
					match lvl:
						2: mandatePerLevel += 1; influencePerLevel += 1
						3: mandatePerLevel += 2; influencePerLevel += 2; sciencePerLevel += 1
		"Monument":
			match pos:
				"ORATOR", "HERALD", "CIRCUIT PREACHER":
					match lvl:
						1: culturePerLevel += 1
						2: culturePerLevel += 2; mandatePerLevel += 1
						3: culturePerLevel += 3; mandatePerLevel += 2; happinessPerLevel += 1
				"DIPLOMAT":
					match lvl:
						2: culturePerLevel += 1; happinessPerLevel += 1
						3: culturePerLevel += 2; happinessPerLevel += 2; mandatePerLevel += 1
		"Fortress":
			match pos:
				"WARRIOR", "SOLDIER":
					match lvl:
						1: defensivenessPerLevel += 1
						2: defensivenessPerLevel += 2; mandatePerLevel += 1
						3: defensivenessPerLevel += 3; mandatePerLevel += 2; manpowerPerLevel += 100
				"ENGINEER":
					match lvl:
						1: defensivenessPerLevel += 1
						2: defensivenessPerLevel += 2; manpowerPerLevel += 100
						3: defensivenessPerLevel += 3; manpowerPerLevel += 200
		"Resort":
			match pos:
				"HEALER":
					match lvl:
						1: happinessPerLevel += 1
						2: happinessPerLevel += 2; corruptionLossPerLevel += 1
						3: happinessPerLevel += 3; corruptionLossPerLevel += 2; culturePerLevel += 1
				"DIPLOMAT":
					match lvl:
						2: happinessPerLevel += 1; dollarsPerLevel += 1
						3: happinessPerLevel += 2; dollarsPerLevel += 2
				"ORATOR":
					match lvl:
						2: happinessPerLevel += 1; culturePerLevel += 1
						3: happinessPerLevel += 2; culturePerLevel += 2; dollarsPerLevel += 1

	# Write Dic entries for every resource that changed so the tile info panel can show the breakdown
	var label := "Governor Bonus (" + tile.tileGovernor.governorType + ")"
	if foodPerLevel      != f0:   foodDic[label]      = (foodPerLevel      - f0)   * buildingLevel
	if dollarsPerLevel   != d0:   dollarsDic[label]   = (dollarsPerLevel   - d0)   * buildingLevel
	if woodPerLevel      != w0:   woodDic[label]      = (woodPerLevel      - w0)   * buildingLevel
	if metalPerLevel     != m0:   metalDic[label]     = (metalPerLevel     - m0)   * buildingLevel
	if magicPerLevel     != mg0:  magicDic[label]     = (magicPerLevel     - mg0)  * buildingLevel
	if sciencePerLevel   != sc0:  scienceDic[label]   = (sciencePerLevel   - sc0)  * buildingLevel
	if culturePerLevel   != cu0:  cultureDic[label]   = (culturePerLevel   - cu0)  * buildingLevel
	if mandatePerLevel   != mn0:  mandateDic[label]   = (mandatePerLevel   - mn0)  * buildingLevel
	if happinessPerLevel != hp0:  happinessDic[label] = (happinessPerLevel - hp0)  * buildingLevel
	if manpowerPerLevel  != mp0:  manpowerDic[label]  = (manpowerPerLevel  - mp0)  * buildingLevel
	if influencePerLevel != inf0: influenceDic[label] = (influencePerLevel - inf0) * buildingLevel
	if weaponsPerLevel   != wp0:  weaponsDic[label]   = (weaponsPerLevel   - wp0)  * buildingLevel

func buildBuilding():
	match buildingType:
		"Farm":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/farm.png")
			foodPurchaseCost = 0
			goldPurchaseCost = 25
			woodPurchaseCost = 50
			metalPurchaseCost = 0
		"Granary":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/granary.png") 
			#foodStorageIncrease += 1 #every 1 increase will be calculated as +100 storage on the national level.
			foodPurchaseCost = 100
			goldPurchaseCost = 50
			woodPurchaseCost = 50
			metalPurchaseCost = 0
		"Temple":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/temple.png")
			foodCostPerLevel += 2
			woodCostPerLevel += 1
			culturePerLevel += 1  # faith → culture merge
			foodPurchaseCost = 75
			goldPurchaseCost = 100
			woodPurchaseCost = 50
			metalPurchaseCost = 0
			foodDic["Base Temple Food Cost"] = (-2 * buildingLevel)
			woodDic["Base Temple Wood Cost"] = (-1 * buildingLevel)
			cultureDic["Base Temple Culture Output"] = (1 * buildingLevel)
		"Mine":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/mine.png")
			foodCostPerLevel +=1
			woodCostPerLevel +=1
			metalPerLevel += 1
			foodPerLevel = 1
			foodPurchaseCost = 50
			goldPurchaseCost = 75
			woodPurchaseCost = 75
			metalPurchaseCost = 0
			foodDic["Base Mine Food Cost"] = (-1 * buildingLevel)
			woodDic["Base Mine Wood Cost"] = (-1 * buildingLevel)
			metalDic["Base Mine Metal Output"] = (1 * buildingLevel)
		"Camp":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/camp.png")
			woodPerLevel +=1
			foodPurchaseCost = 25
			goldPurchaseCost = 25
			woodPurchaseCost = 50
			metalPurchaseCost = 0
			woodDic["Base Camp Wood Output"] = (1 * buildingLevel)
		"Tower":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/tower.png")
			foodPurchaseCost = 50
			goldPurchaseCost = 125
			woodPurchaseCost = 125
			metalPurchaseCost = 75
			emit_signal("towerBuilding")
			print("building type in", tile.tileName)
		"Library":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/library.png")
			dollarsCostPerLevel += 1
			woodCostPerLevel += 1
			sciencePerLevel += 2
			foodPurchaseCost = 0
			goldPurchaseCost = 100
			woodPurchaseCost = 100
			metalPurchaseCost = 0
			scienceDic["Base Library Science Output"] = (2 * buildingLevel)
			woodDic["Base Library Wood Cost"] = (-2 * buildingLevel)
			dollarsDic["Base Library Gold Cost"] = (-1 * buildingLevel)
		"Workshop":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/workshop.png")
			dollarsPerLevel += 1
			metalCostPerLevel += 1
			woodCostPerLevel += 1
			foodPurchaseCost = 25
			goldPurchaseCost = 25
			woodPurchaseCost = 50
			metalPurchaseCost = 100
			dollarsDic["Base Workshop Dollars Output"] = (1 * buildingLevel)
			woodDic["Base Workshop Wood Cost"] = (-1 * buildingLevel)
			metalDic["Base Workshop Metal Cost"] = (-1 * buildingLevel)
		"Market":
			# Market = Workshop equivalent (produces Dollars)
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/workshop.png")
			dollarsPerLevel += 1
			metalCostPerLevel += 1
			woodCostPerLevel += 1
			foodPurchaseCost = 25
			goldPurchaseCost = 25
			woodPurchaseCost = 50
			metalPurchaseCost = 100
			dollarsDic["Base Market Dollars Output"] = (1 * buildingLevel)
			woodDic["Base Market Wood Cost"] = (-1 * buildingLevel)
			metalDic["Base Market Metal Cost"] = (-1 * buildingLevel)
		"Dock":
			# Dock: converts wood + metal into food + gold; raises food storage cap
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/workshop.png")
			foodPerLevel += 3
			dollarsPerLevel += 2
			woodCostPerLevel += 2
			metalCostPerLevel += 2
			foodPurchaseCost = 50
			goldPurchaseCost = 75
			woodPurchaseCost = 100
			metalPurchaseCost = 50
			foodDic["Base Dock Food Output"] = (3 * buildingLevel)
			dollarsDic["Base Dock Gold Output"] = (2 * buildingLevel)
			woodDic["Base Dock Wood Cost"] = (-2 * buildingLevel)
			metalDic["Base Dock Metal Cost"] = (-2 * buildingLevel)
		"Monument":
			# Monument = Temple equivalent (produces Culture instead of old Faith)
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/temple.png")
			foodCostPerLevel += 2
			woodCostPerLevel += 1
			culturePerLevel += 1
			foodPurchaseCost = 75
			goldPurchaseCost = 150
			woodPurchaseCost = 100
			metalPurchaseCost = 50
			foodDic["Base Monument Food Cost"] = (-2 * buildingLevel)
			woodDic["Base Monument Wood Cost"] = (-1 * buildingLevel)
			cultureDic["Base Monument Culture Output"] = (1 * buildingLevel)
		"Resort":
			# Resort produces Happiness
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/bath.png")
			happinessPerLevel += 1
			foodCostPerLevel += 2
			dollarsCostPerLevel += 1
			foodPurchaseCost = 100
			goldPurchaseCost = 150
			woodPurchaseCost = 75
			metalPurchaseCost = 0
			happinessDic["Base Resort Happiness Output"] = (1 * buildingLevel)
			dollarsDic["Base Resort Dollar Cost"] = (-1 * buildingLevel)
			foodDic["Base Resort Food Cost"] = (-2 * buildingLevel)
		"Fortress":
			# Fortress adds tile defensiveness (no mana output)
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/barracks.png")
			defensivenessPerLevel += 2
			foodCostPerLevel += 1
			woodCostPerLevel += 1
			metalCostPerLevel += 2
			foodPurchaseCost = 50
			goldPurchaseCost = 100
			woodPurchaseCost = 75
			metalPurchaseCost = 200
			woodDic["Base Fortress Wood Cost"] = (-1 * buildingLevel)
			metalDic["Base Fortress Metal Cost"] = (-2 * buildingLevel)
			foodDic["Base Fortress Food Cost"] = (-1 * buildingLevel)
		"Bath":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/bath.png")
			corruptionLossPerLevel -= 1
			foodCostPerLevel += 3
			dollarsCostPerLevel += 1
			happinessPerLevel += 1
			foodPurchaseCost = 100
			goldPurchaseCost = 100
			woodPurchaseCost = 50
			metalPurchaseCost = 20
			happinessDic["Base Bath Happiness Output"] = (1 * buildingLevel)
			dollarsDic["Base Bath Dollar Cost"] = (-1 * buildingLevel)
			foodDic["Base Bath Food Cost"] = (-1 * buildingLevel)
			corruptionDic["Base Corruption Loss From Baths"] = (-1 * buildingLevel)
		"Faire":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/faire.png")
			culturePerLevel += 1
			foodCostPerLevel += 2
			woodCostPerLevel += 1
			dollarsCostPerLevel += 2
			foodPurchaseCost = 100
			goldPurchaseCost = 100
			woodPurchaseCost = 50
			metalPurchaseCost = 20
			cultureDic["Base Faire Culture Output"] = (1 * buildingLevel)
			dollarsDic["Base Faire Dollar Cost"] = (-2 * buildingLevel)
			foodDic["Base Faire Food Cost"] = (-2 * buildingLevel)
			woodDic["Base Faire Wood Cost"] = (-1 * buildingLevel)
		"Forge":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/forge.png")
			weaponsPerLevel += 1
			metalPerLevel += 1
			woodPerLevel += 1
			dollarsPerLevel += 1
			foodPurchaseCost = 25
			goldPurchaseCost = 25
			woodPurchaseCost = 50
			metalPurchaseCost = 100
			weaponsDic["Base Forge Weapons Output"] = (1 * buildingLevel)
			dollarsDic["Base Forge Dollar Output"] = (-1 * buildingLevel)
			woodDic["Base Forge Wood Cost"] = (-1 * buildingLevel)
			metalDic["Base Forge Metal Cost"] = (-1 * buildingLevel)
		"Barracks":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/barracks.png")
			manpowerPerLevel += 15
			dollarsCostPerLevel += 2
			woodCostPerLevel += 1
			foodCostPerLevel += 1
			foodPurchaseCost = 30
			goldPurchaseCost = 30
			woodPurchaseCost = 30
			metalPurchaseCost = 90
			manpowerDic["Base Barracks Manpower Output"] = (50 * buildingLevel)
			dollarsDic["Base Barracks Dollar Cost"] = (-2 * buildingLevel)
			woodDic["Base Barracks Wood Cost"] = (-1 * buildingLevel)
			foodDic["Base Barracks Food Cost"] = (-1 * buildingLevel)
		"Courthouse":
			buildingSprite = load("res://art assets/finishedAssets/buildingsketches/courthouse.png")
			mandatePerLevel += 1
			dollarsCostPerLevel += 1
			cultureCostPerLevel += 1
			woodCostPerLevel += 1
			foodPurchaseCost = 50
			goldPurchaseCost = 100
			woodPurchaseCost = 75
			metalPurchaseCost = 25
			mandateDic["Base Courthouse Mandate Output"] = (1 * buildingLevel)
			dollarsDic["Base Courthouse Dollar Cost"] = (-1 * buildingLevel)
			cultureDic["Base Courthouse Culture Cost"] = (-1 * buildingLevel)
			woodDic["Base Courthouse Wood Cost"] = (-1 * buildingLevel)

func matchPlayerUnlockables(playerCountryNode):
	foodDic.clear()
	dollarsDic.clear()
	woodDic.clear()
	metalDic.clear()
	happinessDic.clear()
	influenceDic.clear()
	mandateDic.clear()
	weaponsDic.clear()
	manpowerDic.clear()
	scienceDic.clear()
	# cultureDic removed — merged into cultureDic
	magicDic.clear()
	cultureDic.clear()
	playerCountry = playerCountryNode
	match buildingType:
		"Farm":
			foodPerLevel = 1
			foodDic["Base Farm Output"] = (1 * buildingLevel)
			var farmTech: int = 0
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Drainage Ditches":
					foodPerLevel += 1
					farmTech += 1
				if Technology.techName == "Planting Calendar":
					foodPerLevel += 1
					farmTech += 1
				if Technology.techName == "Land Survey":
					foodPerLevel += 1
					farmTech += 1
			if farmTech != 0:
				foodDic["Farm Technology Food Bonus"] = farmTech
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Frontier Schoolhouse Act":
					sciencePerLevel += 1
					dollarsCostPerLevel += 1
				if law.lawType == "Colonial Trade Act":
					dollarsPerLevel += 1
					dollarsDic["Enacted Law: Mercantilism"] = (1 * buildingLevel)
				if law.lawType == "Homestead Act":
					foodPerLevel += 1
					foodDic["Law: Homestead Act"] = (1 * buildingLevel)
			_apply_governor_archetype_bonus("Farm")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Plain Folk Virtues":
					culturePerLevel += 1
				if tradition.traditionType == "Minuteman Ready":
					manpowerPerLevel += 250
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"MANIFEST DESTINY SUBSIDY PROGRAM":
						foodPerLevel +=1
						woodPerLevel +=1
						magicCostPerLevel += 4
						foodDic["Spell: Manifest Destiny"] = (1 * buildingLevel)
						woodDic["Spell: Manifest Destiny"] = (1 * buildingLevel)
						magicDic["Spell: Manifest Destiny"] = (-4 * buildingLevel)
					"Gentle Rains":
						foodPerLevel += 2
						magicCostPerLevel += 5
			match tile.tileCrop:
				"corn":
					foodPerLevel += 2
					foodDic["Farm Crop: Corn"] = (2 * buildingLevel)
				"apples":
					dollarsPerLevel += 1
					culturePerLevel += 1
					dollarsDic["Farm Crop: Apples"] = (1 * buildingLevel)
					cultureDic["Farm Crop: Apples"] = (1 * buildingLevel)
				"hay":
					foodPerLevel += 1
					manpowerPerLevel += 5  # hay feeds animals, animals pull plows
					foodDic["Farm Crop: Hay"] = (1 * buildingLevel)
				"soybeans":
					foodPerLevel += 2
					metalPerLevel += 1   # industrial crop, feeds ironworkers
					foodDic["Farm Crop: Soybeans"] = (2 * buildingLevel)
				"peanuts":
					foodPerLevel += 1
					dollarsPerLevel += 1
					foodDic["Farm Crop: Peanuts"] = (1 * buildingLevel)
					dollarsDic["Farm Crop: Peanuts"] = (1 * buildingLevel)
				"peaches":
					foodPerLevel += 1
					culturePerLevel += 1
					happinessPerLevel += 1
					foodDic["Farm Crop: Peaches"] = (1 * buildingLevel)
				"oranges":
					foodPerLevel += 2
					happinessPerLevel += 1
					foodDic["Farm Crop: Oranges"] = (2 * buildingLevel)
				"mushrooms":  # Kennett Square PA — easter egg
					magicPerLevel += 1
					sciencePerLevel += 1
					magicDic["Farm Crop: Kennett Square Mushrooms"] = (1 * buildingLevel)
					scienceDic["Farm Crop: Mushrooms"] = (1 * buildingLevel)
				"cannabis":   # Brattleboro VT — easter egg
					culturePerLevel += 2
					happinessPerLevel += 1
					cultureDic["Farm Crop: Brattleboro Cannabis"] = (2 * buildingLevel)
				_:
					# Unknown crop — safe fallback
					foodPerLevel += 1
		"Granary":
			dollarsCostPerLevel += 1
			foodPerLevel = 1
			dollarsDic["Base Granary Gold Cost"] = (-1 * buildingLevel)
			foodDic["Base Granary Food Output"] = (1 * buildingLevel)
			var granaryTech: int = 0
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Almanac Forecasting":
					foodPerLevel += 1
					granaryTech += 1
				if Technology.techName == "Mill Construction":
					foodPerLevel += 1
					granaryTech += 1
			if granaryTech != 0:
				foodDic["Granary Technology Food Bonus"] = granaryTech
			if playerCountry.mandateFromGranaries == true:
				mandatePerLevel += 1
				for Technology in playerCountry.unlockedTechnologies:
					if Technology.techName == "Public Granary Charter":
						mandatePerLevel += 1
						mandateDic["Granary Technology Mandate Bonus"] = (1 * buildingLevel)
				for tradition in playerCountry.unlockedTraditions:
					if tradition.traditionType == "Continental Congress Ledgers":
						mandatePerLevel += 1
				if tile.tileSpell != null:
					match tile.tileSpell.spellType:
						"Celebration":
							mandatePerLevel += 1
							magicCostPerLevel += 4
			_apply_governor_archetype_bonus("Granary")
		"Mine":
			var geoResource = tile.geologicResource if tile.geologicResource != null else ""
			match geoResource:
				"Copper":
					metalPerLevel += 2
					dollarsPerLevel += 1
					metalDic["Mine Resource: Copper"] = (2 * buildingLevel)
					dollarsDic["Mine Resource: Copper"] = (1 * buildingLevel)
				"Iron":
					metalPerLevel += 3
					metalDic["Mine Resource: Iron"] = (3 * buildingLevel)
				"Marble":
					dollarsPerLevel += 1
					culturePerLevel += 2
					dollarsDic["Mine Resource: Marble"] = (1 * buildingLevel)
					cultureDic["Mine Resource: Marble"] = (2 * buildingLevel)
				"Gold":
					dollarsPerLevel += 2
					mandatePerLevel += 1
					dollarsDic["Mine Resource: Gold"] = (2 * buildingLevel)
					mandateDic["Mine Resource: Gold"] = (1 * buildingLevel)
				"None", "":
					# Tile has no mineral resource — mine produces base output only
					metalPerLevel += 1
					metalDic["Base Mine Output (no resource)"] = (1 * buildingLevel)
				_:
					# Unknown resource — safe fallback
					metalPerLevel += 1
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Steam-Powered Shaft":
					metalPerLevel += 3
					magicCostPerLevel += 1
					woodCostPerLevel += 1
					foodCostPerLevel += 1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Open Land Act":
					dollarsPerLevel += 1
				if law.lawType == "Crown Monopoly":
					dollarsCostPerLevel +=1
					happinessCostPerLevel +=1
					metalPerLevel += 2
			_apply_governor_archetype_bonus("Mine")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Appalachian Heritage":
					culturePerLevel += 1
				if tradition.traditionType == "Miners' Commons":
					foodPerLevel +=1
				if tradition.traditionType == "Master Craftsman Guild":
					influencePerLevel +=1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Nightvision":
						metalPerLevel += 1
						magicCostPerLevel += 3
					"Divining Rods":
						metalPerLevel +=1
						dollarsPerLevel +=2
						magicCostPerLevel += 6
					"Replenishment":
						metalPerLevel += 4
						magicCostPerLevel += 12
		"Temple":
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Carpenter's Guild":
					woodCostPerLevel +=1
					metalCostPerLevel +=1
					cultureCostPerLevel +=2
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Right of Sanctuary":
					happinessPerLevel +=1
				if law.lawType == "Parish Records":
					culturePerLevel +=1
			_apply_governor_archetype_bonus("Temple")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Puritan Scholarship":
					sciencePerLevel += 1
				if tradition.traditionType == "Meetinghouse Gardens":
					culturePerLevel +=1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Foresight":
						mandatePerLevel += 2
						magicCostPerLevel += 6
					"Omniscient Direction":
						culturePerLevel += 2
						mandatePerLevel += 5
						magicCostPerLevel += 15
			if tile.tileCrop == "cannabis":
				# Brattleboro's spiritual community appreciates the temple
				culturePerLevel += 1
				cultureDic["Temple: Cannabis Crop Harmony"] = (1 * buildingLevel)
		"Camp":
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Axe Grinding":
					woodPerLevel +=2
					metalCostPerLevel +=1
				if Technology.techName == "Iron Saw":
					woodPerLevel +=2
					metalCostPerLevel +=1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Land Grant Act":
					happinessPerLevel +=1
				if law.lawType == "Timber Reserve":
					culturePerLevel +=1
				if law.lawType == "Naval Stores Act":
					dollarsPerLevel += 1
				if law.lawType == "Homestead Act":
					woodPerLevel += 1
					woodDic["Law: Homestead Act"] = (1 * buildingLevel)
			_apply_governor_archetype_bonus("Camp")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Frontier Scouts":
					foodPerLevel += (1 * Governor.governorLevel)
					manpowerPerLevel += (50 * Governor.governorLevel)
				if tradition.traditionType == "Timber Warden":
					mandatePerLevel +=1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Ent Tongue":
						woodPerLevel +=1
						culturePerLevel += 1
						magicCostPerLevel += 4
					"Hunter's Mark":
						foodPerLevel += 1
						magicCostPerLevel += 2
		"Tower":
			magicPerLevel += 4
			foodCostPerLevel += 2
			metalCostPerLevel += 1
			woodCostPerLevel += 2
			dollarsCostPerLevel += 1
			magicDic["Base Tower Magic Output"] = (4 * buildingLevel)
			foodDic["Base Tower Food Cost"] = (-2 * buildingLevel)
			woodDic["Base Tower Wood Cost"] = (-2 * buildingLevel)
			metalDic["Base Tower Metal Cost"] = (-1 * buildingLevel)
			dollarsDic["Base Tower Gold Cost"] = (-1 * buildingLevel)
			if tile.tileWizard != null:
				match tile.tileWizard.wizardSchool:
					"storm":    woodPerLevel    += 3
					"manifest": dollarsPerLevel += 3
					"iron":     metalPerLevel   += 3
					"cryptid":  metalPerLevel   += 2
					"liberty":  culturePerLevel += 3
					"spectral":
						foodPerLevel    += 1
						woodPerLevel    += 1
						dollarsPerLevel += 1
						metalPerLevel   += 1
			else:
				print("no assigned wizard to tile:", tile.tileNumber)
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Optician's Art":
					magicPerLevel += 1
					sciencePerLevel += 1
					metalCostPerLevel +=1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Right of Travel":
					happinessPerLevel +=2
				if law.lawType == "Land Registry":
					culturePerLevel +=1
					sciencePerLevel +=1
				if law.lawType == "Colonial Apprenticeship":
					magicPerLevel += 2
			_apply_governor_archetype_bonus("Tower")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Natural Order Studies":
					sciencePerLevel += 1
				if tradition.traditionType == "Old Ways Knowledge":
					influencePerLevel +=1
				if tradition.traditionType == "Republican Virtue":
					mandatePerLevel +=1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Extradimensional Servants":
						woodPerLevel +=1
						foodPerLevel += 1
						dollarsPerLevel += 1
						metalPerLevel += 1
						magicCostPerLevel += 4
					"Clear Skies":
						sciencePerLevel += 1
						culturePerLevel += 1
						magicCostPerLevel += 5
					"Peace":
						happinessPerLevel += 1
						influencePerLevel += 1
						magicCostPerLevel += 5
			if tile.tileCrop == "Cannabis":
				culturePerLevel +=1
				magicCostPerLevel += 1
			if tile.tileCrop == "Cloudbean":
				magicPerLevel +=1
			if tile.geologicResource == "Gold":
				# Gold deposits correlate with ley lines (flavor)
				magicPerLevel += 1
				magicDic["Tower: Gold Deposits"] = (1 * buildingLevel)
		"Library":
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Constitutional Studies":
					sciencePerLevel += 1
					mandatePerLevel += 1
					dollarsCostPerLevel += 1
				if Technology.techName == "Paper Mill":
					sciencePerLevel += 1
					woodPerLevel += 1
				if Technology.techName == "Common Literacy":
					sciencePerLevel += 1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Weights and Measures Act":
					sciencePerLevel += 1
				if law.lawType == "Philosopher-Statesmen":
					influencePerLevel += 1
				if law.lawType == "Free Press Act":
					happinessPerLevel += 1
			_apply_governor_archetype_bonus("Library")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Republican Letters":
					sciencePerLevel += 1
				if tradition.traditionType == "Gentleman Scholar":
					culturePerLevel +=1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Potion: Focusing Dust":
						sciencePerLevel +=1
						magicCostPerLevel += 2
					"Inspiration":
						sciencePerLevel += 3
						culturePerLevel += 1
						magicCostPerLevel += 8
					"Hive Mind":
						happinessPerLevel += 1
						sciencePerLevel += 2
						magicCostPerLevel += 6
			if tile.geologicResource == "Gold":
				sciencePerLevel += 1
				scienceDic["Library: Gold Deposit Funding"] = (1 * buildingLevel)
		"Workshop":
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Land Bank":
					dollarsPerLevel += 2
				if Technology.techName == "Guild Craft":
					dollarsPerLevel += 2
					woodCostPerLevel += 2
				if Technology.techName == "Foundry Casting":
					metalCostPerLevel += 1
					dollarsPerLevel += 2
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Indentured Terms":
					foodCostPerLevel += 2
				if law.lawType == "Non-Importation Agreement":
					foodCostPerLevel += 1
					metalCostPerLevel += 1
					dollarsPerLevel += 2
				if law.lawType == "Continental Engineers":
					manpowerPerLevel += 300
				if law.lawType == "Merchant Marine Act":
					dollarsPerLevel += 1

			_apply_governor_archetype_bonus("Workshop")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Artisan Quarter":
					culturePerLevel += 1
				if tradition.traditionType == "Apprentice System":
					sciencePerLevel +=1
				if tradition.traditionType == "Self-Made Man":
					mandatePerLevel += 1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Potion: Stamina":
						dollarsPerLevel += 2
						metalCostPerLevel += 1
						woodCostPerLevel += 1
						magicCostPerLevel += 2
					"Duplication":
						dollarsPerLevel += 4
						happinessCostPerLevel += 1
						magicCostPerLevel += 7
		"Bath":
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Aqueduct Construction":
					dollarsPerLevel += 1
					corruptionLossPerLevel -= 1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Clean Water Ordinance":
					corruptionLossPerLevel -= 1
					foodPerLevel += 1
				if law.lawType == "Public Health Act":
					culturePerLevel += 1
					corruptionLossPerLevel -= 1
				if law.lawType == "Town Meeting Rights":
					influencePerLevel +=1
					mandatePerLevel += 1
			_apply_governor_archetype_bonus("Bath")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Public Well Customs":
					mandatePerLevel += 1
				if tradition.traditionType == "Common Green":
					culturePerLevel += 1
				if tradition.traditionType == "Colonial Apothecary":
					happinessPerLevel += 1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Geothermic Well":
						dollarsPerLevel += 3
						culturePerLevel += 2
						magicCostPerLevel += 10
					"Vitamins and Minerals":
						#-1 corruption in this tile per level
						sciencePerLevel += 1
						culturePerLevel += 1
						magicCostPerLevel += 6
		"Faire":
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Exhibition Hall":
					culturePerLevel += 2
					woodPerLevel += 2
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Continental Exhibition":
					influencePerLevel += 1
				if law.lawType == "Free Assembly Act":
					culturePerLevel += 1
				if law.lawType == "Muster Day Games":
					manpowerPerLevel += 15
			_apply_governor_archetype_bonus("Faire")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Colonial Cookbook":
					culturePerLevel += 1
				if tradition.traditionType == "Artisan Market":
					dollarsPerLevel += 1
				if tradition.traditionType == "Free Cider Day":
					foodPerLevel += 1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Celebration":
						dollarsPerLevel += 1
						culturePerLevel += 1
						foodPerLevel += 1
						magicCostPerLevel += 6
					"Fireworks":
						happinessPerLevel += 3
						magicCostPerLevel +=7
		"Forge":
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Blast Furnace":
					weaponsPerLevel += 2
					metalCostPerLevel += 1
					woodCostPerLevel += 1
					dollarsCostPerLevel += 1
					#corruption in this tile +1
				if Technology.techName == "Quench Hardening":
					weaponsPerLevel += 2
					metalCostPerLevel += 1
					dollarsCostPerLevel += 1
					#corruption in this tile +1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Continental Contract":
					weaponsPerLevel += 2
					dollarsCostPerLevel += 1
					metalCostPerLevel += 1
					#corruption in this tile +1
				if law.lawType == "Armorer's License":
					weaponsPerLevel += 1
					#corruption in this tile +1
					happinessPerLevel += 1
					metalCostPerLevel += 1
				if law.lawType == "Scrap Metal Drive":
					metalPerLevel += 1
					dollarsPerLevel += 1
			_apply_governor_archetype_bonus("Forge")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Iron Discipline":
					weaponsPerLevel += 1
				#corruption in this tile +1
				if tradition.traditionType == "Fighting Smiths":
					manpowerPerLevel += 250
				if tradition.traditionType == "Decorative Ironwork":
					culturePerLevel += 1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Heart of the Forge":
						foodPerLevel += 1
						culturePerLevel += 1
						culturePerLevel += 1
						happinessPerLevel += 1
						magicCostPerLevel += 8
					"Resist Heat":
						weaponsPerLevel += 3
						#corruption in this tile +3
						metalCostPerLevel += 3
						magicCostPerLevel += 9
		"Barracks":
			# Barracks produces Manpower — drill technologies, conscription laws, and military traditions boost it.
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Steuben Drill Manual":
					# Baron von Steuben's training regimen — more manpower per level, costs dollars
					manpowerPerLevel += 300
					dollarsCostPerLevel += 1
				if Technology.techName == "Field Fortification":
					# Vauban earthworks — barracks contributes to tile defense
					defensivenessPerLevel += 1
					woodCostPerLevel += 1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Continental Draft":
					# Mandatory service — historically controversial, historically effective
					manpowerPerLevel += 300
					happinessCostPerLevel += 1
				if law.lawType == "Enlistment Bounty":
					# Cash and land bounties to fill the ranks
					manpowerPerLevel += 200
					dollarsCostPerLevel += 2
				if law.lawType == "National Security Act" or law.lawType == "National Defence Act":
					mandateCostPerLevel += 1
					mandateDic["Law: " + law.lawType + " (Barracks cost)"] = (-1 * buildingLevel)
			_apply_governor_archetype_bonus("Barracks")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Minuteman Ready":
					# Sixty seconds to muster — colonial militia tradition; benefits both farms and barracks
					manpowerPerLevel += 250
				if tradition.traditionType == "Continental Veterans":
					# Pride in service — veterans improve weapons output and inspire culture
					weaponsPerLevel += 1
					culturePerLevel += 1
		"Market":
			# Market uses the same unlockable logic as Workshop (both produce Dollars).
			# Any tradition/tech/law that would boost Workshop also boosts Market.
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Land Bank":
					dollarsPerLevel += 2
				if Technology.techName == "Artisan Craft":
					dollarsPerLevel += 2
					woodCostPerLevel += 2
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Merchant Marine Act":
					dollarsPerLevel += 1
					mandateCostPerLevel += 2
				if law.lawType == "Non-Importation Agreement":
					dollarsPerLevel += 2
					foodCostPerLevel += 1
					metalCostPerLevel += 1
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Agrarian Bastions":
					# Agrarian Bastions: markets also produce food
					foodPerLevel += 1
				if tradition.traditionType == "Artisan Quarter":
					culturePerLevel += 1
			_apply_governor_archetype_bonus("Market")
		"Dock":
			# Dock unlockables: techs/laws/traditions that boost output.
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Dead Reckoning":
					dollarsPerLevel += 1
					woodPerLevel += 1
					dollarsDic["Tech: Dead Reckoning"] = (1 * buildingLevel)
					woodDic["Tech: Dead Reckoning"] = (1 * buildingLevel)
				if Technology.techName == "Dry Dock Construction":
					dollarsPerLevel += 1
					woodPerLevel += 1
					dollarsDic["Tech: Dry Dock Construction"] = (1 * buildingLevel)
					woodDic["Tech: Dry Dock Construction"] = (1 * buildingLevel)
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Naval Contracts":
					weaponsPerLevel += 1
					sciencePerLevel += 1
					weaponsDic["Law: Naval Contracts"] = (1 * buildingLevel)
					scienceDic["Law: Naval Contracts"] = (1 * buildingLevel)
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Agrarian Bastions":
					dollarsPerLevel += 1
					dollarsDic["Tradition: Agrarian Bastions"] = (1 * buildingLevel)
			# Conditional: food stockpile < 50% cap → +1 food/level; else → +1 gold/level
			var food_cap_half: int = int(playerCountry.foodStorageMax * 0.5)
			if playerCountry.TotalFood < food_cap_half:
				foodPerLevel += 1
				foodDic["Dock Stockpile Bonus (Food)"] = (1 * buildingLevel)
			else:
				dollarsPerLevel += 1
				dollarsDic["Dock Stockpile Bonus (Gold)"] = (1 * buildingLevel)
			_apply_governor_archetype_bonus("Dock")
		"Monument":
			# Monument is the primary Reason↔Providence axis building.
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Classical Design":
					woodCostPerLevel += 1
					metalCostPerLevel += 1
					cultureCostPerLevel += 2
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Peace Memorial":
					happinessPerLevel += 1
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Puritan Scholarship":
					sciencePerLevel += 1
			_apply_governor_archetype_bonus("Monument")
			var monAxLvl: int = playerCountry.churchLevel
			match monAxLvl:
				3:
					dollarsPerLevel += 1
					mandatePerLevel += 1
					dollarsDic["Axis: Providence III"] = (1 * buildingLevel)
					mandateDic["Axis: Providence III"] = (1 * buildingLevel)
				2:
					dollarsPerLevel += 1
					mandatePerLevel += 1
					dollarsDic["Axis: Providence II"] = (1 * buildingLevel)
					mandateDic["Axis: Providence II"] = (1 * buildingLevel)
				1:
					culturePerLevel += 1
					dollarsPerLevel += 1
					mandatePerLevel += 1
					cultureDic["Axis: Providence I"] = (1 * buildingLevel)
					dollarsDic["Axis: Providence I"] = (1 * buildingLevel)
					mandateDic["Axis: Providence I"] = (1 * buildingLevel)
				0:
					culturePerLevel += 1
					dollarsPerLevel += 1
					mandatePerLevel += 1
					happinessPerLevel += 1
					cultureDic["Axis: Balanced"] = (1 * buildingLevel)
					dollarsDic["Axis: Balanced"] = (1 * buildingLevel)
					mandateDic["Axis: Balanced"] = (1 * buildingLevel)
					happinessDic["Axis: Balanced"] = (1 * buildingLevel)
				-1:
					culturePerLevel += 1
					dollarsPerLevel += 1
					happinessPerLevel += 1
					cultureDic["Axis: Reason I"] = (1 * buildingLevel)
					dollarsDic["Axis: Reason I"] = (1 * buildingLevel)
					happinessDic["Axis: Reason I"] = (1 * buildingLevel)
				-2:
					culturePerLevel += 1
					happinessPerLevel += 1
					cultureDic["Axis: Reason II"] = (1 * buildingLevel)
					happinessDic["Axis: Reason II"] = (1 * buildingLevel)
				-3:
					culturePerLevel += 1
					cultureDic["Axis: Reason III"] = (1 * buildingLevel)
		"Resort":
			# Resort produces Happiness — buffed by comfort/hospitality traditions.
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Spa Construction":
					happinessPerLevel += 1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Right of Rest":
					happinessPerLevel += 1
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Common Respite":
					happinessPerLevel += 1
			_apply_governor_archetype_bonus("Resort")
		"Fortress":
			# Fortress adds defensiveness; traditions can unlock food production.
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Garrison Farm":
					# Agrarian Bastions: fortresses produce food from garrison farming
					foodPerLevel += 1
				if tradition.traditionType == "Star Fort Tradition":
					defensivenessPerLevel += 1
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Military Engineering":
					defensivenessPerLevel += 1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Engineer Corps":
					defensivenessPerLevel += 1
			_apply_governor_archetype_bonus("Fortress")
		"Courthouse":
			# Courthouse produces Mandate — governance technologies, civic laws, and administrative traditions boost it.
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Constitutional Studies":
					mandatePerLevel += 1
					sciencePerLevel += 1
				if Technology.techName == "Common Literacy":
					sciencePerLevel += 1
					mandatePerLevel += 1
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Philosopher-Statesmen":
					influencePerLevel += 1
					mandatePerLevel += 1
				if law.lawType == "Parish Records Act":
					culturePerLevel += 1
				if law.lawType == "Free Speech Act":
					happinessPerLevel += 1
					influencePerLevel += 1
				if law.lawType == "Accessible Canada Act":
					dollarsPerLevel += 1
					culturePerLevel += 1
					dollarsDic["Law: Accessible Canada Act"] = (1 * buildingLevel)
					cultureDic["Law: Accessible Canada Act"] = (1 * buildingLevel)
			_apply_governor_archetype_bonus("Courthouse")
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Continental Congress Ledgers":
					mandatePerLevel += 1
				if tradition.traditionType == "Self-Made Man":
					mandatePerLevel += 1
			if tile.tileSpell != null:
				match tile.tileSpell.spellType:
					"Foresight":
						mandatePerLevel += 2
						magicCostPerLevel += 6
					"Omniscient Direction":
						culturePerLevel += 2
						mandatePerLevel += 5
						magicCostPerLevel += 15
	_apply_faction_bonuses(buildingType)
		# Global law bonuses — apply to every building type
	for law in playerCountry.lawsInConstitution:
			if law.lawType == "National Security Act" or law.lawType == "National Defence Act":
				manpowerPerLevel += 5
				manpowerDic["Law: " + law.lawType] = (5 * buildingLevel)
			if law.lawType == "French Language Rights":
				if tile != null and tile.tileState == "CA - QB":
					culturePerLevel += 1
					cultureDic["Law: French Language Rights"] = (1 * buildingLevel)
					if buildingType == "Courthouse":
						mandatePerLevel -= 2
						mandateDic["Law: French Language Rights"] = (-2 * buildingLevel)
					if buildingType == "Barracks":
						manpowerPerLevel = int(round(float(manpowerPerLevel) * 1.1))
			if law.lawType == "French Cultural Identity Enshrined":
				if tile != null and tile.tileState == "CA - QB" and buildingType == "Resort":
					culturePerLevel += 1
					cultureDic["Law: French Cultural Identity Enshrined"] = (1 * buildingLevel)
					dollarsPerLevel += 1
					dollarsDic["Law: French Cultural Identity Enshrined"] = (1 * buildingLevel)
					manpowerPerLevel += 100
					manpowerDic["Law: French Cultural Identity Enshrined"] = (100 * buildingLevel)
					mandatePerLevel -= 1
					mandateDic["Law: French Cultural Identity Enshrined"] = (-1 * buildingLevel)
	_apply_axis_bonuses(buildingType)
	_apply_belief_bonuses(buildingType)

func _apply_faction_bonuses(bType: String) -> void:
	if playerCountry == null:
		return
	for fac in playerCountry.countryFactionList:
		match fac.factionName:
			"Sons of Liberty":
				if fac.factionLoyalty >= 30:
					if bType == "Barracks":
						manpowerPerLevel += 50
						manpowerDic["Faction: Sons of Liberty (Militia Muster)"] = (50 * buildingLevel)
				if fac.factionLoyalty >= 60:
					if bType == "Market" or bType == "Workshop":
						dollarsPerLevel += 1
						dollarsDic["Faction: Sons of Liberty (Merchant Networks)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Dock":
						weaponsPerLevel += 1
						weaponsDic["Faction: Sons of Liberty (Letters of Marque)"] = (1 * buildingLevel)
			"Continental Congress":
				if fac.factionLoyalty >= 30:
					if bType == "Courthouse":
						mandatePerLevel += 1
						mandateDic["Faction: Continental Congress (Articles of Confederation)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 60:
					if bType == "Monument":
						influencePerLevel += 1
						influenceDic["Faction: Continental Congress (Foreign Diplomacy)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Library":
						sciencePerLevel += 1
						scienceDic["Faction: Continental Congress (Constitutional Convention)"] = (1 * buildingLevel)
			"Common Cause":
				if fac.factionLoyalty >= 30:
					if bType == "Farm":
						foodPerLevel += 1
						foodDic["Faction: Common Cause (Frontier Homesteads)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 60:
					if bType == "Resort" or bType == "Monument":
						happinessPerLevel += 1
						happinessDic["Faction: Common Cause (The People's Assembly)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Farm":
						foodPerLevel += 1
						foodDic["Faction: Common Cause (Land Reform)"] = (1 * buildingLevel)
			"Abolitionist League":
				if fac.factionLoyalty >= 60:
					if bType == "Monument":
						culturePerLevel += 1
						cultureDic["Faction: Abolitionist League (Underground Railroad)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Monument":
						happinessPerLevel += 1
						happinessDic["Faction: Abolitionist League (Universal Emancipation)"] = (1 * buildingLevel)
					if bType == "Courthouse":
						mandatePerLevel += 1
						mandateDic["Faction: Abolitionist League (Universal Emancipation)"] = (1 * buildingLevel)
			"Free Workers Union":
				if fac.factionLoyalty >= 30:
					if bType == "Forge":
						weaponsPerLevel += 1
						weaponsDic["Faction: Free Workers Union (Guild Charters)"] = (1 * buildingLevel)
					if bType == "Market" or bType == "Workshop":
						dollarsPerLevel += 1
						dollarsDic["Faction: Free Workers Union (Guild Charters)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 60:
					if bType == "Camp":
						woodPerLevel += 1
						woodDic["Faction: Free Workers Union (General Strike)"] = (1 * buildingLevel)
					if bType == "Mine":
						metalPerLevel += 1
						metalDic["Faction: Free Workers Union (General Strike)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Farm":
						foodPerLevel += 1
						foodDic["Faction: Free Workers Union (Workers Commonwealth)"] = (1 * buildingLevel)
					if bType == "Library":
						sciencePerLevel += 1
						scienceDic["Faction: Free Workers Union (Workers Commonwealth)"] = (1 * buildingLevel)
			"French Habitants":
				if fac.factionLoyalty >= 30:
					if bType == "Monument":
						culturePerLevel += 1
						cultureDic["Faction: French Habitants (Quebec Act Recognition)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 60:
					if bType == "Farm":
						foodPerLevel += 1
						foodDic["Faction: French Habitants (Habitants Alliance)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Farm":
						foodPerLevel += 1
						foodDic["Faction: French Habitants (Republic of Quebec)"] = (1 * buildingLevel)
					if bType == "Monument":
						happinessPerLevel += 1
						happinessDic["Faction: French Habitants (Republic of Quebec)"] = (1 * buildingLevel)
			"Loyalist Settlers":
				if fac.factionLoyalty >= 30:
					if bType == "Courthouse":
						mandatePerLevel += 1
						mandateDic["Faction: Loyalist Settlers (Crown Defectors)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 60:
					if bType == "Barracks":
						manpowerPerLevel += 50
						manpowerDic["Faction: Loyalist Settlers (Pragmatic Compact)"] = (50 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Library":
						sciencePerLevel += 1
						scienceDic["Faction: Loyalist Settlers (New Republic Converts)"] = (1 * buildingLevel)
					if bType == "Market" or bType == "Workshop":
						dollarsPerLevel += 1
						dollarsDic["Faction: Loyalist Settlers (New Republic Converts)"] = (1 * buildingLevel)
			"Haudenosaunee Confederacy":
				if fac.factionLoyalty >= 30:
					if bType == "Camp":
						woodPerLevel += 1
						woodDic["Faction: Haudenosaunee Confederacy (Treaty of Friendship)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 60:
					if bType == "Camp":
						weaponsPerLevel += 1
						weaponsDic["Faction: Haudenosaunee Confederacy (Haudenosaunee Alliance)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Barracks":
						manpowerPerLevel += 50
						manpowerDic["Faction: Haudenosaunee Confederacy (Sovereign Partnership)"] = (50 * buildingLevel)
			"Coureurs des Bois":
				if fac.factionLoyalty >= 30:
					if bType == "Camp":
						woodPerLevel += 1
						woodDic["Faction: Coureurs des Bois (Trade Routes)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 60:
					if bType == "Camp":
						woodPerLevel += 1
						woodDic["Faction: Coureurs des Bois (Frontier Network)"] = (1 * buildingLevel)
					if bType == "Mine":
						metalPerLevel += 1
						metalDic["Faction: Coureurs des Bois (Frontier Network)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Camp":
						weaponsPerLevel += 1
						weaponsDic["Faction: Coureurs des Bois (Continental Reach)"] = (1 * buildingLevel)
			"Maritime Patriots":
				if fac.factionLoyalty >= 30:
					if bType == "Dock":
						foodPerLevel += 1
						foodDic["Faction: Maritime Patriots (Port Alliance)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 60:
					if bType == "Market" or bType == "Workshop":
						dollarsPerLevel += 1
						dollarsDic["Faction: Maritime Patriots (Atlantic Commerce)"] = (1 * buildingLevel)
					if bType == "Dock":
						dollarsPerLevel += 1
						dollarsDic["Faction: Maritime Patriots (Atlantic Commerce)"] = (1 * buildingLevel)
				if fac.factionLoyalty >= 90:
					if bType == "Dock":
						manpowerPerLevel += 100
						manpowerDic["Faction: Maritime Patriots (Maritime Union)"] = (100 * buildingLevel)

func _apply_axis_bonuses(bType: String) -> void:
	if playerCountry == null:
		return
	var lvl: int = playerCountry.churchLevel
	if lvl == 3:
		match bType:
			"Barracks":
				manpowerPerLevel += 50
				manpowerDic["Axis: Providence III (Martial Faith)"] = (50 * buildingLevel)
			"Farm":
				foodPerLevel += 1
				foodDic["Axis: Providence III (Sacred Harvest)"] = (1 * buildingLevel)
			"Fortress":
				defensivenessPerLevel += 1
				# no dic for defensiveness — matches existing pattern
			"Courthouse":
				mandatePerLevel += 1
				mandateDic["Axis: Providence III (Divine Law)"] = (1 * buildingLevel)
	elif lvl == -3:
		match bType:
			"Library":
				sciencePerLevel += 1
				culturePerLevel += 1
				scienceDic["Axis: Reason III (Secular Learning)"] = (1 * buildingLevel)
				cultureDic["Axis: Reason III (Secular Learning)"] = (1 * buildingLevel)
			"Market":
				dollarsPerLevel += 1
				dollarsDic["Axis: Reason III (Free Commerce)"] = (1 * buildingLevel)
			"Resort":
				happinessPerLevel += 1
				happinessDic["Axis: Reason III (Civic Pleasure)"] = (1 * buildingLevel)
			"Courthouse":
				mandatePerLevel += 1
				mandateDic["Axis: Reason III (Secular Law)"] = (1 * buildingLevel)


func _apply_belief_bonuses(bType: String) -> void:
	if playerCountry == null:
		return
	for belief in playerCountry.selectedBeliefs:
		match belief.beliefType:
			# ── American Doctrines (→ Providence) ──────────────────────────────────
			"Social Security Act":
				if bType == "Resort":
					happinessPerLevel += 1
					happinessDic["Doctrine: Social Security Act"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Doctrine: Social Security Act"] = (1 * buildingLevel)
			"Landmark Heritage":
				if bType == "Monument":
					mandatePerLevel += 1
					mandateDic["Doctrine: Landmark Heritage"] = (1 * buildingLevel)
			"Sherman Antitrust Act":
				if bType == "Market":
					dollarsPerLevel += 1
					dollarsDic["Doctrine: Sherman Antitrust Act"] = (1 * buildingLevel)
				if bType == "Mine":
					metalPerLevel += 1
					metalDic["Doctrine: Sherman Antitrust Act"] = (1 * buildingLevel)
			"Nature Conservationists":
				if bType == "Camp":
					culturePerLevel += 1
					cultureDic["Doctrine: Nature Conservationists"] = (1 * buildingLevel)
			"Civic Pride":
				if bType == "Resort":
					culturePerLevel += 1
					cultureDic["Doctrine: Civic Pride"] = (1 * buildingLevel)
			"Pioneer Heritage":
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Doctrine: Pioneer Heritage"] = (1 * buildingLevel)
			"Defense Production Act":
				if bType == "Tower":
					magicPerLevel += 1
					magicDic["Doctrine: Defense Production Act"] = (1 * buildingLevel)
				if bType == "Library":
					sciencePerLevel += 1
					scienceDic["Doctrine: Defense Production Act"] = (1 * buildingLevel)
			"Inland Maritime Expertise":
				pass # movement bonus handled in world.gd tick
			"First Amendment":
				if bType == "Monument":
					mandatePerLevel += 1
					mandateDic["Doctrine: First Amendment"] = (1 * buildingLevel)
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Doctrine: First Amendment"] = (1 * buildingLevel)
			"National Research Act":
				if bType == "Library":
					sciencePerLevel += 1
					scienceDic["Doctrine: National Research Act"] = (1 * buildingLevel)
			"Height of Buildings Act":
				if bType == "Monument":
					culturePerLevel += 1
					mandatePerLevel += 1
					cultureDic["Doctrine: Height of Buildings Act"] = (1 * buildingLevel)
					mandateDic["Doctrine: Height of Buildings Act"] = (1 * buildingLevel)
			# ── Canadian Doctrines (→ Providence) ───────────────────────────────
			# "Nature Conservationists" covers both USA and CA — handled above
			"Canada Council for the Arts Act":
				if bType == "Theater" or bType == "Faire":
					culturePerLevel += 1
					cultureDic["Doctrine: Canada Council for the Arts Act"] = (1 * buildingLevel)
				if bType == "Resort":
					happinessPerLevel += 1
					happinessDic["Doctrine: Canada Council for the Arts Act"] = (1 * buildingLevel)
			"Republic Lands Act":
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Doctrine: Republic Lands Act"] = (1 * buildingLevel)
				if bType == "Camp":
					woodPerLevel += 1
					woodDic["Doctrine: Republic Lands Act"] = (1 * buildingLevel)
			"Historic Sites and Monuments Act":
				if bType == "Monument":
					mandatePerLevel += 1
					mandateDic["Doctrine: Historic Sites and Monuments Act"] = (1 * buildingLevel)
			"Combines Investigation Act":
				if bType == "Market":
					dollarsPerLevel += 1
					dollarsDic["Doctrine: Combines Investigation Act"] = (1 * buildingLevel)
				if bType == "Mine":
					metalPerLevel += 1
					metalDic["Doctrine: Combines Investigation Act"] = (1 * buildingLevel)
			"Canada Health Act":
				if bType == "Resort":
					happinessPerLevel += 1
					happinessDic["Doctrine: Canada Health Act"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Doctrine: Canada Health Act"] = (1 * buildingLevel)
			"National Parks Act":
				if bType == "Camp":
					woodPerLevel += 1
					woodDic["Doctrine: National Parks Act"] = (1 * buildingLevel)
				if bType == "Barracks":
					manpowerPerLevel += 50
					manpowerDic["Doctrine: National Parks Act"] = (50 * buildingLevel)
			"Charter of Rights and Freedoms":
				if bType == "Monument":
					mandatePerLevel += 1
					mandateDic["Doctrine: Charter of Rights and Freedoms"] = (1 * buildingLevel)
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Doctrine: Charter of Rights and Freedoms"] = (1 * buildingLevel)
			"Medical Research Council Act":
				if bType == "Library":
					sciencePerLevel += 1
					scienceDic["Doctrine: Medical Research Council Act"] = (1 * buildingLevel)
			"National Building Code of Canada":
				if bType == "Monument":
					culturePerLevel += 1
					mandatePerLevel += 1
					cultureDic["Doctrine: National Building Code of Canada"] = (1 * buildingLevel)
					mandateDic["Doctrine: National Building Code of Canada"] = (1 * buildingLevel)
			"War Measures Act":
				if bType == "Tower":
					magicPerLevel += 1
					magicDic["Doctrine: War Measures Act"] = (1 * buildingLevel)
				if bType == "Library":
					sciencePerLevel += 1
					scienceDic["Doctrine: War Measures Act"] = (1 * buildingLevel)
			# ── American Icons (→ Reason) ────────────────────────────────────────
			"George Washington":
				if bType == "Barracks":
					manpowerPerLevel += 50
					weaponsPerLevel += 1
					manpowerDic["Icon: George Washington"] = (50 * buildingLevel)
					weaponsDic["Icon: George Washington"] = (1 * buildingLevel)
			"Benjamin Franklin":
				if bType == "Library":
					sciencePerLevel += 1
					scienceDic["Icon: Benjamin Franklin"] = (1 * buildingLevel)
				if bType == "Workshop":
					dollarsPerLevel += 1
					dollarsDic["Icon: Benjamin Franklin"] = (1 * buildingLevel)
			"Abigail Adams":
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Abigail Adams"] = (1 * buildingLevel)
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Abigail Adams"] = (1 * buildingLevel)
			"Alexander Hamilton":
				if bType == "Market" or bType == "Workshop":
					dollarsPerLevel += 1
					dollarsDic["Icon: Alexander Hamilton"] = (1 * buildingLevel)
			"Phillis Wheatley":
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Phillis Wheatley"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: Phillis Wheatley"] = (1 * buildingLevel)
			"Thomas Jefferson":
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Icon: Thomas Jefferson"] = (1 * buildingLevel)
				if bType == "Library":
					sciencePerLevel += 1
					scienceDic["Icon: Thomas Jefferson"] = (1 * buildingLevel)
			"Abraham Lincoln":
				if bType == "Barracks":
					manpowerPerLevel += 50
					manpowerDic["Icon: Abraham Lincoln"] = (50 * buildingLevel)
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Abraham Lincoln"] = (1 * buildingLevel)
			"Harriet Tubman":
				if bType == "Barracks":
					manpowerPerLevel += 50
					weaponsPerLevel += 1
					manpowerDic["Icon: Harriet Tubman"] = (50 * buildingLevel)
					weaponsDic["Icon: Harriet Tubman"] = (1 * buildingLevel)
			"Frederick Douglass":
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Frederick Douglass"] = (1 * buildingLevel)
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Frederick Douglass"] = (1 * buildingLevel)
			"Sitting Bull":
				if bType == "Camp":
					woodPerLevel += 1
					foodPerLevel += 1
					woodDic["Icon: Sitting Bull"] = (1 * buildingLevel)
					foodDic["Icon: Sitting Bull"] = (1 * buildingLevel)
			"Sojourner Truth":
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Icon: Sojourner Truth"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: Sojourner Truth"] = (1 * buildingLevel)
			"Chief Joseph":
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Chief Joseph"] = (1 * buildingLevel)
			"Theodore Roosevelt":
				if bType == "Mine":
					metalPerLevel += 1
					metalDic["Icon: Theodore Roosevelt"] = (1 * buildingLevel)
				if bType == "Camp":
					woodPerLevel += 1
					woodDic["Icon: Theodore Roosevelt"] = (1 * buildingLevel)
				if bType == "Barracks":
					manpowerPerLevel += 50
					manpowerDic["Icon: Theodore Roosevelt"] = (50 * buildingLevel)
			"Susan B. Anthony":
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Susan B. Anthony"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: Susan B. Anthony"] = (1 * buildingLevel)
			"Ida B. Wells":
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Ida B. Wells"] = (1 * buildingLevel)
			"Eleanor Roosevelt":
				if bType == "Resort":
					happinessPerLevel += 1
					happinessDic["Icon: Eleanor Roosevelt"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: Eleanor Roosevelt"] = (1 * buildingLevel)
			"Martin Luther King Jr.":
				if bType == "Monument":
					culturePerLevel += 1
					mandatePerLevel += 1
					cultureDic["Icon: Martin Luther King Jr."] = (1 * buildingLevel)
					mandateDic["Icon: Martin Luther King Jr."] = (1 * buildingLevel)
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Martin Luther King Jr."] = (1 * buildingLevel)
			"Cesar Chavez":
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Icon: Cesar Chavez"] = (1 * buildingLevel)
				if bType == "Barracks":
					manpowerPerLevel += 50
					manpowerDic["Icon: Cesar Chavez"] = (50 * buildingLevel)
			"Jimmy Carter":
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Icon: Jimmy Carter"] = (1 * buildingLevel)
				if bType == "Resort":
					happinessPerLevel += 1
					happinessDic["Icon: Jimmy Carter"] = (1 * buildingLevel)
			"Dolores Huerta":
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Icon: Dolores Huerta"] = (1 * buildingLevel)
			# ── Canadian Icons (→ Reason) ────────────────────────────────────────
			"John A. Macdonald":
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: John A. Macdonald"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: John A. Macdonald"] = (1 * buildingLevel)
			"George-Étienne Cartier":
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: George-Étienne Cartier"] = (1 * buildingLevel)
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: George-Étienne Cartier"] = (1 * buildingLevel)
			"Wilfrid Laurier":
				if bType == "Market":
					dollarsPerLevel += 1
					dollarsDic["Icon: Wilfrid Laurier"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: Wilfrid Laurier"] = (1 * buildingLevel)
			"Agnes Macphail":
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Agnes Macphail"] = (1 * buildingLevel)
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Agnes Macphail"] = (1 * buildingLevel)
			"Laura Secord":
				if bType == "Barracks":
					manpowerPerLevel += 50
					weaponsPerLevel += 1
					manpowerDic["Icon: Laura Secord"] = (50 * buildingLevel)
					weaponsDic["Icon: Laura Secord"] = (1 * buildingLevel)
			"Louis-Hippolyte LaFontaine":
				pass  # handled in _apply_abnormal_modifiers (flat Ottawa/Montreal courthouse bonus)
			"Tommy Douglas":
				if bType == "Resort":
					happinessPerLevel += 1
					happinessDic["Icon: Tommy Douglas"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: Tommy Douglas"] = (1 * buildingLevel)
			"Viola Desmond":
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Viola Desmond"] = (1 * buildingLevel)
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Viola Desmond"] = (1 * buildingLevel)
			"Lester B. Pearson":
				if bType == "Monument":
					culturePerLevel += 1
					mandatePerLevel += 1
					cultureDic["Icon: Lester B. Pearson"] = (1 * buildingLevel)
					mandateDic["Icon: Lester B. Pearson"] = (1 * buildingLevel)
			"Louis Riel":
				if bType == "Camp":
					woodPerLevel += 1
					woodDic["Icon: Louis Riel"] = (1 * buildingLevel)
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Icon: Louis Riel"] = (1 * buildingLevel)
			"Emily Murphy":
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Emily Murphy"] = (1 * buildingLevel)
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Emily Murphy"] = (1 * buildingLevel)
			"Nellie McClung":
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Icon: Nellie McClung"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: Nellie McClung"] = (1 * buildingLevel)
			"Terry Fox":
				if bType == "Barracks":
					manpowerPerLevel += 50
					manpowerDic["Icon: Terry Fox"] = (50 * buildingLevel)
				if bType == "Resort":
					happinessPerLevel += 1
					happinessDic["Icon: Terry Fox"] = (1 * buildingLevel)
			"Chief Dan George":
				if bType == "Camp":
					woodPerLevel += 1
					woodDic["Icon: Chief Dan George"] = (1 * buildingLevel)
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Chief Dan George"] = (1 * buildingLevel)
			"Buffy Sainte-Marie":
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Buffy Sainte-Marie"] = (1 * buildingLevel)
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: Buffy Sainte-Marie"] = (1 * buildingLevel)
			"David Suzuki":
				if bType == "Camp":
					woodPerLevel += 1
					woodDic["Icon: David Suzuki"] = (1 * buildingLevel)
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Icon: David Suzuki"] = (1 * buildingLevel)
			"Roméo Dallaire":
				if bType == "Barracks":
					manpowerPerLevel += 50
					weaponsPerLevel += 1
					manpowerDic["Icon: Roméo Dallaire"] = (50 * buildingLevel)
					weaponsDic["Icon: Roméo Dallaire"] = (1 * buildingLevel)
			"Thérèse Casgrain":
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Thérèse Casgrain"] = (1 * buildingLevel)
				if bType == "Library":
					culturePerLevel += 1
					cultureDic["Icon: Thérèse Casgrain"] = (1 * buildingLevel)
			"Mary Two-Axe Earley":
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Mary Two-Axe Earley"] = (1 * buildingLevel)
				if bType == "Farm":
					foodPerLevel += 1
					foodDic["Icon: Mary Two-Axe Earley"] = (1 * buildingLevel)
			"Pierre Elliott Trudeau":
				if bType == "Monument":
					culturePerLevel += 1
					cultureDic["Icon: Pierre Elliott Trudeau"] = (1 * buildingLevel)
				if bType == "Courthouse":
					mandatePerLevel += 1
					mandateDic["Icon: Pierre Elliott Trudeau"] = (1 * buildingLevel)

func calculateOutputs(playerCountryNode):
	foodPerLevel = 0
	woodPerLevel = 0
	dollarsPerLevel = 0
	metalPerLevel = 0
	magicPerLevel = 0
	weaponsPerLevel = 0
	culturePerLevel = 0    # covers both Culture and old Faith
	sciencePerLevel = 0
	mandatePerLevel = 0
	happinessPerLevel = 0  # renamed from harmonyPerLevel
	influencePerLevel = 0
	manpowerPerLevel = 0
	defensivenessPerLevel = 0
	corruptionLossPerLevel = 0

	foodCostPerLevel = 0
	woodCostPerLevel = 0
	dollarsCostPerLevel = 0
	metalCostPerLevel = 0
	magicCostPerLevel = 0
	cultureCostPerLevel = 0
	scienceCostPerLevel = 0
	weaponsCostPerLevel = 0
	mandateCostPerLevel = 0
	happinessCostPerLevel = 0
	influenceCostPerLevel = 0
	manpowerCostPerLevel = 0
	corruptionGainPerLevel = 0
	buildBuilding()
	matchPlayerUnlockables(playerCountryNode)
	totalBuildingDollars = 0
	totalBuildingFood = 0
	totalBuildingWood = 0
	totalBuildingMetal = 0
	totalBuildingWeapons = 0
	totalBuildingScience = 0
	totalBuildingCulture = 0   # covers both Culture and old Faith
	totalBuildingMagic = 0
	totalBuildingManpower = 0
	totalBuildingInfluence = 0
	totalBuildingHappiness = 0 # renamed from totalBuildingHarmony
	totalBuildingDefensiveness = 0
	corruptionChange = 0
	if dollarsPerLevel != 0 or dollarsCostPerLevel != 0:
		totalBuildingDollars = (dollarsPerLevel - dollarsCostPerLevel)
		totalBuildingDollars *= buildingLevel
	if foodPerLevel != 0 or foodCostPerLevel != 0:
		totalBuildingFood = (foodPerLevel - foodCostPerLevel)
		totalBuildingFood *= buildingLevel
	if woodPerLevel != 0 or woodCostPerLevel != 0:
		totalBuildingWood = (woodPerLevel - woodCostPerLevel)
		totalBuildingWood *= buildingLevel
	if metalPerLevel != 0 or metalCostPerLevel != 0:
		totalBuildingMetal = (metalPerLevel - metalCostPerLevel)
		totalBuildingMetal *= buildingLevel
	if weaponsPerLevel != 0 or weaponsCostPerLevel != 0:
		totalBuildingWeapons = (weaponsPerLevel - weaponsCostPerLevel)
		totalBuildingWeapons *= buildingLevel
	if sciencePerLevel != 0 or scienceCostPerLevel != 0:
		totalBuildingScience = (sciencePerLevel - scienceCostPerLevel)
		totalBuildingScience *= buildingLevel
	if culturePerLevel != 0 or cultureCostPerLevel != 0:
		totalBuildingCulture = (culturePerLevel - cultureCostPerLevel)
		totalBuildingCulture *= buildingLevel
	if magicPerLevel != 0 or magicCostPerLevel != 0:
		totalBuildingMagic = (magicPerLevel - magicCostPerLevel)
		totalBuildingMagic *= buildingLevel
	if mandatePerLevel != 0 or mandateCostPerLevel != 0:
		totalBuildingMandate = (mandatePerLevel - mandateCostPerLevel)
		totalBuildingMandate *= buildingLevel
		if totalBuildingMandate < 0 and is_instance_valid(playerCountry):
			for law in playerCountry.lawsInConstitution:
				if law.lawType == "Canadian Citizenship Act":
					totalBuildingMandate = int(float(totalBuildingMandate) * 0.9)
					break
	if happinessPerLevel != 0 or happinessCostPerLevel != 0:
		totalBuildingHappiness = (happinessPerLevel - happinessCostPerLevel)
		totalBuildingHappiness *= buildingLevel
	if manpowerPerLevel != 0 or manpowerCostPerLevel != 0:
		totalBuildingManpower = (manpowerPerLevel - manpowerCostPerLevel)
		totalBuildingManpower *= buildingLevel
	if influencePerLevel != 0 or influenceCostPerLevel != 0:
		totalBuildingInfluence = (influencePerLevel - influenceCostPerLevel)
		totalBuildingInfluence *= buildingLevel
	if defensivenessPerLevel != 0:
		totalBuildingDefensiveness = defensivenessPerLevel * buildingLevel
	if corruptionLossPerLevel != 0 or corruptionGainPerLevel != 0:
		corruptionChange = corruptionGainPerLevel - corruptionLossPerLevel
	_apply_abnormal_modifiers()
	#print("totalBuildingMagic", totalBuildingMagic)

func _apply_abnormal_modifiers() -> void:
	# Flat bonuses that don't follow the standard PerLevel × buildingLevel model.
	# Country check (CA / USA) always comes first; icon/doctrine checks follow.
	if not is_instance_valid(playerCountry):
		return

	# ── Canada ───────────────────────────────────────────────────────────────
	if playerCountry.CID == "CA":
		for belief in religiousBeliefs:
			if belief.beliefType == "Louis-Hippolyte LaFontaine":
				# Courthouse in Ottawa or Montreal only — flat +1 all resources, +50 manpower
				if buildingType == "Courthouse" and \
						(tile.tileName == "Ottawa" or tile.tileName == "Montreal"):
					totalBuildingDollars  += 3
					totalBuildingFood     += 3
					totalBuildingWood     += 3
					totalBuildingWeapons  += 3
					totalBuildingMandate  += 3
					totalBuildingCulture  += 3
					totalBuildingManpower += 150
					dollarsDic["Icon: Louis-Hippolyte LaFontaine"]  = 3
					foodDic["Icon: Louis-Hippolyte LaFontaine"]     = 3
					woodDic["Icon: Louis-Hippolyte LaFontaine"]     = 3
					weaponsDic["Icon: Louis-Hippolyte LaFontaine"]  = 3
					mandateDic["Icon: Louis-Hippolyte LaFontaine"]  = 3
					cultureDic["Icon: Louis-Hippolyte LaFontaine"]  = 3
					manpowerDic["Icon: Louis-Hippolyte LaFontaine"] = 150
				break

		for belief in religiousBeliefs:
			if belief.beliefType == "Agnes Macphail":
				# All buildings except Dock and Barracks: redirect labour to knowledge
				# -10 manpower flat; culture or science depending on building type
				if buildingType != "Dock" and buildingType != "Barracks" and buildingType != "Fortress":
					totalBuildingManpower -= 10
					manpowerDic["Icon: Agnes Macphail"] = -10
					if buildingType in ["Farm", "Camp", "Mine", "Forge", "Granary"]:
						totalBuildingCulture += 1
						cultureDic["Icon: Agnes Macphail"] = 1
					elif buildingType in ["Library", "Monument", "Courthouse", "Market", "Resort"]:
						totalBuildingScience += 1
						scienceDic["Icon: Agnes Macphail"] = 1
				break

	# ── USA ──────────────────────────────────────────────────────────────────
	# (reserved for future USA abnormal icon/doctrine checks)


func upgradeBuilding():
	buildingLevel += 1
	print("upgrade successful", buildingType, buildingLevel)

func downgradeBuilding():
	buildingLevel -= 1
