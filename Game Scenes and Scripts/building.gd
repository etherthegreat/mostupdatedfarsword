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
var tileSpell: spell # the spell affecting this tile 
var religiousBeliefs: Array = [] #used to determine religious beliefs in calculations
var traditionsList: Array = [] #used to determine cultural traditions in calculations
var Governor: governor
var faithChurchLevel: int
#Resources
#each month, this building produces this amount of resources
var foodPerLevel: int = 0
var goldPerLevel: int = 0
var woodPerLevel: int = 0
var magicPerLevel: int = 0
var faithPerLevel: int = 0
var weaponsPerLevel: int = 0
var metalPerLevel: int = 0
var sciencePerLevel: int = 0
var culturePerLevel: int = 0
var mandatePerLevel: int = 0
var harmonyPerLevel: int = 0
var manpowerPerLevel: int = 0
var influencePerLevel: int = 0
var corruptionLossPerLevel: int = 0
#each month this building costs this amount of resources
var foodCostPerLevel: int = 0
var goldCostPerLevel: int = 0
var woodCostPerLevel: int = 0
var magicCostPerLevel: int = 0
var faithCostPerLevel: int = 0
var weaponsCostPerLevel: int = 0
var metalCostPerLevel: int = 0
var scienceCostPerLevel: int = 0
var cultureCostPerLevel: int = 0
var mandateCostPerLevel: int = 0
var harmonyCostPerLevel: int = 0
var manpowerCostPerLevel: int = 0
var influenceCostPerLevel: int = 0
var corruptionGainPerLevel: int = 0

#the balance of resourcePerLevel - resourceCostPerLevel
var totalBuildingFood: int = 0
var totalBuildingGold: int = 0
var totalBuildingWood: int = 0
var totalBuildingMagic: int = 0
var totalBuildingFaith: int = 0
var totalBuildingWeapons: int = 0
var totalBuildingScience: int = 0
var totalBuildingCulture: int = 0
var totalBuildingMetal: int = 0
var totalBuildingMandate: int = 0
var totalBuildingInfluence: int = 0
var totalBuildingManpower: int = 0
var totalBuildingHarmony: int = 0
var totalBuildingDefensiveness: int  = 0#how much defensiveness this building gives the province
var corruptionChange: int #corruption difference
#storage capacity buildings - used to increase max national storage capacity of resource
var foodStorageIncrease: int #granaries
var woodStorageIncrease: int #warehouse
var goldStorageIncrease: int #banks
var magicStorageIncrease: int #towers
var faithStorageIncrease: int #temple
var weaponsStorageIncrease: int #barracks
var scienceStorageIncrease: int #libraries
var cultureStorageIncrease: int #monuments
var metalStorageIncrease: int #warehouse

var magicOutput: String

signal towerBuilding
func buildBuilding():
	match buildingType:
		"Farm":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/resources/Farm.png")
			foodPerLevel = 1
		"Granary":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/resources/Granary.png") 
			#foodStorageIncrease += 1 #every 1 increase will be calculated as +100 storage on the national level.
			goldCostPerLevel += 1
		"Temple":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/temple.png")
			foodCostPerLevel +=2
			woodCostPerLevel +=1
		"Mine":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/mine.png")
			foodCostPerLevel +=1
			woodCostPerLevel +=1
			metalPerLevel += 1
		"Camp":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/camp.png")
			foodCostPerLevel +=1
			woodPerLevel +=1
		"Tower":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/tower.png")
			magicPerLevel += 4
			foodCostPerLevel += 2
			metalCostPerLevel += 2
			woodCostPerLevel += 2
			goldCostPerLevel += 2
			emit_signal("towerBuilding")
			print("building type in", tile.tileName)
		"Library":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/library.png")
			goldCostPerLevel += 1
			woodCostPerLevel += 1
			foodCostPerLevel += 1
			sciencePerLevel += 2
		"Workshop":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/Workshop.png")
			goldPerLevel += 1
			metalCostPerLevel += 1
			foodCostPerLevel += 1
			woodCostPerLevel += 1
		"Bath":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/Bath.png")
			corruptionLossPerLevel -= 1
			foodCostPerLevel += 3
			goldCostPerLevel += 1
		"Faire":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/Faire.png")
			culturePerLevel +=1
			foodCostPerLevel +=1
			woodCostPerLevel +=1
			goldCostPerLevel += 1
		"Forge":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/forge.png")
			weaponsPerLevel += 1
			metalPerLevel += 1
			woodPerLevel += 1
			goldPerLevel += 1
			foodPerLevel += 1
		"Barracks":
			buildingSprite = load("res://art assets/Placeholder Art/UI Art/resources/Farm.png")
			manpowerPerLevel += 15
			goldCostPerLevel += 2
	pass

func matchPlayerUnlockables(playerCountryNode):
	playerCountry = playerCountryNode
	if buildingType == "Farm":
		cropSlot = tile.cropSlot
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Agriculture":
				foodPerLevel += 1
			if Technology.techName == "Irrigation":
				foodPerLevel += 1
			if Technology.techName == "Calendar":
				foodPerLevel += 1
			if Technology.techName == "Engineering":
				foodPerLevel += 1
		for law in playerCountry.unlockedLaws:
			if law.lawType == "Rural Education Initiative":
				sciencePerLevel += 1
				goldCostPerLevel +=1
			if law.lawType == "Mercantilism":
				goldPerLevel +=1
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "BREWER":
				goldPerLevel += 2
			if Governor.governorType == "FARMER":
				foodPerLevel += (2 * Governor.governorLevel)
				mandateCostPerLevel += (1 * Governor.governorLevel)
			if Governor.governorType == "RECRUITER":
				manpowerPerLevel += (200 * Governor.governorLevel)
				mandateCostPerLevel += (1 * Governor.governorLevel)
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Humble Folk":
				faithPerLevel += 1
			if tradition.traditionType == "Peasant Militias":
				manpowerPerLevel += 250
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Plentify":
				foodPerLevel +=1
				woodPerLevel +=1
				magicCostPerLevel += 4
			if tileSpell.spellType == "Gentle Rains":
				foodPerLevel += 2
				magicCostPerLevel += 5
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "Gentle Shepherds":
				foodPerLevel += 1
			if belief.beliefType == "SARATIAN":
				culturePerLevel += 1
		if cropSlot != null:
			if cropSlot.cropType == "Bananas":
				foodPerLevel += 1
				magicPerLevel += 1
			if cropSlot.cropType == "Razorberry":
				goldPerLevel += 5
				faithCostPerLevel +=2
				foodCostPerLevel +=1
			if cropSlot.cropType == "Mushrooms":
				magicPerLevel +=1
				sciencePerLevel +=1
			if cropSlot.cropType == "Spices":
				goldPerLevel += 1
				culturePerLevel += 1
			if cropSlot.cropType == "Wheat":
				foodPerLevel += 2
			if cropSlot.cropType == "Seaweed":
				foodPerLevel += 1
				culturePerLevel += 1
			if cropSlot.cropType == "Copperflower":
				metalPerLevel +=1
				sciencePerLevel +=1 
			if cropSlot.cropType == "Incense":
				faithPerLevel +=2
			if cropSlot.cropType == "Cannabis":
				culturePerLevel +=2
			if cropSlot.cropType == "Wereroot":
				woodPerLevel +=1
				faithPerLevel +=1
			if cropSlot.cropType == "Bamboo":
				woodPerLevel +=2
			if cropSlot.cropType == "Cloudbean":
				magicPerLevel +=2
			if cropSlot.cropType == "Papyrus":
				sciencePerLevel +=2
			if cropSlot.cropType == "Cotton":
				goldPerLevel +=2
		else:
			print("error, no crop in", tile.tileNumber)
	if buildingType == "Granary":
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Calendar":
				foodPerLevel += 1
				goldCostPerLevel += 1
			if Technology.techName == "Engineering":
				foodPerLevel += 1
				goldCostPerLevel += 1
		if playerCountry.mandateFromGranaries == true:
			mandatePerLevel += 1
			for Technology in playerCountry.unlockedTechnologies:
				if Technology.techName == "Statecraft":
					mandatePerLevel += 1
			for tradition in playerCountry.unlockedTraditions:
				if tradition.traditionType == "Meticulous Organizers":
					mandatePerLevel += 1
			for belief in playerCountry.selectedBeliefs:
				if belief.beliefType == "FA ENEPO":
					mandatePerLevel += 1
			if tile.tileGovernor != null:
				if tile.tileGovernor.governorType == "Administrator":
					mandatePerLevel += 1
			if tile.tileSpell != null:
				if tile.tileSpell.spellType == "Celebration":
					mandatePerLevel += 1
					magicCostPerLevel += 4
	pass
	if buildingType == "Mine":
		oreSlot = tile.oreSlot
		if oreSlot != null:
			if oreSlot.oreType == "Copper":
				metalPerLevel +=2
				goldPerLevel +=1
			if oreSlot.oreType == "Iron":
				metalPerLevel +=3
			if oreSlot.oreType == "Marble":
				goldPerLevel +=1
				culturePerLevel +=2
			if oreSlot.oreType == "Gold":
				goldPerLevel +=2
				mandatePerLevel +=1
			if oreSlot.oreType == "Jewels":
				mandatePerLevel +=1
				goldPerLevel +=1
				faithPerLevel +=1
			if oreSlot.oreType == "Floodstone":
				metalPerLevel +=1
				magicPerLevel +=2
			if oreSlot.oreType == "Ivoroid":
				faithPerLevel +=2
				magicPerLevel +=1
			if oreSlot.oreType == "Moonbone":
				metalPerLevel +=1
				harmonyPerLevel +=1
				culturePerLevel +=1
			if oreSlot.oreType == "Zylfire":
				foodPerLevel +=2
				metalPerLevel +=1
		else:
			print("error, no ore in", tile.tileNumber)
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Steam Engine":
				metalPerLevel += 3
				magicCostPerLevel += 1
				woodCostPerLevel += 1
				foodCostPerLevel += 1
		for law in playerCountry.unlockedLaws:
			if law.lawType == "Free Land Prospecting":
				goldPerLevel += 1
			if law.lawType == "State-Operated Mines":
				goldCostPerLevel +=1
				harmonyCostPerLevel +=1
				metalPerLevel += 2
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "MINER":
				metalPerLevel +=2
			if Governor.governorType == "BUILDER":
				woodPerLevel += 1
				metalPerLevel += 1
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Home Underground":
				culturePerLevel += 1
			if tradition.traditionType == "Dungeon Gourmet":
				foodPerLevel +=1
			if tradition.traditionType == "Valued Expertise":
				influencePerLevel +=1
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Nightvision":
				metalPerLevel += 1
				magicCostPerLevel += 3
			if tileSpell.spellType == "Divining Rods":
				metalPerLevel +=1
				goldPerLevel +=2
				magicCostPerLevel += 6
			if tileSpell.spellType == "Replenishment":
				metalPerLevel += 4
				magicCostPerLevel += 12
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "BIBWEY":
				metalPerLevel += 1
			if belief.beliefType == "Precious Metals":
				faithPerLevel += 1
	if buildingType == "Temple":
		faithChurchLevel = playerCountry.churchLevel
		if faithChurchLevel == 0:
			faithPerLevel += 1
			goldPerLevel +=1
			mandatePerLevel +=1
			harmonyPerLevel +=1
		elif faithChurchLevel == 1:
			faithPerLevel += 1
			goldPerLevel +=1
			mandatePerLevel +=1
		elif faithChurchLevel == 2:
			goldPerLevel +=1
			mandatePerLevel +=1
		elif faithChurchLevel == 3:
			goldPerLevel +=1
		elif faithChurchLevel == -1:
			faithPerLevel += 1
			goldPerLevel +=1
			harmonyPerLevel +=1
		elif faithChurchLevel == -2:
			faithPerLevel += 1
			harmonyPerLevel +=1
		elif faithChurchLevel == -3:
			faithPerLevel += 1
		else:
			print("error, no faith / church level found in player country Node")
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Architecture":
				woodCostPerLevel +=1
				metalCostPerLevel +=1
				cultureCostPerLevel +=2
		for law in playerCountry.unlockedLaws:
			if law.lawType == "Pacifist Sanctuaries":
				harmonyPerLevel +=1
			if law.lawType == "Clerical Administration":
				faithPerLevel +=1
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "NUN":
				faithPerLevel += (1 * Governor.governorLevel)
				influencePerLevel += (1 * Governor.governorLevel)
			if Governor.governorType == "BISHOP":
				faithPerLevel += (1 * Governor.governorLevel)
				mandatePerLevel += (1 * Governor.governorLevel)
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Studious Monks":
				sciencePerLevel += 1
			if tradition.traditionType == "Quiet Gardens":
				faithPerLevel +=1
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Foresight":
				mandatePerLevel += 2
				magicCostPerLevel += 6
			if tileSpell.spellType == "Omniscient Direction":
				faithPerLevel += 2
				mandatePerLevel += 5
				magicCostPerLevel += 15
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "Religious Arts":
				culturePerLevel += 1
			if belief.beliefType == "Protected Pilgrims":
				influencePerLevel += 1
			if belief.beliefType == "VIBIAN KARIK":
				foodPerLevel += 2
				goldCostPerLevel += 1
		cropSlot = tile.cropSlot
		if cropSlot.cropType == "Incense":
			faithPerLevel += 1
	if buildingType == "Camp":
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "TYLA DYN":
				foodPerLevel += 1
			if belief.beliefType == "Tree of Life":
				harmonyPerLevel += 1
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Bronze Working":
				woodPerLevel +=2
				metalCostPerLevel +=1
			if Technology.techName == "Iron Working":
				woodPerLevel +=2
				metalCostPerLevel +=1
		for law in playerCountry.unlockedLaws:
			if law.lawType == "Universal Land Rights":
				harmonyPerLevel +=1
			if law.lawType == "Land Conservation":
				culturePerLevel +=1
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "FORESTER":
				woodPerLevel += (2 * Governor.governorLevel)
			if Governor.governorType == "ADMIRAL":
				woodPerLevel += 1
				manpowerPerLevel += (200 * Governor.governorLevel)
			if Governor.governorType == "ARTISAN":
				culturePerLevel += (1 * Governor.governorLevel)
				influencePerLevel += (1 * Governor.governorLevel)
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Hunting Parties":
				foodPerLevel += (1 * Governor.governorLevel)
				manpowerPerLevel += (50 * Governor.governorLevel)
			if tradition.traditionType == "Forest Wardens":
				mandatePerLevel +=1
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Ent Tongue":
				woodPerLevel +=1
				culturePerLevel += 1
				magicCostPerLevel += 4
			if tileSpell.spellType == "Hunter's Mark":
				foodPerLevel += 1
				magicCostPerLevel += 2
	if buildingType == "Tower":
		if tile.tileWizard != null:
			wizardSlot = tile.tileWizard
			if wizardSlot.wizardType == "DRUID":
				woodPerLevel += 3
			elif wizardSlot.wizardType == "ALCHEMIST":
				goldPerLevel += 3
			elif wizardSlot.wizardType == "ELEMENTALST":
				foodPerLevel += 3
			elif wizardSlot.wizardType == "SUMMONER":
				metalPerLevel += 2
			elif wizardSlot.wizardType == "SEER":
				faithPerLevel += 3
			elif wizardSlot.wizardType == "PSIONICIST":
				foodPerLevel += 1
				woodPerLevel += 1
				goldPerLevel += 1
				metalPerLevel += 1
			else:
				print("no assigned wizard to tile:", tile.tileNumber)
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "ORIL-RA":
				magicPerLevel += 2
			if belief.beliefType == "VANODAM":
				faithPerLevel += 1
				magicPerLevel += 1
			if belief.beliefType == "Wandering Exorcists":
				manpowerPerLevel == 250
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Lenscraft":
				magicPerLevel += 1
				sciencePerLevel += 1
				metalCostPerLevel +=1
		for law in playerCountry.unlockedLaws:
			if law.lawType == "Freedom of Movement":
				harmonyPerLevel +=2
			if law.lawType == "Record Keeping Act":
				culturePerLevel +=1
				sciencePerLevel +=1
			if law.lawType == "Apprenticeship Programs":
				magicPerLevel += 2
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "ASTROLOGER":
				sciencePerLevel += (1 * Governor.governorLevel)
				magicPerLevel += (1 * Governor.governorLevel)
			if Governor.governorType == "MYSTIC":
				culturePerLevel += (1 *Governor.governorLevel)
				faithPerLevel += (1* Governor.governorLevel)
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Cosmic Inspiration":
				sciencePerLevel += 1
			if tradition.traditionType == "Ancient Wizdom":
				influencePerLevel +=1
			if tradition.traditionType == "Natural Order":
				mandatePerLevel +=1
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Extradimensional Servants":
				woodPerLevel +=1
				foodPerLevel += 1
				goldPerLevel += 1
				metalPerLevel += 1
				magicCostPerLevel += 4
			if tileSpell.spellType == "Clear Skies":
				sciencePerLevel += 1
				faithPerLevel += 1
				magicCostPerLevel += 5
			if tileSpell.spellType == "Peace":
				harmonyPerLevel += 1
				influencePerLevel += 1
				magicCostPerLevel += 5
		cropSlot = tile.cropSlot
		if cropSlot.cropType == "Cannabis":
			culturePerLevel +=1
			magicCostPerLevel += 1
		if cropSlot.cropType == "Cloudbean":
			magicPerLevel +=1
		oreSlot = tile.oreSlot
		if oreSlot.oreType == "Floodstone":
			magicPerLevel +=1
		pass
	if buildingType == "Library":
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "DILNITH-AMEN":
				sciencePerLevel += 2
			if belief.beliefType == "Divine Spark":
				sciencePerLevel += 1
			if belief.beliefType == "Church Records":
				faithPerLevel += 1
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Statecraft":
				sciencePerLevel += 1
				mandatePerLevel += 1
				goldCostPerLevel += 1
			if Technology.techName == "Paper":
				sciencePerLevel += 1
				woodPerLevel += 1
			if Technology.techName == "Alphabet":
				sciencePerLevel += 1
		for law in playerCountry.unlockedLaws:
			if law.lawType == "Standardized Measurements":
				sciencePerLevel += 1
			if law.lawType == "Philosopher Kings":
				influencePerLevel += 1
			if law.lawType == "Freedom of the Press":
				harmonyPerLevel += 1
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "SCHOLAR":
				sciencePerLevel += (2 * Governor.governorLevel)
			if Governor.governorType == "INVENTOR":
				sciencePerLevel += (1 * Governor.governorLevel)
				goldPerLevel += (1 * Governor.governorLevel)
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Free Thinkers":
				sciencePerLevel += 1
			if tradition.traditionType == "Renaissance Men":
				culturePerLevel +=1
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Potion: Focusing Dust":
				sciencePerLevel +=1
				magicCostPerLevel += 2
			if tileSpell.spellType == "Inspiration":
				sciencePerLevel += 3
				culturePerLevel += 1
				magicCostPerLevel += 8
			if tileSpell.spellType == "Hive Mind":
				harmonyPerLevel += 1
				sciencePerLevel += 2
				magicCostPerLevel += 6
		cropSlot = tile.cropSlot
		if cropSlot.cropType == "Papyrus":
			sciencePerLevel +=1
			woodPerLevel += 1
	if buildingType == "Workshop":
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "Valued Idolatry":
				faithPerLevel += 1
				mandatePerLevel += 1
				metalCostPerLevel += 2
			if belief.beliefType == "TYRUS":
				goldPerLevel += 2
				metalCostPerLevel += 1
			if belief.beliefType == "Busy Hands":
				faithPerLevel += 2
				woodCostPerLevel += 1
				foodCostPerLevel += 1
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Banking":
				goldPerLevel += 2
			if Technology.techName == "Craftsmenship":
				goldPerLevel += 2
				woodCostPerLevel += 2
			if Technology.techName == "Metal Casting":
				metalCostPerLevel += 1
				goldPerLevel += 2
		for law in playerCountry.unlockedLaws:
			if law.lawType == "Labor Contracts":
				goldPerLevel += 2
				foodCostPerLevel += 2
			if law.lawType == "Protected Supply Chain":
				foodCostPerLevel += 1
				metalCostPerLevel += 1
				goldPerLevel += 2
			if law.lawType == "Military Engineers":
				manpowerPerLevel += 300
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "MINTER":
				goldPerLevel += (2 * Governor.governorLevel)
			if Governor.governorType == "BUILDER":
				metalPerLevel += 1
				woodPerLevel += 1
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Artist Enclaves":
				culturePerLevel += 1
			if tradition.traditionType == "Guild Education":
				sciencePerLevel +=1
			if tradition.traditionType == "Meritocracy":
				mandatePerLevel += 1
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Potion: Stamina":
				goldPerLevel += 2
				metalCostPerLevel += 1
				woodCostPerLevel += 1
				magicCostPerLevel += 2
			if tileSpell.spellType == "Duplication":
				goldPerLevel += 4
				harmonyCostPerLevel += 1
				magicCostPerLevel += 7
	if buildingType == "Bath":
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "Healing Waters":
				faithPerLevel += 1
				corruptionLossPerLevel -= 1
			if belief.beliefType == "JERRIWIX":
				corruptionLossPerLevel -= 1
				mandatePerLevel += 1
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Engineering":
				goldPerLevel += 1
				corruptionLossPerLevel -= 1
		for law in playerCountry.unlockedLaws:
			if law.lawType == "Pollution Control":
				corruptionLossPerLevel -= 1
				foodPerLevel += 1
			if law.lawType == "Mandatory Hygiene":
				culturePerLevel += 1
				corruptionLossPerLevel -= 1
			if law.lawType == "Freedom of Speech":
				influencePerLevel +=1
				mandatePerLevel += 1
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "MASSEUSE":
				magicPerLevel += 1
				corruptionLossPerLevel -= 1
			if Governor.governorType == "SPY":
				influencePerLevel += 1
				corruptionLossPerLevel -= 1
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Communal Bathing":
				mandatePerLevel += 1
			if tradition.traditionType == "Beautiful Spaces":
				culturePerLevel += 1
			if tradition.traditionType == "Soaps, Lotions, Perfumes":
				harmonyPerLevel += 1
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Geothermic Well":
				goldPerLevel += 3
				culturePerLevel += 2
				magicCostPerLevel += 10
			if tileSpell.spellType == "Vitamins and Minerals":
				#-1 corruption in this tile per level
				sciencePerLevel += 1
				faithPerLevel += 1
				magicCostPerLevel += 6
		print("corruption change from bath ", corruptionLossPerLevel)
	if buildingType == "Faire":
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "Holiday Feasts":
				faithPerLevel += 1
				culturePerLevel += 1
				foodCostPerLevel += 2
			if belief.beliefType == "BENAXTARA":
				mandatePerLevel += 2
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Architecture":
				culturePerLevel += 2
				woodPerLevel += 2
		for law in playerCountry.unlockedLaws:
			if law.lawType == "National Exhibitions":
				influencePerLevel += 1
			if law.lawType == "Freedom of Expression":
				culturePerLevel += 1
			if law.lawType == "Sanctified Sports":
				manpowerPerLevel += 250
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "TAMER":
				# corruption in this tile -= (1 * Governor.governorLevel)
				culturePerLevel += (1 * Governor.governorLevel)
			if Governor.governorType == "EXPLORER":
				manpowerPerLevel += (250 * Governor.governorLevel)
				culturePerLevel += (1 * Governor.governorLevel)
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Gastronomic Studies":
				culturePerLevel += 1
			if tradition.traditionType == "Art Trade":
				goldPerLevel += 1
			if tradition.traditionType == "Bread and Circuses":
				foodPerLevel += 1
				pass
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Celebration":
				goldPerLevel += 1
				culturePerLevel += 1
				foodPerLevel += 1
				magicCostPerLevel += 6
			if tileSpell.spellType == "Fireworks":
				harmonyPerLevel += 3
				magicCostPerLevel +=7
	if buildingType == "Forge":
		for belief in playerCountry.selectedBeliefs:
			if belief.beliefType == "Sacred Bladecraft":
				faithPerLevel += 1
				weaponsPerLevel += 1
				metalCostPerLevel += 1
			if belief.beliefType == "QALIN LING":
				weaponsPerLevel += 2
				metalCostPerLevel += 2
		for Technology in playerCountry.unlockedTechnologies:
			if Technology.techName == "Iron Working":
				weaponsPerLevel += 2
				metalCostPerLevel += 1
				woodCostPerLevel += 1
				goldCostPerLevel += 1
				#corruption in this tile +1
			if Technology.techName == "Tempuring":
				weaponsPerLevel += 2
				metalCostPerLevel += 1
				goldCostPerLevel += 1
				#corruption in this tile +1
		for law in playerCountry.unlockedLaws:
			if law.lawType == "Bulk Orders":
				weaponsPerLevel += 2
				goldCostPerLevel += 1
				metalCostPerLevel += 1
				#corruption in this tile +1
			if law.lawType == "Licensed Swordsmen":
				weaponsPerLevel += 1
				#corruption in this tile +1
				harmonyPerLevel += 1
				metalCostPerLevel += 1
			if law.lawType == "Recycling Centers":
				metalPerLevel += 1
				goldPerLevel += 1
		if tile.tileGovernor != null:
			Governor = tile.tileGovernor
			if Governor.governorType == "BLACKSMITH":
				weaponsPerLevel += (2 * Governor.governorLevel)
				#corruption in this tile +(2 * Governor.governorLevel)
				metalCostPerLevel += (2 * Governor.governorLevel)
			if Governor.governorType == "BLADEMASTER":
				manpowerPerLevel += (250 * Governor.governoLevel)
				weaponsPerLevel += (1 * Governor.governorLevel)
				#corruption in this tile +(1 * Governor.governorLevel)
				metalCostPerLevel += (1 * Governor.governorLevel)
		for tradition in playerCountry.unlockedTraditions:
			if tradition.traditionType == "Steady Hands":
				weaponsPerLevel += 1
				#corruption in this tile +1
			if tradition.traditionType == "Battlesmiths":
				manpowerPerLevel += 250
			if tradition.traditionType == "Intricate Designs":
				culturePerLevel += 1
				pass
		if tile.tileSpell != null:
			tileSpell = tile.tileSpell
			if tileSpell.spellType == "Heart of the Forge":
				foodPerLevel += 1
				culturePerLevel += 1
				faithPerLevel += 1
				harmonyPerLevel += 1
				magicCostPerLevel += 8
			if tileSpell.spellType == "Resist Heat":
				weaponsPerLevel += 3
				#corruption in this tile +3
				metalCostPerLevel += 3
				magicCostPerLevel += 9
	#add Barracks Unlockables
	pass


func calculateOutputs(playerCountryNode):
	foodPerLevel = 0
	woodPerLevel = 0
	goldPerLevel = 0
	metalPerLevel = 0
	magicPerLevel = 0
	weaponsPerLevel = 0
	faithPerLevel = 0
	sciencePerLevel = 0
	culturePerLevel = 0
	mandatePerLevel = 0
	harmonyPerLevel = 0
	influencePerLevel = 0
	manpowerPerLevel = 0
	corruptionLossPerLevel = 0
	
	foodCostPerLevel = 0
	woodCostPerLevel = 0
	goldCostPerLevel = 0
	metalCostPerLevel = 0
	magicCostPerLevel = 0
	faithCostPerLevel = 0
	scienceCostPerLevel =0
	weaponsCostPerLevel = 0
	cultureCostPerLevel = 0
	mandateCostPerLevel = 0
	harmonyCostPerLevel = 0
	influenceCostPerLevel = 0
	manpowerCostPerLevel = 0
	corruptionGainPerLevel = 0
	#buildBuilding()
	matchPlayerUnlockables(playerCountryNode)
	totalBuildingGold = 0
	totalBuildingFood = 0
	totalBuildingWood = 0
	totalBuildingMetal = 0
	totalBuildingWeapons = 0
	totalBuildingScience = 0
	totalBuildingFaith = 0
	totalBuildingMagic = 0
	totalBuildingCulture = 0
	totalBuildingManpower = 0
	totalBuildingInfluence = 0
	totalBuildingHarmony = 0
	corruptionChange = 0
	if goldPerLevel != 0 or goldCostPerLevel != 0:
		totalBuildingGold = (goldPerLevel - goldCostPerLevel)
		totalBuildingGold *= buildingLevel
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
	if faithPerLevel != 0 or faithCostPerLevel != 0:
		totalBuildingFaith = (faithPerLevel - faithCostPerLevel)
		totalBuildingFaith *= buildingLevel
	if magicPerLevel != 0 or magicCostPerLevel != 0:
		totalBuildingMagic = (magicPerLevel - magicCostPerLevel)
		totalBuildingMagic *= buildingLevel
	if mandatePerLevel != 0 or mandateCostPerLevel != 0:
		totalBuildingMandate = (mandatePerLevel - mandateCostPerLevel)
		totalBuildingMandate *= buildingLevel
	if harmonyPerLevel != 0 or harmonyCostPerLevel != 0:
		totalBuildingHarmony = (harmonyPerLevel - harmonyCostPerLevel)
		totalBuildingHarmony *= buildingLevel
	if manpowerPerLevel != 0 or manpowerCostPerLevel != 0:
		totalBuildingManpower = (manpowerPerLevel - manpowerCostPerLevel)
		totalBuildingManpower *= buildingLevel
	if influencePerLevel != 0 or influenceCostPerLevel != 0:
		totalBuildingInfluence = (influencePerLevel - influenceCostPerLevel)
		totalBuildingInfluence *= buildingLevel
	if corruptionLossPerLevel != 0 or corruptionGainPerLevel != 0:
		corruptionChange = corruptionGainPerLevel - corruptionLossPerLevel
	#print("totalBuildingMagic", totalBuildingMagic)
	pass

func upgradeBuilding():
	buildingLevel += 1
	print("upgrade successful", buildingType, buildingLevel)
	pass

func downgradeBuilding():
	buildingLevel -= 1
	pass
