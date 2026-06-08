extends Node2D

var locBallUIScene = load("res://loc_ball_ui.tscn")
var gameLanguage: String
var LocBallUI

var playerCountry: String
var playerCountryNode: country
var playerOutputDict: Dictionary
var paused: bool #determines if game is paused or not
var date: int #date of the in-game world
var newGame: bool #whether or not this is a saved game or not
var loadGameFile #file, document, saved in computer
var aliveCountriesList: Array = []

var month: int #25 day months
var year: int #12 month years
var day: int #300 day years
var dayOfMonth: int #25 day months
var age: int #current age, changes when Demon King dies

var worldCreation: bool

var armyMode: bool

var playerCapitalPathButton: pathPointButton 

var mapMode: String
var displayCorruption: bool

var _republic_collapsed: bool = false
var _mission_timers: Dictionary = {}   # flag_key → turns_remaining until expiry
var _event_cooldowns: Dictionary = {}  # event_id → turns_remaining before can fire again

const CANADIAN_STATES = ["CA - QB", "CA - OT", "CA - NB", "CA - NS", "CA - PEI"]

const STATE_FULL_NAMES: Dictionary = {
	"PA": "Commonwealth of Pennsylvania",
	"NJ": "State of New Jersey",
	"NY": "State of New York",
	"MA": "Commonwealth of Massachusetts",
	"VT": "Republic of Vermont",
	"MD": "State of Maryland",
	"VA": "Commonwealth of Virginia",
	"CT": "State of Connecticut",
	"RI": "State of Rhode Island",
	"DE": "State of Delaware",
	"WV": "State of West Virginia",
	"NC": "State of North Carolina",
	"SC": "State of South Carolina",
	"GA": "State of Georgia",
	"TN": "State of Tennessee",
	"AL": "State of Alabama",
	"FL": "State of Florida",
	"NH": "State of New Hampshire",
	"ME": "District of Maine",
}

func _process(delta: float) -> void:
	if worldCreation == true:
		$CanvasLayer/LoadingSprite.rotation += 1
		return
	else:
		$"CanvasLayer/Resource Bar (TOP)/container/FoodLabel/Label".text = str(playerCountryNode.TotalFood)
		$"CanvasLayer/Resource Bar (TOP)/container/GoldLabel/Label".text = str(playerCountryNode.TotalDollars)
		$"CanvasLayer/Resource Bar (TOP)/container/WoodLabel/Label".text = str(playerCountryNode.TotalWood)
		$"CanvasLayer/Resource Bar (TOP)/container/MetalLabel/Label".text = str(playerCountryNode.TotalMetal)
		$"CanvasLayer/Resource Bar (TOP)/container/WeaponsLabel/Label".text = str(playerCountryNode.TotalWeapons)
		$"CanvasLayer/Resource Bar (TOP)/container/ScienceLabel/Label".text = str(playerCountryNode.SPM)
		$"CanvasLayer/Resource Bar (TOP)/container/FaithLabel/Label".text = str(playerCountryNode.TotalCulture)  # Faith→Culture
		$"CanvasLayer/Resource Bar (TOP)/container/MagicLabel/Label".text = str(playerCountryNode.TotalMagic)
		$"CanvasLayer/Resource Bar (TOP)/container/CultureLabel/Label".text = str(playerCountryNode.TotalCulture)
		$"CanvasLayer/Resource Bar (TOP)/container/MandateLabel/Label".text = str(playerCountryNode.TotalMandate)
		$"CanvasLayer/Resource Bar (TOP)/container/HarmonyLabel/Label".text = str(playerCountryNode.TotalHappiness)  # Harmony→Happiness
		$"CanvasLayer/Resource Bar (TOP)/container/InfluenceLabel/Label".text = str(playerCountryNode.TotalInfluence)
		$"CanvasLayer/Resource Bar (TOP)/container/ManpowerLabel/Label".text = str(playerCountryNode.TotalManpower)
		updateMap()
	if $CanvasLayer/TechTree.investmentTech == null:
		$CanvasLayer/NextTurnControl/NextTurn.visible = false
		$CanvasLayer/NextTurnControl/PickTech.visible = true
	else:
		$CanvasLayer/NextTurnControl/PickTech.visible = false
		$CanvasLayer/NextTurnControl/NextTurn.visible = true
	pass

func updateMap():
	$TileController.updateTiles(mapMode, displayCorruption, playerCountryNode)
	pass


var currentWorldTurn: int = 0

signal calculateSeason
func newGameBuild(CID, gameLang):
	currentWorldTurn = 1
	worldCreation = true
	gameLanguage = gameLang
	var locBallUIWorld = locBallUIScene.instantiate()
	locBallUIWorld.buildSelf("Game", gameLanguage)
	LocBallUI = locBallUIWorld
	add_child(locBallUIWorld)
	$CanvasLayer/LoadingLabel.text = "Building World"
	month = 6
	year = 673
	day = 126
	dayOfMonth = 1
	age = 2
	armyMode = false
	$TileController.connectTileSignals()
	$TileController.transfer.connect(calculateTileEvent)
	for Tile in $TileController.get_children():
		Tile.onNewGame()
		Tile.calculateSeason(month)
		Tile.clicked.connect(tileClicked)
		Tile.censusComplete.connect(manaUpdate)
		Tile.tileSpawnPoint = $PathControl/PathPointsControl.get_node_or_null(str(Tile.EXPTileNumber))
	$CanvasLayer/LoadingLabel.text = "Spawning Countries"
	$CanvasLayer/LoadingProgressBar.value = 25
	spawnNewGameCountries(CID)
	connectCountrySignals()
	$CanvasLayer/BuildingInfoPanel/buildingPanelPanel.player = playerCountryNode
	$CanvasLayer/LoadingLabel.text = "Prospecting for Ores"
	$CanvasLayer/LoadingProgressBar.value = 50
	matchCountryBuildings()
	for country in aliveCountriesList:
		country.prospectForOres()
	emit_signal("calculateSeason", month)
	$CanvasLayer/TileInfoPanel.TilesCalculated()
	#$CanvasLayer/TileInfoPanel.displayTileInfo()
	#$CanvasLayer/BuildingInfoPanel.displayBuildingInfo()
	#$CanvasLayer/Spellbook.displaySpells(playerCountryNode)
	$CanvasLayer/LoadingLabel.text = "Loading UI (Magic)"
	$CanvasLayer/LoadingProgressBar.value = 75
	updatePlayerUI()
	for Tile in $TileController.get_children():
		Tile.discoverTile()
	#$TileController.discoverTiles(playerCountryNode)
	worldCreation = false
	$RightClickDetector.visible = true
	mapMode = "Polis"
	displayCorruption = true
	$CanvasLayer/LoadingProgressBar.value = 100
	$CanvasLayer/LoadingBackground.visible = false
	$CanvasLayer/LoadingSprite.visible = false
	$CanvasLayer/LoadingProgressBar.visible = false
	$CanvasLayer/LoadingLabel.visible = false
	# Generate procedural commanders (assigns them to barracks tiles, adds
	# Ualani Carlisle to pool), spawn 3 random starting armies, set up all
	# 17 protector arcs, then fire the game-start event.
	generateBarracksCommanders()
	spawnStartingArmies()
	$CanvasLayer/WarRoomPanel.setupAllProtectors($TileController.get_children())
	evaluateDateEvents()
	#for country in aliveCountriesList:
		#for Army in country.countryArmyList:
			#Army.raiseSelf()
	pass

# ── BARRACKS COMMANDER GENERATION ───────────────────────────────────────────
# Scans every tile owned by the player at game start.  For each Barracks tile
# a procedural governor is built using a terrain-matched archetype and a name
# drawn from the appropriate cultural name pool.  The governor is added to the
# player's unlocked pool AND registered in the War Room as a CommanderArcEntry.
func generateBarracksCommanders() -> void:
	# ── Archetype table ──────────────────────────────────────────────────────
	# terrain: which tile terrains can produce this archetype
	# name_pools: preferred cultural name pools (one picked at random)
	# position: governor role title
	var ARCHETYPES := [
		{"id":"ARC_01","name":"Wetlands Fisher",      "position":"SCOUT",      "terrain":["Wetlands"],               "pools":["NP_01","NP_04"]},
		{"id":"ARC_02","name":"Appalachian Miner",     "position":"ENGINEER",   "terrain":["Foothills"],              "pools":["NP_03"]},
		{"id":"ARC_03","name":"Ivy League Dropout",    "position":"SCHOLAR",    "terrain":["Metro"],                  "pools":["NP_01","NP_09","NP_10"]},
		{"id":"ARC_04","name":"Seminole Fighter",      "position":"WARRIOR",    "terrain":["Wetlands","Farmlands"],   "pools":["NP_07"]},
		{"id":"ARC_05","name":"Green Mountain Farmer", "position":"FARMER",     "terrain":["Foothills","Farmlands"],  "pools":["NP_01","NP_06"]},
		{"id":"ARC_06","name":"Chesapeake Shipwright", "position":"ENGINEER",   "terrain":["Wetlands"],               "pools":["NP_01","NP_04"]},
		{"id":"ARC_07","name":"Loyalist Turncoat",     "position":"SPY",        "terrain":["Metro","Suburbs"],        "pools":["NP_01","NP_02"]},
		{"id":"ARC_08","name":"Tobacco Belt Drifter",  "position":"SCOUT",      "terrain":["Farmlands"],              "pools":["NP_03","NP_04"]},
		{"id":"ARC_09","name":"War Widow",             "position":"DIPLOMAT",   "terrain":["Suburbs","Metro"],        "pools":["NP_01","NP_04","NP_09"]},
		{"id":"ARC_10","name":"Indigenous Scout",      "position":"SCOUT",      "terrain":["Woods","Wetlands"],       "pools":["NP_07"]},
		{"id":"ARC_11","name":"Boston Rabble-Rouser",  "position":"ORATOR",     "terrain":["Metro"],                  "pools":["NP_01","NP_09"]},
		{"id":"ARC_12","name":"Continental Surgeon",   "position":"HEALER",     "terrain":["Farmlands","Foothills"],  "pools":["NP_01","NP_02"]},
		{"id":"ARC_13","name":"Nantucket Sailor",      "position":"ADMIRAL",    "terrain":["Wetlands"],               "pools":["NP_01"]},
		{"id":"ARC_14","name":"Frontier Preacher",     "position":"ORATOR",     "terrain":["Woods","Foothills"],      "pools":["NP_03"]},
		{"id":"ARC_15","name":"DC Bureaucrat",         "position":"BUREAUCRAT", "terrain":["Metro"],                  "pools":["NP_01","NP_04"]},
		{"id":"ARC_16","name":"Rust Belt Steelworker", "position":"ENGINEER",   "terrain":["Suburbs"],               "pools":["NP_02","NP_09"]},
		{"id":"ARC_17","name":"Plantation Deserter",   "position":"SOLDIER",    "terrain":["Farmlands"],              "pools":["NP_04"]},
		{"id":"ARC_18","name":"Swamp Witch",           "position":"MAGE",       "terrain":["Wetlands"],               "pools":["NP_04","NP_05"]},
		{"id":"ARC_19","name":"Caribbean Privateer",   "position":"ADMIRAL",    "terrain":["Wetlands","Suburbs"],     "pools":["NP_05"]},
		{"id":"ARC_20","name":"Hawaiian Refugee",      "position":"DIPLOMAT",   "terrain":["Wetlands","Metro"],       "pools":["NP_08"]},
		{"id":"ARC_21","name":"Border Mercenary",      "position":"SOLDIER",    "terrain":["Suburbs","Farmlands"],    "pools":["NP_03","NP_05"]},
		{"id":"ARC_22","name":"Acadian Forest Ranger", "position":"SCOUT",      "terrain":["Woods","Wetlands"],       "pools":["NP_06"]},
		{"id":"ARC_23","name":"Gettysburg Descendant", "position":"SOLDIER",    "terrain":["Farmlands","Foothills"],  "pools":["NP_01","NP_04"]},
		{"id":"ARC_24","name":"LGBTQ+ Organizer",      "position":"DIPLOMAT",   "terrain":["Metro","Suburbs"],        "pools":["NP_01","NP_04","NP_09"]},
		{"id":"ARC_25","name":"Carnival Barker",       "position":"ORATOR",     "terrain":["Wetlands","Suburbs"],     "pools":["NP_03","NP_05"]},
	]

	# ── Name pools (first-male, first-female, first-nb, last) ────────────────
	var NAME_POOLS := {
		"NP_01": {
			"m":  ["Elias","Caleb","Josiah","Nathan","Ezra","Silas","Amos","Seth","Gideon","Abel"],
			"f":  ["Abigail","Prudence","Mercy","Hannah","Thankful","Patience","Ruth","Lydia","Miriam","Constance"],
			"nb": ["Sable","Rowe","Birch","Wren","Ash","Flint","Grey"],
			"l":  ["Aldrich","Whitfield","Hatch","Coffin","Morse","Tilden","Brewster","Alden","Sears"],
		},
		"NP_02": {
			"m":  ["Heinrich","Jakob","Gottfried","Samuel","Johannes","Luther","Conrad","Wilhelm","Ezekiel","Barnabas"],
			"f":  ["Katarina","Liesel","Anna","Greta","Hilde","Martha","Clara","Dorothea","Marta","Bettina"],
			"nb": ["Rael","Stern","Thorn","Kels","Bram"],
			"l":  ["Zimmermann","Keller","Brauer","Hochstetler","Mast","Yoder","Kreider","Becker","Roth"],
		},
		"NP_03": {
			"m":  ["Beauregard","Hezekiah","Cletus","Earl","Virgil","Jasper","Leland","Floyd","Harlan","Orville"],
			"f":  ["Beulah","Maybelle","Loretta","Edna","Clementine","Opaline","Willa","Dovie","Rosalee","Faye"],
			"nb": ["Dale","Lee","Bo","Rue","Sly","Beau"],
			"l":  ["Hatfield","McCoy","Combs","Slone","Tackett","Blevins","Castle","Holbrook","Prater"],
		},
		"NP_04": {
			"m":  ["Isaiah","Elijah","Marcus","Darius","Leroy","Roosevelt","Clarence","Augustus","Cornelius","Theron"],
			"f":  ["Ida","Zenobia","Celestine","Lavinia","Ophelia","Harriet","Josephine","Addie","Cora","Estelle"],
			"nb": ["Soleil","Roux","Jael","Lux","Zephyr"],
			"l":  ["Washington","Freeman","Justice","Douglass","Truth","Tubman","Bell","Price","Gaines","Bridges"],
		},
		"NP_05": {
			"m":  ["Carlos","Miguel","Alejandro","Rafael","Ernesto","Joaquin","Mateo","Santiago","Hector","Rodrigo"],
			"f":  ["Carmen","Pilar","Rosario","Dolores","Ines","Valentina","Marisol","Lupe","Consuelo","Xiomara"],
			"nb": ["Paz","Sol","Cruz","Rio","Lune","Ciel"],
			"l":  ["Reyes","Morales","Delgado","Vega","Fuentes","Castellanos","Cienfuegos","Garza","Ybarra"],
		},
		"NP_06": {
			"m":  ["Jean-Baptiste","Rene","Gaston","Emile","Theodore","Alphonse","Honore","Sebastien","Lucien","Fernand"],
			"f":  ["Marie-Claire","Therese","Marguerite","Colette","Vivienne","Celeste","Odette","Elise","Adele","Brigitte"],
			"nb": ["Claude","Dominique","Sable","Lune","Rene"],
			"l":  ["Tremblay","Gagnon","Roy","Cote","Bouchard","Leblanc","Pelletier","Lavoie","Fortin","Bergeron"],
		},
		"NP_07": {
			"m":  ["Skenandoa","Chayton","Tokala","Mahpiya","Elan","Hotah","Chaska","Mato","Ohiyesa","Kimimela"],
			"f":  ["Winona","Kaya","Aiyana","Taini","Chenoa","Aponi","Wren","Dove","Ama","Shoshana"],
			"nb": ["River","Ash","Stone","Flint","Cedar","Birch","Sky"],
			"l":  [""],   # Nation-specific; will appear as single-name
		},
		"NP_08": {
			"m":  ["Kai","Koa","Makoa","Keoni","Hoku","Noa","Kahale","Ikaika","Kaimana","Lono"],
			"f":  ["Leilani","Malia","Nohea","Haunani","Kalani","Pua","Moana","Alana","Kealoha","Kaimana"],
			"nb": ["Kai","Noa","Lani","Hoku","Koa"],
			"l":  ["Kahananui","Akana","Kealoha","Makoa","Puanani","Kamaka","Akina"],
		},
		"NP_09": {
			"m":  ["Seamus","Brennan","Declan","Cormac","Finn","Rory","Patrick","Kieran","Liam","Conor"],
			"f":  ["Brigid","Siobhan","Aoife","Niamh","Maeve","Fionnuala","Roisin","Ciara","Grainne","Nora"],
			"nb": ["Quinn","Rowan","Riley","Shea","Carey"],
			"l":  ["O'Brien","Murphy","Doyle","Callahan","Sullivan","Flanagan","McCarthy","Hennessy","Gallagher"],
		},
		"NP_10": {
			"m":  ["Abraham","Mordecai","Solomon","Isaac","Levi","Tobias","Emanuel","Felix","Siegfried","Otto"],
			"f":  ["Miriam","Rebecca","Leah","Esther","Judith","Rachel","Deborah","Hannah","Sarah","Naomi"],
			"nb": ["Sable","Rael","Aron","Sol","Lev"],
			"l":  ["Goldstein","Rosenberg","Weiss","Katz","Schwartz","Blum","Stein","Levy","Cohen","Bernstein"],
		},
	}

	var portrait_placeholder: Texture = load(
		"res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")

	# ── Spawn Ualani Carlisle FIRST, station her in Washington DC ────────────
	var carlisle: governor = governor.new()
	carlisle.buildSelf("Ualani Carlisle", 3)
	playerCountryNode.unlockedGovernors.append(carlisle)
	for tile in $TileController.get_children():
		if tile.tileNumber == 188 and tile.tileOwner == playerCountry:
			tile.tileGovernor       = carlisle
			tile.filledGovernorSlot = true
			carlisle.hired          = true
			print("[Commanders] President Carlisle stationed in Washington DC (tile 188).")
			break
	if not carlisle.hired:
		print("[Commanders] Washington DC not player-owned at start — Carlisle added to pool unassigned.")

	var used_names: Dictionary = {}
	var generated: int = 0

	for tile in $TileController.get_children():
		# Only player-owned tiles with a barracks
		if tile.tileOwner != playerCountry:
			continue
		if not tile.buildings.has("barracks"):
			continue
		# Skip tiles already governed (e.g., DC if Ualani was stationed there)
		if tile.filledGovernorSlot:
			continue

		# ── Pick archetype ────────────────────────────────────────────────
		var candidates: Array = []
		for arch in ARCHETYPES:
			if tile.terrain in arch["terrain"]:
				candidates.append(arch)
		if candidates.is_empty():
			candidates = ARCHETYPES          # any archetype if terrain has no match
		var chosen: Dictionary = candidates[randi() % candidates.size()]

		# ── Pick name pool ────────────────────────────────────────────────
		var pool_id: String = chosen["pools"][randi() % chosen["pools"].size()]
		var pool: Dictionary = NAME_POOLS.get(pool_id, NAME_POOLS["NP_01"])

		# Gender: 0 = m, 1 = f, 2 = nb
		var gender: int = randi() % 3
		var first_list: Array
		match gender:
			0: first_list = pool["m"]
			1: first_list = pool["f"]
			_: first_list = pool["nb"]
		var last_list: Array = pool.get("l", [])

		var first: String = first_list[randi() % first_list.size()]
		var last: String  = ""
		if last_list.size() > 0 and last_list[0] != "":
			last = last_list[randi() % last_list.size()]

		var full_name: String = (first + " " + last).strip_edges()

		# Deduplicate — try up to 8 times before giving up
		var tries: int = 0
		while used_names.has(full_name) and tries < 8:
			first = first_list[randi() % first_list.size()]
			full_name = (first + " " + last).strip_edges()
			tries += 1
		used_names[full_name] = true

		# ── Build governor ────────────────────────────────────────────────
		var new_gov: governor = governor.new()
		new_gov.governorType       = full_name           # display name shown in UI
		new_gov.governorArchetypeId = chosen["id"]       # archetype for War Room matching
		new_gov.governorPosition   = chosen["position"]  # role title (SCOUT, ORATOR, …)
		new_gov.governorLevel      = 1
		new_gov.governorDescription = \
			"A " + chosen["name"] + " who answered the revolution's call from " + tile.tileName + "."
		new_gov.governorBiography  = \
			full_name + " came from " + tile.tileName + " (" + tile.terrain + "). " + \
			"They carry the skills of " + chosen["name"] + " into the fight for independence."
		new_gov.governorTexture    = portrait_placeholder
		new_gov.hired              = false

		# Add to player's unlocked governor pool
		playerCountryNode.unlockedGovernors.append(new_gov)

		# Auto-assign as the tile's governor so they show up immediately
		tile.tileGovernor      = new_gov
		tile.filledGovernorSlot = true
		new_gov.hired           = true

		# Register their arc in the War Room
		$CanvasLayer/WarRoomPanel.registerCommanderArc(new_gov, tile)

		generated += 1
		print("[Commanders] Generated: ", full_name, " — ", chosen["name"],
			  " (", chosen["id"], ") at ", tile.tileName, " [", tile.terrain, "]")

	print("[Commanders] Barracks scan complete. ", generated, " commanders generated.")

	# ── Auto-assign tile governors to stationed armies ────────────────────────
	# Every barracks tile that received a governor above also has an army
	# stationed in it (army.inTile).  Match them now so armies start the game
	# with a commander already assigned.
	var assigned: int = 0
	for army in playerCountryNode.countryArmyList:
		if army.inTile != null and army.inTile.tileGovernor != null:
			army.addUnitCommander(army.inTile.tileGovernor)
			army.updateArmyUI()
			assigned += 1
			print("[Commanders] Assigned ", army.inTile.tileGovernor.governorType,
				  " as commander of ", army.ArmyName)
	print("[Commanders] ", assigned, " armies received a starting commander.")


# ── STARTING ARMY SPAWNER ─────────────────────────────────────────────────────
# Picks up to 3 player-owned, non-DC tiles that have a governor and a barracks
# at level 2-4 with no army yet, then spawns a uniquely-named army drawn from
# the tile name and the governor's archetype.  Must run after
# generateBarracksCommanders() so every tile's tileGovernor is already set.
func spawnStartingArmies() -> void:
	var ARMY_SUFFIX := {
		"ARC_01": "Wetlands Rangers",    "ARC_02": "Mountain Militia",
		"ARC_03": "Volunteer Regiment",  "ARC_04": "Forest Skirmishers",
		"ARC_05": "Green Mountain Boys", "ARC_06": "Harbor Guard",
		"ARC_07": "Irregular Rifles",    "ARC_08": "Frontier Militia",
		"ARC_09": "Liberty Brigade",     "ARC_10": "Ranger Company",
		"ARC_11": "Sons of Liberty",     "ARC_12": "Continental Corps",
		"ARC_13": "Naval Infantry",      "ARC_14": "Righteous Rifles",
		"ARC_15": "Federal Guard",       "ARC_16": "Iron Brigade",
		"ARC_17": "Freedom Rifles",      "ARC_18": "Bayou Raiders",
		"ARC_19": "Privateer Corps",     "ARC_20": "Pacific Guard",
		"ARC_21": "Border Company",      "ARC_22": "Forest Rangers",
		"ARC_23": "Heritage Guard",      "ARC_24": "Solidarity Regiment",
		"ARC_25": "Showmen's Rifles",
	}

	var candidates: Array = []
	for tile in $TileController.get_children():
		if tile.tileOwner != playerCountry:
			continue
		if tile.tileNumber == 188:            # Washington DC — Ualani's territory
			continue
		if not tile.filledGovernorSlot or tile.tileGovernor == null:
			continue
		var blvl: int = int(tile.buildings.get("barracks", 0))
		if blvl < 2 or blvl > 4:
			continue
		if tile.stationedArmy != null:
			continue
		candidates.append(tile)

	candidates.shuffle()
	var chosen: Array = candidates.slice(0, min(3, candidates.size()))

	for tile in chosen:
		var gov: governor = tile.tileGovernor
		var arc_id: String = gov.governorArchetypeId \
			if gov.governorArchetypeId != "" else "ARC_01"
		var army_name: String = tile.tileName + " " + ARMY_SUFFIX.get(arc_id, "Militia")

		playerCountryNode.addArmy(army_name, tile.tileNumber)

		# addArmy() always appends — grab the army we just added and assign its commander
		var new_army = playerCountryNode.countryArmyList.back()
		if new_army != null:
			new_army.addUnitCommander(gov)
			new_army.updateArmyUI()

		print("[StartingArmies] '", army_name, "' at ", tile.tileName,
			  " (barracks lvl ", int(tile.buildings.get("barracks", 0)),
			  ", ", arc_id, ")")

	print("[StartingArmies] ", chosen.size(), " starting armies placed.")


var countryNode = load("res://Game Scenes and Scripts/country.tscn")

func spawnNewGameCountries(CID: String) -> void:
	playerCountry = CID
 
	# Spawn all countries defined in countries.csv
	for countryCID in CountryDatabase.get_all_CIDs():
		var newCountry = countryNode.instantiate()
		newCountry.CID = countryCID
 
		# Assign player flag
		if countryCID == playerCountry:
			newCountry.Player = true
			playerCountryNode = newCountry
 
		else:
			newCountry.Player = false
 
		# Assign tiles that belong to this country
		for Tile in $TileController.get_children():
			if Tile.tileOwner == countryCID:
				newCountry.OwnedTileList.append(Tile)
 
		# Build country from CSV data
		newCountry.NewGameBuild()
		aliveCountriesList.append(newCountry)
		$CountryController.add_child(newCountry)
 
	# Set player capital camera position
	if playerCountryNode != null:
		var capitalData = CountryDatabase.get_country(playerCountry)
		var capitalTileNum = capitalData.get("primaryCapital", 1)
		var capitalPathPoint = get_node_or_null(
			"PathControl/PathPointsControl/" + str(capitalTileNum)
		)
		if capitalPathPoint:
			playerCapitalPathButton = capitalPathPoint
			$CameraMovementController/Camera2D.global_position = capitalPathPoint.global_position
		else:
			push_warning("spawnNewGameCountries: Could not find capital path point for " + playerCountry)

var playerOutput: Dictionary = {}
func calculatePlayerOutputs(caller):
	playerOutput.clear()
	playerCountryNode.outputCheck(caller)
	pass

func returnOutput(outputsDict, caller):
	playerOutput = outputsDict
	caller.returnedOutput(playerOutput)
	pass

func connectCountrySignals():
	for country in aliveCountriesList:
		country.raiseThisArmySignal.connect(raiseArmyFromWorld)
	pass

func updateBeliefControl():
	$CanvasLayer/BeliefControl.updateSelf()
	pass

func updatePlayerUI():
	$CanvasLayer.assignPlayerNode(playerCountryNode)
	$CanvasLayer/TileInfoPanel.selectThisTile.connect(assignSelectedTile)
	$CanvasLayer/TileInfoPanel.governorButtonPressed.connect(openGovernorsPanel)
	$CanvasLayer/TileInfoPanel.confirmThisGovernor.connect(assignGovernor)
	$CanvasLayer/TechTree.buildSelf(playerCountryNode)
	$CanvasLayer/TechTree.addTechToPlayer.connect(newPlayerTech)
	$CanvasLayer/BeliefControl.buildSelf(playerCountryNode)
	$CanvasLayer/BuildingInfoPanel/buildingPanelPanel.player = playerCountryNode
	$PathControl.activateArmyControlMode.connect(activateArmyControl)
	$PathControl.connectPathPoints(playerCountryNode)
	$PathControl.updateArmy.connect(updateArmyFunc)
	$PathControl.updatePathPoints.connect(updatePathPointsFunc)
	$PathControl.updateCivilian.connect(updateCivFunc)
	$PathControl.tileDevelopment.connect(newTileDevelopment)
	$PathControl.meleeButtonPressed.connect(meleePressed)
	$PathControl.rangedButtonPressed.connect(rangedPressed)
	$CanvasLayer/CivilianControl.loadCivilians(playerCountryNode, playerCountryNode.OwnedTileList)
	$CanvasLayer/CivilianControl.raiseThisUnit.connect(raiseCivilianUnit)
	$CanvasLayer/MilitaryPanelControl.buildSelf(playerCountryNode)
	$CanvasLayer/MilitaryPanelControl.newArmySignal.connect(buildNewPlayerArmy)
	playerCountryNode.displayCommander.connect(UICommander)
	playerCountryNode.checkingOutput.connect(returnOutput)
	$CanvasLayer/GovernmentControl.buildSelf(playerCountryNode)
	$CanvasLayer/GovernmentControl.addToConstitution.connect(addLawToCountry)
	$CanvasLayer/FactionControl.newRewardSend.connect(addNewRewards)
	for faction in playerCountryNode.countryFactionList:
			$CanvasLayer/FactionControl.addFaction(
				faction.factionName,
				faction.factionLoyalty,
				faction.factionLeader
			)
	$CanvasLayer/SpellSchoolsControl.connectSchools()
	$CanvasLayer/SpellSchoolsControl.lvlUpSpell.connect(newSpellEvent)
	#$CanvasLayer/SpellSchoolsControl.askForInfo.connect(giveSpellInfo)
	$CanvasLayer/Spellbook.spellToUse.connect(activateSpellMapMode)
	$TileController.spellAssignedToTile.connect(spellPurchased)
	#$TileController.colonizeTile.connect(updateCountryTiles)
	$TileController.newTileOwner.connect(tileSiegeWon)
	$PathControl.call_deferred("showPathPoints", playerCapitalPathButton)
	$CanvasLayer/BuildingInfoPanel.buildSelf(playerCountryNode)
	$CanvasLayer/BuildingInfoPanel.newBuildingInTile.connect(addNewBuildingToTile)
	$CanvasLayer/TileInfoPanel.retrieveTileOutputs.connect(retrieveOutputs)
	#$PathControl.makeAllContainersPassable()
	#print("ALL I NEED")
	# War Room panel wiring
	$CanvasLayer/WarRoomPanel.buildSelf(playerCountryNode)
	if not $CanvasLayer/WarRoomPanel.requestEventFire.is_connected(_on_arc_event_requested):
		$CanvasLayer/WarRoomPanel.requestEventFire.connect(_on_arc_event_requested)
	if not $CanvasLayer/WarRoomPanel.protectorSummoned.is_connected(_on_protector_summoned):
		$CanvasLayer/WarRoomPanel.protectorSummoned.connect(_on_protector_summoned)
	pass

var thisTileNumber: int
var selectedTile: Tile


func manaUpdate(type, amount, dictionary):
	$CanvasLayer/TileInfoPanel.buildTileOutput(type, amount, dictionary)
	pass

func tileClicked(tile):
	#print("Tile", tile.tileNumber, "Clicked")
	selectedTile = tile
	#$CanvasLayer/TileInfoPanel.thisTile = tile
	
	$CanvasLayer/TileInfoPanel.displayTileInfo(tile)
	if $CanvasLayer/TileInfoPanel.visible == false:
		$CanvasLayer/TileInfoPanel.visible = true
	else:
		$CanvasLayer/TileInfoPanel.visible = false
	#$CanvasLayer/TileInfoPanel.thisTile = tile
	#$CanvasLayer/TileInfoPanel.displayTileInfo()
	#$CanvasLayer/BuildingInfoPanel.thisTile = tile
	#if $CanvasLayer/BuildingInfoPanel.visible == false:
		#$CanvasLayer/BuildingInfoPanel.visible = true
	$CanvasLayer/BuildingInfoPanel.displayBuildingInfo(tile)
	pass

func retrieveOutputs():
	selectedTile.censusTile(playerCountryNode)
	pass

func matchCountryBuildings():
	for country in aliveCountriesList:
		for Tile in $TileController.get_children():
			if Tile.tileOwner == playerCountry:
				for building in Tile.tileBuildingsList:
					playerCountryNode.connectBuilding(building)
					#building.towerBuilding.connect(signalTowerInTile)
	pass

func _on_food_area_2d_mouse_entered():
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 360
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 1)
func _on_food_area_2d_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_wood_area_2d_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 480
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 2)
func _on_wood_area_2d_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_metal_area_2d_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 600
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 3)
func _on_metal_area_2d_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_gold_area_2d_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 240
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 0)
func _on_gold_area_2d_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_weapons_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 720
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 4)
func _on_weapons_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_science_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1000
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 5)
func _on_science_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_faith_control_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1000
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 6)
func _on_faith_control_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_magic_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1000
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 7)
func _on_magic_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_culture_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1000
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 8)
	pass # Replace with function body.
func _on_culture_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.
func _on_mandate_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1440
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 9)
	pass # Replace with function body.
func _on_mandate_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.
func _on_harmony_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1440
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 10)
	pass # Replace with function body.
func _on_harmony_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.
func _on_influence_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1440
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 11)
	pass # Replace with function body.
func _on_influence_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.
func _on_manpower_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 840
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 12)
	pass # Replace with function body.

func _on_manpower_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.

#oldnext turn function
func _on_test_resource_button_pressed() -> void:
	
	pass # Replace with function body.

func newPlayerTech(techName) -> void:
	playerCountryNode.addTechnologicalDiscovery(techName)
	pass # Replace with function body.

func _on_building_panel_panel_upgrade_building(thisBuilding) -> void:
	print("thisBuilding", thisBuilding.buildingType, thisBuilding.buildingLevel)
	for Tile in $TileController.get_children():
		if Tile.tileNumber == thisBuilding.number:
			print("tile", Tile.tileNumber)
			for building in Tile.tileBuildingsList:
				if building.buildingType == thisBuilding.buildingType:
					building.upgradeBuilding()
	pass # Replace with function body.


func _on_building_panel_panel_downgrade_building(thisBuilding) -> void:
	for Tile in $TileController.get_children():
		if Tile.tileNumber == thisBuilding.number:
			print("tile", Tile.tileNumber)
			for building in Tile.tileBuildingsList:
				if building.buildingType == thisBuilding.buildingType:
					building.downgradeBuilding()
	pass # Replace with function body.


func assignSelectedTile(tileToSelect):
	#selectedTile = tileToSelect
	pass

func addNewRewards(rewardType):
	playerCountryNode.createFactionReward(rewardType)
	pass

func assignGovernor(governorToAssign, tileToAssignTo):
	tileToAssignTo.assignNewGovernor(governorToAssign)
	governorToAssign.hire()
	$CanvasLayer/TileInfoPanel.displayTileInfo(tileToAssignTo)
	if tileToAssignTo.stationedArmy !=null:
		tileToAssignTo.stationedArmy.addUnitCommander(governorToAssign)
	calculateGovernorEvent(governorToAssign)
	# Register commander arc in War Room
	$CanvasLayer/WarRoomPanel.registerCommanderArc(governorToAssign, tileToAssignTo)
	pass

func openGovernorsPanel(tile):
	$CanvasLayer/TileInfoPanel.calculateAvailableGovernor(playerCountryNode, selectedTile)
	pass

#Magic Code

func newSpellEvent(schoolType, currentLvl):
	match schoolType:
		"iron", "elementalist":
			match currentLvl:
				0: createNewEvent("GEN_PLENTIFY_UNLOCK")
				1: createNewEvent("GEN_HEALING_WINDS_UNLOCK")
				2: createNewEvent("GEN_RAISE_SPRING_UNLOCK")

#Government Code
func addLawToCountry(lawType):
	playerCountryNode.addLawToConstitution(lawType)
	$CanvasLayer/GovernmentControl.updateGovernmentPanel()
	pass

#Army World Code
func _on_army_button_pressed() -> void:
	if $CanvasLayer/MilitaryPanelControl.visible == false:
		$CanvasLayer/MilitaryPanelControl.visible = true
		for BarracksButton in $CanvasLayer/MilitaryPanelControl/ScrollContainer/GridContainer.get_children():
			BarracksButton.updateSelf()
	else:
		$CanvasLayer/MilitaryPanelControl.visible = false
	pass # Replace with function body.
	
const armyScene = preload("res://Game Scenes and Scripts/army.tscn")
func buildNewPlayerArmy(barracksBuilding, barracksTile, bbButton, playerNode, newArmyName):
	# Cost scales +20% per previously purchased army (game-start armies not counted).
	var n: int  = playerNode.purchasedArmyCount
	var cost: int = ceili(10.0 * pow(1.2, n))
	if playerNode.TotalDollars  < cost or playerNode.TotalWeapons < cost \
			or playerNode.TotalCulture < cost or playerNode.TotalScience < cost:
		print("[Army] Cannot afford new army — need ", cost,
			  " each of Dollars / Weapons / Culture / Science (army #", n + 1, ")")
		return
	playerNode.TotalDollars  -= cost
	playerNode.TotalWeapons  -= cost
	playerNode.TotalCulture  -= cost
	playerNode.TotalScience  -= cost
	playerNode.purchasedArmyCount += 1
	var next_cost: int = ceili(10.0 * pow(1.2, playerNode.purchasedArmyCount))
	print("[Army] Army purchased (cost ", cost, " each). Next army costs ", next_cost, " each.")
	playerNode.addArmy(newArmyName, barracksTile.tileNumber)
	for Army in playerNode.countryArmyList:
		if Army.ArmyName == newArmyName:
			bbButton.addPrebuiltArmy(Army)
	pass

func UICommander(commander, army):
	if commander != null:
		# Show the assigned commander's details panel
		$CanvasLayer/TileInfoPanel/GovernorSelection.buildSelectedSelf(commander)
		$CanvasLayer/TileInfoPanel/GovernorSelection.changePanel("commander")
		$CanvasLayer/TileInfoPanel/GovernorSelection.position = Vector2(-212, -473)
		if $CanvasLayer/TileInfoPanel/GovernorSelection.visible == false:
			$CanvasLayer/TileInfoPanel/GovernorSelection.visible = true
		else:
			$CanvasLayer/TileInfoPanel/GovernorSelection.visible = false
	else:
		# No commander yet — open the governor picker so the player can assign one
		_open_army_commander_picker(army)
	pass

# ── ARMY COMMANDER PICKER ─────────────────────────────────────────────────────
# Built entirely in code — no .tscn changes needed.
# Opens a floating panel over the canvas that lists every governor in
# playerCountryNode.unlockedGovernors.  Clicking a governor's confirm button
# calls army.addUnitCommander() and closes the panel.
# ─────────────────────────────────────────────────────────────────────────────
const _govSelScene = preload("res://governor_selection.tscn")
var _commanderPickerPanel: Panel = null
var _armyAwaitingCommander: Army = null

func _open_army_commander_picker(army: Army) -> void:
	# Close any existing picker first
	if _commanderPickerPanel != null:
		_commanderPickerPanel.queue_free()
		_commanderPickerPanel = null

	_armyAwaitingCommander = army

	# ── Outer panel ──────────────────────────────────────────────────────────
	var panel = Panel.new()
	panel.size     = Vector2(440, 520)
	panel.position = Vector2(220, 80)
	$CanvasLayer.add_child(panel)
	_commanderPickerPanel = panel

	# ── Title ────────────────────────────────────────────────────────────────
	var title = Label.new()
	title.text     = "Assign Commander — " + army.ArmyName
	title.position = Vector2(10, 8)
	title.size     = Vector2(380, 24)
	panel.add_child(title)

	# ── Close button ─────────────────────────────────────────────────────────
	var closeBtn = Button.new()
	closeBtn.text     = "X"
	closeBtn.position = Vector2(402, 4)
	closeBtn.size     = Vector2(32, 32)
	closeBtn.pressed.connect(_close_army_commander_picker)
	panel.add_child(closeBtn)

	# ── Scroll container holding one GovernorSelection per unlocked governor ─
	var scroll = ScrollContainer.new()
	scroll.position = Vector2(4, 40)
	scroll.size     = Vector2(432, 472)
	panel.add_child(scroll)

	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vbox)

	if playerCountryNode.unlockedGovernors.is_empty():
		var empty = Label.new()
		empty.text = "No governors available."
		vbox.add_child(empty)
	else:
		for gov in playerCountryNode.unlockedGovernors:
			var govSel = _govSelScene.instantiate()
			vbox.add_child(govSel)
			govSel.buildSelf(gov)
			# Lambda captures gov by value at loop time
			govSel.governorConfirmed.connect(
				func(confirmed_gov): _assign_army_commander(confirmed_gov)
			)

func _assign_army_commander(gov) -> void:
	if _armyAwaitingCommander != null:
		_armyAwaitingCommander.addUnitCommander(gov)
		_armyAwaitingCommander.updateArmyUI()
	_close_army_commander_picker()

func _close_army_commander_picker() -> void:
	if _commanderPickerPanel != null:
		_commanderPickerPanel.queue_free()
		_commanderPickerPanel = null
	_armyAwaitingCommander = null
var pathPointButtonToSend: pathPointButton

func raiseArmyFromWorld(Army, country, Tile):
	
	#this is how the armies spawn into the world, will need a redo soon
	#literally just add a system where tiles have a reference to their pathPointButton instead of this
	#demon AI system will spawn units using raiseArmyFromWorld
	pathPointButtonToSend = Tile.tileSpawnPoint
	if country == playerCountryNode:
		$PathControl.raisePlayerArmy(Army, country, Tile, pathPointButtonToSend)
	else:
		#here is where we will raise either Demonic or nonPlayer Country AIs
		$PathControl.raiseComputerArmy(Army, country, Tile, pathPointButtonToSend)
	pass
func raiseCivilianUnit(civ, country):
	var civTile = civ.stationNode.ppbTile if civ.stationNode != null else null
	$PathControl.raisePlayerCiv(civ, country, civTile)
	pass

func activateArmyControl():
	armyMode = true
	pass

var eventScene = load("res://eventScene.tscn")

var temporaryTile: Tile
#MAP INTERACTION
func activateSpellMapMode(spell, cost):
	if spell.militarySpell == false:
		$TileController.spellSelectionMode(spell, cost, playerCountryNode)
	else:
		$PathControl.spellSelectionMode(spell, cost, playerCountryNode)
	pass

func spellPurchased(cost):
	playerCountryNode.TotalMagic -= cost
	$TileController.normalMode()
	$CanvasLayer/Spellbook.displaySpells(playerCountryNode)
	pass

#EVENT SYSTEM

func calculateTileEvent(tile, type) -> void:
	match type:
		"wizard":
			createNewEvent("wizardSelect", tile)

func calculateGovernorEvent(gov) -> void:
	match gov.governorType:
		"Wolverina Gundo":
			match gov.governorLevel:
				1: createNewEvent("PDT_Wolverina0")

func _on_arc_event_requested(event_id: String, tile) -> void:
	createNewEvent(event_id, tile)


func _on_protector_summoned(origin_tile, protector_name: String, protector_id: String) -> void:
	if origin_tile != null:
		var school: String = _protector_id_to_school(protector_id)
		origin_tile.addWizard(protector_name, school)
		print("[Protectors] Tower: ", protector_name,
			  " (", school, ") stationed at ", origin_tile.tileName)
	var spell_name: String = _protector_id_to_spell(protector_id)
	if spell_name != "":
		playerCountryNode.addSpellToSpellbook(spell_name, 1, 0)
		print("[Protectors] Presidential Power unlocked: ", spell_name)


func _protector_id_to_school(pid: String) -> String:
	match pid:
		"PROT_01", "PROT_02", "PROT_03", "PROT_10", "PROT_15": return "cryptid"
		"PROT_04", "PROT_06", "PROT_07":                        return "storm"
		"PROT_05", "PROT_13", "PROT_17":                        return "spectral"
		"PROT_08", "PROT_09", "PROT_16":                        return "iron"
		"PROT_11", "PROT_12":                                   return "liberty"
		"PROT_14":                                              return "manifest"
	return "manifest"


func _protector_id_to_spell(pid: String) -> String:
	match pid:
		"PROT_01": return "FEDERAL ATMOSPHERIC SURVEILLANCE ACT"
		"PROT_02": return "PINE BARRENS DEVELOPMENT MORATORIUM"
		"PROT_03": return "PACIFIC NORTHWEST PRIVACY PROTECTION ACT"
		"PROT_04": return "EXECUTIVE WEATHER CONTROL INITIATIVE"
		"PROT_05": return "CLASSIFIED TACTICAL TERROR BUDGET"
		"PROT_06": return "CHESAPEAKE WATERS RECLAMATION PROJECT"
		"PROT_07": return "DEPARTMENT OF PSYCHOLOGICAL OPERATIONS"
		"PROT_08": return "NAVAL SUPERIORITY MAINTENANCE DIRECTIVE"
		"PROT_09": return "COLD WEATHER RESILIENCE FUNDING ACT"
		"PROT_10": return "INTER-AGENCY CRYPTID INTEGRATION PROGRAM"
		"PROT_11": return "MIDNIGHT EMERGENCY MOBILIZATION ORDER"
		"PROT_12": return "FREEDOM RESONANCE AMPLIFICATION DECREE"
		"PROT_13": return "RURAL SPECTRAL INVESTMENT INITIATIVE"
		"PROT_14": return "MONUMENT-BASED ECONOMIC STIMULUS PACKAGE"
		"PROT_15": return "FLORIDA CRYPTID INTEGRATION TASK FORCE"
		"PROT_16": return "PERMANENT READINESS MANDATE (EXPIRES NEVER)"
		"PROT_17": return "EMANCIPATION PROCLAMATION 2: STILL EMANCIPATING"
	return ""

func createNewEvent(event_id: String, tile = null) -> void:
	if not EventDatabase.event_can_fire(event_id, currentWorldTurn):
		return
	var newEvent = eventScene.instantiate()
	newEvent.build_from_csv(event_id, tile, playerCountryNode)
	newEvent.eventButtonPressed.connect(_on_event_button_pressed)
	newEvent.tileEventButtonPressed.connect(_on_tile_event_button_pressed)
	$CanvasLayer/EventControl/EventContainer.add_child(newEvent)
	EventDatabase.mark_event_fired(event_id, currentWorldTurn)

func _on_event_button_pressed(button_id: String, event_id: String,
		event_country: String, outcome_type: String,
		outcome_value: String, outcome_amount: int) -> void:
	executeOutcome(outcome_type, outcome_value, outcome_amount, null)
	var btn = EventDatabase.get_button(button_id)
	var next_id = btn.get("next_event_id", "")
	if next_id != "":
		createNewEvent(next_id)

func _on_tile_event_button_pressed(button_id: String, event_id: String,
		event_country: String, outcome_type: String,
		outcome_value: String, outcome_amount: int, tile: Tile) -> void:
	executeOutcome(outcome_type, outcome_value, outcome_amount, tile)
	var btn = EventDatabase.get_button(button_id)
	var next_id = btn.get("next_event_id", "")
	if next_id != "":
		createNewEvent(next_id, tile)

func executeOutcome(outcome_type: String, outcome_value: String,
		outcome_amount: int, tile) -> void:
	match outcome_type:
		"add_faction":
			var leader = _find_or_create_leader(outcome_value)
			$CanvasLayer/FactionControl.addFaction(outcome_value, outcome_amount, leader)
		"loyalty_change":
			playerCountryNode.changeFactionLoyalty(outcome_value, outcome_amount)
		"add_spell":
			playerCountryNode.addSpellToSpellbook(outcome_value, outcome_amount, 0)
			playerCountryNode.levelUpSchool(_get_spell_school(outcome_value))
		"add_tech":
			playerCountryNode.addTechnologicalDiscovery(outcome_value)
		"add_law":
			playerCountryNode.addGovernmentLaw(outcome_value)
		"add_governor":
			playerCountryNode.addGovernorToGovernorPool(outcome_value, outcome_amount)
		"add_mil_mod":
			playerCountryNode.addMilMod(outcome_value)
		"resource_change":
			_apply_resource_change(outcome_value, outcome_amount)
		"morale_boost":
			_apply_morale_boost(outcome_amount)
		"tile_liberation":
			if tile != null:
				tile.record_conquest("USA")
				tileSiegeWon(tile, tile.tileOwner, "USA")
		"tile_loyalty_change":
			if tile != null:
				tile.corruption = max(0, tile.corruption - outcome_amount)
		"tile_moral_decay_change":
			if tile != null:
				tile.tileMoralDecay = clampi(tile.tileMoralDecay + outcome_amount, 0, 100)
				print("[MoralDecay] ", tile.tileName, " → ", tile.tileMoralDecay)
		"add_wizard":
			if tile != null:
				tile.addWizard(outcome_value)
		"reveal_tiles":
			if tile != null:
				for neighbor in tile.TileNeighbors:
					neighbor.discoverTile()
		"tile_building":
			if tile != null:
				tile.addBuilding(outcome_value, outcome_amount)
		"army_buff":
			_apply_army_buff(outcome_value, outcome_amount, tile)
		"summon_protector":
			_summon_protector(outcome_value, tile)
		"trigger_event":
			createNewEvent(outcome_value, tile)
		"set_flag":
			playerCountryNode.CountryFlags.append(outcome_value)
		"clear_flag":
			playerCountryNode.CountryFlags.erase(outcome_value)
		"set_mission_flag":
			# Encodes completion event ID + tile number: "mission_<eventId>_<tileNum>"
			# outcome_amount = turn countdown before mission expires (0 = no timer)
			if tile == null:
				push_warning("executeOutcome: set_mission_flag requires a tile context")
			else:
				var flag_val: String = "mission_" + outcome_value + "_" + str(tile.tileNumber)
				if not playerCountryNode.CountryFlags.has(flag_val):
					playerCountryNode.CountryFlags.append(flag_val)
					var timeout: int = int(outcome_amount)
					if timeout > 0:
						_mission_timers[flag_val] = timeout
						print("[Mission] Activated: ", flag_val, " — expires in ", timeout, " turns")
					else:
						print("[Mission] Activated: ", flag_val, " — no timeout")
		"claim_change":
			playerCountryNode.presidentialClaim = clampf(
				playerCountryNode.presidentialClaim + float(outcome_amount), -10.0, 10.0)
			print("[Claim] Event adjustment: ", outcome_amount, " → now ", playerCountryNode.presidentialClaim)
		"pardon_state_governors":
			# Keep governors on their tiles but reset any negative loyalty to 0
			if tile != null:
				var sc: String = tile.tileContinent
				for t in $TileController.get_children():
					if t.tileContinent == sc and t.tileGovernor != null:
						t.tileGovernor.loyalty = maxf(t.tileGovernor.loyalty, 0.0)
				playerCountryNode.presidentialClaim = clampf(
					playerCountryNode.presidentialClaim + 1.0, -10.0, 10.0)
				print("[Pardon] Governors in ", sc, " pardoned — loyalty floored at 0")
		"replace_state_governors":
			# Remove every governor in the state and generate fresh ones
			if tile != null:
				var sc: String = tile.tileContinent
				for t in $TileController.get_children():
					if t.tileContinent == sc and t.tileOwner == "USA":
						if t.tileGovernor != null:
							playerCountryNode.unlockedGovernors.erase(t.tileGovernor)
							t.tileGovernor.hired = false
							t.tileGovernor = null
							t.filledGovernorSlot = false
						_generate_and_assign_governor(t)
				print("[Replace] All governors in ", sc, " replaced with fresh appointments")
		"remove_governor":
			# Sack the tile's governor and generate a procedural replacement.
			if tile != null and tile.tileGovernor != null:
				tile.tileGovernor.hired = false
				tile.tileGovernor = null
				tile.filledGovernorSlot = false
				_generate_and_assign_governor(tile)
		"repair_fort":
			if tile != null:
				tile.fortDisrepair = false
			playerCountryNode.CountryFlags.erase("ualani_at_fort")
		"disable_building":
			if tile != null:
				tile.disable_building(outcome_value, int(outcome_amount))
			else:
				push_warning("executeOutcome: disable_building requires a tile context")
		"set_mission_flag_own":
			# Like set_mission_flag but completion condition is tile ownership, not army presence
			if tile == null:
				push_warning("executeOutcome: set_mission_flag_own requires a tile context")
			else:
				var flag_val: String = "mission_" + outcome_value + "_" + str(tile.tileNumber) + "_own"
				if not playerCountryNode.CountryFlags.has(flag_val):
					playerCountryNode.CountryFlags.append(flag_val)
					var timeout: int = int(outcome_amount)
					if timeout > 0:
						_mission_timers[flag_val] = timeout
						print("[Mission] Activated (own): ", flag_val, " — expires in ", timeout, " turns")
					else:
						print("[Mission] Activated (own): ", flag_val, " — no timeout")
		"trigger_collapse":
			_execute_republic_collapse()
		"nothing":
			pass
		_:
			push_warning("executeOutcome: Unknown outcome type: " + outcome_type)

func evaluateDateEvents() -> void:
	checkPendingMissions()
	checkMissionExpiry()
	checkCollapseCondition()
	checkStateSecessionConditions()
	_calculate_presidential_claim()
	_update_governor_loyalty()
	_tick_event_cooldowns()
	if playerCountry == "USA" and not _republic_collapsed:
		_check_harvest_crisis()
		_check_harbor_threat()
		_check_forge_threat()
		_check_corruption_crisis()
		_check_border_dispute()
		_check_garrison_hunger()
		_check_legitimacy_crisis()
		_check_turncoat_general()
	var to_fire = EventDatabase.evaluate_date_triggers(currentWorldTurn, month)
	for event_id in to_fire:
		if event_id == "FORT_001":
			_fire_fort_disrepair_event()
		else:
			createNewEvent(event_id)

func checkPendingMissions() -> void:
	var flags_to_remove: Array = []
	var events_to_fire: Array = []

	for flag in playerCountryNode.CountryFlags:
		if not flag.begins_with("mission_"):
			continue
		var body: String = flag.substr(8)

		# Detect ownership-type mission (_own suffix)
		var own_type: bool = body.ends_with("_own")
		if own_type:
			body = body.substr(0, body.length() - 4)

		var last_us: int = body.rfind("_")
		if last_us == -1:
			continue
		var event_id: String = body.substr(0, last_us)
		var tile_num_str: String = body.substr(last_us + 1)
		if not tile_num_str.is_valid_int():
			continue
		var tile_num: int = tile_num_str.to_int()

		# _own missions search all tiles; army missions only search owned tiles
		var search_list: Array = $TileController.get_children() if own_type else playerCountryNode.OwnedTileList
		for tile in search_list:
			if tile.tileNumber != tile_num:
				continue
			var condition_met: bool
			if own_type:
				condition_met = tile.tileOwner == "USA"
			else:
				condition_met = tile.stationedArmy != null and tile.stationedArmy.parentCountry == playerCountryNode
			if condition_met:
				flags_to_remove.append(flag)
				events_to_fire.append([event_id, tile])
				print("[Mission] Condition met (", "own" if own_type else "army", ") — firing ", event_id, " at ", tile.tileName)
			break

	for flag in flags_to_remove:
		playerCountryNode.CountryFlags.erase(flag)
	for pair in events_to_fire:
		createNewEvent(pair[0], pair[1])


func checkCollapseCondition() -> void:
	if playerCountry != "USA" or _republic_collapsed:
		return
	for tile in $TileController.get_children():
		if tile.terrain != "Metro":
			continue
		if tile.tileContinent in CANADIAN_STATES or tile.tileContinent == "":
			continue
		if tile.tileOwner == "USA":
			return  # Still hold at least one American metro — no collapse yet
	_republic_collapsed = true
	print("[Collapse] All American metros have fallen. Triggering COLLAPSE_01.")
	createNewEvent("COLLAPSE_01")


# ── PRESIDENTIAL CLAIM ───────────────────────────────────────────
func _calculate_presidential_claim() -> void:
	if playerCountry != "USA" or _republic_collapsed:
		return
	var metro_gain: float = 0.0
	var loss_penalty: float = 0.0
	var uk_penalty: float = 0.0
	for tile in $TileController.get_children():
		var sc: String = tile.tileContinent
		if sc in CANADIAN_STATES or sc == "" or sc == "DC":
			continue
		if tile.terrain == "Metro":
			if tile.tileOwner == "USA":
				metro_gain += 0.25
			else:
				loss_penalty += 0.20
		else:
			if tile.tileOwner != "USA":
				loss_penalty += 0.025
		if tile.tileOwner == "UK":
			uk_penalty += 0.025
	var delta: float = clampf(metro_gain - loss_penalty - uk_penalty, -2.0, 2.0)
	playerCountryNode.presidentialClaim = clampf(
		playerCountryNode.presidentialClaim + delta, -10.0, 10.0)


func _update_governor_loyalty() -> void:
	if playerCountry != "USA":
		return
	var claim: float = playerCountryNode.presidentialClaim
	for gov in playerCountryNode.unlockedGovernors:
		if is_instance_valid(gov):
			gov.update_loyalty(claim)


# ── MISSION EXPIRY ───────────────────────────────────────────────
func checkMissionExpiry() -> void:
	if playerCountry != "USA":
		return
	var expired: Array = []
	for flag in _mission_timers.keys():
		_mission_timers[flag] -= 1
		if _mission_timers[flag] <= 0:
			expired.append(flag)
	for flag in expired:
		_mission_timers.erase(flag)
		playerCountryNode.CountryFlags.erase(flag)
		_on_mission_expired(flag)


func _on_mission_expired(flag: String) -> void:
	var body: String = flag.substr(8)
	# Strip _own suffix before parsing
	if body.ends_with("_own"):
		body = body.substr(0, body.length() - 4)
	var last_us: int = body.rfind("_")
	if last_us == -1:
		return
	var event_id: String = body.substr(0, last_us)
	var tile_num_str: String = body.substr(last_us + 1)
	if not tile_num_str.is_valid_int():
		return
	var tile_num: int = tile_num_str.to_int()

	var source_tile = null
	for t in $TileController.get_children():
		if t.tileNumber == tile_num:
			source_tile = t
			break
	if source_tile == null:
		return

	var sc: String = source_tile.tileContinent
	print("[Mission] EXPIRED — flagging all tiles in '", sc, "' as president_failed for 10 turns")
	for t in $TileController.get_children():
		if t.tileContinent == sc:
			t.presidentFailedTimer = 10
	playerCountryNode.presidentialClaim = clampf(
		playerCountryNode.presidentialClaim - 2.0, -10.0, 10.0)
	print("[Claim] Mission-failure penalty. Claim now: ", playerCountryNode.presidentialClaim)

	# Event-specific expiry effects
	if event_id.begins_with("CORRUPT_"):
		source_tile.disable_building("Courthouse", 10)
		print("[Corrupt] Courthouse disabled 10 turns at ", source_tile.tileName)


# ── STATE SECESSION ──────────────────────────────────────────────
func checkStateSecessionConditions() -> void:
	if playerCountry != "USA" or _republic_collapsed:
		return
	if playerCountryNode.presidentialClaim > -3.0:
		return  # Claim not low enough to enable secession

	# Find all USA states that have at least one tile with an active failure timer
	var states_at_risk: Dictionary = {}
	for tile in playerCountryNode.OwnedTileList:
		var sc: String = tile.tileContinent
		if sc in CANADIAN_STATES or sc == "" or sc == "DC":
			continue
		if tile.presidentFailedTimer > 0:
			states_at_risk[sc] = true

	for state_code in states_at_risk.keys():
		if playerCountryNode.CountryFlags.has("rebel_" + state_code):
			continue  # Already in rebellion
		# Look for at least one disloyal governor (loyalty ≤ –5) in this state
		for tile in $TileController.get_children():
			if tile.tileContinent != state_code or tile.tileOwner != "USA":
				continue
			if tile.tileGovernor != null and tile.tileGovernor.loyalty <= -5.0:
				print("[Secession] All conditions met — ", state_code, " declares independence!")
				_fire_state_secession(state_code)
				break


func _fire_state_secession(state_code: String) -> void:
	var tiles_to_seize: Array = []
	for tile in playerCountryNode.OwnedTileList.duplicate():
		if tile.tileContinent == state_code:
			tiles_to_seize.append(tile)
	if tiles_to_seize.is_empty():
		return

	var display_name: String = STATE_FULL_NAMES.get(state_code, "State of " + state_code)
	var rebel_country: country = _spawn_state_country(state_code, display_name)

	var metro_tile = null
	for tile in tiles_to_seize:
		playerCountryNode.OwnedTileList.erase(tile)
		rebel_country.addTile(tile)
		tile.record_conquest(state_code)

		if tile.terrain == "Metro" and metro_tile == null:
			metro_tile = tile

		if tile.tileGovernor != null:
			var gov = tile.tileGovernor
			playerCountryNode.unlockedGovernors.erase(gov)
			rebel_country.unlockedGovernors.append(gov)

		if tile.stationedArmy != null:
			var army = tile.stationedArmy
			if army.parentCountry == playerCountryNode:
				playerCountryNode.countryArmyList.erase(army)
				rebel_country.countryArmyList.append(army)
				army.parentCountry = rebel_country
				army.enemy = true  # Rebel armies are hostile to USA

	playerCountryNode.CountryFlags.append("rebel_" + state_code)
	playerCountryNode.presidentialClaim = clampf(
		playerCountryNode.presidentialClaim - 3.0, -10.0, 10.0)
	createNewEvent("STATE_REBEL_01", metro_tile)
	print("[Secession] ", display_name, " has seceded — ", tiles_to_seize.size(), " tiles lost.")


func _fire_state_reintegration(state_code: String, metro_tile) -> void:
	var rebel_country = null
	for c in aliveCountriesList:
		if c.CID == state_code:
			rebel_country = c
			break
	if rebel_country == null:
		return

	# Transfer all tiles the rebel country still holds back to USA
	var rebel_tiles: Array = rebel_country.OwnedTileList.duplicate()
	for tile in rebel_tiles:
		rebel_country.OwnedTileList.erase(tile)
		playerCountryNode.OwnedTileList.append(tile)
		tile.record_conquest("USA")
		if tile.stationedArmy != null:
			var army = tile.stationedArmy
			if army.parentCountry == rebel_country:
				rebel_country.countryArmyList.erase(army)
				playerCountryNode.countryArmyList.append(army)
				army.parentCountry = playerCountryNode
				army.enemy = false

	# Move governor references back to USA pool so event buttons can act on them
	for gov in rebel_country.unlockedGovernors.duplicate():
		rebel_country.unlockedGovernors.erase(gov)
		playerCountryNode.unlockedGovernors.append(gov)

	playerCountryNode.CountryFlags.erase("rebel_" + state_code)
	aliveCountriesList.erase(rebel_country)
	rebel_country.queue_free()

	playerCountryNode.presidentialClaim = clampf(
		playerCountryNode.presidentialClaim + 2.0, -10.0, 10.0)
	createNewEvent("STATE_REINTEGRATED_01", metro_tile)
	print("[Reintegration] ", STATE_FULL_NAMES.get(state_code, state_code), " reintegrated!")


func _execute_republic_collapse() -> void:
	print("[Collapse] Executing republic fragmentation...")

	# Find UK so we can hand over coastal tiles and set the peace flag
	var uk_country = null
	for c in aliveCountriesList:
		if c.CID == "UK":
			uk_country = c
			break

	if uk_country != null and not uk_country.CountryFlags.has("uk_usa_peace"):
		uk_country.CountryFlags.append("uk_usa_peace")

	# Snapshot — we mutate OwnedTileList as we go
	var usa_tiles: Array = playerCountryNode.OwnedTileList.duplicate()

	# ── Pass 1: categorise every USA tile ─────────────────────────
	var coastal_tiles: Array  = []            # → UK (Wetlands)
	var state_tile_groups: Dictionary = {}    # state_code → Array[Tile]

	for tile in usa_tiles:
		if tile.tileContinent == "DC":
			continue  # Washington stays with Ualani

		if tile.terrain == "Wetlands" and uk_country != null:
			coastal_tiles.append(tile)
			continue

		var sc: String = tile.tileContinent
		if sc == "":
			continue
		if not state_tile_groups.has(sc):
			state_tile_groups[sc] = []
		state_tile_groups[sc].append(tile)

	# ── Pass 2: coastal tiles → UK ─────────────────────────────────
	for tile in coastal_tiles:
		# Governors on coastal tiles are released — no longer under any presidency
		if tile.tileGovernor != null:
			var gov = tile.tileGovernor
			playerCountryNode.unlockedGovernors.erase(gov)
			gov.hired = false
			tile.tileGovernor = null
			tile.filledGovernorSlot = false

		# Armies on coastal tiles are captured/disbanded under peace terms
		if tile.stationedArmy != null:
			var army = tile.stationedArmy
			if army.parentCountry == playerCountryNode:
				playerCountryNode.countryArmyList.erase(army)
				tile.stationedArmy = null
				army.queue_free()

		playerCountryNode.OwnedTileList.erase(tile)
		uk_country.addTile(tile)
		tile.record_conquest("UK")
		print("[Collapse] Coastal annexation: ", tile.tileName, " → UK")

	# ── Pass 3: interior tiles → state countries ───────────────────
	for state_code in state_tile_groups.keys():
		var tiles: Array = state_tile_groups[state_code]
		var display_name: String = STATE_FULL_NAMES.get(state_code, "State of " + state_code)
		var state_country: country = _spawn_state_country(state_code, display_name)

		for tile in tiles:
			playerCountryNode.OwnedTileList.erase(tile)
			state_country.addTile(tile)
			tile.record_conquest(state_code)

			# Transfer governor: moves to state country's pool, stays on tile
			if tile.tileGovernor != null:
				var gov = tile.tileGovernor
				playerCountryNode.unlockedGovernors.erase(gov)
				state_country.unlockedGovernors.append(gov)

			# Transfer stationed USA army: becomes the state's garrison
			if tile.stationedArmy != null:
				var army = tile.stationedArmy
				if army.parentCountry == playerCountryNode:
					playerCountryNode.countryArmyList.erase(army)
					state_country.countryArmyList.append(army)
					army.parentCountry = state_country
					army.enemy = false

		print("[Collapse] ", display_name, " (", state_code, ") — ", tiles.size(), " tiles")

	print("[Collapse] USA retains ", playerCountryNode.OwnedTileList.size(), " tile(s):")
	for tile in playerCountryNode.OwnedTileList:
		print("[Collapse]   • ", tile.tileName)

	createNewEvent("COLLAPSE_02")


func _spawn_state_country(state_code: String, display_name: String) -> country:
	# Guard: return existing node if somehow called twice for the same state
	for c in aliveCountriesList:
		if c.CID == state_code:
			return c

	var new_country: country = countryNode.instantiate()
	new_country.name        = state_code + "_state"
	new_country.CID         = state_code
	new_country.NatName     = display_name
	new_country.NatAdj      = state_code
	new_country.isAlive     = true
	new_country.Player      = false
	new_country.AIPersonality      = "Passive"
	new_country.armyReinforceRate  = 5
	new_country.TotalDollars   = 50.0
	new_country.TotalFood      = 100
	new_country.TotalWood      = 50
	new_country.TotalMetal     = 20
	new_country.TotalWeapons   = 5
	new_country.TotalManpower  = 200
	new_country.TotalHappiness = 5.0
	new_country.TotalMandate   = 10

	aliveCountriesList.append(new_country)
	$CountryController.add_child(new_country)
	return new_country


func _fire_fort_disrepair_event() -> void:
	if not EventDatabase.event_can_fire("FORT_001", currentWorldTurn):
		return
	# Find a random owned Fortress tile that has a non-Ualani governor and isn't already in disrepair
	var candidates: Array = []
	for tile in playerCountryNode.OwnedTileList:
		if tile.terrain == "Fortress" \
				and not tile.fortDisrepair \
				and tile.tileGovernor != null \
				and tile.tileGovernor.governorType != "Ualani Carlisle":
			candidates.append(tile)
	if candidates.is_empty():
		return
	var target: Tile = candidates[randi() % candidates.size()]
	target.fortDisrepair = true
	EventDatabase.mark_event_fired("FORT_001", currentWorldTurn)
	createNewEvent("FORT_001", target)


# ── EVENT COOLDOWN HELPERS ───────────────────────────────────────
func _tick_event_cooldowns() -> void:
	var expired: Array = []
	for eid in _event_cooldowns.keys():
		_event_cooldowns[eid] -= 1
		if _event_cooldowns[eid] <= 0:
			expired.append(eid)
	for eid in expired:
		_event_cooldowns.erase(eid)

func _event_on_cooldown(event_id: String) -> bool:
	return _event_cooldowns.has(event_id)

func _start_cooldown(event_id: String, turns: int) -> void:
	_event_cooldowns[event_id] = turns


# ── CHAIN 5: HARVEST CRISIS ──────────────────────────────────────
func _check_harvest_crisis() -> void:
	if _event_on_cooldown("HARVEST_001"):
		return
	if playerCountryNode.TotalFood >= 50:
		return
	var candidates: Array = []
	for tile in playerCountryNode.OwnedTileList:
		for b in tile.tileBuildingsList:
			if b.buildingType == "Farm" and b.enabled:
				candidates.append(tile)
				break
	if candidates.is_empty():
		return
	var target: Tile = candidates[randi() % candidates.size()]
	_start_cooldown("HARVEST_001", 20)
	createNewEvent("HARVEST_001", target)
	print("[Harvest] Food crisis — firing HARVEST_001 at ", target.tileName)


# ── CHAIN 1: HARBOR THREAT ───────────────────────────────────────
func _check_harbor_threat() -> void:
	if _event_on_cooldown("HARBOR_001"):
		return
	var candidates: Array = []
	for tile in playerCountryNode.OwnedTileList:
		if not tile.has_neighbor_owned_by("UK"):
			continue
		for b in tile.tileBuildingsList:
			if b.buildingType == "Dock" and b.enabled:
				candidates.append(tile)
				break
	if candidates.is_empty():
		return
	var target: Tile = candidates[randi() % candidates.size()]
	_start_cooldown("HARBOR_001", 15)
	createNewEvent("HARBOR_001", target)
	print("[Harbor] Threat detected — firing HARBOR_001 at ", target.tileName)


# ── CHAIN 6: FORGE THREAT ────────────────────────────────────────
func _check_forge_threat() -> void:
	if _event_on_cooldown("FORGE_001"):
		return
	var candidates: Array = []
	for tile in playerCountryNode.OwnedTileList:
		if not tile.has_neighbor_owned_by("UK"):
			continue
		for b in tile.tileBuildingsList:
			if b.buildingType == "Forge" and b.enabled:
				candidates.append(tile)
				break
	if candidates.is_empty():
		return
	var target: Tile = candidates[randi() % candidates.size()]
	_start_cooldown("FORGE_001", 15)
	createNewEvent("FORGE_001", target)
	print("[Forge] Threat detected — firing FORGE_001 at ", target.tileName)


# ── CHAIN 2: CORRUPTION CRISIS ───────────────────────────────────
func _check_corruption_crisis() -> void:
	if _event_on_cooldown("CORRUPT_001"):
		return
	var candidates: Array = []
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileMoralDecay < 50:
			continue
		for b in tile.tileBuildingsList:
			if b.buildingType == "Courthouse" and b.enabled:
				candidates.append(tile)
				break
	if candidates.is_empty():
		return
	var target: Tile = candidates[randi() % candidates.size()]
	_start_cooldown("CORRUPT_001", 12)
	createNewEvent("CORRUPT_001", target)
	print("[Corrupt] Crisis — moral decay ", target.tileMoralDecay, " at ", target.tileName)


# ── CHAIN 9: BORDER DISPUTE ──────────────────────────────────────
func _check_border_dispute() -> void:
	if _event_on_cooldown("BORDER_001"):
		return
	var candidates: Array = []
	for tile in playerCountryNode.OwnedTileList:
		if tile.terrain not in ["Woods", "Foothills", "Wetlands"]:
			continue
		var has_ca_neighbor: bool = false
		for n in tile.TileNeighbors:
			if n.tileContinent in CANADIAN_STATES:
				has_ca_neighbor = true
				break
		if has_ca_neighbor:
			candidates.append(tile)
	if candidates.is_empty():
		return
	var target: Tile = candidates[randi() % candidates.size()]
	_start_cooldown("BORDER_001", 15)
	createNewEvent("BORDER_001", target)
	print("[Border] Dispute detected — firing BORDER_001 at ", target.tileName)


# ── CHAIN 3: STARVING GARRISON ───────────────────────────────────
func _check_garrison_hunger() -> void:
	if _event_on_cooldown("GARRISON_001"):
		return
	for army in playerCountryNode.countryArmyList:
		if not is_instance_valid(army) or army.deleteMode or army.inTile == null:
			continue
		if army.inTile.tileOwner != "USA":
			continue
		if army.manpowerInArmy < 50:
			_start_cooldown("GARRISON_001", 12)
			createNewEvent("GARRISON_001", army.inTile)
			print("[Garrison] Starving army at ", army.inTile.tileName)
			return


# ── CHAIN 8: LEGITIMACY CRISIS ───────────────────────────────────
func _check_legitimacy_crisis() -> void:
	if _event_on_cooldown("CRISIS_CLAIM_001"):
		return
	if playerCountryNode.presidentialClaim > -5.0:
		return
	_start_cooldown("CRISIS_CLAIM_001", 20)
	createNewEvent("CRISIS_CLAIM_001")
	print("[Crisis] Legitimacy crisis — claim at ", playerCountryNode.presidentialClaim)


# ── CHAIN 4: TURNED GENERAL ──────────────────────────────────────
func _check_turncoat_general() -> void:
	if _event_on_cooldown("TURNCOAT_001"):
		return
	var suspect_tile: Tile = null
	for tile in $TileController.get_children():
		if tile.tileOwner != "USA" or tile.tileGovernor == null:
			continue
		if tile.tileGovernor.loyalty <= -8.0:
			suspect_tile = tile
			break
	if suspect_tile == null:
		return
	_start_cooldown("TURNCOAT_001", 15)
	createNewEvent("TURNCOAT_001", suspect_tile)
	print("[Turncoat] Suspicious commander: ", suspect_tile.tileGovernor.governorType,
		" at ", suspect_tile.tileName)


func _generate_and_assign_governor(tile: Tile) -> void:
	var portrait_placeholder: Texture = load(
		"res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
	var candidates: Array = []
	for arch in ARCHETYPES:
		if tile.terrain in arch["terrain"]:
			candidates.append(arch)
	if candidates.is_empty():
		candidates = ARCHETYPES
	var chosen: Dictionary = candidates[randi() % candidates.size()]
	var pool_id: String = chosen["pools"][randi() % chosen["pools"].size()]
	var pool: Dictionary = NAME_POOLS.get(pool_id, NAME_POOLS["NP_01"])
	var gender: int = randi() % 3
	var first_list: Array
	match gender:
		0: first_list = pool["m"]
		1: first_list = pool["f"]
		_: first_list = pool["nb"]
	var last_list: Array = pool.get("l", [])
	var first: String = first_list[randi() % first_list.size()]
	var last: String = ""
	if last_list.size() > 0 and last_list[0] != "":
		last = last_list[randi() % last_list.size()]
	var full_name: String = (first + " " + last).strip_edges()
	var new_gov: governor = governor.new()
	new_gov.governorType        = full_name
	new_gov.governorArchetypeId = chosen["id"]
	new_gov.governorPosition    = chosen["position"]
	new_gov.governorLevel       = 1
	new_gov.governorDescription = "A " + chosen["name"] + " appointed to " + tile.tileName + " by presidential order."
	new_gov.governorBiography   = full_name + " was appointed following a change of command at " + tile.tileName + "."
	new_gov.governorTexture     = portrait_placeholder
	new_gov.hired               = true
	new_gov.loyalty             = float(randi_range(-6, 6))
	playerCountryNode.unlockedGovernors.append(new_gov)
	tile.tileGovernor      = new_gov
	tile.filledGovernorSlot = true
	$CanvasLayer/WarRoomPanel.registerCommanderArc(new_gov, tile)
	print("[Fort] Replacement governor generated: ", full_name, " at ", tile.tileName)

func evaluateTileEvents(tile) -> void:
	var to_fire = EventDatabase.evaluate_tile_triggers(tile, currentWorldTurn)
	for event_id in to_fire:
		createNewEvent(event_id, tile)

func evaluateStateLiberation(state_code: String) -> void:
	var to_fire = EventDatabase.evaluate_state_triggers(state_code, currentWorldTurn)
	for event_id in to_fire:
		createNewEvent(event_id)

func evaluateCommanderObjective(archetype_id: String, objective_num: int) -> void:
	var to_fire = EventDatabase.evaluate_commander_triggers(
		archetype_id, objective_num, currentWorldTurn)
	for event_id in to_fire:
		createNewEvent(event_id)

func evaluateProtectorSummon(protector_id: String) -> void:
	var to_fire = EventDatabase.evaluate_protector_triggers(
		protector_id, "protector_summon", currentWorldTurn)
	for event_id in to_fire:
		createNewEvent(event_id)

func _apply_resource_change(resource: String, amount: int) -> void:
	match resource:
		"gold", "dollars": playerCountryNode.TotalDollars  += amount  # "gold" kept for CSV compat
		"food":            playerCountryNode.TotalFood      += amount
		"wood":            playerCountryNode.TotalWood      += amount
		"metal":           playerCountryNode.TotalMetal     += amount
		"weapons":         playerCountryNode.TotalWeapons   += amount
		"faith", "culture":playerCountryNode.TotalCulture   += amount  # "faith" kept for compat
		"magic":           playerCountryNode.TotalMagic     += amount
		"science":         playerCountryNode.TotalScience   += amount
		"harmony", "happiness": playerCountryNode.TotalHappiness += amount  # "harmony" compat
		"boats":           playerCountryNode.TotalBoats     += amount
		"mandate":         playerCountryNode.TotalMandate   += amount
		"manpower":        playerCountryNode.TotalManpower  += amount

func _apply_morale_boost(amount: int) -> void:
	for Tile in playerCountryNode.OwnedTileList:
		Tile.corruption = max(0, Tile.corruption - int(amount * 0.5))

func _apply_army_buff(buff_type: String, duration: int, tile) -> void:
	for Army in playerCountryNode.countryArmyList:
		if tile == null or Army.inTile == tile:
			pass

func _summon_protector(protector_id: String, tile) -> void:
	createNewEvent("PROT_" + protector_id + "_SUMMON", tile)

func _get_spell_school(spell_name: String) -> String:
	match spell_name:
		"MANIFEST DESTINY SUBSIDY PROGRAM":        return "iron"
		"THOUGHTS & PRAYERS (FEDERAL ALLOCATION)": return "spectral"
		"UNAUTHORIZED WEATHER MODIFICATION ACT":   return "storm"
		# Presidential Powers — map to their protector's school
		"FEDERAL ATMOSPHERIC SURVEILLANCE ACT",
		"PINE BARRENS DEVELOPMENT MORATORIUM",
		"PACIFIC NORTHWEST PRIVACY PROTECTION ACT",
		"INTER-AGENCY CRYPTID INTEGRATION PROGRAM",
		"FLORIDA CRYPTID INTEGRATION TASK FORCE":  return "cryptid"
		"EXECUTIVE WEATHER CONTROL INITIATIVE",
		"CHESAPEAKE WATERS RECLAMATION PROJECT",
		"DEPARTMENT OF PSYCHOLOGICAL OPERATIONS":  return "storm"
		"CLASSIFIED TACTICAL TERROR BUDGET",
		"NAVAL SUPERIORITY MAINTENANCE DIRECTIVE",
		"COLD WEATHER RESILIENCE FUNDING ACT",
		"MIDNIGHT EMERGENCY MOBILIZATION ORDER",
		"PERMANENT READINESS MANDATE (EXPIRES NEVER)": return "iron"
		"FREEDOM RESONANCE AMPLIFICATION DECREE",
		"RURAL SPECTRAL INVESTMENT INITIATIVE",
		"EMANCIPATION PROCLAMATION 2: STILL EMANCIPATING": return "liberty"
		"MONUMENT-BASED ECONOMIC STIMULUS PACKAGE": return "manifest"
		"HEADLESS HORSEMAN": return "spectral"
		_: return "manifest"

func _find_or_create_leader(faction_name: String) -> governor:
	for gov in playerCountryNode.unlockedGovernors:
		if gov.governorType == faction_name:
			return gov
	var placeholder = governor.new()
	placeholder.buildSelf("Unknown Leader", 1)
	return placeholder

func _is_state_liberated(state_code: String, cid: String) -> bool:
	for Tile in $TileController.get_children():
		if Tile.tileContinent == state_code and Tile.tileOwner != cid:
			return false
	return true



func _on_right_click_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed('Right Click'):
		resetUI()
	pass # Replace with function body.

func resetUI():
	for Tile in $TileController.get_children():
		Tile.visible = true
	$TileController.normalMode()
	for Control in $CanvasLayer.get_children():
		Control.visible = false
		$CanvasLayer/PanelOpenerControl.visible = true
		$"CanvasLayer/Resource Bar (TOP)".visible = true
	pass

var lastSelectedPathPoint: pathPointButton
func updateArmyFunc(Army, pathPoint):
	$CanvasLayer/ArmyPanel/ArmyNameLabel.text = Army.ArmyName
	$CanvasLayer/ArmyPanel/AttackLabel.text = str(Army.armyPunch)
	$CanvasLayer/ArmyPanel/DefenseLabel.text = str(Army.armyBlock)
	$CanvasLayer/ArmyPanel/RangedAttackLabel.text = str(Army.armyLaunch)
	$CanvasLayer/ArmyPanel/RangedDefenseLabel.text = str(Army.armyDefence)
	$CanvasLayer/ArmyPanel/ManpowerLabel.text = str(Army.manpowerInArmy, " / ", Army.maxManpower)
	$CanvasLayer/ArmyPanel/ShieldLabel.text = str(Army.armyShield, " / ", Army.armyMaxShield)
	#$CanvasLayer/ArmyPanel/LocationLabel.text = str(pathPoint.pathNumber)
	if $CanvasLayer/ArmyPanel.visible == false:
		$CanvasLayer/ArmyPanel.visible = true
		lastSelectedPathPoint = pathPoint
	else:
		$CanvasLayer/ArmyPanel.visible = false
		lastSelectedPathPoint = null
	pass

func _on_path_control_show_army_info(key) -> void:
	match key:
		"Wait":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 60
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Wait"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Pause this unit for the turn."
		"Hold":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 110
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Hold"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Hold this unit indefinitely."
		"Melee":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 160
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Melee Attack"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Attack using this unit's melee strength - unit will sustain manpower casualties!"
		"Ranged":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 210
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Ranged Attack"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Attack using this unit's ranged strength - unit will lose weapons!"
		"Reinforce":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 260
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Reinforce"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Rebuild the manpower reserves of this unit."
		"Weapons":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 310
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Resupply"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Build up the supplies and weapons of this unit."
		"Shield":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 360
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Shield"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Grant half of this unit's defense to a nearby unit for this turn."
		"Close":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

#this is where the battles for melee are calculated
var calculateMelee: bool
func meleePressed(armyPath, thisArmy) -> void:
	if lastSelectedPathPoint != null:
		for pathPointButton in lastSelectedPathPoint.neighborPathPoints:
			pathPointButton.calculateBattle(armyPath, "melee", thisArmy, lastSelectedPathPoint)
	#set all apfs that are not neighbors to 'disabled' which makes them unclickable
	#set the world to 'melee attack calc' bool
	#if an apf is hovered over while in melee attack calc, build a battle and display results
	#if an apf is clicked while in melee attack calc, enact the battle and add damage/results
	
	pass # Replace with function body.

func rangedPressed(armyPath, thisArmy) -> void:
	if lastSelectedPathPoint != null:
		for pathPointButton in lastSelectedPathPoint.neighborPathPoints:
			pathPointButton.calculateBattle(armyPath, "ranged", thisArmy, lastSelectedPathPoint)
	pass # Replace with function body.

func updatePathPointsFunc(visibility):
	if visibility == false:
		$CanvasLayer/ArmyPanel/ArmyButtonsContainer.visible = false
	else:
		$CanvasLayer/ArmyPanel/ArmyButtonsContainer.visible = true
	pass

func newTileDevelopment(tileToDev, devType, devCivilian):
	for Tile in $TileController.get_children():
		if Tile.tileNumber == tileToDev.tileNumber:
			Tile.devChange(devType, devCivilian)
	pass


func giveSpellInfo(type, spellBranch):
	print("RETURN GIVE SPELL")
	var schoolPoints: String = LocBallUI.magicDic.schoolPoints
	var turnsUntil: String = LocBallUI.magicDic.turnsUntil
	var unlocked: String = LocBallUI.magicDic.spellUnlocked
	print("RETURN GIVE SPELL")
	var spellString: String
	var spellDesc: String
	var schoolType: String
	match type:
		"healingPotion":
			spellString = LocBallUI.magicDic.healingPotion
			spellDesc = LocBallUI.magicDic.healingPotionDesc
			schoolType = LocBallUI.magicDic.alchemy
		"draughtOfKnowledge":
			spellString = LocBallUI.magicDic.draughtOfKnowledge
			spellDesc = LocBallUI.magicDic.draughtOfKnowledgeDesc
			schoolType = LocBallUI.magicDic.alchemy
		"fireworks":
			spellString = LocBallUI.magicDic.fireworks
			spellDesc = LocBallUI.magicDic.fireworksDesc
			schoolType = LocBallUI.magicDic.alchemy
		"fleetingFoot":
			spellString = LocBallUI.magicDic.fleetingFoot
			spellDesc = LocBallUI.magicDic.fleetingFootDesc
			schoolType = LocBallUI.magicDic.alchemy
		"focusingDust":
			spellString = LocBallUI.magicDic.focusDust
			spellDesc = LocBallUI.magicDic.focusDustDesc
			schoolType = LocBallUI.magicDic.alchemy
		"goldenTouch":
			spellString = LocBallUI.magicDic.goldenTouch
			spellDesc = LocBallUI.magicDic.goldenTouchDesc
			schoolType = LocBallUI.magicDic.alchemy
		"paralysis":
			spellString = LocBallUI.magicDic.paralysis
			spellDesc = LocBallUI.magicDic.paralysisDesc
			schoolType = LocBallUI.magicDic.alchemy
		"poison":
			spellString = LocBallUI.magicDic.poison
			spellDesc = LocBallUI.magicDic.poisonDesc
			schoolType = LocBallUI.magicDic.alchemy
		"slimeSoldier":
			spellString = LocBallUI.magicDic.slimeSoldier
			spellDesc = LocBallUI.magicDic.slimeSoldierDesc
			schoolType = LocBallUI.magicDic.alchemy
		"slimeSpitter":
			spellString = LocBallUI.magicDic.slimeSpitter
			spellDesc = LocBallUI.magicDic.slimeSpitterDesc
			schoolType = LocBallUI.magicDic.alchemy
		"slimeWeapons":
			spellString = LocBallUI.magicDic.slimeWeapons
			spellDesc = LocBallUI.magicDic.slimeWeaponsDesc
			schoolType = LocBallUI.magicDic.alchemy
		"waterbreathing":
			spellString = LocBallUI.magicDic.waterbreathing
			spellDesc = LocBallUI.magicDic.waterbreathingDesc
			schoolType = LocBallUI.magicDic.alchemy
	spellBranch.giveSpellInfo(schoolPoints, turnsUntil, unlocked, spellString, spellDesc, schoolType)
	pass

func _on_belief_control_purchased_belief(beliefName, beliefCost) -> void:
	#print(beliefName, beliefCost, "WORLD SIGNALRECEIVED")
	playerCountryNode.addReligiousBelief(beliefName)
	playerCountryNode.payBill("faith", beliefCost)
	$CanvasLayer/BeliefControl.updateSelf()
	pass # Replace with function body.


func _on_government_control_slider_changed(amount, type) -> void:
	playerCountryNode.setNewTaxAmount(amount, type)
	pass # Replace with function body.

func _on_civilian_button_pressed() -> void:
	$CanvasLayer/CivilianControl.updateCivilians()
	if $CanvasLayer/CivilianControl.visible == true:
		$CanvasLayer/CivilianControl.visible = false
	else:
		$CanvasLayer/CivilianControl.visible = true
	pass # Replace with function body.

var milModScene = load("res://mil_mod.tscn")

func updateCivFunc(civ, pathPoint):
	$CanvasLayer/CivilianUnitControl/ToolIcon.texture = civ.civilianTool.toolImage
	$CanvasLayer/CivilianUnitControl/KitIton.texture = civ.civilianKit.kitImage
	if $CanvasLayer/CivilianUnitControl/MilModGridContainer.get_children != null:
		for MilMod in $CanvasLayer/CivilianUnitControl/MilModGridContainer.get_children():
			$CanvasLayer/CivilianUnitControl/MilModGridContainer.remove_child(MilMod)
	for MilMod in civ.milMods:
		var newMilMod = milModScene.instantiate()
		newMilMod.buildSelf(MilMod.milModType)
		$CanvasLayer/CivilianUnitControl/MilModGridContainer.add_child(newMilMod)
	calculateCivilianButtons(civ, pathPoint.ppbTile)
	if $CanvasLayer/ArmyPanel.visible == true:
		$CanvasLayer/ArmyPanel.visible = false
	if $CanvasLayer/CivilianUnitControl.visible == false:
		$CanvasLayer/CivilianUnitControl.visible = true
	else:
		$CanvasLayer/CivilianUnitControl.visible = false
	pass

func calculateCivilianButtons(civ, ppbTile):
	$CanvasLayer/CivilianUnitControl/CivilianActionButtons.updateUI(playerCountryNode.CID, civ, civ.civilianTool.toolName, civ.civilianKit.kitType, ppbTile)
	pass

func _on_colonize_button_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.colonizeTile()
	pass # Replace with function body.

func updateCountryTiles(colonizedTile):
	if colonizedTile.tileOwner != null:
		for country in aliveCountriesList:
			if country.CID == colonizedTile.tileOwner:
				country.addTile(colonizedTile)
	pass

func _on_increase_agricultural_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.agricultureTile()
	pass # Replace with function body.

func _on_increase_resource_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.resourceTile()
	pass # Replace with function body.

func _on_increase_urban_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.urbanTile()
	pass # Replace with function body.

func _on_increase_elite_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.eliteTile()
	pass # Replace with function body.

func _on_increase_military_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.militaryTile()
	pass # Replace with function body.

func _on_clear_corruption_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.fightCorruptionTile()
	pass # Replace with function body.

func _on_discover_nearby_tiles_button_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.discoverNearby()
	pass # Replace with function body.

func _on_building_info_panel_fill_with_unlocked_buildings() -> void:
	for building in playerCountryNode.unlockedBuildings:
		$CanvasLayer/BuildingInfoPanel.addNewBuildingButton(building)
	pass # Replace with function body.

func addNewBuildingToTile(buildingType, goldCalculatedCost, foodCalculatedCost, woodCalculatedCost, metalCalculatedCost, thisTile,player):
	thisTile.addBuilding(buildingType, 1)
	playerCountryNode.TotalDollars -= goldCalculatedCost
	playerCountryNode.TotalFood -= foodCalculatedCost
	playerCountryNode.TotalWood -= woodCalculatedCost
	playerCountryNode.TotalMetal -= metalCalculatedCost
	$CanvasLayer/BuildingInfoPanel/AddBuildingControl.visible = false
	$CanvasLayer/BuildingInfoPanel.displayBuildingInfo(thisTile)
	pass

func _on_spell_schools_control_ask_for_info(type, SpellUnlock) -> void:
	giveSpellInfo(type, SpellUnlock)
	pass # Replace with function body.

func _on_spell_schools_control_calculate_player_outputs(spellSchools) -> void:
	calculatePlayerOutputs(spellSchools)
	pass # Replace with function body.

func tileSiegeWon(tile, oldCID: String, newCID: String) -> void:
	for country in aliveCountriesList:
		if country.CID == oldCID:
			country.OwnedTileList.erase(tile)
		if country.CID == newCID:
			country.addTile(tile)
	tile.record_conquest(newCID)
	evaluateTileEvents(tile)
	var state_code = tile.tileContinent
	if state_code != "" and _is_state_liberated(state_code, newCID):
		evaluateStateLiberation(state_code)

	# Reintegration: USA recaptures a state capitol (Metro + courthouse) from a rebel state
	if newCID == "USA" and tile.terrain == "Metro" and state_code != "":
		var has_courthouse: bool = tile.buildings.get("courthouse", 0) > 0
		if has_courthouse and playerCountryNode.CountryFlags.has("rebel_" + state_code):
			_fire_state_reintegration(state_code, tile)

	# Memorial: UK captures a tile with special features — fire rescue event
	if newCID == "UK" and playerCountry == "USA" and tile.tileSpecialFeatures.size() > 0:
		var mem_flag: String = "memorial_mission_" + str(tile.tileNumber)
		if not playerCountryNode.CountryFlags.has(mem_flag):
			createNewEvent("MEMORIAL_001", tile)
			print("[Memorial] UK occupied special feature tile: ", tile.tileName)

func _on_next_turn_pressed() -> void:
	playerCountryNode.surveyResources()
	for pathPointButton in $PathControl/PathPointsControl.get_children():
		if pathPointButton.get_children() != null:
			#print(pathPointButton.get_children(), "DEBUG PATHPOINTBUTTONCHILDREN")
			for civilianPathFollow in pathPointButton.get_children():
				if civilianPathFollow.is_class("Button") != true:
					civilianPathFollow.emitTileChange()
	$CanvasLayer/SpellSchoolsControl.updateMagicAmounts(playerCountryNode)
	for country in aliveCountriesList:
		if country != playerCountryNode:
			country.calculateTurn()
	# Check War Room arc objectives (auto-detects completion, no player input needed)
	$CanvasLayer/WarRoomPanel.checkObjectives(
		$TileController.get_children(), currentWorldTurn)
	$CanvasLayer/TechTree.investInTech(playerCountryNode.SPM)
	currentWorldTurn += 1
	_advance_fortnight()
	_apply_winter_army_drain()
	evaluateDateEvents()
	for Tile in $TileController.get_children():
		Tile.tick_conquest_timer()
	$CanvasLayer/TurnLabel.text = _format_game_date()
	pass # Replace with function body.

# ── DATE SYSTEM ──────────────────────────────────────────────────────────────
# Each turn represents one fortnight (14 days).
# Calendar: 25-day months, 12 months per year (300-day year).
# Game starts month=6 year=673 (equivalent to June 1775).
# At ~26 fortnights per year, four years ≈ 104 turns — one presidential term.
func _advance_fortnight() -> void:
	var FORTNIGHT: int = 14
	var DAYS_PER_MONTH: int = 25
	var MONTHS_PER_YEAR: int = 12
	dayOfMonth += FORTNIGHT
	day += FORTNIGHT
	if dayOfMonth > DAYS_PER_MONTH:
		dayOfMonth -= DAYS_PER_MONTH
		month += 1
		if month > MONTHS_PER_YEAR:
			month = 1
			year += 1
		# Broadcast season change to all tiles
		emit_signal("calculateSeason", month)

func _format_game_date() -> String:
	var month_names: Array = [
		"January","February","March","April","May","June",
		"July","August","September","October","November","December"
	]
	var mname: String = month_names[month - 1] if (month >= 1 and month <= 12) else ("Month " + str(month))
	return mname + " " + str(year)

# ── WINTER ARMY SUPPLY DRAIN ─────────────────────────────────────────────────
# During winter months (Nov–Feb), armies stationed in cold-winter tiles consume
# extra food from the national stockpile.  Tropical/storm tiles (negative
# winterScore) are excluded — they have hurricane penalties, not cold ones.
#
# Drain per army per fortnight, keyed to tile.get_winter_army_modifier():
#   modifier 1.0  (mild/no winter)  → 0 food
#   modifier 0.85 (cold winter)     → 3 food
#   modifier 0.65 (harsh winter)    → 7 food
#   modifier 0.40 (blizzard)        → 12 food
#
# Formula: drain = int((1.0 - modifier) * 20)
# Scale factor 20 keeps numbers small enough that a well-stocked nation
# survives one winter but not two back-to-back without granaries.
#
# Snow-adapted armies (future: armyTags contains "Cold Weather") will bypass
# this drain — see snow adapter design note in army.gd.
func _apply_winter_army_drain() -> void:
	var is_winter: bool = (month == 11 or month == 12 or month == 1 or month == 2)
	if not is_winter:
		return
	var total_drain: int = 0
	for army in playerCountryNode.countryArmyList:
		if army.inTile == null:
			continue
		# Negative winterScore = tropical / hurricane territory — no cold drain
		if army.inTile.winterScore <= 0:
			continue
		# Armies with Cold Weather tag are adapted — no supply drain
		if army.armyTags.has("Cold Weather"):
			continue
		var modifier: float = army.inTile.get_winter_army_modifier()
		# modifier == 1.0 means mild winter zone, no penalty
		if modifier >= 1.0:
			continue
		var drain: int = int((1.0 - modifier) * 20)
		total_drain += drain
	if total_drain > 0:
		playerCountryNode.TotalFood = max(0, playerCountryNode.TotalFood - total_drain)

#======
#saving functionality
#======

func saveCountryStatesToFile() -> void:
	var country_states = {}
	for country in aliveCountriesList:
		country_states[country.CID] = country.save_state()
	var save_file = FileAccess.open("user://save_countries.json", FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(country_states))
		save_file.close()
		print("World: Country states saved.")
	else:
		push_error("World: Could not save country states.")
 
 
func loadCountryStatesFromFile() -> Dictionary:
	if not FileAccess.file_exists("user://save_countries.json"):
		return {}
	var save_file = FileAccess.open("user://save_countries.json", FileAccess.READ)
	if not save_file:
		return {}
	var json = JSON.new()
	var error = json.parse(save_file.get_as_text())
	save_file.close()
	if error != OK:
		push_error("World: Failed to parse country save file.")
		return {}
	return json.get_data()

func save_all_armies(aliveCountriesList: Array) -> Array:
	var all_armies = []
	for country in aliveCountriesList:
		for army in country.countryArmyList:
			all_armies.append(save_army_state(army, country.CID))
	return all_armies
 
func save_army_state(army: Army, parentCID: String) -> Dictionary:
	var state = {
		"armyName":          army.ArmyName,
		"parentCID":         parentCID,
		"inTileNumber":      army.inTile.tileNumber if army.inTile != null else 0,
		"inRetreat":         army.inRetreat,
		"raised":            army.raised,
		"deleteMode":        army.deleteMode,
 
		# Spell state
		"armySpell":         army.armySpell.spellType if army.has_active_spell() else "",
		"armySpellDuration": army.armySpellDuration,
		"armySpellCasterCID":army.armySpellCaster.CID if army.armySpellCaster != null else "",
 
		# Unit states
		"units": _save_unit_states(army),
	}
	return state
 
func _save_unit_states(army: Army) -> Array:
	var units = []
	for unit in army.unitsList:
		units.append({
			"unitType":       unit.unitType,
			"unitLevel":      unit.unitLevel,
			"weaponType":     unit.unitWeapon.weaponType if unit.unitWeapon != null else "",
			"uniformType":    unit.unitArmor.armorType if unit.unitArmor != null else "",
			"oreType":        unit.unitOre.oreType if unit.unitOre != null else "",
			"currentManpower":unit.unitCurrentManpower,
			"currentWeapons": unit.unitCurrentWeapons,
			"currentShield":  unit.unitShield,
			"reloadCounter":  unit.reloadCounter,
		})
	return units


func load_army_states_from_file() -> Array:
	if not FileAccess.file_exists("user://save_armies.json"):
		return []
	var save_file = FileAccess.open("user://save_armies.json", FileAccess.READ)
	if not save_file:
		return []
	var json = JSON.new()
	var error = json.parse(save_file.get_as_text())
	save_file.close()
	if error != OK:
		push_error("ArmyDatabase: Failed to parse army save file.")
		return []
	return json.get_data()
 
func save_army_states_to_file(aliveCountriesList: Array) -> void:
	var all_armies = save_all_armies(aliveCountriesList)
	var save_file = FileAccess.open("user://save_armies.json", FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(all_armies))
		save_file.close()
		print("ArmyDatabase: ", all_armies.size(), " armies saved.")
	else:
		push_error("ArmyDatabase: Could not write army save file.")


# WORLD.GD ADDITIONS
# Add to existing save/load functions
# ============================================================
 
# func saveGameState() -> void:
#     saveTileStatesToFile()          # tiles
#     saveCountryStatesToFile()       # countries
#     ArmyDatabase.save_army_states_to_file(aliveCountriesList)  # armies
 
# func loadGameState() -> void:
#     var tileStates    = loadTileStatesFromFile()
#     var countryStates = loadCountryStatesFromFile()
#     var armyStates    = ArmyDatabase.load_army_states_from_file()
#     # ... then initialize tiles, countries, then restore armies
