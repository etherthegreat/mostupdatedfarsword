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
var _hover_saved_mapMode: String = ""

# Populated by generateBarracksCommanders() — shared by _generate_and_assign_governor()
var _usa_archetypes: Array = []
var _usa_name_pools: Dictionary = {}

var _republic_collapsed: bool = false
var _ca_collapsed: bool = false
var _game_ended: bool = false
var _mission_timers: Dictionary = {}   # flag_key → turns_remaining until expiry
var _event_cooldowns: Dictionary = {}  # event_id → turns_remaining before can fire again
var _anarchist_armies: Array = []      # anarchist armies that auto-attack UK each turn
var _commander_turns: Dictionary = {}  # "TileName:CommanderName" → turns_served
var _vp_governor = null                # reference to the assigned Vice President governor
var _vp_faction: String = ""           # game faction name belonging to the VP
var _ca_vp_governor = null             # reference to Marc Penoit as CA Deputy Governor
var _ca_vp_faction: String = ""        # faction of CA's Deputy Governor
var _peace_dock_was_uk: Dictionary = {}  # tile_num → bool; tracks UK ownership flip per turn
var _ai_combat_log: Array = []           # entries collected during AI resolution each round
var _ai_playback_queue: Array = []       # AI battles recorded this round, replayed with camera + pauses
var _ai_recording_country = null         # which AI country is currently taking its turn
var _skip_ai_playback: bool = false      # fast-forward the replay
var _playing_ai: bool = false            # true while the AI-turn replay runs
var _stashed_atk_loss: int = 0           # losses from a real battle, attached to the next attack record
var _stashed_def_loss: int = 0
var _floating_damage_scene = preload("res://floating_damage_number.tscn")
var _peace_last_freed_tile = null        # most-recently freed peace dock tile node
var isCoopMode: bool = false             # true when both USA and CA are player-controlled
var coopCountryNode    # second player's country in co-op mode
var _player_turn_order: Array = []       # ordered CIDs of player-controlled countries
var _turn_phase_index: int = 0           # which slot in _player_turn_order is active

const CANADIAN_STATES = ["CA - QB", "CA - OT", "CA - NB", "CA - NS", "CA - PEI"]

# Maps named governor display names → their in-game faction name
const VP_FACTION_MAP: Dictionary = {
	"Patrick Henry":    "Sons of Liberty",
	"Abigail Adams":    "Continental Congress",
	"Thomas Paine":     "Free Workers Union",
	"Mercy Otis Warren":"Abolitionist League",
	"Daniel Shays":     "Common Cause",
	"Benjamin Tallmadge":"Sons of Liberty",
	"Phillis Wheatley": "Abolitionist League",
	"Francis Asbury":   "Common Cause",
}

const PROTECTOR_IDS: Array = [
	"PROT_01", "PROT_02", "PROT_03", "PROT_04", "PROT_05",
	"PROT_06", "PROT_07", "PROT_08", "PROT_09", "PROT_10",
	"PROT_11", "PROT_12", "PROT_13", "PROT_15",
	"PROT_16", "PROT_17"
]

const PROTECTOR_SUMMON_TURNS: Dictionary = {
	"PROT_01": 10,  "PROT_02": 15,  "PROT_03": 20,  "PROT_04": 25,
	"PROT_05": 30,  "PROT_06": 35,  "PROT_07": 40,  "PROT_08": 45,
	"PROT_09": 50,  "PROT_10": 55,  "PROT_11": 60,  "PROT_12": 65,
	"PROT_13": 70,  "PROT_15": 80,  "PROT_16": 85,
	"PROT_17": 90
}

# Maps each USA protector to their home tile number.
# These tiles get a Tower built and the protector assigned as wizard when the player agrees.
const USA_PROT_TILES: Dictionary = {
	"PROT_01":  46,   # Mothman               — Harper's Ferry, WV (Appalachian Minerals)
	"PROT_02":  23,   # Jersey Devil          — Lakewood, NJ (Pine Barrens wetlands)
	"PROT_03": 145,   # Bigfoot               — Asheville, NC (Blue Ridge Highlands)
	"PROT_04": 139,   # Thunderbird           — Buffalo, NY (Niagara / Great Lakes storms)
	"PROT_05":  17,   # Headless Horseman     — Peekskill, NY (Hudson Valley)
	"PROT_06":  37,   # Chessie               — Baltimore, MD (Chesapeake Shipyards)
	"PROT_07": 165,   # Bell Witch            — Nashville, TN
	"PROT_08":  65,   # Old Ironsides         — Boston, MA (Charlestown Navy Yard)
	"PROT_09":   1,   # Valley Forge Guardian — Valley Forge, PA
	"PROT_10":  42,   # Snallygaster          — Frederick, MD
	"PROT_11":  61,   # Paul Revere           — Lexington, MA (Lexington Cry)
	"PROT_12":   2,   # Liberty Bell          — Philadelphia, PA (Liberty Bell)
	"PROT_13":  80,   # Green Mountain Ghost  — Montpelier, VT (Green Mountains)

	"PROT_15": 177,   # Skunk Ape             — Gainesville, FL (Wetlands)
	"PROT_16":  71,   # Eternal Minuteman     — Springfield, MA (Gun Valley / Armory)
	"PROT_17": 188,   # Lincoln's Ghost       — Washington, DC (White House)
}

# ── CANADIAN PROTECTORS ───────────────────────────────────────────────────────
# Eight creatures from Algonquin, Mi'kmaq, and French-Canadian folklore.
# Each anchored to a specific CA-owned tile.  Fire as dispatches from Jessica
# Commanda to President Carlisle regardless of alliance status.
const CA_PROT_IDS: Array = [
	"CA_PROT_01", "CA_PROT_02", "CA_PROT_03", "CA_PROT_04",
	"CA_PROT_05", "CA_PROT_06", "CA_PROT_07", "CA_PROT_08"
]

const CA_PROT_SUMMON_TURNS: Dictionary = {
	"CA_PROT_01":  8, "CA_PROT_02": 13, "CA_PROT_03": 18, "CA_PROT_04": 23,
	"CA_PROT_05": 28, "CA_PROT_06": 33, "CA_PROT_07": 38, "CA_PROT_08": 43
}

# Maps CA_PROT_ID → tile number where the creature lives
const CA_PROT_TILES: Dictionary = {
	"CA_PROT_01":  99,   # Le Wendigo        — Saint-Georges, QC (Woods)
	"CA_PROT_02": 105,   # Le Loup-Garou     — Rivière-du-Loup, QC (Woods)
	"CA_PROT_03": 194,   # Les Feux Follets  — Saint John, NB (Wetlands)
	"CA_PROT_04": 131,   # Mishepeshu        — Barrie, ON (Wetlands)
	"CA_PROT_05": 106,   # La Corriveau      — Trois-Pistoles, QC (Woods)
	"CA_PROT_06": 193,   # Le Carcajou       — Moncton, NB (Woods)
	"CA_PROT_07": 128,   # La Chasse-Galerie — Deep River, ON (Woods)
	"CA_PROT_08": 109,   # Le Gougou         — Bathurst, NB (Farmlands)
}

# Dock tiles that must be liberated for peace — Nassau (182, BA) excluded
const PEACE_DOCK_USA: Array = [65, 66, 67, 151]  # Boston/MA, Plymouth/MA, Nantucket/MA, Charleston/SC
const PEACE_DOCK_CA:  Array = [114, 123, 195]     # Halifax/CA-NS, Quebec City/CA-QB, Anticosti/CA-QB

# Loyal governor dispatch system
const GOV_LOYAL_THRESHOLD: float = 8.0   # minimum loyalty to be eligible
const GOV_LOYAL_CHANCE:    float = 0.03  # 3% per governor per turn

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
	if worldCreation:
		$CanvasLayer/LoadingSprite.rotation += 1

func updateResourceBar() -> void:
	if playerCountryNode == null:
		return
	$"CanvasLayer/Resource Bar (TOP)/container/FoodLabel/Label".text = str(playerCountryNode.TotalFood)
	$"CanvasLayer/Resource Bar (TOP)/container/GoldLabel/Label".text = str(playerCountryNode.TotalDollars)
	$"CanvasLayer/Resource Bar (TOP)/container/WoodLabel/Label".text = str(playerCountryNode.TotalWood)
	$"CanvasLayer/Resource Bar (TOP)/container/MetalLabel/Label".text = str(playerCountryNode.TotalMetal)
	$"CanvasLayer/Resource Bar (TOP)/container/WeaponsLabel/Label".text = str(playerCountryNode.TotalWeapons)
	$"CanvasLayer/Resource Bar (TOP)/container/ScienceLabel/Label".text = str(playerCountryNode.SPM)
	$"CanvasLayer/Resource Bar (TOP)/container/FaithLabel/Label".text = str(playerCountryNode.TotalCulture)
	$"CanvasLayer/Resource Bar (TOP)/container/MagicLabel/Label".text = str(playerCountryNode.TotalMagic)
	$"CanvasLayer/Resource Bar (TOP)/container/CultureLabel/Label".text = str(playerCountryNode.TotalCulture)
	$"CanvasLayer/Resource Bar (TOP)/container/MandateLabel/Label".text = str(playerCountryNode.TotalMandate)
	$"CanvasLayer/Resource Bar (TOP)/container/HarmonyLabel/Label".text = str(playerCountryNode.TotalHappiness)
	$"CanvasLayer/Resource Bar (TOP)/container/InfluenceLabel/Label".text = str(playerCountryNode.TotalInfluence)
	$"CanvasLayer/Resource Bar (TOP)/container/ManpowerLabel/Label".text = str(playerCountryNode.TotalManpower)

func _refresh_next_turn_ui() -> void:
	var has_tech := $CanvasLayer/TechTree.investmentTech != null
	$CanvasLayer/NextTurnControl/NextTurn.visible = has_tech
	$CanvasLayer/NextTurnControl/PickTech.visible = not has_tech

const RESOURCE_MAP_MODES := ["MapFood","MapWood","MapMetal","MapFaith","MapHappiness",
	"MapManpower","MapWeapons","MapDollars","MapMagic","MapMandate","MapOutputs"]

func updateMap() -> void:
	if mapMode in RESOURCE_MAP_MODES:
		for tile in $TileController.get_children():
			if tile.tileOwner == playerCountry:
				tile.calculateOutputsForMap(playerCountryNode)
	$TileController.updateTiles(mapMode, displayCorruption, playerCountryNode)


var currentWorldTurn: int = 0

signal calculateSeason
func newGameBuild(CID, gameLang, isCoop: bool = false):
	currentWorldTurn = 1
	worldCreation = true
	isCoopMode = isCoop
	gameLanguage = gameLang
	var locBallUIWorld = locBallUIScene.instantiate()
	locBallUIWorld.buildSelf("Game", gameLanguage)
	LocBallUI = locBallUIWorld
	add_child(locBallUIWorld)
	$CanvasLayer/LoadingLabel.text = "Building World"
	month = 7       # July
	year = 2026
	day = 0
	dayOfMonth = 4  # July 4, 2026 — inauguration day
	age = 2
	armyMode = false
	$TileController.connectTileSignals()
	$TileController.transfer.connect(calculateTileEvent)
	for Tile in $TileController.get_children():
		Tile.onNewGame()
		Tile.calculateSeason(month)
		Tile.clicked.connect(tileClicked)
		Tile.tile_hovered.connect(func(t): _hovered_tile = t)
		Tile.tile_unhovered.connect(func(t): if _hovered_tile == t: _hovered_tile = null)
		Tile.censusComplete.connect(manaUpdate)
		Tile.tileSpawnPoint = $PathControl/PathPointsControl.get_node_or_null(str(Tile.EXPTileNumber))
	$CanvasLayer/LoadingLabel.text = "Spawning Countries"
	$CanvasLayer/LoadingProgressBar.value = 25
	spawnNewGameCountries(CID)
	connectCountrySignals()
	_raise_starting_armies()
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
	mapMode = "Polis"
	displayCorruption = true
	updatePlayerUI()
	for Tile in $TileController.get_children():
		Tile.discoverTile()
	worldCreation = false
	$RightClickDetector.visible = true
	$CanvasLayer/LoadingProgressBar.value = 100
	$CanvasLayer/LoadingBackground.visible = false
	$CanvasLayer/LoadingSprite.visible = false
	$CanvasLayer/LoadingProgressBar.visible = false
	$CanvasLayer/LoadingLabel.visible = false
	generateBarracksCommanders()
	spawnStartingArmies()
	# Populate AI country commanders and armies at barracks tiles
	for ai_country in aliveCountriesList:
		if ai_country.Player:
			continue
		match ai_country.CID:
			"CA":
				_generate_ai_barracks_commanders(ai_country)
				_spawn_ai_starting_armies(ai_country)
	var coop_country_id: String = "COOP" if isCoopMode else playerCountry
	$CanvasLayer/WarRoomPanel.setupAllProtectors($TileController.get_children(), coop_country_id)
	_assign_vice_president()
	_build_turn_order()
	$CanvasLayer/MilitaryPanelControl.trimEmptyButtons()
	updateMap()
	evaluateDateEvents()
	_seed_opening_journal_entry()

# ── BARRACKS COMMANDER GENERATION ───────────────────────────────────────────
# Assigns a governor to the faction with the fewest current members.
# Skips if the governor already belongs to a valid faction in the list.
func _assign_governor_to_faction(gov: governor) -> void:
	if playerCountryNode == null or playerCountryNode.countryFactionList.is_empty():
		return
	for fac in playerCountryNode.countryFactionList:
		if gov.governorFaction == fac.factionName:
			return
	var best_faction: String = ""
	var best_count: int = 999
	for fac in playerCountryNode.countryFactionList:
		var count: int = 0
		for g in playerCountryNode.unlockedGovernors:
			if g.governorFaction == fac.factionName:
				count += 1
		if count < best_count:
			best_count = count
			best_faction = fac.factionName
	if best_faction != "":
		gov.governorFaction = best_faction

# Scans every tile owned by the player at game start.  For each Barracks tile
# a procedural governor is built using a terrain-matched archetype and a name
# drawn from the appropriate cultural name pool.  The governor is added to the
# player's unlocked pool AND registered in the War Room as a CommanderArcEntry.
func _apply_archetype_mods(gov: governor, arc_id: String) -> void:
	match arc_id:
		"ARC_01":
			gov.addMilMod("Experienced Fisherman", 123)
			gov.addMilMod("Master Baiter",          23)
			gov.addMilMod("Marine",                  3)
		"ARC_02":
			gov.addMilMod("Appalachian Hill Fighter", 123)
			gov.addMilMod("Explosives Expert",         23)
			gov.addMilMod("Mountain Pathfinder",        3)
		"ARC_03":
			gov.addMilMod("Student Body Commander", 123)
			gov.addMilMod("Field Research",          23)
			gov.addMilMod("Cultural Corps",           3)
		"ARC_04":
			gov.addMilMod("Swamp Legs",       123)
			gov.addMilMod("Saber Drill",      123)
			gov.addMilMod("Guerrilla Tactics", 23)
			gov.addMilMod("Last Stand",         3)
		"ARC_05":
			gov.addMilMod("Farmhand",         123)
			gov.addMilMod("Hill Runner",      123)
			gov.addMilMod("Corrupted Ground",  23)
			gov.addMilMod("Liberator's Will",   3)
		"ARC_06":
			gov.addMilMod("Coastal Watch",    123)
			gov.addMilMod("Powder & Shot",    123)
			gov.addMilMod("Double Shot",       23)
			gov.addMilMod("Double Cannonade",   3)
		"ARC_07":
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Marksman",         123)
			gov.addMilMod("Night Raider",      23)
			gov.addMilMod("Ghost March",        3)
		"ARC_08":
			gov.addMilMod("Farmhand",         123)
			gov.addMilMod("Quick Reload",     123)
			gov.addMilMod("Corrupted Ground",  23)
			gov.addMilMod("The Long March",     3)
		"ARC_09":
			gov.addMilMod("Steady Line",      123)
			gov.addMilMod("Fortified Position",123)
			gov.addMilMod("Rallying Voice",    23)
			gov.addMilMod("Undaunted",          3)
		"ARC_10":
			gov.addMilMod("Woodsman",         123)
			gov.addMilMod("Swamp Legs",       123)
			gov.addMilMod("Guerrilla Tactics", 23)
			gov.addMilMod("Ghost March",        3)
		"ARC_11":
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Saber Drill",      123)
			gov.addMilMod("Rallying Voice",    23)
			gov.addMilMod("Terror",             3)
		"ARC_12":
			gov.addMilMod("Steady Line",      123)
			gov.addMilMod("Fortified Position",123)
			gov.addMilMod("Cleaner",           23)
			gov.addMilMod("Liberator's Will",   3)
		"ARC_13":
			gov.addMilMod("Coastal Watch",    123)
			gov.addMilMod("Marksman",         123)
			gov.addMilMod("Marine",            23)
			gov.addMilMod("Naval Supremacy",    3)
		"ARC_14":
			gov.addMilMod("Woodsman",         123)
			gov.addMilMod("Hill Runner",      123)
			gov.addMilMod("Rallying Voice",    23)
			gov.addMilMod("Undaunted",          3)
		"ARC_15":
			gov.addMilMod("Fortified Position",123)
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Flanking Drill",    23)
			gov.addMilMod("Iron Wall",          3)
		"ARC_16":
			gov.addMilMod("Powder & Shot",    123)
			gov.addMilMod("Fortified Position",123)
			gov.addMilMod("Siege Line",        23)
			gov.addMilMod("Double Cannonade",   3)
		"ARC_17":
			gov.addMilMod("Farmhand",         123)
			gov.addMilMod("Saber Drill",      123)
			gov.addMilMod("Guerrilla Tactics", 23)
			gov.addMilMod("Last Stand",         3)
		"ARC_18":
			gov.addMilMod("Swamp Legs",       123)
			gov.addMilMod("Coastal Watch",    123)
			gov.addMilMod("Cleaner",           23)
			gov.addMilMod("Terror",             3)
		"ARC_19":
			gov.addMilMod("Coastal Watch",    123)
			gov.addMilMod("Saber Drill",      123)
			gov.addMilMod("Marine",            23)
			gov.addMilMod("Double Cannonade",   3)
		"ARC_20":
			gov.addMilMod("Farmhand",         123)
			gov.addMilMod("Coastal Watch",    123)
			gov.addMilMod("Marine",            23)
			gov.addMilMod("Naval Supremacy",    3)
		"ARC_21":
			gov.addMilMod("Hill Runner",      123)
			gov.addMilMod("Saber Drill",      123)
			gov.addMilMod("Iron Bayonet",      23)
			gov.addMilMod("Last Stand",         3)
		"ARC_22":
			gov.addMilMod("Woodsman",         123)
			gov.addMilMod("Quick Reload",     123)
			gov.addMilMod("Guerrilla Tactics", 23)
			gov.addMilMod("Ghost March",        3)
		"ARC_23":
			gov.addMilMod("Steady Line",      123)
			gov.addMilMod("Saber Drill",      123)
			gov.addMilMod("Iron Bayonet",      23)
			gov.addMilMod("Entrenched",         3)
		"ARC_24":
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Steady Line",      123)
			gov.addMilMod("Rallying Voice",    23)
			gov.addMilMod("Continental Line",   3)
		"ARC_25":
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Marksman",         123)
			gov.addMilMod("Night Raider",      23)
			gov.addMilMod("The Long March",     3)
		# ── NEW ENGLAND ────────────────────────────────────────────────────────
		"ARC_26": # Boston Irish Dockworker
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Quick Reload",     123)
			gov.addMilMod("Iron Bayonet",      23)
			gov.addMilMod("Last Stand",         3)
		"ARC_27": # Cape Ann Fisherwoman
			gov.addMilMod("Coastal Watch",    123)
			gov.addMilMod("Marksman",         123)
			gov.addMilMod("Marine",            23)
			gov.addMilMod("Naval Supremacy",    3)
		"ARC_28": # Yankee Tinkerer
			gov.addMilMod("Fortified Position",123)
			gov.addMilMod("Powder & Shot",    123)
			gov.addMilMod("Double Shot",       23)
			gov.addMilMod("Double Cannonade",   3)
		# ── MID-ATLANTIC ───────────────────────────────────────────────────────
		"ARC_29": # Tammany Ward Boss
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Rallying Voice",   123)
			gov.addMilMod("Cleaner",           23)
			gov.addMilMod("Terror",             3)
		"ARC_30": # Pennsylvania Dutch Braucher
			gov.addMilMod("Farmhand",         123)
			gov.addMilMod("Corrupted Ground", 123)
			gov.addMilMod("Rallying Voice",    23)
			gov.addMilMod("Undaunted",          3)
		"ARC_31": # Hudson Valley Patroon
			gov.addMilMod("Fortified Position",123)
			gov.addMilMod("Steady Line",      123)
			gov.addMilMod("Flanking Drill",    23)
			gov.addMilMod("Iron Wall",          3)
		# ── APPALACHIAN ────────────────────────────────────────────────────────
		"ARC_32": # Scots-Irish Rifleman
			gov.addMilMod("Hill Runner",      123)
			gov.addMilMod("Marksman",         123)
			gov.addMilMod("Guerrilla Tactics", 23)
			gov.addMilMod("Ghost March",        3)
		"ARC_33": # Appalachian Moonshiner
			gov.addMilMod("Hill Runner",      123)
			gov.addMilMod("Woodsman",         123)
			gov.addMilMod("Night Raider",      23)
			gov.addMilMod("Ghost March",        3)
		"ARC_34": # Granny Witch
			gov.addMilMod("Corrupted Ground", 123)
			gov.addMilMod("Farmhand",         123)
			gov.addMilMod("Rallying Voice",    23)
			gov.addMilMod("Undaunted",          3)
		# ── CHESAPEAKE / TIDEWATER ─────────────────────────────────────────────
		"ARC_35": # Chesapeake Freedman Waterman
			gov.addMilMod("Coastal Watch",    123)
			gov.addMilMod("Swamp Legs",       123)
			gov.addMilMod("Marine",            23)
			gov.addMilMod("Naval Supremacy",    3)
		"ARC_36": # Tidewater Gentlewoman
			gov.addMilMod("Steady Line",      123)
			gov.addMilMod("Rallying Voice",   123)
			gov.addMilMod("Cleaner",           23)
			gov.addMilMod("Continental Line",   3)
		# ── GULLAH / AFRICAN AMERICAN ──────────────────────────────────────────
		"ARC_37": # Gullah Sea Islander
			gov.addMilMod("Swamp Legs",       123)
			gov.addMilMod("Guerrilla Tactics",123)
			gov.addMilMod("Night Raider",      23)
			gov.addMilMod("Liberator's Will",   3)
		"ARC_38": # Underground Railroad Conductor
			gov.addMilMod("Woodsman",         123)
			gov.addMilMod("Night Raider",     123)
			gov.addMilMod("Ghost March",       23)
			gov.addMilMod("The Long March",     3)
		"ARC_39": # Great Migration Church Elder
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Rallying Voice",   123)
			gov.addMilMod("Cleaner",           23)
			gov.addMilMod("Continental Line",   3)
		# ── DEEP SOUTH ─────────────────────────────────────────────────────────
		"ARC_40": # Deep South Sharecropper
			gov.addMilMod("Farmhand",         123)
			gov.addMilMod("Steady Line",      123)
			gov.addMilMod("Flanking Drill",    23)
			gov.addMilMod("Last Stand",         3)
		"ARC_41": # Conjure Woman
			gov.addMilMod("Swamp Legs",       123)
			gov.addMilMod("Corrupted Ground", 123)
			gov.addMilMod("Night Raider",      23)
			gov.addMilMod("Terror",             3)
		"ARC_42": # Florida Cracker Cowman
			gov.addMilMod("Farmhand",         123)
			gov.addMilMod("Hill Runner",      123)
			gov.addMilMod("Guerrilla Tactics", 23)
			gov.addMilMod("Ghost March",        3)
		# ── INDUSTRIAL / URBAN ─────────────────────────────────────────────────
		"ARC_43": # Rust Belt Union Organizer
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Rallying Voice",   123)
			gov.addMilMod("Flanking Drill",    23)
			gov.addMilMod("Liberator's Will",   3)
		"ARC_44": # Little Italy Neighborhood Captain
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Steady Line",      123)
			gov.addMilMod("Iron Bayonet",      23)
			gov.addMilMod("Iron Wall",          3)
		"ARC_45": # Lower East Side Organizer
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Rallying Voice",   123)
			gov.addMilMod("Cleaner",           23)
			gov.addMilMod("Continental Line",   3)
		# ── CARIBBEAN / ATLANTIC ───────────────────────────────────────────────
		"ARC_46": # Bahamian Free Sailor
			gov.addMilMod("Coastal Watch",    123)
			gov.addMilMod("Swamp Legs",       123)
			gov.addMilMod("Marine",            23)
			gov.addMilMod("Naval Supremacy",    3)
		# ── WASHINGTON DC ──────────────────────────────────────────────────────
		"ARC_47": # DC Political Fixer
			gov.addMilMod("Street Tough",     123)
			gov.addMilMod("Fortified Position",123)
			gov.addMilMod("Cleaner",           23)
			gov.addMilMod("Terror",             3)
		# ── USA TRIBAL ARCHETYPES ─────────────────────────────────────────────
		"ARC_NA_01": # Mohawk War Captain
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Guerrilla Tactics", 123)
			gov.addMilMod("Iron Bayonet",       23)
			gov.addMilMod("Last Stand",           3)
		"ARC_NA_02": # Oneida Alliance Scout
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Quick Reload",      123)
			gov.addMilMod("Night Raider",       23)
			gov.addMilMod("Ghost March",          3)
		"ARC_NA_03": # Wampanoag Mariner
			gov.addMilMod("Coastal Watch",     123)
			gov.addMilMod("Marine",            123)
			gov.addMilMod("Swamp Legs",         23)
			gov.addMilMod("Naval Supremacy",      3)
		"ARC_NA_04": # Lenape Guide
			gov.addMilMod("Steady Line",       123)
			gov.addMilMod("Farmhand",          123)
			gov.addMilMod("Rallying Voice",     23)
			gov.addMilMod("Continental Line",     3)
		"ARC_NA_05": # Abenaki Tracker
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Quick Reload",      123)
			gov.addMilMod("Guerrilla Tactics",  23)
			gov.addMilMod("Ghost March",          3)
		"ARC_NA_06": # Cherokee Rifleman
			gov.addMilMod("Hill Runner",       123)
			gov.addMilMod("Marksman",          123)
			gov.addMilMod("Quick Reload",       23)
			gov.addMilMod("Ghost March",          3)
		"ARC_NA_07": # Muscogee Creek Warrior
			gov.addMilMod("Swamp Legs",        123)
			gov.addMilMod("Saber Drill",       123)
			gov.addMilMod("Guerrilla Tactics",  23)
			gov.addMilMod("Last Stand",           3)
		"ARC_NA_08": # Shawnee Runner
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Hill Runner",       123)
			gov.addMilMod("Night Raider",       23)
			gov.addMilMod("Ghost March",          3)
		"ARC_NA_09": # Seneca War Chief
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Saber Drill",       123)
			gov.addMilMod("Iron Bayonet",       23)
			gov.addMilMod("Entrenched",           3)
		"ARC_NA_10": # Catawba Rifleman
			gov.addMilMod("Hill Runner",       123)
			gov.addMilMod("Marksman",          123)
			gov.addMilMod("Steady Line",        23)
			gov.addMilMod("Continental Line",     3)
		# ── CANADIAN ARCHETYPES ───────────────────────────────────────────────
		"CA_ARC_01": # Coureur des Bois
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Quick Reload",      123)
			gov.addMilMod("Guerrilla Tactics",  23)
			gov.addMilMod("Ghost March",          3)
		"CA_ARC_02": # Voyageur
			gov.addMilMod("Coastal Watch",     123)
			gov.addMilMod("Farmhand",          123)
			gov.addMilMod("Rallying Voice",     23)
			gov.addMilMod("The Long March",       3)
		"CA_ARC_03": # Mi'kmaq Raider
			gov.addMilMod("Coastal Watch",     123)
			gov.addMilMod("Swamp Legs",        123)
			gov.addMilMod("Guerrilla Tactics",  23)
			gov.addMilMod("Ghost March",          3)
		"CA_ARC_04": # Loyalist Farmer
			gov.addMilMod("Farmhand",          123)
			gov.addMilMod("Steady Line",       123)
			gov.addMilMod("Fortified Position", 23)
			gov.addMilMod("Entrenched",           3)
		"CA_ARC_05": # Montreal Merchant
			gov.addMilMod("Street Tough",      123)
			gov.addMilMod("Steady Line",       123)
			gov.addMilMod("Rallying Voice",     23)
			gov.addMilMod("Continental Line",     3)
		"CA_ARC_06": # Habitant Militia
			gov.addMilMod("Farmhand",          123)
			gov.addMilMod("Saber Drill",       123)
			gov.addMilMod("Guerrilla Tactics",  23)
			gov.addMilMod("Last Stand",           3)
		"CA_ARC_07": # Anglican Officer
			gov.addMilMod("Steady Line",       123)
			gov.addMilMod("Fortified Position",123)
			gov.addMilMod("Iron Bayonet",       23)
			gov.addMilMod("Iron Wall",            3)
		"CA_ARC_08": # Haudenosaunee Diplomat
			gov.addMilMod("Steady Line",       123)
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Rallying Voice",     23)
			gov.addMilMod("Continental Line",     3)
		"CA_ARC_09": # Acadian Fisherman
			gov.addMilMod("Coastal Watch",     123)
			gov.addMilMod("Quick Reload",      123)
			gov.addMilMod("Swamp Legs",         23)
			gov.addMilMod("Ghost March",          3)
		"CA_ARC_10": # Lumber Camp Foreman
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Powder & Shot",     123)
			gov.addMilMod("Siege Line",         23)
			gov.addMilMod("Entrenched",           3)
		# ── CANADIAN TRIBAL ARCHETYPES ────────────────────────────────────────
		"CA_ARC_NA_01": # Algonquin River Guide
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Quick Reload",      123)
			gov.addMilMod("Guerrilla Tactics",  23)
			gov.addMilMod("Ghost March",          3)
		"CA_ARC_NA_02": # Haudenosaunee Confederacy Envoy
			gov.addMilMod("Steady Line",       123)
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Rallying Voice",     23)
			gov.addMilMod("Continental Line",     3)
		"CA_ARC_NA_03": # Cree Hunter
			gov.addMilMod("Woodsman",          123)
			gov.addMilMod("Quick Reload",      123)
			gov.addMilMod("Night Raider",       23)
			gov.addMilMod("Guerrilla Tactics",    3)


func generateBarracksCommanders() -> void:
	# ── Archetype table ──────────────────────────────────────────────────────
	# terrain: which tile terrains can produce this archetype
	# name_pools: preferred cultural name pools (one picked at random)
	# position: governor role title
	var ARCHETYPES := [
		{"id":"ARC_01","name":"Wetlands Fisher",      "position":"SCOUT",      "terrain":["Wetlands"],               "pools":["NP_01","NP_04"]},
		{"id":"ARC_02","name":"Appalachian Miner",     "position":"ENGINEER",  "terrain":["Foothills"],
		 "regions":["WV","VA","PA","NC","TN"],           "pools":["NP_03"]},
		{"id":"ARC_03","name":"Ivy League Dropout",    "position":"SCHOLAR",   "terrain":["Metro"],
		 "regions":["MA","CT","RI","NY","NJ","PA"],      "pools":["NP_01","NP_09","NP_10"]},
		{"id":"ARC_04","name":"Seminole Fighter",      "position":"WARRIOR",   "terrain":["Wetlands","Farmlands"],
		 "regions":["FL","GA","AL","SC"],                "pools":["NP_07"]},
		{"id":"ARC_05","name":"Green Mountain Farmer", "position":"FARMER",    "terrain":["Foothills","Farmlands"],
		 "regions":["VT","NH","ME","MA","CT"],           "pools":["NP_01","NP_06"]},
		{"id":"ARC_06","name":"Chesapeake Shipwright", "position":"ENGINEER",  "terrain":["Wetlands"],
		 "regions":["MD","VA","DE","NC"],                "pools":["NP_01","NP_04"]},
		{"id":"ARC_07","name":"Loyalist Turncoat",     "position":"SPY",       "terrain":["Metro","Suburbs"],        "pools":["NP_01","NP_02"]},
		{"id":"ARC_08","name":"Tobacco Belt Drifter",  "position":"SCOUT",     "terrain":["Farmlands"],
		 "regions":["VA","NC","MD","SC","GA"],           "pools":["NP_03","NP_04"]},
		{"id":"ARC_09","name":"War Widow",             "position":"DIPLOMAT",  "terrain":["Suburbs","Metro"],        "pools":["NP_01","NP_04","NP_09"]},
		# ── TRIBAL ARCHETYPES — USA (replace generic ARC_10) ────────────────────
		{"id":"ARC_NA_01","name":"Mohawk War Captain",          "position":"WARRIOR",   "terrain":["Woods","Foothills"],
		 "regions":["NY","VT","NH","MA","PA"],        "pools":["NP_NA_01"]},
		{"id":"ARC_NA_02","name":"Oneida Alliance Scout",       "position":"SCOUT",     "terrain":["Woods","Wetlands"],
		 "regions":["NY","PA","VT"],                  "pools":["NP_NA_01"]},
		{"id":"ARC_NA_03","name":"Wampanoag Mariner",           "position":"ADMIRAL",   "terrain":["Wetlands"],
		 "regions":["MA","RI","CT","NH"],             "pools":["NP_NA_02"]},
		{"id":"ARC_NA_04","name":"Lenape Guide",                "position":"DIPLOMAT",  "terrain":["Woods","Farmlands"],
		 "regions":["NJ","PA","DE","NY","MD"],        "pools":["NP_NA_03"]},
		{"id":"ARC_NA_05","name":"Abenaki Tracker",             "position":"SCOUT",     "terrain":["Woods","Foothills","Wetlands"],
		 "regions":["VT","NH","MA","ME"],             "pools":["NP_NA_04"]},
		{"id":"ARC_NA_06","name":"Cherokee Rifleman",           "position":"SOLDIER",   "terrain":["Foothills","Woods"],
		 "regions":["TN","NC","GA","VA","SC"],        "pools":["NP_NA_05"]},
		{"id":"ARC_NA_07","name":"Muscogee Creek Warrior",      "position":"WARRIOR",   "terrain":["Wetlands","Farmlands"],
		 "regions":["GA","AL","FL","MS"],             "pools":["NP_NA_06"]},
		{"id":"ARC_NA_08","name":"Shawnee Runner",              "position":"SCOUT",     "terrain":["Woods","Foothills"],
		 "regions":["WV","OH","KY","PA","IN"],        "pools":["NP_NA_07"]},
		{"id":"ARC_NA_09","name":"Seneca War Chief",            "position":"WARRIOR",   "terrain":["Woods","Foothills"],
		 "regions":["NY","PA"],                       "pools":["NP_NA_01"]},
		{"id":"ARC_NA_10","name":"Catawba Rifleman",            "position":"SOLDIER",   "terrain":["Foothills","Farmlands"],
		 "regions":["NC","SC","VA"],                  "pools":["NP_NA_08"]},
		{"id":"ARC_11","name":"Boston Rabble-Rouser",  "position":"ORATOR",    "terrain":["Metro"],
		 "regions":["MA","RI","CT","NH","VT"],           "pools":["NP_01","NP_09"]},
		{"id":"ARC_12","name":"Continental Surgeon",   "position":"HEALER",    "terrain":["Farmlands","Foothills"],  "pools":["NP_01","NP_02"]},
		{"id":"ARC_13","name":"Nantucket Sailor",      "position":"ADMIRAL",   "terrain":["Wetlands"],
		 "regions":["MA","ME","NH","RI","CT"],           "pools":["NP_01"]},
		{"id":"ARC_14","name":"Frontier Preacher",     "position":"ORATOR",    "terrain":["Woods","Foothills"],
		 "regions":["VA","WV","TN","NC","GA","SC","AL"], "pools":["NP_03"]},
		{"id":"ARC_15","name":"DC Bureaucrat",         "position":"BUREAUCRAT","terrain":["Metro"],
		 "regions":["DC","MD","VA"],                    "pools":["NP_01","NP_04"]},
		{"id":"ARC_16","name":"Rust Belt Steelworker", "position":"ENGINEER",  "terrain":["Suburbs"],
		 "regions":["PA","NJ","NY"],                    "pools":["NP_02","NP_09"]},
		{"id":"ARC_17","name":"Plantation Deserter",   "position":"SOLDIER",   "terrain":["Farmlands"],
		 "regions":["VA","NC","SC","GA","AL","FL","MD"], "pools":["NP_04"]},
		{"id":"ARC_18","name":"Swamp Witch",           "position":"MAGE",      "terrain":["Wetlands"],
		 "regions":["SC","GA","FL","AL","NC"],           "pools":["NP_04","NP_05"]},
		{"id":"ARC_19","name":"Caribbean Privateer",   "position":"ADMIRAL",   "terrain":["Wetlands","Suburbs"],
		 "regions":["FL","BA","SC","GA"],                "pools":["NP_05"]},
		{"id":"ARC_20","name":"Hawaiian Refugee",      "position":"DIPLOMAT",  "terrain":["Wetlands","Metro"],       "pools":["NP_08"]},
		{"id":"ARC_21","name":"Border Mercenary",      "position":"SOLDIER",   "terrain":["Suburbs","Farmlands"],    "pools":["NP_03","NP_05"]},
		{"id":"ARC_22","name":"Acadian Forest Ranger", "position":"SCOUT",     "terrain":["Woods","Wetlands"],
		 "regions":["ME","NH","VT","NY"],                "pools":["NP_06"]},
		{"id":"ARC_23","name":"Gettysburg Descendant", "position":"SOLDIER",   "terrain":["Farmlands","Foothills"],
		 "regions":["PA","MD","VA"],                     "pools":["NP_01","NP_04"]},
		{"id":"ARC_24","name":"LGBTQ+ Organizer",      "position":"DIPLOMAT",  "terrain":["Metro","Suburbs"],
		 "regions":["NY","MA","PA","DC","NJ","CT","RI","DE"],"pools":["NP_01","NP_04","NP_09"]},
		{"id":"ARC_25","name":"Carnival Barker",       "position":"ORATOR",    "terrain":["Wetlands","Suburbs"],     "pools":["NP_03","NP_05"]},
		# ── REGIONAL ARCHETYPES — NEW ENGLAND ──────────────────────────────────
		{"id":"ARC_26","name":"Boston Irish Dockworker",      "position":"SOLDIER",  "terrain":["Metro"],
		 "regions":["MA","NY","NJ"],                          "pools":["NP_09"]},
		{"id":"ARC_27","name":"Cape Ann Fisherwoman",         "position":"SCOUT",    "terrain":["Wetlands"],
		 "regions":["MA","ME","NH","RI"],                     "pools":["NP_01"]},
		{"id":"ARC_28","name":"Yankee Tinkerer",              "position":"ENGINEER", "terrain":["Suburbs","Metro"],
		 "regions":["MA","CT","RI","NH","VT"],                "pools":["NP_01"]},
		# ── REGIONAL ARCHETYPES — MID-ATLANTIC ──────────────────────────────────
		{"id":"ARC_29","name":"Tammany Ward Boss",            "position":"DIPLOMAT", "terrain":["Metro"],
		 "regions":["NY","NJ"],                              "pools":["NP_01","NP_09"]},
		{"id":"ARC_30","name":"Pennsylvania Dutch Braucher",  "position":"HEALER",   "terrain":["Farmlands"],
		 "regions":["PA"],                                   "pools":["NP_02"]},
		{"id":"ARC_31","name":"Hudson Valley Patroon",        "position":"DIPLOMAT", "terrain":["Farmlands"],
		 "regions":["NY","NJ"],                              "pools":["NP_11"]},
		# ── REGIONAL ARCHETYPES — APPALACHIAN ───────────────────────────────────
		{"id":"ARC_32","name":"Scots-Irish Rifleman",         "position":"SOLDIER",  "terrain":["Foothills","Woods"],
		 "regions":["VA","WV","PA","NC","TN"],                "pools":["NP_03"]},
		{"id":"ARC_33","name":"Appalachian Moonshiner",       "position":"SCOUT",    "terrain":["Foothills","Woods"],
		 "regions":["WV","VA","NC","TN","PA"],                "pools":["NP_03"]},
		{"id":"ARC_34","name":"Granny Witch",                 "position":"MAGE",     "terrain":["Foothills","Woods"],
		 "regions":["WV","VA","NC","TN"],                    "pools":["NP_03"]},
		# ── REGIONAL ARCHETYPES — CHESAPEAKE / TIDEWATER ────────────────────────
		{"id":"ARC_35","name":"Chesapeake Freedman Waterman", "position":"ADMIRAL",  "terrain":["Wetlands"],
		 "regions":["MD","VA","DE"],                         "pools":["NP_04"]},
		{"id":"ARC_36","name":"Tidewater Gentlewoman",        "position":"DIPLOMAT", "terrain":["Farmlands","Suburbs"],
		 "regions":["VA","MD","NC"],                         "pools":["NP_01"]},
		# ── REGIONAL ARCHETYPES — GULLAH / AFRICAN AMERICAN ─────────────────────
		{"id":"ARC_37","name":"Gullah Sea Islander",          "position":"WARRIOR",  "terrain":["Wetlands","Farmlands"],
		 "regions":["SC","GA"],                              "pools":["NP_13"]},
		{"id":"ARC_38","name":"Underground Railroad Conductor","position":"SPY",     "terrain":["Farmlands","Suburbs"],
		 "regions":["MD","PA","DE","VA","DC"],               "pools":["NP_04"]},
		{"id":"ARC_39","name":"Great Migration Church Elder", "position":"ORATOR",   "terrain":["Metro","Suburbs"],
		 "regions":["NY","PA","NJ","DC","MA"],               "pools":["NP_04"]},
		# ── REGIONAL ARCHETYPES — DEEP SOUTH ────────────────────────────────────
		{"id":"ARC_40","name":"Deep South Sharecropper",      "position":"FARMER",   "terrain":["Farmlands"],
		 "regions":["SC","GA","AL","NC"],                    "pools":["NP_04"]},
		{"id":"ARC_41","name":"Conjure Woman",                "position":"MAGE",     "terrain":["Wetlands"],
		 "regions":["SC","GA","AL","FL","NC"],               "pools":["NP_04"]},
		{"id":"ARC_42","name":"Florida Cracker Cowman",       "position":"SCOUT",    "terrain":["Farmlands","Foothills"],
		 "regions":["FL","GA"],                              "pools":["NP_03"]},
		# ── REGIONAL ARCHETYPES — INDUSTRIAL / URBAN ────────────────────────────
		{"id":"ARC_43","name":"Rust Belt Union Organizer",    "position":"ORATOR",   "terrain":["Suburbs","Metro"],
		 "regions":["PA","NJ","NY"],                         "pools":["NP_09","NP_02"]},
		{"id":"ARC_44","name":"Little Italy Neighborhood Captain","position":"SOLDIER","terrain":["Metro","Suburbs"],
		 "regions":["NY","NJ","PA"],                         "pools":["NP_12"]},
		{"id":"ARC_45","name":"Lower East Side Organizer",    "position":"DIPLOMAT", "terrain":["Metro"],
		 "regions":["NY","NJ","PA"],                         "pools":["NP_10"]},
		# ── REGIONAL ARCHETYPES — CARIBBEAN / ATLANTIC ──────────────────────────
		{"id":"ARC_46","name":"Bahamian Free Sailor",         "position":"ADMIRAL",  "terrain":["Wetlands"],
		 "regions":["FL","BA","SC","GA"],                    "pools":["NP_05"]},
		# ── REGIONAL ARCHETYPES — WASHINGTON DC ─────────────────────────────────
		{"id":"ARC_47","name":"DC Political Fixer",           "position":"SPY",      "terrain":["Metro","Suburbs"],
		 "regions":["DC","MD","VA"],                         "pools":["NP_01"]},
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
		# Creek / Muscogee / Seminole — Southeast FL/GA/SC, 1780s–1790s
		"NP_NA_CREEK": {
			"m":  ["Menawa","Opothle","Yahola","Hadjo","Tustenuggee","Fixico","Emathla","Hoboithle","Thlucco","Coacoochee"],
			"f":  ["Sehoy","Coosaponakeesa","Wewoka","Okchai","Tallassee","Moniac","Talofah","Hichiti","Oki","Efvhvke"],
			"nb": ["Hatchee","Ekvnv","Hvse","Cedar","Talwa","Homosa"],
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
		# Dutch-American — Hudson Valley patroon families
		"NP_11": {
			"m":  ["Pieter","Hendrick","Cornelius","Dirck","Gerrit","Jan","Wouter","Jacobus","Claes","Barent"],
			"f":  ["Margriet","Annetje","Catharina","Lysbeth","Tryntje","Hilletje","Aeltje","Jannetje","Cornelia","Geertruyd"],
			"nb": ["Rik","Bram","Daan","Fien","Lou","Rens","Teun","Sien"],
			"l":  ["Van Cortlandt","Schuyler","Van Rensselaer","Stuyvesant","Beekman","Van Wyck","De Peyster","Brinckerhoff","Vander Berg","Knickerbocker"],
		},
		# Italian-American — immigrant community surnames
		"NP_12": {
			"m":  ["Giuseppe","Antonio","Salvatore","Francesco","Carmelo","Vito","Enzo","Rocco","Luigi","Nunzio"],
			"f":  ["Carmela","Rosaria","Concetta","Filomena","Assunta","Lucia","Giuseppina","Annunziata","Rosa","Nunzia"],
			"nb": ["Nico","Santi","Neri","Luca","Fia","Gino","Tito","Mara"],
			"l":  ["Ferrara","Conti","Rizzo","Esposito","Moretti","Lombardi","De Luca","Bruno","Mancini","Caruso"],
		},
		# Gullah/Geechee — West African day names + Sea Island surnames
		# Kofi=Friday, Kwame=Saturday, Kojo=Monday, Kweku=Wednesday, Yaw=Thursday
		# Akosua=Sunday, Abena=Tuesday, Ama=Saturday, Afia=Friday, Ekua=Wednesday
		"NP_13": {
			"m":  ["Kofi","Kwame","Kojo","Kweku","Yaw","Cudjoe","Quow","Cudjo","Quamino","Cuffee"],
			"f":  ["Akosua","Abena","Ama","Afia","Ekua","Adwoa","Adjoa","Efua","Akua","Esi"],
			"nb": ["Nana","Kwei","Aba","Osei","Addo","Bisa","Eno"],
			"l":  ["Smalls","Heyward","Ravenel","Pinckney","Singleton","Brown","Rivers","Blake","Grant","Gullah"],
		},
		# ── NATION-SPECIFIC INDIGENOUS POOLS ─────────────────────────────────
		# Haudenosaunee (Mohawk / Oneida / Seneca — shared pool)
		"NP_NA_01": {
			"m":  ["Thayendanegea","Skenandoa","Oronhyatekha","Red Jacket","Cornplanter","Handsome Lake","Big Tree","Farmer's Brother","Complanter","Young King"],
			"f":  ["Degonwadonti","Konwatsi","Owandah","Molly","Sarah","Mary","Annie","Clara","Lydia","Catherine"],
			"nb": ["Rotiyaner","Kanien","Wahta","Ohsweken","Kasennakoha","Ranienras","Ionkwaritons"],
			"l":  ["Brant","Oakes","Hill","Lazore","Swamp","Herne","Jock","Deer","Montour","Thompson"],
		},
		# Wampanoag (Massachusetts coast / southern New England)
		"NP_NA_02": {
			"m":  ["Massasoit","Metacom","Tisquantum","Wamsutta","Tuspaquin","Annawan","Corbitant","Hobomock","Akkompoin","Nanepashemet"],
			"f":  ["Weetamoo","Awashonks","Amie","Abiah","Patience","Hope","Mercy","Hannah","Priscilla","Nessutan"],
			"nb": ["Aquinnah","Noepe","Pocasset","Mashpee","Wonkham","Chappaquiddick"],
			"l":  ["Peters","Coombs","Pocknett","Vanderhoop","Haskins","Attaquin","Oakley","Macy","Hendricks","Belain"],
		},
		# Lenape / Delaware (New Jersey, Pennsylvania, Delaware, Maryland)
		"NP_NA_03": {
			"m":  ["Teedyuscung","Shingas","Tamend","Gelelemend","Hopocan","Buckongahelas","Netawatwees","Pisquetomen","Custaloga","Pachgantschihilas"],
			"f":  ["Hannah","Mary","Sarah","Lydia","Rachel","Elizabeth","Amie","Rebekah","Abigail","Martha"],
			"nb": ["Unami","Minsi","Munsee","Lenape","Scheyichbi","Monsey"],
			"l":  ["Killbuck","Anderson","Halfmoon","Journeycake","Conner","Johns","Thompson","Delaware","Gale","Pratt"],
		},
		# Abenaki (Vermont, New Hampshire, Maine — Western Abenaki homeland)
		"NP_NA_04": {
			"m":  ["Assacumbuit","Nescambiouit","Paugus","Kancamagus","Natanis","Sabatis","Wattanummon","Molsem","Atecouando","Loron"],
			"f":  ["Singing Bird","Natawammet","Pesando","Nolka","Tahmount","Wahwa","Marie","Abbe","Molian","Cecile"],
			"nb": ["Wabanaki","Penobscot","Passamaquoddy","Kennebec","Sokoki","Pigwacket"],
			"l":  ["Obomsawin","Benedict","Bruchac","Watso","Swallow","Neptune","Levi","Lampman","Bowman","Nolette"],
		},
		# Cherokee (Tennessee, Carolina, Georgia, Virginia)
		"NP_NA_05": {
			"m":  ["Sequoyah","Attakullakulla","Oconostota","Doublehead","Pathkiller","Outacite","Cunne Shote","Tistoe","Dragging Canoe","Emmet"],
			"f":  ["Nanyehi","Wurteh","Betsy","Mary","Sally","Caty","Nellie","Polly","Tsiyu","Quatsy"],
			"nb": ["Tsalagi","Aniyunwiya","Atali","Unega","Wahya","Uwetsi"],
			"l":  ["Ward","Ross","Ridge","Hicks","Vann","Fields","Adair","Watie","Bushyhead","Rogers"],
		},
		# Muscogee / Creek (Georgia, Alabama, Florida, Mississippi)
		"NP_NA_06": {
			"m":  ["Menawa","Hopoithle Miko","Efau Hadjo","Kinache","Tuskenugge","Bowlegs","Cusseta","Coweta","Tuckabatchee","Factor"],
			"f":  ["Coosapanaakeesa","Sehoy","Mary","Nancy","Polly","Sally","Betsy","Molly","Sophia","Lydia"],
			"nb": ["Muscogee","Hitchiti","Yuchi","Eufaula","Atasi","Tuckabatchee"],
			"l":  ["McGillivray","McIntosh","Harjo","Fixico","Grayson","Perryman","Tiger","Checote","Factor","Deer"],
		},
		# Shawnee (West Virginia, Ohio, Kentucky, Pennsylvania)
		"NP_NA_07": {
			"m":  ["Hokolesqua","Weyapiersenwah","Catahecassa","Pucksinwah","Tenskwatawa","Chiksika","Nimwha","Moluntha","Kispoko","Tecumseh"],
			"f":  ["Nonhelema","Methoataske","Tecumapease","Peshewah","Wabete","Fanny","Hannah","Mary","Polly","Sarah"],
			"nb": ["Maykujay","Pekowi","Chillicothe","Thawegila","Kispoko","Mekoche"],
			"l":  ["Black","Blue","White","Logan","Spicer","Gray","King","Reed","Ward","Cloud"],
		},
		# Catawba (North Carolina, South Carolina, Virginia)
		"NP_NA_08": {
			"m":  ["Hagler","Nopkehe","New River","John Frow","George Canty","Thomas Spratt","James Patterson","William Harris","John George","Billy Brown"],
			"f":  ["Sally","Jane","Margaret","Hannah","Nancy","Betsy","Mary","Polly","Cathey","Susan"],
			"nb": ["Catawba","Iswa","Esaw","Waxhaw","Sugaree","Wateree"],
			"l":  ["Harris","Blue","Brown","Canty","Morrison","Patterson","Sanders","Wahoo","Williams","Gordon"],
		},
	}

	# Cache at class level so _generate_and_assign_governor() can access them
	_usa_archetypes = ARCHETYPES
	_usa_name_pools = NAME_POOLS

	var portrait_placeholder: Texture = load(
		"res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")

	# ── Spawn player leader — Ualani (USA) or Jessica Commanda Odjick (CA) ──────────
	if playerCountry == "CA":
		# Jessica Commanda Odjick in Ottawa (tile 201)
		var jessica: governor = governor.new()
		jessica.buildSelf("Jessica Commanda Odjick", 3)
		playerCountryNode.unlockedGovernors.append(jessica)
		for tile in $TileController.get_children():
			if tile.tileNumber == 201 and tile.tileOwner == playerCountry:
				tile.tileGovernor       = jessica
				tile.filledGovernorSlot = true
				jessica.hired           = true
				print("[Commanders] PM Commanda stationed in Ottawa (tile 201).")
				break
		#if not jessica.hired:
#		if not jessica.hired:
		# Marc Penoit in Quebec City (tile 123) as Deputy Governor
		var penoit: governor = governor.new()
		penoit.buildSelf("Marc Penoit", 2)
		playerCountryNode.unlockedGovernors.append(penoit)
		for tile in $TileController.get_children():
			if tile.tileNumber == 123 and tile.tileOwner == playerCountry:
				if not tile.filledGovernorSlot:
					tile.tileGovernor       = penoit
					tile.filledGovernorSlot = true
					penoit.hired            = true
					print("[Commanders] Deputy Penoit stationed in Quebec City (tile 123).")
					break
		#if not penoit.hired:
#		if not penoit.hired:
	else:
		# Ualani Carlisle in Washington DC (tile 188)
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
		#if not carlisle.hired:
	#	if not carlisle.hired:
		# Secret Service Detail unlocks alongside Carlisle
		var detail: governor = governor.new()
		detail.buildSelf("Secret Service Detail", 1)
		playerCountryNode.unlockedGovernors.append(detail)
		# Turkey God and Baseball Legend available from game start
		var turkey_god: governor = governor.new()
		turkey_god.buildSelf("Turkey God", 1)
		playerCountryNode.unlockedGovernors.append(turkey_god)
		var baseball: governor = governor.new()
		baseball.buildSelf("Baseball Legend", 1)
		playerCountryNode.unlockedGovernors.append(baseball)

	governor.reset_portrait_pool()
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

		# ── Pick archetype (terrain + optional region filter) ────────────────
		var candidates: Array = []
		for arch in ARCHETYPES:
			var terrain_ok: bool = tile.terrain in arch["terrain"]
			var regions: Array = arch.get("regions", [])
			var region_ok: bool = regions.is_empty() or tile.tileContinent in regions
			if terrain_ok and region_ok:
				candidates.append(arch)
		if candidates.is_empty():
			# Fallback: terrain only, ignore region constraint
			for arch in ARCHETYPES:
				if tile.terrain in arch["terrain"]:
					candidates.append(arch)
		if candidates.is_empty():
			candidates = ARCHETYPES
		var arch_chosen: Dictionary = candidates[randi() % candidates.size()]

		# ── Pick portrait first — portrait drives name, pronouns, culture ────
		var new_gov: governor = governor.new()
		var portrait_data: Dictionary = new_gov.pick_procedural_portrait()
		new_gov.culture  = portrait_data["culture"]
		new_gov.pronouns = portrait_data["pronouns"]
		new_gov.governorTexture = load(portrait_data["path"])

		var first_list: Array = portrait_data["first"]
		var last_list: Array  = portrait_data["last"]

		var first: String = first_list[randi() % first_list.size()]
		var last: String  = ""
		if last_list.size() > 0:
			last = last_list[randi() % last_list.size()]

		var full_name: String = (first + " " + last).strip_edges()

		# Deduplicate — try up to 8 times before giving up
		var tries: int = 0
		while used_names.has(full_name) and tries < 8:
			first = first_list[randi() % first_list.size()]
			full_name = (first + " " + last).strip_edges()
			tries += 1
		used_names[full_name] = true

		# ── Configure governor from archetype ─────────────────────────────
		new_gov.governorType        = full_name
		new_gov.governorArchetypeId = arch_chosen["id"]
		new_gov.governorPosition    = arch_chosen["position"]
		new_gov.governorLevel       = 1
		_apply_archetype_mods(new_gov, arch_chosen["id"])
		var subj: String = portrait_data["pronouns"].get("subject", "they")
		var subj_cap: String = subj.substr(0, 1).to_upper() + subj.substr(1)
		new_gov.governorDescription = \
			"A " + arch_chosen["name"] + " who answered the revolution's call from " + tile.tileName + "."
		new_gov.governorBiography = \
			full_name + " came from " + tile.tileName + " (" + tile.terrain + "). " + \
			subj_cap + " carr" + ("ies" if subj == "he" or subj == "she" else "y") + \
			" the skills of " + arch_chosen["name"] + " into the fight for independence."
		new_gov.hired = false
		_assign_thanks_content(new_gov, arch_chosen["position"], portrait_data)

		# Add to player's unlocked governor pool
		playerCountryNode.unlockedGovernors.append(new_gov)
		_assign_governor_to_faction(new_gov)

		# Auto-assign as the tile's governor so they show up immediately
		tile.tileGovernor      = new_gov
		tile.filledGovernorSlot = true
		new_gov.hired           = true

		# Register their arc in the War Room
		$CanvasLayer/WarRoomPanel.registerCommanderArc(new_gov, tile)

		generated += 1
		#print("[Commanders] Generated: ", full_name, " — ", chosen["name"],
			#  " (", chosen["id"], ") at ", tile.tileName, " [", tile.terrain, "]")

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
			#assigned += 1
				 # " as commander of ", army.ArmyName)
				#  " as commander of ", army.ArmyName)


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
		"ARC_26": "Harbor Wolves",       "ARC_27": "Gloucester Guard",
		"ARC_28": "Clockwork Company",   "ARC_29": "Ward Rifles",
		"ARC_30": "Hex Company",         "ARC_31": "River Gentry",
		"ARC_32": "Long Rifle Company",  "ARC_33": "Hollow Runners",
		"ARC_34": "Ridge Wardens",       "ARC_35": "Bay Freedmen",
		"ARC_36": "Parlor Guard",        "ARC_37": "Sea Island Rangers",
		"ARC_38": "North Star Company",  "ARC_39": "Cathedral Regiment",
		"ARC_40": "Red Clay Rifles",     "ARC_41": "Root Brigade",
		"ARC_42": "Scrub Riders",        "ARC_43": "Iron Hall Brigade",
		"ARC_44": "Mulberry Street Guard","ARC_45": "Tenement Rifles",
		"ARC_46": "Blue Water Raiders",  "ARC_47": "Capital Shadows",
	}

	var all_candidates: Array = []
	for tile in $TileController.get_children():
		if tile.tileOwner != playerCountry:
			continue
		if tile.tileNumber == 188:
			continue
		if not tile.filledGovernorSlot or tile.tileGovernor == null:
			continue
		if int(tile.buildings.get("barracks", 0)) < 1:
			continue
		if tile.stationedArmy != null:
			continue
		all_candidates.append(tile)

	# Group by state; for each state pick the best "capital" tile to get an
	# army first — Metro terrain wins, then countryCapital flag, then highest
	# barracks level.  State capitals are seeded first so armies spread across
	# the map rather than clustering in a single region.
	var by_state: Dictionary = {}
	for tile in all_candidates:
		var s: String = tile.tileContinent if tile.tileContinent != "" else "__none__"
		if not by_state.has(s):
			by_state[s] = []
		by_state[s].append(tile)

	var capital_tiles: Array = []
	var other_tiles: Array = []
	for state in by_state:
		var group: Array = by_state[state]
		var best = null
		# Capitals are identified by having a courthouse; highest courthouse
		# level wins when multiple tiles in the state qualify.
		var top_court := -1
		for t in group:
			var clvl := int(t.buildings.get("courthouse", 0))
			if clvl > top_court:
				top_court = clvl
				best = t
		if top_court < 1:
			# Fallback: countryCapital flag, then highest barracks level
			best = null
			for t in group:
				if t.countryCapital:
					best = t
					break
			if best == null:
				var top_lvl := -1
				for t in group:
					var lvl := int(t.buildings.get("barracks", 0))
					if lvl > top_lvl:
						top_lvl = lvl
						best = t
		capital_tiles.append(best)
		for t in group:
			if t != best:
				other_tiles.append(t)

	capital_tiles.shuffle()
	other_tiles.shuffle()
	var chosen: Array = []
	chosen.append_array(capital_tiles)
	chosen.append_array(other_tiles)
	chosen = chosen.slice(0, min(18, chosen.size()))

	print("[StartingArmies] %d state capitals + %d others → %d chosen" \
		% [capital_tiles.size(), other_tiles.size(), chosen.size()])

	for tile in chosen:
		var gov: governor = tile.tileGovernor
		var arc_id: String = gov.governorArchetypeId \
			if gov.governorArchetypeId != "" else "ARC_01"
		var army_name: String = tile.tileName + " " + ARMY_SUFFIX.get(arc_id, "Militia")

		playerCountryNode.addArmy(army_name, tile.tileNumber)

		var new_army = playerCountryNode.countryArmyList.back()
		print("[StartingArmies] created '%s' — inTile=%s spawnPt=%s" % [
			army_name,
			str(new_army.inTile) if new_army != null else "NULL ARMY",
			str(new_army.inTile.tileSpawnPoint) if new_army != null and new_army.inTile != null else "N/A"
		])
		if new_army != null:
			# Wire the army to its BarracksButton before updateArmyUI so $Node
			# paths inside the Army scene resolve correctly (Army must be in tree).
			for bb in $CanvasLayer/MilitaryPanelControl/ScrollContainer/GridContainer.get_children():
				if bb.barracksTile != null and bb.barracksTile.tileNumber == tile.tileNumber and bb.barracksArmy == null:
					bb.addPrebuiltArmy(new_army)
					break
			new_army.addUnitCommander(gov)
			new_army.updateArmyUI()
			new_army.raiseSelf()

		print("[StartingArmies] '", army_name, "' at ", tile.tileName,
			  " (barracks lvl ", int(tile.buildings.get("barracks", 0)),
			  ", ", arc_id, ")")

	print("[StartingArmies] ", chosen.size(), " starting armies placed.")


# ── CANADIAN AI BARRACKS COMMANDERS ─────────────────────────────────────────
# Scans all CA-owned tiles at game start.  For each barracks tile without a
# governor already assigned, generates a procedural governor drawn from
# Canadian-themed archetypes and name pools.  Does NOT register commanders in
# the War Room (player-only UI) and does NOT spawn Ualani.
func _generate_ai_barracks_commanders(country_node) -> void:
	var CA_ARCHETYPES := [
		{"id":"CA_ARC_01",    "name":"Coureur des Bois",            "position":"SCOUT",    "terrain":["Woods","Wetlands"],      "regions":["CA - OT","CA - QB"],                          "pools":["NP_06"]},
		{"id":"CA_ARC_02",    "name":"Voyageur",                    "position":"DIPLOMAT", "terrain":["Wetlands"],              "regions":["CA - OT","CA - QB"],                          "pools":["NP_06"]},
		{"id":"CA_ARC_03",    "name":"Mi'kmaq Raider",              "position":"WARRIOR",  "terrain":["Woods","Wetlands"],      "regions":["CA - NB","CA - NS","CA - PEI"],               "pools":["NP_NA_CA_03"]},
		{"id":"CA_ARC_04",    "name":"Loyalist Farmer",             "position":"FARMER",   "terrain":["Farmlands","Foothills"], "regions":["CA - NB","CA - NS","CA - OT"],                "pools":["NP_01","NP_02"]},
		{"id":"CA_ARC_05",    "name":"Montreal Merchant",           "position":"DIPLOMAT", "terrain":["Metro"],                 "regions":["CA - QB"],                                    "pools":["NP_06","NP_01"]},
		{"id":"CA_ARC_06",    "name":"Habitant Militia",            "position":"SOLDIER",  "terrain":["Farmlands"],             "regions":["CA - QB"],                                    "pools":["NP_06"]},
		{"id":"CA_ARC_07",    "name":"Anglican Officer",            "position":"SOLDIER",  "terrain":["Suburbs","Metro"],       "regions":["CA - OT","CA - NB","CA - NS"],                "pools":["NP_01","NP_02"]},
		{"id":"CA_ARC_08",    "name":"Haudenosaunee Diplomat",      "position":"DIPLOMAT", "terrain":["Woods","Foothills"],     "regions":["CA - OT","CA - QB"],                          "pools":["NP_NA_01"]},
		{"id":"CA_ARC_09",    "name":"Acadian Fisherman",           "position":"SCOUT",    "terrain":["Wetlands","Foothills"],  "regions":["CA - NB","CA - NS","CA - PEI"],               "pools":["NP_06"]},
		{"id":"CA_ARC_10",    "name":"Lumber Camp Foreman",         "position":"ENGINEER", "terrain":["Woods","Foothills"],     "regions":["CA - OT","CA - QB","CA - NB"],                "pools":["NP_01","NP_06"]},
		{"id":"CA_ARC_NA_01", "name":"Algonquin River Guide",       "position":"SCOUT",    "terrain":["Woods","Wetlands"],      "regions":["CA - OT","CA - QB"],                          "pools":["NP_NA_CA_01"]},
		{"id":"CA_ARC_NA_02", "name":"Haudenosaunee Confederacy Envoy","position":"DIPLOMAT","terrain":["Foothills","Metro"],   "regions":["CA - OT"],                                    "pools":["NP_NA_01"]},
		{"id":"CA_ARC_NA_03", "name":"Cree Hunter",                 "position":"WARRIOR",  "terrain":["Woods","Wetlands"],      "regions":["CA - OT"],                                    "pools":["NP_NA_CA_02"]},
	]

	var CA_NAME_POOLS := {
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
			"l":  [""],
		},
		# Creek / Muscogee / Seminole — Southeast FL/GA/SC, 1780s–1790s
		"NP_NA_CREEK": {
			"m":  ["Menawa","Opothle","Yahola","Hadjo","Tustenuggee","Fixico","Emathla","Hoboithle","Thlucco","Coacoochee"],
			"f":  ["Sehoy","Coosaponakeesa","Wewoka","Okchai","Tallassee","Moniac","Talofah","Hichiti","Oki","Efvhvke"],
			"nb": ["Hatchee","Ekvnv","Hvse","Cedar","Talwa","Homosa"],
			"l":  [""],   # Nation-specific; will appear as single-name
		},
		# Algonquin (Anishinaabe Algonquin) — attested Kitigan Zibi / Pikwakanagan community names
		"NP_NA_CA_01": {
			"m":  ["Kichi","Mitigomij","Anoki","Makwa","Bizhiw","Animikiins","Pagak","Waaboz"],
			"f":  ["Waabishkizi","Ikwe","Ajijaak","Makoons","Zaagi","Miigizi","Nibiin","Giizhig"],
			"nb": ["Cedar","River","Fog","Ash","Birch","Stone"],
			"l":  ["Commanda","Decontie","Odjick","Ratt","Thusky","Jerome","Sarazin","Jocko"],
		},
		# Cree — attested Plains/Woodland Cree names and surnames
		"NP_NA_CA_02": {
			"m":  ["Mistahi","Asiniy","Kihiw","Mahihkan","Ocekos","Kinosew","Wapos","Piyesis"],
			"f":  ["Iskwew","Nipin","Seepeetza","Wapan","Atim","Kisik","Nipiy","Miyo"],
			"nb": ["Plains","Wind","Sky","Moss","Thorn","Willow"],
			"l":  ["Custer","Swifthawk","Badger","Moostoos","Dreaver","Favel","Ahenakew","Sanderson"],
		},
		# Mi'kmaq — attested Mi'kmaw community names and surnames
		"NP_NA_CA_03": {
			"m":  ["Kluskap","Sipuk","Apistanewj","Kitpu","Wiksedaqan","Sulapk","Metawe","Elpit"],
			"f":  ["Nukumi","Sipu","Wejkwapeniaq","Tepkunset","Mimkej","Aplikinej","Kespukwitk","Lnu"],
			"nb": ["Tide","Shore","Fog","Birch","Spruce","Eel"],
			"l":  ["Bernard","Gould","Denny","Francis","Googoo","Joe","Julian","Marshall","Paul","Sock"],
		},
	}

	# ── Spawn Jessica Commanda Odjick (leader) at Ottawa, tile 201 ──────────────────
	var jessica: governor = governor.new()
	jessica.buildSelf("Jessica Commanda Odjick", 3)
	country_node.unlockedGovernors.append(jessica)
	country_node.NatLeader = jessica
	for tile in $TileController.get_children():
		if tile.tileNumber == 201 and tile.tileOwner == country_node.CID:
			tile.tileGovernor       = jessica
			tile.filledGovernorSlot = true
			jessica.hired           = true
			print("[CA Leaders] Jessica Commanda Odjick stationed at Ottawa (tile 201).")
			break
	#if not jessica.hired:
#	if not jessica.hired:

	# ── Spawn Marc Penoit (deputy/VP) at Saint-Georges, tile 99 ─────────────────
	# Montreal (tile 94) is UK-occupied at game start; Saint-Georges is the nearest
	# CA-owned Quebec tile with a fortress (fortress:2, barracks:2).
	var mark: governor = governor.new()
	mark.buildSelf("Marc Penoit", 2)
	country_node.unlockedGovernors.append(mark)
	for tile in $TileController.get_children():
		if tile.tileNumber == 99 and tile.tileOwner == country_node.CID:
			tile.tileGovernor       = mark
			tile.filledGovernorSlot = true
			mark.hired              = true
			print("[CA Leaders] Marc Penoit stationed at Saint-Georges (tile 99).")
			break
	#if not mark.hired:
#	if not mark.hired:

	var used_names: Dictionary = {}
	var generated: int = 0

	for tile in $TileController.get_children():
		if tile.tileOwner != country_node.CID:
			continue
		if not tile.buildings.has("barracks"):
			continue
		if tile.filledGovernorSlot:
			continue

		var candidates: Array = []
		for arch in CA_ARCHETYPES:
			var terrain_ok: bool = tile.terrain in arch["terrain"]
			var regions: Array = arch.get("regions", [])
			var region_ok: bool = regions.is_empty() or tile.tileContinent in regions
			if terrain_ok and region_ok:
				candidates.append(arch)
		if candidates.is_empty():
			for arch in CA_ARCHETYPES:
				if tile.terrain in arch["terrain"]:
					candidates.append(arch)
		if candidates.is_empty():
			candidates = CA_ARCHETYPES
		var chosen_arch: Dictionary = candidates[randi() % candidates.size()]

		var pool_id: String = chosen_arch["pools"][randi() % chosen_arch["pools"].size()]
		var pool: Dictionary = CA_NAME_POOLS.get(pool_id, CA_NAME_POOLS["NP_06"])

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

		var tries: int = 0
		while used_names.has(full_name) and tries < 8:
			first = first_list[randi() % first_list.size()]
			full_name = (first + " " + last).strip_edges()
			tries += 1
		used_names[full_name] = true

		var new_gov: governor = governor.new()
		new_gov.governorType        = full_name
		new_gov.governorArchetypeId = chosen_arch["id"]
		new_gov.governorPosition    = chosen_arch["position"]
		new_gov.governorLevel       = 1
		_apply_archetype_mods(new_gov, chosen_arch["id"])
		new_gov.governorDescription = \
			"A " + chosen_arch["name"] + " from " + tile.tileName + "."
		new_gov.governorBiography   = \
			full_name + " from " + tile.tileName + " (" + tile.terrain + "). " + \
			"A " + chosen_arch["name"] + " defending the colony."
		new_gov.hired = false

		country_node.unlockedGovernors.append(new_gov)
		tile.tileGovernor      = new_gov
		tile.filledGovernorSlot = true
		new_gov.hired           = true

		#generated += 1
			  #" at ", tile.tileName, " [", tile.terrain, "]")
			  #" at ", tile.tileName, " [", tile.terrain, "]")

	# Assign tile governors to stationed armies
	var assigned: int = 0
	for army in country_node.countryArmyList:
		if army.inTile != null and army.inTile.tileGovernor != null:
			army.addUnitCommander(army.inTile.tileGovernor)
			army.updateArmyUI()
			assigned += 1
			#assigned, " armies received a commander.")
		  #assigned, " armies received a commander.")


# ── CANADIAN AI STARTING ARMIES ──────────────────────────────────────────────
# Spawns up to 4 armies at CA-owned barracks tiles (level 2+) that already
# have a governor assigned.  Must run after _generate_ai_barracks_commanders().
func _spawn_ai_starting_armies(country_node) -> void:
	var CA_ARMY_SUFFIX := {
		"CA_ARC_01": "Coureurs Company",   "CA_ARC_02": "River Brigade",
		"CA_ARC_03": "Forest Trackers",    "CA_ARC_04": "Loyalist Militia",
		"CA_ARC_05": "Montreal Guard",     "CA_ARC_06": "Habitant Rifles",
		"CA_ARC_07": "Colonial Infantry",  "CA_ARC_08": "Iroquois Warriors",
		"CA_ARC_09": "Acadian Rangers",    "CA_ARC_10": "Timber Men",
	}

	var candidates: Array = []
	for tile in $TileController.get_children():
		if tile.tileOwner != country_node.CID:
			continue
		if not tile.filledGovernorSlot or tile.tileGovernor == null:
			continue
		var blvl: int = int(tile.buildings.get("barracks", 0))
		if blvl < 1:
			continue
		if tile.stationedArmy != null:
			continue
		candidates.append(tile)

	candidates.shuffle()
	var chosen: Array = candidates.slice(0, min(4, candidates.size()))

	for tile in chosen:
		var gov: governor = tile.tileGovernor
		var arc_id: String = gov.governorArchetypeId if gov.governorArchetypeId != "" else "CA_ARC_06"
		var army_name: String = tile.tileName + " " + CA_ARMY_SUFFIX.get(arc_id, "Colonial Militia")

		country_node.addArmy(army_name, tile.tileNumber)

		var new_army = country_node.countryArmyList.back()
		if new_army != null:
			new_army.addUnitCommander(gov)
			new_army.updateArmyUI()
			new_army.raiseSelf()

	print("[CA Armies] ", chosen.size(), " starting armies placed for ", country_node.CID, ".")


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
			newCountry.commanderFallen.connect(_on_commander_fallen)
		elif isCoopMode and ((playerCountry == "USA" and countryCID == "CA") or
				(playerCountry == "CA" and countryCID == "USA")):
			newCountry.Player = true
			coopCountryNode = newCountry
			newCountry.commanderFallen.connect(_on_commander_fallen)
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

	# Verify player country was found
	if playerCountryNode == null:
		push_error("spawnNewGameCountries: playerCountryNode is null! CID='%s' not in CountryDatabase." % playerCountry)
	#else:

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
		if not country.armyRepositioned.is_connected(_on_ai_army_repositioned):
			country.armyRepositioned.connect(_on_ai_army_repositioned)
		if not country.aiCombatEvent.is_connected(_on_ai_combat_event):
			country.aiCombatEvent.connect(_on_ai_combat_event)
		if not country.battleResolved.is_connected(_on_ai_battle_resolved):
			country.battleResolved.connect(_on_ai_battle_resolved)

func _raise_starting_armies() -> void:
	# Raises every army that was created during NewGameBuild() (CSV-named starting
	# armies like the Continental Army). Must be called AFTER connectCountrySignals()
	# so raiseThisArmySignal is wired before the emit fires.
	for country in aliveCountriesList:
		for army in country.countryArmyList:
			army.raiseSelf()

func updateBeliefControl():
	$CanvasLayer/BeliefControl.updateSelf()
	pass


# ── TURN ORDER & PHASE SYSTEM ────────────────────────────────────────────────

func _build_turn_order() -> void:
	_player_turn_order.clear()
	# USA always goes before CA in co-op; solo games have one entry.
	if isCoopMode:
		_player_turn_order.append("USA")
		_player_turn_order.append("CA")
	else:
		_player_turn_order.append(playerCountry)
	_turn_phase_index = 0
	# playerCountryNode is already correct from newGameBuild; just update button text.
	_update_turn_phase_ui()


func _activate_player(cid: String) -> void:
	for c in aliveCountriesList:
		if c.CID == cid:
			playerCountry     = cid
			playerCountryNode = c
			break
	$CanvasLayer.assignPlayerNode(playerCountryNode)
	$CanvasLayer/TechTree.buildSelf(playerCountryNode)
	$CanvasLayer/BeliefControl.buildSelf(playerCountryNode)
	$CanvasLayer/BuildingInfoPanel/buildingPanelPanel.player = playerCountryNode
	$PathControl.connectPathPoints(playerCountryNode)
	$CanvasLayer/WarRoomPanel.buildSelf(playerCountryNode)
	var prot_filter: String = "COOP" if isCoopMode else playerCountry
	$CanvasLayer/WarRoomPanel.setupAllProtectors($TileController.get_children(), prot_filter)
	_update_turn_phase_ui()
	updateResourceBar()
	updateMap()
	print("[TurnOrder] Active player: ", playerCountry)


func _update_turn_phase_ui() -> void:
	var btn = $CanvasLayer/NextTurnControl/NextTurn
	if _player_turn_order.is_empty():
		btn.text = "Next Turn"
		return
	var active_cid: String = _player_turn_order[_turn_phase_index] if _turn_phase_index < _player_turn_order.size() else ""
	match active_cid:
		"USA":
			btn.text = "End USA Turn" if isCoopMode else "Next Turn"
		"CA":
			btn.text = "End Canada Turn" if isCoopMode else "Next Turn"
		_:
			btn.text = "Next Turn"


func _end_current_player_turn() -> void:
	# Per-player end-of-turn processing for the currently active country
	playerCountryNode.surveyResources()
	for pathPointButton in $PathControl/PathPointsControl.get_children():
		if pathPointButton.get_children() != null:
			for civilianPathFollow in pathPointButton.get_children():
				if civilianPathFollow.is_class("Button") != true:
					civilianPathFollow.emitTileChange()
	$CanvasLayer/SpellSchoolsControl.updateMagicAmounts(playerCountryNode)
	$CanvasLayer/TechTree.investInTech(playerCountryNode.SPM)


func _set_active_country_no_ui(cid: String) -> void:
	for c in aliveCountriesList:
		if c.CID == cid:
			playerCountry     = cid
			playerCountryNode = c
			return


func _resolve_ai_and_advance_round() -> void:
	# All non-player countries take their AI turn (battles are recorded, shown afterward)
	_ai_playback_queue.clear()
	_defer_events = true
	for c in aliveCountriesList:
		if c.CID not in _player_turn_order:
			_ai_recording_country = c
			c.calculateTurn()
	_ai_recording_country = null
	# Replay the AI's turn with camera + damage numbers so the player can watch it
	await _play_ai_turn()
	$CanvasLayer/WarRoomPanel.checkObjectives($TileController.get_children(), currentWorldTurn)
	currentWorldTurn += 1
	_advance_fortnight()
	_tick_storms()
	_apply_storm_debuffs()
	# Apply per-player effects and fire events without rebuilding the UI each time
	for pcid in _player_turn_order:
		_set_active_country_no_ui(pcid)
		_apply_winter_army_drain()
		evaluateDateEvents()
	for tile in $TileController.get_children():
		tile.tick_conquest_timer()
	$CanvasLayer/TurnLabel.text = _format_game_date()
	_apply_ualani_aura()
	_check_win_conditions()
	_show_ai_turn_report()
	# Player's turn begins — release the events the AI turn queued so they don't block the replay.
	_defer_events = false
	_show_next_event()
	# playerCountry/Node now hold last player in order; caller calls _activate_player to restore


func switchActivePlayer() -> void:
	if not isCoopMode or coopCountryNode == null:
		return
	var temp = playerCountryNode
	playerCountryNode = coopCountryNode
	coopCountryNode   = temp
	playerCountry     = playerCountryNode.CID
	print("[Coop] Switched active player to: ", playerCountry)
	updatePlayerUI()
	$CanvasLayer/WarRoomPanel.buildSelf(playerCountryNode)
	var coop_country_id: String = "COOP" if isCoopMode else playerCountry
	$CanvasLayer/WarRoomPanel.setupAllProtectors($TileController.get_children(), coop_country_id)

func updatePlayerUI():
	$CanvasLayer.assignPlayerNode(playerCountryNode)
	if not $CanvasLayer/TileInfoPanel.selectThisTile.is_connected(assignSelectedTile):
		$CanvasLayer/TileInfoPanel.selectThisTile.connect(assignSelectedTile)
	if not $CanvasLayer/TileInfoPanel.governorButtonPressed.is_connected(openGovernorsPanel):
		$CanvasLayer/TileInfoPanel.governorButtonPressed.connect(openGovernorsPanel)
	if not $CanvasLayer/TileInfoPanel.confirmThisGovernor.is_connected(assignGovernor):
		$CanvasLayer/TileInfoPanel.confirmThisGovernor.connect(assignGovernor)
	$CanvasLayer/TechTree.buildSelf(playerCountryNode)
	if not $CanvasLayer/TechTree.addTechToPlayer.is_connected(newPlayerTech):
		$CanvasLayer/TechTree.addTechToPlayer.connect(newPlayerTech)
	$CanvasLayer/BeliefControl.buildSelf(playerCountryNode)
	$CanvasLayer/BuildingInfoPanel/buildingPanelPanel.player = playerCountryNode
	if not $PathControl.activateArmyControlMode.is_connected(activateArmyControl):
		$PathControl.activateArmyControlMode.connect(activateArmyControl)
	$PathControl.connectPathPoints(playerCountryNode)
	if not $PathControl.updateArmy.is_connected(updateArmyFunc):
		$PathControl.updateArmy.connect(updateArmyFunc)
	if not $PathControl.updatePathPoints.is_connected(updatePathPointsFunc):
		$PathControl.updatePathPoints.connect(updatePathPointsFunc)
	if not $PathControl.updateCivilian.is_connected(updateCivFunc):
		$PathControl.updateCivilian.connect(updateCivFunc)
	if not $PathControl.tileDevelopment.is_connected(newTileDevelopment):
		$PathControl.tileDevelopment.connect(newTileDevelopment)
	if not $PathControl.meleeButtonPressed.is_connected(meleePressed):
		$PathControl.meleeButtonPressed.connect(meleePressed)
	if not $PathControl.rangedButtonPressed.is_connected(rangedPressed):
		$PathControl.rangedButtonPressed.connect(rangedPressed)
	if not $PathControl.playerBattleResolved.is_connected(_on_player_battle_resolved):
		$PathControl.playerBattleResolved.connect(_on_player_battle_resolved)
	$CanvasLayer/CivilianControl.loadCivilians(playerCountryNode, playerCountryNode.OwnedTileList)
	if not $CanvasLayer/CivilianControl.raiseThisUnit.is_connected(raiseCivilianUnit):
		$CanvasLayer/CivilianControl.raiseThisUnit.connect(raiseCivilianUnit)
	$CanvasLayer/MilitaryPanelControl.buildSelf(playerCountryNode)
	if not $CanvasLayer/MilitaryPanelControl.newArmySignal.is_connected(buildNewPlayerArmy):
		$CanvasLayer/MilitaryPanelControl.newArmySignal.connect(buildNewPlayerArmy)
	if not playerCountryNode.displayCommander.is_connected(UICommander):
		playerCountryNode.displayCommander.connect(UICommander)
	if not playerCountryNode.checkingOutput.is_connected(returnOutput):
		playerCountryNode.checkingOutput.connect(returnOutput)
	$CanvasLayer/GovernmentControl.buildSelf(playerCountryNode)
	if not $CanvasLayer/GovernmentControl.addToConstitution.is_connected(addLawToCountry):
		$CanvasLayer/GovernmentControl.addToConstitution.connect(addLawToCountry)
	if not $CanvasLayer/FactionControl.newRewardSend.is_connected(addNewRewards):
		$CanvasLayer/FactionControl.newRewardSend.connect(addNewRewards)
	for faction in playerCountryNode.countryFactionList:
			$CanvasLayer/FactionControl.addFaction(
				faction.factionName,
				faction.factionLoyalty,
				faction.factionLeader
			)
	$CanvasLayer/SpellSchoolsControl.connectSchools()
	if not $CanvasLayer/SpellSchoolsControl.lvlUpSpell.is_connected(newSpellEvent):
		$CanvasLayer/SpellSchoolsControl.lvlUpSpell.connect(newSpellEvent)
	#if not #$CanvasLayer/SpellSchoolsControl.askForInfo.is_connected(giveSpellInfo):
		#$CanvasLayer/SpellSchoolsControl.askForInfo.connect(giveSpellInfo)
	if not $CanvasLayer/Spellbook.spellToUse.is_connected(activateSpellMapMode):
		$CanvasLayer/Spellbook.spellToUse.connect(activateSpellMapMode)
	if not $TileController.spellAssignedToTile.is_connected(spellPurchased):
		$TileController.spellAssignedToTile.connect(spellPurchased)
	#if not #$TileController.colonizeTile.is_connected(updateCountryTiles):
		#$TileController.colonizeTile.connect(updateCountryTiles)
	if not $TileController.newTileOwner.is_connected(tileSiegeWon):
		$TileController.newTileOwner.connect(tileSiegeWon)
	$PathControl.call_deferred("showPathPoints", playerCapitalPathButton)
	$CanvasLayer/BuildingInfoPanel.buildSelf(playerCountryNode)
	if not $CanvasLayer/BuildingInfoPanel.newBuildingInTile.is_connected(addNewBuildingToTile):
		$CanvasLayer/BuildingInfoPanel.newBuildingInTile.connect(addNewBuildingToTile)
	if not $CanvasLayer/TileInfoPanel.retrieveTileOutputs.is_connected(retrieveOutputs):
		$CanvasLayer/TileInfoPanel.retrieveTileOutputs.connect(retrieveOutputs)
	#$PathControl.makeAllContainersPassable()
	#print("ALL I NEED")
	# War Room panel wiring
	$CanvasLayer/WarRoomPanel.buildSelf(playerCountryNode)
	if not $CanvasLayer/WarRoomPanel.requestEventFire.is_connected(_on_arc_event_requested):
		$CanvasLayer/WarRoomPanel.requestEventFire.connect(_on_arc_event_requested)
	if not $CanvasLayer/WarRoomPanel.protectorSummoned.is_connected(_on_protector_summoned):
		$CanvasLayer/WarRoomPanel.protectorSummoned.connect(_on_protector_summoned)
	if not $CanvasLayer/TechTree.investmentChanged.is_connected(_refresh_next_turn_ui):
		$CanvasLayer/TechTree.investmentChanged.connect(_refresh_next_turn_ui)
	updateResourceBar()
	_refresh_next_turn_ui()
	updateMap()

var thisTileNumber: int
var selectedTile: Tile
var _hovered_tile: Tile = null


func manaUpdate(type, amount, dictionary):
	$CanvasLayer/TileInfoPanel.buildTileOutput(type, amount, dictionary)
	pass

func tileClicked(tile):
	selectedTile = tile
	# Left-click a tile: deselect any army + open tile info (movement is right-click).
	$PathControl.deselectAll()
	$CanvasLayer/TileInfoPanel.displayTileInfo(tile)
	if $CanvasLayer/TileInfoPanel.visible == false:
		$CanvasLayer.closeAllPanels()
		$CanvasLayer/TileInfoPanel.visible = true
	else:
		$CanvasLayer/TileInfoPanel.visible = false
	$CanvasLayer/BuildingInfoPanel.displayBuildingInfo(tile)

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

func _resource_hover_enter(panel_x: int, resource_index: int, mode: String) -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = panel_x
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, resource_index)
	if mode != "":
		_hover_saved_mapMode = mapMode
		mapMode = mode
		updateMap()

func _resource_hover_exit() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	if _hover_saved_mapMode != "":
		mapMode = _hover_saved_mapMode
		_hover_saved_mapMode = ""
		updateMap()

func _on_food_area_2d_mouse_entered():    _resource_hover_enter(360,  1, "MapFood")
func _on_food_area_2d_mouse_exited():     _resource_hover_exit()
func _on_wood_area_2d_mouse_entered():    _resource_hover_enter(480,  2, "MapWood")
func _on_wood_area_2d_mouse_exited():     _resource_hover_exit()
func _on_metal_area_2d_mouse_entered():   _resource_hover_enter(600,  3, "MapMetal")
func _on_metal_area_2d_mouse_exited():    _resource_hover_exit()
func _on_gold_area_2d_mouse_entered():    _resource_hover_enter(240,  0, "MapDollars")
func _on_gold_area_2d_mouse_exited():     _resource_hover_exit()
func _on_weapons_area_mouse_entered():    _resource_hover_enter(720,  4, "MapWeapons")
func _on_weapons_area_mouse_exited():     _resource_hover_exit()
func _on_science_area_mouse_entered():    _resource_hover_enter(1000, 5, "")
func _on_science_area_mouse_exited():     _resource_hover_exit()
func _on_faith_control_mouse_entered():   _resource_hover_enter(1000, 6, "MapFaith")
func _on_faith_control_mouse_exited():    _resource_hover_exit()
func _on_magic_area_mouse_entered():      _resource_hover_enter(1000, 7, "MapMagic")
func _on_magic_area_mouse_exited():       _resource_hover_exit()
func _on_culture_area_mouse_entered():    _resource_hover_enter(1000, 8, "MapFaith")
func _on_culture_area_mouse_exited():     _resource_hover_exit()
func _on_mandate_area_mouse_entered():    _resource_hover_enter(1440, 9, "MapMandate")
func _on_mandate_area_mouse_exited():     _resource_hover_exit()
func _on_harmony_area_mouse_entered():    _resource_hover_enter(1440, 10, "MapHappiness")
func _on_harmony_area_mouse_exited():     _resource_hover_exit()
func _on_influence_area_mouse_entered():  _resource_hover_enter(1440, 11, "")
func _on_influence_area_mouse_exited():   _resource_hover_exit()
func _on_manpower_area_mouse_entered():   _resource_hover_enter(840,  12, "MapManpower")
func _on_manpower_area_mouse_exited():    _resource_hover_exit()

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
		$CanvasLayer.closeAllPanels()
		$CanvasLayer/MilitaryPanelControl.visible = true
		for BarracksButton in $CanvasLayer/MilitaryPanelControl/ScrollContainer/GridContainer.get_children():
			BarracksButton.updateSelf()
	else:
		$CanvasLayer/MilitaryPanelControl.visible = false
	
const armyScene = preload("res://Game Scenes and Scripts/army.tscn")
func buildNewPlayerArmy(barracksBuilding, barracksTile, bbButton, playerNode, newArmyName):
	# Cost scales +20% per previously purchased army (game-start armies not counted).
	var n: int  = playerNode.purchasedArmyCount
	var cost: int = ceili(10.0 * pow(1.2, n))
	if playerNode.TotalDollars  < cost or playerNode.TotalWeapons < cost or playerNode.TotalCulture < cost or playerNode.TotalScience < cost:
		print(" each of Dollars / Weapons / Culture / Science (army #", n + 1, ")")
			  #" each of Dollars / Weapons / Culture / Science (army #", n + 1, ")")
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
			Army.applyCountryBeliefMilMods()

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

# ── ITEM 1: APF REPOSITIONING ────────────────────────────────────────────────
# Called when an AI army conquers a tile.  Reparents the APF node from the old
# pathPointButton to the new one so the visual token reflects the move.
func _on_ai_army_repositioned(army: Army, old_tile: Tile, new_tile: Tile) -> void:
	if not is_instance_valid(army) or old_tile == null or new_tile == null:
		return
	var new_ppb = new_tile.tileSpawnPoint
	if new_ppb == null:
		return
	# Find this army's APF — try old_tile.tileSpawnPoint.stationedAPF first, then
	# search raisedPlayerAPFs so stale stationedAPF references don't strand the APF.
	var apf = null
	var apf_ppb = null
	var old_ppb = old_tile.tileSpawnPoint
	if old_ppb != null and old_ppb.stationedAPF != null \
			and is_instance_valid(old_ppb.stationedAPF) \
			and old_ppb.stationedAPF.thisArmy == army:
		apf = old_ppb.stationedAPF
		apf_ppb = old_ppb
	else:
		for candidate in $PathControl.raisedPlayerAPFs:
			if is_instance_valid(candidate) and candidate.thisArmy == army:
				apf = candidate
				apf_ppb = candidate.currentPathPoint
				break
	if apf == null or not is_instance_valid(apf_ppb):
		return
	apf_ppb.remove_child(apf)
	apf_ppb.stationedAPF = null
	apf_ppb.stationedArmy = null
	apf_ppb.occupied = false
	new_ppb.add_child(apf)
	new_ppb.stationedAPF = apf
	new_ppb.stationedArmy = army
	new_ppb.occupied = true
	apf.currentPathPoint = new_ppb
	apf.currentTile = new_tile
	# Record the move for the AI-turn replay (played back as an animated march).
	_ai_playback_queue.append({
		"kind": "move", "apf": apf,
		"old_tile": old_tile, "new_tile": new_tile,
		"country": _ai_recording_country,
	})

# ── ITEM 4: AI COMBAT LOG ─────────────────────────────────────────────────────
func _on_ai_combat_event(attacker_cid: String, tile, result: String) -> void:
	var tname = tile.tileName if tile != null else "?"
	_ai_combat_log.append({"attacker": attacker_cid, "tile": tname, "result": result})
	# Record every AI attack/capture for the replay tour; attach any battle losses stashed above.
	_ai_playback_queue.append({
		"kind": "combat", "tile": tile, "result": result,
		"atk_loss": _stashed_atk_loss, "def_loss": _stashed_def_loss,
		"country": _ai_recording_country,
	})
	_stashed_atk_loss = 0
	_stashed_def_loss = 0

func _show_ai_turn_report() -> void:
	if _ai_combat_log.is_empty():
		_ai_combat_log.clear()
		return
	var lines: PackedStringArray = []
	for entry in _ai_combat_log:
		var verb := "captured" if entry.result == "captured" else "attacked"
		lines.append("%s %s %s" % [entry.attacker, verb, entry.tile])
	var report := "[b]Enemy Activity[/b]\n" + "\n".join(lines)
	var label = get_node_or_null("CanvasLayer/TurnLabel")
	if label != null:
		label.text = _format_game_date() + "\n" + "\n".join(lines)
	_ai_combat_log.clear()

# ── FLOATING DAMAGE NUMBERS ───────────────────────────────────────────────────
func focus_camera_on(node, duration: float = 0.45) -> void:
	# Smoothly pan the map camera to center on a node (tile spawn point, army token, etc.).
	if node == null or not is_instance_valid(node):
		return
	var cam = $CameraMovementController/Camera2D
	if cam == null:
		return
	var tw = create_tween()
	tw.tween_property(cam, "global_position", node.global_position, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _spawn_damage_number(amount: int, color: Color, world_pos: Vector2, x_offset: float) -> void:
	if amount <= 0:
		return
	var node = _floating_damage_scene.instantiate()
	add_child(node)
	node.z_index = 200            # draw above tiles + army tokens
	node.global_position = world_pos + Vector2(x_offset, 0.0)
	node.setup(amount, color)

func _on_battle_resolved(tile, atk_loss: int, def_loss: int) -> void:
	if tile == null or tile.tileSpawnPoint == null:
		return
	var base_pos: Vector2 = tile.tileSpawnPoint.global_position
	_spawn_damage_number(atk_loss, Color(1.0, 0.4, 0.1), base_pos, -28.0)
	_spawn_damage_number(def_loss, Color(1.0, 0.85, 0.1), base_pos, 28.0)

func _on_player_battle_resolved(tile, atk_loss: int, def_loss: int) -> void:
	_on_battle_resolved(tile, atk_loss, def_loss)


func _on_ai_battle_resolved(tile, atk_loss: int, def_loss: int) -> void:
	# A real army-vs-army battle: stash losses so the following aiCombatEvent attaches them.
	_stashed_atk_loss = atk_loss
	_stashed_def_loss = def_loss


func _play_ai_turn() -> void:
	# Replay the AI round: marches, sieges, and battles with camera + numbers.
	if _ai_playback_queue.is_empty():
		return
	_playing_ai = true
	_skip_ai_playback = false
	for entry in _ai_playback_queue:
		if _skip_ai_playback:
			if entry.get("kind") != "move":
				_show_ai_battle(entry)
			continue
		if entry.get("kind") == "move":
			await _play_ai_move(entry)
		else:
			var tile = entry.get("tile")
			if is_instance_valid(tile) and tile.tileSpawnPoint != null:
				focus_camera_on(tile.tileSpawnPoint, 0.35)
				await get_tree().create_timer(0.4).timeout
			_show_ai_battle(entry)
			await get_tree().create_timer(0.5).timeout
	_ai_playback_queue.clear()
	_playing_ai = false


func _play_ai_move(entry) -> void:
	var apf = entry["apf"]
	var old_tile = entry["old_tile"]
	var new_tile = entry["new_tile"]
	if not is_instance_valid(apf) or old_tile == null or new_tile == null \
			or old_tile.tileSpawnPoint == null or new_tile.tileSpawnPoint == null:
		return
	var from_pos: Vector2 = old_tile.tileSpawnPoint.global_position
	var to_pos: Vector2 = new_tile.tileSpawnPoint.global_position
	focus_camera_on(new_tile.tileSpawnPoint, 0.35)
	apf.z_as_relative = false
	apf.z_index = 100
	apf.global_position = from_pos
	var tw = create_tween()
	tw.tween_property(apf, "global_position", to_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tw.finished
	apf.z_as_relative = true
	apf.z_index = 15


func _show_ai_battle(entry) -> void:
	# HOOK: entry["country"] is available here for a future 'Jessica's / George III's Turn' banner.
	var al = entry.get("atk_loss", 0)
	var dl = entry.get("def_loss", 0)
	if al > 0 or dl > 0:
		_on_battle_resolved(entry.get("tile"), al, dl)


func _unhandled_input(event: InputEvent) -> void:
	# A click or keypress during the AI replay fast-forwards it.
	if _playing_ai and event.is_pressed():
		_skip_ai_playback = true

func raiseArmyFromWorld(Army, country, Tile):
	if Tile == null or not is_instance_valid(Tile):
		push_warning("raiseArmyFromWorld: Tile is null for army '%s' — skipped" % Army.ArmyName)
		return
	pathPointButtonToSend = Tile.tileSpawnPoint
	if pathPointButtonToSend == null:
		push_warning("raiseArmyFromWorld: no spawn point on tile '%s' for army '%s' — skipped" % [Tile.tileName, Army.ArmyName])
		return
	if country == playerCountryNode:
		$PathControl.raisePlayerArmy(Army, country, Tile, pathPointButtonToSend)
	else:
		$PathControl.raiseComputerArmy(Army, country, Tile, pathPointButtonToSend)
func raiseCivilianUnit(civ, country):
	var civTile = civ.stationNode.ppbTile if civ.stationNode != null else null
	$PathControl.raisePlayerCiv(civ, country, civTile)
	pass

func activateArmyControl():
	armyMode = true
	pass

var eventScene = load("res://eventScene.tscn")
var _event_queue: Array = []      # pending events, shown one at a time
var _event_showing: bool = false # true while an event panel is on screen
var _defer_events: bool = false  # true during an AI turn — events queue, then flush at the player's turn

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
			  #" (", school, ") stationed at ", origin_tile.tileName)
			 # " (", school, ") stationed at ", origin_tile.tileName)
	var spell_name: String = _protector_id_to_spell(protector_id)
	if spell_name != "":
		playerCountryNode.addSpellToSpellbook(spell_name, 1, 0)
		print("[Protectors] Presidential Power unlocked: ", spell_name)


# Called when any protector AGREE event button sets a "*_agreed" flag.
# Builds a Tower at the protector's home tile (if none exists), assigns the protector
# as that tile's wizard, and grants the associated Presidential Power spell.
func _on_protector_agreed(agreed_flag: String) -> void:
	# "prot_01_agreed" → "PROT_01",  "ca_prot_01_agreed" → "CA_PROT_01"
	var pid: String = agreed_flag.replace("_agreed", "").to_upper()
	var prot_name: String = _protector_id_to_name(pid)

	var home_tile = _get_ca_prot_tile(pid) if pid.begins_with("CA_") else _get_prot_tile(pid)

	if home_tile != null:
		# Build a Tower at the home tile if one doesn't exist yet
		var has_tower: bool = false
		for b in home_tile.tileBuildingsList:
			if b.buildingType == "Tower":
				has_tower = true
				break
		if not has_tower:
			home_tile.addBuilding("Tower", 1)

		# Assign the protector as the tile's wizard so the tower produces their school's magic
		var school: String = _protector_id_to_school(pid)
		home_tile.addWizard(prot_name, school)
			 # home_tile.tileNumber, " — ", home_tile.tileName)
			 # home_tile.tileNumber, " — ", home_tile.tileName)
	else:
		push_warning("[Protectors] No home tile mapped for " + pid)

	# Unlock the Presidential Power spell associated with this protector
	var spell_name: String = _protector_id_to_spell(pid)
	if spell_name != "":
		playerCountryNode.addSpellToSpellbook(spell_name, 1, 0)
		print("[Protectors] Presidential Power unlocked: ", spell_name)

	# PROT_08: grant USS Constitution Support mil mod to all current armies
	if agreed_flag == "prot_08_agreed":
		for army in playerCountryNode.countryArmyList:
			army.applyCountryBeliefMilMods()
			army.surveySelf()
			army.updateArmyUI()
		print("[Protectors] USS Constitution Support granted to all player armies")

	# Reveal this protector's Records entry globally
	if get_node_or_null("/root/LibraryData"):
		LibraryData.discover_entry(pid)
		LibraryData.add_journal_entry(
			pid + "_agreed",
			currentWorldTurn,
			prot_name + " — Alliance Confirmed",
			"After [i]" + str(currentWorldTurn) + "[/i] turns, the accord was reached.\n\n"
			+ prot_name + " has agreed to serve as guardian of the Republic. "
			+ "A Tower has been raised at their home. The Presidential spell has been granted.",
			"EYES ONLY"
		)


func _protector_id_to_name(pid: String) -> String:
	match pid:
		"PROT_01": return "Mothman"
		"PROT_02": return "Jersey Devil"
		"PROT_03": return "Bigfoot"
		"PROT_04": return "Thunderbird"
		"PROT_05": return "Headless Horseman"
		"PROT_06": return "Chessie"
		"PROT_07": return "Bell Witch"
		"PROT_08": return "Old Ironsides"
		"PROT_09": return "Valley Forge Guardian"
		"PROT_10": return "Snallygaster"
		"PROT_11": return "Paul Revere"
		"PROT_12": return "Liberty Bell"
		"PROT_13": return "Green Mountain Ghost"
		"PROT_15": return "Skunk Ape"
		"PROT_16": return "Eternal Minuteman"
		"PROT_17": return "Lincoln's Ghost"
		"CA_PROT_01": return "Le Wendigo"
		"CA_PROT_02": return "Le Loup-Garou"
		"CA_PROT_03": return "Les Feux Follets"
		"CA_PROT_04": return "Mishepeshu"
		"CA_PROT_05": return "La Corriveau"
		"CA_PROT_06": return "Le Carcajou"
		"CA_PROT_07": return "La Chasse-Galerie"
		"CA_PROT_08": return "Le Gougou"
	return pid


func _protector_id_to_school(pid: String) -> String:
	match pid:
		"PROT_01", "PROT_02", "PROT_03", "PROT_10", "PROT_15": return "cryptid"
		"PROT_04", "PROT_06", "PROT_07":                        return "storm"
		"PROT_05", "PROT_13", "PROT_17":                        return "spectral"
		"PROT_08", "PROT_09", "PROT_16":                        return "iron"
		"PROT_11", "PROT_12":                                   return "liberty"
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
		"PROT_15": return "FLORIDA CRYPTID INTEGRATION TASK FORCE"
		"PROT_16": return "PERMANENT READINESS MANDATE (EXPIRES NEVER)"
		"PROT_17": return "EMANCIPATION PROCLAMATION 2: STILL EMANCIPATING"
	return ""

func createNewEvent(event_id: String, tile = null, prepend: bool = false) -> void:
	if not EventDatabase.event_can_fire(event_id, currentWorldTurn):
		return
	# Claim + enqueue now; panels are built and shown one at a time by _show_next_event().
	EventDatabase.mark_event_fired(event_id, currentWorldTurn)
	_library_on_event_fired(event_id)
	var item := {"event_id": event_id, "tile": tile}
	if prepend:
		_event_queue.push_front(item)   # chained (next_event_id) events jump the line so arcs stay contiguous
	else:
		_event_queue.push_back(item)
	_show_next_event()

func _show_next_event() -> void:
	if _event_showing or _event_queue.is_empty() or _defer_events:
		return
	var item: Dictionary = _event_queue.pop_front()
	var event_id: String = item["event_id"]
	var tile = item["tile"]
	var newEvent = eventScene.instantiate()
	if event_id == "CA_PM_LEGACY":
		newEvent.build_from_data(_build_ca_pm_legacy_data(), tile, playerCountryNode)
	elif event_id in ["CMD_THANKS", "CMD_THANKS_INTIMATE"] and tile != null and tile.tileGovernor != null:
		var is_exp: bool = (event_id == "CMD_THANKS_INTIMATE")
		newEvent.build_from_data(_build_cmd_thanks_data(tile, is_exp), tile, playerCountryNode)
	else:
		newEvent.build_from_csv(event_id, tile, playerCountryNode)
	newEvent.eventButtonPressed.connect(_on_event_button_pressed)
	newEvent.tileEventButtonPressed.connect(_on_tile_event_button_pressed)
	newEvent.tree_exited.connect(_on_event_dismissed)
	#AudioManager.play_sfx("event_shown")
	$CanvasLayer/EventControl/EventContainer.add_child(newEvent)
	_event_showing = true

func _on_event_dismissed() -> void:
	# Player closed an event (panel queue_free'd itself) — show the next queued one.
	_event_showing = false
	_show_next_event()


# Assembles CA_PM_LEGACY long_desc dynamically based on the player's CA run flags.
func _build_ca_pm_legacy_data() -> Dictionary:
	var flags: Dictionary = playerCountryNode.CountryFlags

	# ── Protector names by flag ───────────────────────────────────────────────
	var PROT_NAMES: Dictionary = {
		"ca_prot_01_agreed": "Le Wendigo",
		"ca_prot_02_agreed": "Le Loup-Garou",
		"ca_prot_03_agreed": "Les Feux Follets",
		"ca_prot_04_agreed": "Mishepeshu",
		"ca_prot_05_agreed": "La Corriveau",
		"ca_prot_06_agreed": "Le Carcajou",
		"ca_prot_07_agreed": "La Chasse-Galerie",
		"ca_prot_08_agreed": "Le Gougou",
	}
	var agreed: Array = []
	for f in PROT_NAMES:
		if flags.has(f):
			agreed.append(PROT_NAMES[f])

	# ── Check whether all Quebec tiles are held by the player ───────────────
	var quebec_total: int = 0
	var quebec_player: int = 0
	for t in $TileController.get_children():
		if t.get("tileContinent") == "Quebec":
			quebec_total += 1
			if t.get("tileOwner") == "CA":
				quebec_player += 1
	var quebec_held: bool = (quebec_total > 0 and quebec_player == quebec_total)

	# ── Count Quebec-rooted protectors ────────────────────────────────────────
	var QUEBEC_PROT_FLAGS: Array = [
		"ca_prot_01_agreed", "ca_prot_02_agreed",
		"ca_prot_05_agreed", "ca_prot_07_agreed",
	]
	var quebec_prot_count: int = 0
	for f in QUEBEC_PROT_FLAGS:
		if flags.has(f):
			quebec_prot_count += 1

	# ── Assemble paragraphs ───────────────────────────────────────────────────
	var parts: Array = []

	# Opening — always present
	parts.append("Marc Penoit's dispatch arrived before dawn. It was addressed to the Prime Minister personally. It did not begin with a salutation. It began: I have served this Republic for ninety-six turns. I have one more thing to say before I file it.")

	# Britain expelled
	if flags.has("uk_ca_peace"):
		parts.append("Britain is gone. I want to write that sentence again because I did not expect to write it once. The Crown that garrisoned this country for a century, that tried Corriveau and called it justice, that named our rivers and then mispronounced them — is gone. You did that. The Republic did that. I will not pretend I am not moved.")

	# Quebec liberated
	if quebec_held:
		parts.append("Quebec is free because of your actions. I was born in Montreal. I have carried this since I was nineteen years old in a café on Saint-Denis that no longer exists. The Quebecois people held the Saint Lawrence corridor for six weeks without reinforcement and without complaint and without leaving. You did not trade them away in a negotiation about something else. You did not forget them when the capital was under pressure. Our loyalty to you, to Ottawa, and to Canada will remain forever secure.")

	# Protectors
	if agreed.size() == 1:
		parts.append("I spent thirty years dismissing the old stories as strategically irrelevant. " + agreed[0] + " altered the course of this war. You did not laugh at what you could not explain. You acknowledged it. Canada's soul was not lost — it was waiting to be recognized. You recognized it.")
	elif agreed.size() >= 2:
		var names: String = ", ".join(agreed)
		parts.append("I want to name them, because the historians will not know where to begin. " + names + ". I spent thirty years dismissing the old stories. These were not legends that held — these were allies you earned because you treated them as this country always should have. Canada's soul has been restored. I did not think I would live to write that sentence. I am writing it.")

	# Alliance
	if flags.has("can_allied"):
		parts.append("The alliance with the Continental Republic holds. I was not certain it would survive the first year. It has survived four. When they write this history — and they will write it — the Accord will be the chapter that makes everything else legible.")

	# Penultimate — always present
	parts.append("You are the best Prime Minister this country has had. I have worked for three of them. I say this with the precision I apply to all my assessments and without qualification. This Republic exists because of decisions made in this office, by you, under conditions that would have broken most governments before the second year.")

	# Closing — independence decision, conditional on Quebec liberation + protectors
	if quebec_held and quebec_prot_count >= 2:
		parts.append("I have made a decision about Quebec. I am the President of Canada, and this decision belongs to me, and I am making it now. There will be no referendum. The Quebecois people have been answered — not in a vote but in everything you did before one was necessary. Quebec is free. Its soul has been acknowledged. The question I have been carrying since I was nineteen years old in a café on Saint-Denis is closed. The Republic of Canada is whole. The dispatch is filed. The record is complete. I remain, as always, at your service.")
	else:
		parts.append("I have made a decision about Quebec. I am the President of Canada, and this decision belongs to me, and I am making it now. There will be a referendum. I cannot in good conscience close the question while the answer remains incomplete. The Quebecois people deserve to be heard — not as a formality, but as a people whose loyalty was never unconditional and should not have been expected to be. Whatever they decide, I serve this Republic and I serve you. That does not change. The dispatch is filed. The record is complete. I remain, as always, at your service.")

	return {
		"event_id":      "CA_PM_LEGACY",
		"event_type":    "ca_vp",
		"country_cid":   "CA",
		"headline":      "MARC PENOIT'S FINAL ASSESSMENT — THE DEPUTY GOVERNOR WRITES HIS HISTORY",
		"short_desc":    "Marc Penoit Has Filed His Report. This One Is Not About Flanks.",
		"long_desc":     "\n\n".join(parts),
		"image_tag":     "penoit_legacy",
		"tone":          "Somber/Historic",
		"content_flag":  "",
		"repeatable":    "false",
		"cooldown_turns":"0",
		"buttons":       EventDatabase.get_buttons_for_event("CA_PM_LEGACY"),
	}


func _on_event_button_pressed(button_id: String, event_id: String,
		event_country: String, outcome_type: String,
		outcome_value: String, outcome_amount: int,
		next_event_id: String) -> void:
	executeOutcome(outcome_type, outcome_value, outcome_amount, null)
	if outcome_type == "set_flag" and outcome_value.ends_with("_agreed") \
			and (outcome_value.begins_with("prot_") or outcome_value.begins_with("ca_prot_")):
		#AudioManager.play_sfx("protector_agree")
		_on_protector_agreed(outcome_value)
	if next_event_id != "":
		createNewEvent(next_event_id, null, true)

func _on_tile_event_button_pressed(button_id: String, event_id: String,
		event_country: String, outcome_type: String,
		outcome_value: String, outcome_amount: int,
		next_event_id: String, tile: Tile) -> void:
	executeOutcome(outcome_type, outcome_value, outcome_amount, tile)
	if outcome_type == "set_flag" and outcome_value.ends_with("_agreed") \
			and (outcome_value.begins_with("prot_") or outcome_value.begins_with("ca_prot_")):
		#AudioManager.play_sfx("protector_agree")
		_on_protector_agreed(outcome_value)
	if next_event_id != "":
		createNewEvent(next_event_id, tile, true)

func executeOutcome(outcome_type: String, outcome_value: String,
		outcome_amount: int, tile) -> void:
	match outcome_type:
		"add_faction":
			var leader = _find_or_create_leader(outcome_value)
			$CanvasLayer/FactionControl.addFaction(outcome_value, outcome_amount, leader)
		"loyalty_change":
			var lc_faction: String = outcome_value
			if lc_faction == "vp_faction" and _vp_faction != "":
				lc_faction = _vp_faction
			if lc_faction == "ca_pm_faction" and _ca_vp_faction != "":
				lc_faction = _ca_vp_faction
			var lc_amount = outcome_amount
			if _vp_faction != "" and lc_faction == _vp_faction:
				lc_amount *= 2
			if lc_faction != "":
				playerCountryNode.changeFactionLoyalty(lc_faction, lc_amount)
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
		"resource_bundle":
			for _pair in outcome_value.split(","):
				var _kv = _pair.split(":")
				if _kv.size() == 2:
					_apply_resource_change(_kv[0].strip_edges().to_lower(), int(_kv[1].strip_edges()))
		"morale_boost":
			_apply_morale_boost(outcome_amount, tile)
		"harmony_boost":
			playerCountryNode.TotalHappiness += outcome_amount
		"promote_commander":
			# Level-up is now automatic via XP threshold — this outcome grants
			# a commendation morale bonus and faction loyalty to acknowledge the event
			if tile != null and tile.tileGovernor != null:
				tile.tileGovernor.morale = mini(tile.tileGovernor.morale + 20, 100)
				if tile.tileGovernor.governorFaction != "":
					playerCountryNode.changeFactionLoyalty(tile.tileGovernor.governorFaction, 1)
				if tile.stationedArmy != null:
					tile.stationedArmy.updateArmyUI()
				print("[Commander] Commendation issued to ", tile.tileGovernor.governorType)
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
		"propaganda_spread":
			for army in playerCountryNode.countryArmyList:
				army.propagandaBuff += int(outcome_amount)
				army.surveySelf()
				army.updateArmyUI()
			playerCountryNode.TotalMandate += 30
			updatePlayerUI()
		"quebec_manpower_refill":
			for army in playerCountryNode.countryArmyList:
				if army.inTile != null and army.inTile.tileContinent == "CA - QB":
					army.manpowerInArmy = army.maxManpower
					army.updateArmyUI()
		"summon_protector":
			_summon_protector(outcome_value, tile)
		"trigger_event":
			createNewEvent(outcome_value, tile)
		"form_alliance":
			playerCountryNode.CountryFlags["can_allied"] = true
			for c in aliveCountriesList:
				if c.CID == outcome_value:
					if not playerCountryNode.ALLIED.has(c):
						playerCountryNode.ALLIED.append(c)
					if not c.ALLIED.has(playerCountryNode):
						c.ALLIED.append(playerCountryNode)
						#playerCountryNode.CID, " ↔ ", c.CID)
						#playerCountryNode.CID, " ↔ ", c.CID)
					break
		"set_flag":
			playerCountryNode.CountryFlags[outcome_value] = true
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
					playerCountryNode.CountryFlags[flag_val] = true
					var timeout: int = int(outcome_amount)
					if timeout > 0:
						_mission_timers[flag_val] = timeout
					#else:
					#else:
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
					playerCountryNode.CountryFlags[flag_val] = true
					var timeout: int = int(outcome_amount)
					if timeout > 0:
						_mission_timers[flag_val] = timeout
					#else:
					#else:
		"governor_loyalty_change":
			if tile != null and tile.tileGovernor != null:
				tile.tileGovernor.loyalty = clampf(
					tile.tileGovernor.loyalty + float(outcome_amount), -20.0, 20.0)
					#" at ", tile.tileName, " → ", tile.tileGovernor.loyalty)
					#" at ", tile.tileName, " → ", tile.tileGovernor.loyalty)
		"election_pressure_change":
			if tile != null:
				tile.electionPressure = clampi(
					tile.electionPressure + outcome_amount, -100, 100)
				print("[Election] ", tile.tileName, " pressure → ", tile.electionPressure)
		"tile_yield":
			if tile != null:
				var turns: int = max(outcome_amount, 1)
				var per_turn: int = _get_tile_resource_output(tile, outcome_value)
				var total: int = per_turn * turns
				_apply_resource_change(outcome_value, total)
					#" ×", turns, " (", per_turn, "/turn) = ", total)
					#" ×", turns, " (", per_turn, "/turn) = ", total)
			else:
				push_warning("executeOutcome: tile_yield requires a tile context")
		"trigger_collapse":
			_execute_republic_collapse()
		"george_peace_accept":
			_apply_george_peace()
		"george_peace_reject":
			if not playerCountryNode.CountryFlags.has("george_peace_rejected"):
				playerCountryNode.CountryFlags["george_peace_rejected"] = true
			playerCountryNode.presidentialClaim = clampf(
				playerCountryNode.presidentialClaim + 1.0, -10.0, 10.0)
			print("[George Peace] Rejected — presidentialClaim +1")
		"cast_protector_buff":
			# outcome_value = protector buff name (e.g. "Mothman Presence")
			# outcome_amount = magic cost per turn (sustain cost)
			# tile context = apply to the stationed army in that tile
			if tile != null and tile.stationedArmy != null:
				tile.stationedArmy.apply_status(outcome_value, 9999, outcome_amount)
					#" — ", outcome_amount, " magic/turn")
					#" — ", outcome_amount, " magic/turn")
			else:
				push_warning("cast_protector_buff: no army at tile " + str(tile))
		"tile_building_mandate_surge":
			# +1 mandate per building level per turn × outcome_amount turns, paid as lump sum
			if tile != null:
				var total_levels: int = 0
				for b in tile.tileBuildingsList:
					if b.enabled:
						total_levels += b.buildingLevel
				var total: int = total_levels * outcome_amount
				_apply_resource_change("mandate", total)
					#" ×", outcome_amount, " turns = ", total, " mandate")
					#" ×", outcome_amount, " turns = ", total, " mandate")
			else:
				push_warning("tile_building_mandate_surge: requires tile context")
		"corrupt_windfall":
			# outcome_value = resource, outcome_amount = tile yield multiplier
			# Also adds +20 corruption to the tile
			if tile != null:
				var per_turn: int = _get_tile_resource_output(tile, outcome_value)
				var total: int = per_turn * outcome_amount
				_apply_resource_change(outcome_value, total)
				tile.corruption = mini(tile.corruption + 20, 100)
					#outcome_value, " | corruption now ", tile.corruption)
					#outcome_value, " | corruption now ", tile.corruption)
			else:
				push_warning("corrupt_windfall: requires tile context")
		"level_all_spell_schools":
			for i in range(outcome_amount):
				playerCountryNode.levelUpSchool("manifest")
				playerCountryNode.levelUpSchool("iron")
				playerCountryNode.levelUpSchool("storm")
				playerCountryNode.levelUpSchool("liberty")
				playerCountryNode.levelUpSchool("cryptid")
				playerCountryNode.levelUpSchool("spectral")
			print("[SpellSchools] All 6 schools +", outcome_amount, " levels")
		"gold_and_army_buff":
			# outcome_value = buff status name, outcome_amount = turns; also grants 50 gold
			_apply_resource_change("gold", 50)
			_apply_army_buff(outcome_value, outcome_amount, tile)
		"state_building_level_yield":
			if tile != null:
				var total_levels: int = 0
				var state: String = tile.tileContinent
				for t in $TileController.get_children():
					if t.tileOwner == playerCountry and t.tileContinent == state:
						for b in t.tileBuildingsList:
							if b.enabled:
								total_levels += b.buildingLevel
				var yield_amount: int = total_levels * outcome_amount
				_apply_resource_change(outcome_value, yield_amount)
					#" ×", outcome_amount, " = ", yield_amount, " ", outcome_value)
					#" ×", outcome_amount, " = ", yield_amount, " ", outcome_value)
			else:
				push_warning("state_building_level_yield: requires tile context")
		"set_governor_perk":
			if tile != null and tile.tileGovernor != null:
				if not tile.tileGovernor.governor_perks.has(outcome_value):
					tile.tileGovernor.governor_perks.append(outcome_value)
						#" unlocked perk: ", outcome_value)
						#" unlocked perk: ", outcome_value)
			else:
				push_warning("set_governor_perk: requires tile with governor")
		"tile_army_manpower_refill":
			if tile != null and tile.stationedArmy != null:
				tile.stationedArmy.manpowerInArmy = tile.stationedArmy.maxManpower
				tile.stationedArmy.updateArmyUI()
				print("[ManpowerRefill] ", tile.tileName, " army fully refilled")
			else:
				push_warning("tile_army_manpower_refill: no army at tile")
		"spawn_anarchist":
			_spawn_anarchist_army(tile)
		"reveal_british_tiles":
			var revealed_count: int = 0
			for t in $TileController.get_children():
				if t.tileOwner == "UK" or (t.stationedArmy != null and t.stationedArmy.parentCountry != null and t.stationedArmy.parentCountry.CID == "UK"):
					t.discoverTile()
					revealed_count += 1
			print("[RevealBritish] Revealed ", revealed_count, " British tiles")
		"all_armies_manpower_heal":
			var pct: float = float(outcome_amount) / 100.0
			for army in playerCountryNode.countryArmyList:
				for unit in army.unitsList:
					var heal: int = int(float(unit.unitMaxManpower) * pct)
					unit.unitCurrentManpower = mini(unit.unitCurrentManpower + heal, unit.unitMaxManpower)
				army.surveySelf()
				army.updateArmyUI()
			print("[ManpowerHeal] All armies healed ", outcome_amount, "% of max manpower")
		"halloween_endorsement":
			# Ghost presidents' blessing: +1 happiness per unit per turn for N turns
			playerCountryNode.CountryFlags["halloween_endorsement_turns"] = int(outcome_amount)
			print("[HalloweenEndorsement] Granted for ", outcome_amount, " turns")
		"cherry_blossom_prayer":
			# Ualani's prayer at the Washington Monument: permanent +0.01 magic/unit/turn
			playerCountryNode.CountryFlags["cherry_blossom_prayer"] = true
			print("[CherryBlossomPrayer] Granted — permanent fractional magic gain active")
		"nothing":
			pass
		_:
			push_warning("executeOutcome: Unknown outcome type: " + outcome_type)

func evaluateDateEvents() -> void:
	if currentWorldTurn == 1:
		# Turn 1 is the intro chain ONLY — suppress every other event this turn.
		createNewEvent("INTRO_01")
		return
	checkPendingMissions()
	checkMissionExpiry()
	checkCollapseCondition()
	checkCaCollapseCondition()
	checkStateSecessionConditions()
	_calculate_presidential_claim()
	_update_governor_loyalty()
	_tick_event_cooldowns()
	if playerCountry == "USA" and not _republic_collapsed:
		_check_war_events()
		_check_can_events()
		_check_ca_protectors()
		_check_loyal_governor_events()
		_check_arc03_honorary_event()
		_check_arc11_monarchist_event()
		_check_george_peace_offer()
		_check_peace_conditions()
		_check_harvest_crisis()
		_check_harbor_threat()
		_check_forge_threat()
		_check_corruption_crisis()
		_check_border_dispute()
		_check_garrison_hunger()
		_check_legitimacy_crisis()
		_check_turncoat_general()
		_check_ualani_ambush()
		_check_ualani_dignitary()
		_check_ualani_memorial()
		_check_ualani_wounded()
		_check_ualani_winter()
		_check_ualani_forge()
		_check_ualani_culper()
		_check_ualani_alliance()
		_check_ualani_frontier()
		_check_white_house_secrets()
		_check_chalch_summon()
		_check_chalch_quests()
		_check_vp_events()
		_tick_wild_protectors()
		_tick_wild_ca_protectors()
		_check_protector_summons()
		_check_prot08_dma_summon()
		_check_prot17_dma_summon()
		_tick_commander_turns()
		_check_arc01_objectives()
		_tick_arc03_cultural_corps()
		_tick_halloween_endorsement()
		_tick_cherry_blossom_prayer()
		_tick_pioneer_heritage_corruption()
		_tick_nature_conservationists_corruption()
		_tick_inland_maritime_expertise()
		_tick_french_cultural_identity()
		_tick_civic_pride_mandate()
		_check_cmd_merit()
		_check_cmd_recognition()
		_check_cmd_thanks()
		_tick_election_pressure()
		_check_stump_speech()
		_check_election_season()
		_tick_anarchists()
	elif playerCountry == "CA" and not _ca_collapsed:
		_check_war_events()
		_check_usa_alliance_events()
		_check_ca_own_protectors()
		_check_loyal_governor_events()
		_check_arc03_honorary_event()
		_check_arc11_monarchist_event()
		_check_george_peace_offer()
		_check_peace_conditions()
		_check_harvest_crisis()
		_check_harbor_threat()
		_check_forge_threat()
		_check_corruption_crisis()
		_check_border_dispute()
		_check_garrison_hunger()
		_check_legitimacy_crisis()
		_check_ca_vp_events()
		_tick_wild_ca_protectors()
		_tick_commander_turns()
		_check_arc01_objectives()
		_tick_arc03_cultural_corps()
		_check_cmd_merit()
		_check_cmd_recognition()
		_check_cmd_thanks()
		_tick_election_pressure()
		_check_election_season()
		_tick_anarchists()
		_tick_laura_secord_market()
	_check_end_game()
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


func checkCaCollapseCondition() -> void:
	if playerCountry != "CA" or _ca_collapsed:
		return
	# Ottawa (tile 201) must still be held by Canada
	var ottawa_held: bool = false
	for tile in $TileController.get_children():
		if tile.tileNumber == 201 and tile.tileOwner == "CA":
			ottawa_held = true
			break
	if not ottawa_held:
		_ca_collapsed = true
		print("[CA Collapse] Ottawa has fallen. Triggering CA_COLLAPSE_01.")
		createNewEvent("CA_COLLAPSE_01")
		return
	# Jessica Commanda Odjick must still be alive (in unlockedGovernors)
	var jessica_alive: bool = false
	for gov in playerCountryNode.unlockedGovernors:
		if gov.governorType == "Jessica Commanda Odjick":
			jessica_alive = true
			break
	if not jessica_alive:
		_ca_collapsed = true
		print("[CA Collapse] Jessica Commanda Odjick has fallen. Triggering CA_COLLAPSE_JESSICA.")
		createNewEvent("CA_COLLAPSE_JESSICA")


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
	var rebel_country = _spawn_state_country(state_code, display_name)

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

	playerCountryNode.CountryFlags["rebel_" + state_code] = true
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
		uk_country.CountryFlags["uk_usa_peace"] = true

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
		var state_country = _spawn_state_country(state_code, display_name)

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

	#for tile in playerCountryNode.OwnedTileList:

		print("playerCountryNode.OwnedTileList")
	createNewEvent("COLLAPSE_02")


func _spawn_state_country(state_code: String, display_name: String):
	# Guard: return existing node if somehow called twice for the same state
	for c in aliveCountriesList:
		if c.CID == state_code:
			return c

	var new_country = countryNode.instantiate()
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
			if n != null:
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
		#" at ", suspect_tile.tileName)
		#" at ", suspect_tile.tileName)


# ── UALANI EVENTS ──────────────────────────────────────────────

func _find_ualani_tile() -> Tile:
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null:
			continue
		if tile.tileGovernor.governorType != "Ualani Carlisle":
			continue
		if tile.stationedArmy != null and tile.stationedArmy.parentCountry == playerCountryNode:
			return tile
	return null


func _find_jessica_tile() -> Tile:
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null:
			continue
		if tile.tileGovernor.governorType != "Jessica Commanda Odjick":
			continue
		if tile.stationedArmy != null and tile.stationedArmy.parentCountry == playerCountryNode:
			return tile
	return null


func _apply_ualani_aura() -> void:
	# Auras Ualani projects onto adjacent friendly armies. Runs every round;
	# duration 2 so each expires naturally if Ualani moves away.
	#   - George Washington doctrine      -> Spirit of the General (+15 Attack)
	#   - Intro gift Beautiful Flower (flag)   -> +3 Defense to neighbors
	#   - Intro gift Executive Enforcer (flag) -> +3 Attack to neighbors
	var auras: Array = []
	for belief in playerCountryNode.selectedBeliefs:
		if belief.beliefType == "George Washington":
			auras.append("Spirit of the General")
			break
	if playerCountryNode.CountryFlags.has("ualani_beautiful_flower"):
		auras.append("Beautiful Flower")
	if playerCountryNode.CountryFlags.has("ualani_executive_enforcer"):
		auras.append("Executive Enforcer")
	if auras.is_empty():
		return
	var ualani_tile: Tile = _find_ualani_tile()
	if ualani_tile == null:
		return
	for neighbor in ualani_tile.TileNeighbors:
		if neighbor.stationedArmy == null:
			continue
		if neighbor.stationedArmy.parentCountry != playerCountryNode:
			continue
		for aura in auras:
			neighbor.stationedArmy.apply_status(aura, 2)


func _check_ualani_ambush() -> void:
	if _event_on_cooldown("UALANI_AMBUSH_01"):
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	if tile.terrain != "Wetlands":
		return
	if not tile.has_neighbor_owned_by("UK"):
		return
	_start_cooldown("UALANI_AMBUSH_01", 15)
	createNewEvent("UALANI_AMBUSH_01", tile)
	print("[Ualani] Ambush event at ", tile.tileName)


func _check_ualani_dignitary() -> void:
	if _event_on_cooldown("UALANI_DIGNITARY_01"):
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	if tile.terrain not in ["Metro", "Suburbs"]:
		return
	if tile.tileMoralDecay >= 30:
		return
	var has_courthouse: bool = false
	for b in tile.tileBuildingsList:
		if b.buildingType == "Courthouse" and b.enabled:
			has_courthouse = true
			break
	if not has_courthouse:
		return
	_start_cooldown("UALANI_DIGNITARY_01", 18)
	createNewEvent("UALANI_DIGNITARY_01", tile)
	print("[Ualani] Dignitary reception at ", tile.tileName)


func _check_ualani_memorial() -> void:
	if _event_on_cooldown("UALANI_MEMORIAL_01"):
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	if tile.tileSpecialFeatures.is_empty():
		return
	_start_cooldown("UALANI_MEMORIAL_01", 20)
	createNewEvent("UALANI_MEMORIAL_01", tile)
	print("[Ualani] Memorial address at ", tile.tileName)


func _check_ualani_wounded() -> void:
	if _event_on_cooldown("UALANI_WOUNDED_01"):
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	var army = tile.stationedArmy
	if army == null:
		return
	if float(army.manpowerInArmy) >= float(army.maxManpower) * 0.8:
		return
	_start_cooldown("UALANI_WOUNDED_01", 12)
	createNewEvent("UALANI_WOUNDED_01", tile)
		#" (", army.manpowerInArmy, "/", army.maxManpower, ")")
		#" (", army.manpowerInArmy, "/", army.maxManpower, ")")


func _check_ualani_winter() -> void:
	if _event_on_cooldown("UALANI_WINTER_01"):
		return
	if month not in [11, 12, 1, 2]:
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	if tile.terrain not in ["Foothills", "Woods"]:
		return
	if tile.winterScore <= 0:
		return
	_start_cooldown("UALANI_WINTER_01", 20)
	createNewEvent("UALANI_WINTER_01", tile)
	print("[Ualani] Winter march at ", tile.tileName)


func _check_ualani_forge() -> void:
	if _event_on_cooldown("UALANI_FORGE_01"):
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	var has_forge: bool = false
	for b in tile.tileBuildingsList:
		if b.buildingType == "Forge" and b.enabled:
			has_forge = true
			break
	if not has_forge:
		return
	_start_cooldown("UALANI_FORGE_01", 15)
	createNewEvent("UALANI_FORGE_01", tile)
	print("[Ualani] Forge inspection at ", tile.tileName)


func _check_ualani_culper() -> void:
	if _event_on_cooldown("UALANI_CULPER_01"):
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	if not tile.has_neighbor_with_espionage():
		return
	_start_cooldown("UALANI_CULPER_01", 18)
	createNewEvent("UALANI_CULPER_01", tile)
	print("[Ualani] Culper meeting at ", tile.tileName)


func _check_ualani_alliance() -> void:
	if _event_on_cooldown("UALANI_ALLIANCE_01"):
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	var ally_tile: Tile = null
	for neighbor in tile.TileNeighbors:
		if neighbor.tileOwner != "USA":
			continue
		if neighbor.tileGovernor == null:
			continue
		if neighbor.tileGovernor.governorType == "Ualani Carlisle":
			continue
		if neighbor.tileGovernor.governorArchetypeId != "":
			continue
		ally_tile = neighbor
		break
	if ally_tile == null:
		return
	_start_cooldown("UALANI_ALLIANCE_01", 18)
	createNewEvent("UALANI_ALLIANCE_01", ally_tile)
		#" with ", ally_tile.tileGovernor.governorType)
		#" with ", ally_tile.tileGovernor.governorType)


func _check_ualani_frontier() -> void:
	if _event_on_cooldown("UALANI_FRONTIER_01"):
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	if tile.terrain not in ["Woods", "Foothills"]:
		return
	for neighbor in tile.TileNeighbors:
		if neighbor.tileContinent.begins_with("CA - "):
			_start_cooldown("UALANI_FRONTIER_01", 20)
			createNewEvent("UALANI_FRONTIER_01", tile)
				#" bordering ", neighbor.tileContinent)
				#" bordering ", neighbor.tileContinent)
			return


# ── WHITE HOUSE SECRETS ──────────────────────────────────────────────────────
# One event per calendar month, fires when Ualani is stationed at DC (tile 188).
# One-shot per event; once fired that secret is permanently logged.

func _check_white_house_secrets() -> void:
	var ualani_tile: Tile = _find_ualani_tile()
	if ualani_tile == null or ualani_tile.tileNumber != 188:
		return

	var event_id: String = ""
	match month:
		1:  event_id = "WH_SECRET_01"
		2:  event_id = "WH_SECRET_02"
		3:  event_id = "WH_SECRET_03"
		4:  event_id = "WH_SECRET_04"
		5:  event_id = "WH_SECRET_05"
		6:  event_id = "WH_SECRET_06"
		7:  event_id = "WH_SECRET_07"
		8:  event_id = "WH_SECRET_08"
		9:  event_id = "WH_SECRET_09"
		10: event_id = "WH_SECRET_10"
		11: event_id = "WH_SECRET_11"
		12: event_id = "WH_SECRET_12"

	if event_id == "" or _event_on_cooldown(event_id):
		return
	_start_cooldown(event_id, 999)
	createNewEvent(event_id, ualani_tile)
	print("[WHSecrets] ", event_id, " fired — Ualani in DC, month ", month)


# ── CHALCHIUHTOTOLIN PROTECTOR ARC ──────────────────────────────────────────
# Super-secret: fires only when Ualani is stationed at Plymouth (tile 66) in
# month 11 (Thanksgiving).  Quest chain: SUMMON → Q1 (3 farms) → Q2 (150 food)
# → Q3 (5 farms) → AGREE (big food bounty).

func _count_player_farms() -> int:
	var count: int = 0
	for tile in playerCountryNode.OwnedTileList:
		for b in tile.tileBuildingsList:
			if b.buildingType == "Farm" and b.enabled:
				count += 1
	return count


func _check_chalch_summon() -> void:
	if month != 11:
		return
	var ualani_tile: Tile = _find_ualani_tile()
	if ualani_tile == null or ualani_tile.tileNumber != 66:
		return
	if _event_on_cooldown("CHALCH_SUMMON"):
		return
	_start_cooldown("CHALCH_SUMMON", 999)
	if not playerCountryNode.CountryFlags.has("chalch_summoned"):
		playerCountryNode.CountryFlags["chalch_summoned"] = true
	createNewEvent("CHALCH_SUMMON", ualani_tile)
	print("[Chalch] CHALCH_SUMMON fired — Ualani at Plymouth, month 11")


func _check_chalch_quests() -> void:
	if not playerCountryNode.CountryFlags.has("chalch_summoned"):
		return

	# Q1: 3+ farms
	if not _event_on_cooldown("CHALCH_Q1"):
		if _count_player_farms() >= 3:
			_start_cooldown("CHALCH_Q1", 999)
			if not playerCountryNode.CountryFlags.has("chalch_q1_done"):
				playerCountryNode.CountryFlags["chalch_q1_done"] = true
			createNewEvent("CHALCH_Q1", _find_ualani_tile())
			print("[Chalch] CHALCH_Q1 fired — 3+ farms")
			return

	# Q2: 150+ food stockpile (requires Q1 done)
	if playerCountryNode.CountryFlags.has("chalch_q1_done") \
			and not _event_on_cooldown("CHALCH_Q2"):
		if playerCountryNode.TotalFood >= 150:
			_start_cooldown("CHALCH_Q2", 999)
			if not playerCountryNode.CountryFlags.has("chalch_q2_done"):
				playerCountryNode.CountryFlags["chalch_q2_done"] = true
			createNewEvent("CHALCH_Q2", _find_ualani_tile())
			print("[Chalch] CHALCH_Q2 fired — 150+ food")
			return

	# Q3: 5+ farms (requires Q2 done)
	if playerCountryNode.CountryFlags.has("chalch_q2_done") \
			and not _event_on_cooldown("CHALCH_Q3"):
		if _count_player_farms() >= 5:
			_start_cooldown("CHALCH_Q3", 999)
			if not playerCountryNode.CountryFlags.has("chalch_q3_done"):
				playerCountryNode.CountryFlags["chalch_q3_done"] = true
			createNewEvent("CHALCH_Q3", _find_ualani_tile())
			print("[Chalch] CHALCH_Q3 fired — 5+ farms")
			return

	# AGREE: all quests done
	if playerCountryNode.CountryFlags.has("chalch_q3_done") \
			and not _event_on_cooldown("CHALCH_AGREE"):
		_start_cooldown("CHALCH_AGREE", 999)
		createNewEvent("CHALCH_AGREE", _find_ualani_tile())
		print("[Chalch] CHALCH_AGREE fired — all quests complete")


# ── VICE PRESIDENT EVENTS ────────────────────────────────────────

func _find_governor_tile(gov) -> Tile:
	if gov == null:
		return null
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == gov:
			return tile
	return null


func _count_agreed_protectors() -> int:
	var count: int = 0
	for pid in PROTECTOR_IDS:
		if playerCountryNode.CountryFlags.has(pid.to_lower() + "_agreed"):
			count += 1
	return count


func _fire_vp_event(event_id: String, vp_tile: Tile) -> bool:
	_start_cooldown(event_id, 999)
	_start_cooldown("VP_EVENTS", 13)
	createNewEvent(event_id, vp_tile)
	print("[VP] Event fired: ", event_id)
	return true


func _check_vp_events() -> void:
	if _vp_governor == null:
		return
	if _event_on_cooldown("VP_EVENTS"):
		return
	var vp_tile: Tile = _find_governor_tile(_vp_governor)
	if vp_tile == null:
		return
	if _try_vp_first_meeting(vp_tile): return
	if _try_vp_doubt(vp_tile): return
	if _try_vp_sacrifice(vp_tile): return
	if _try_vp_pre_election(vp_tile): return
	if _try_vp_loyalty_test(vp_tile): return
	if _try_vp_counsel(vp_tile): return
	if _try_vp_battlefield(vp_tile): return
	if _try_vp_solidarity(vp_tile): return
	if _try_vp_legacy(vp_tile): return


func _try_vp_first_meeting(vp_tile: Tile) -> bool:
	if _event_on_cooldown("VP_FIRST_MEETING"):
		return false
	if currentWorldTurn < 5:
		return false
	return _fire_vp_event("VP_FIRST_MEETING", vp_tile)


func _try_vp_counsel(vp_tile: Tile) -> bool:
	if _event_on_cooldown("VP_COUNSEL"):
		return false
	if not playerCountryNode.CountryFlags.has("vp_met"):
		return false
	if playerCountryNode.presidentialClaim >= -2.0:
		return false
	return _fire_vp_event("VP_COUNSEL", vp_tile)


func _try_vp_doubt(vp_tile: Tile) -> bool:
	if _event_on_cooldown("VP_DOUBT"):
		return false
	if not playerCountryNode.CountryFlags.has("vp_met"):
		return false
	if vp_tile.tileMoralDecay < 30:
		return false
	return _fire_vp_event("VP_DOUBT", vp_tile)


func _try_vp_loyalty_test(vp_tile: Tile) -> bool:
	if _event_on_cooldown("VP_LOYALTY_TEST"):
		return false
	if not playerCountryNode.CountryFlags.has("vp_met"):
		return false
	if _vp_faction == "":
		return false
	for faction in playerCountryNode.countryFactionList:
		if faction.factionName == _vp_faction and faction.factionLoyalty < 20:
			return _fire_vp_event("VP_LOYALTY_TEST", vp_tile)
	return false


func _try_vp_battlefield(vp_tile: Tile) -> bool:
	if _event_on_cooldown("VP_BATTLEFIELD"):
		return false
	if not playerCountryNode.CountryFlags.has("vp_met"):
		return false
	if not vp_tile.has_neighbor_owned_by("UK"):
		return false
	if vp_tile.stationedArmy == null:
		return false
	return _fire_vp_event("VP_BATTLEFIELD", vp_tile)


func _try_vp_pre_election(vp_tile: Tile) -> bool:
	if _event_on_cooldown("VP_PRE_ELECTION"):
		return false
	if currentWorldTurn < 88 or currentWorldTurn > 92:
		return false
	if not playerCountryNode.CountryFlags.has("vp_met"):
		return false
	return _fire_vp_event("VP_PRE_ELECTION", vp_tile)


func _try_vp_sacrifice(vp_tile: Tile) -> bool:
	if _event_on_cooldown("VP_SACRIFICE"):
		return false
	if not playerCountryNode.CountryFlags.has("vp_met"):
		return false
	if playerCountryNode.CountryFlags.has("vp_resigned"):
		return false
	if vp_tile.electionPressure >= -20:
		return false
	return _fire_vp_event("VP_SACRIFICE", vp_tile)


func _try_vp_solidarity(vp_tile: Tile) -> bool:
	if _event_on_cooldown("VP_SOLIDARITY"):
		return false
	if not playerCountryNode.CountryFlags.has("vp_met"):
		return false
	if _count_agreed_protectors() < 3:
		return false
	return _fire_vp_event("VP_SOLIDARITY", vp_tile)


func _try_vp_legacy(vp_tile: Tile) -> bool:
	if _event_on_cooldown("VP_LEGACY"):
		return false
	if currentWorldTurn < 96:
		return false
	if not playerCountryNode.CountryFlags.has("vp_met"):
		return false
	return _fire_vp_event("VP_LEGACY", vp_tile)


# ── CANADIAN PRESIDENT EVENTS (Marc Penoit as Deputy Governor) ──────────────

func _ca_fire_vp_event(event_id: String, pm_tile) -> bool:
	_start_cooldown(event_id, 999)
	_start_cooldown("CA_PM_EVENTS", 13)
	createNewEvent(event_id, pm_tile)
	print("[CA PM] Event fired: ", event_id)
	return true


func _check_ca_vp_events() -> void:
	if _ca_vp_governor == null:
		return
	if _event_on_cooldown("CA_PM_EVENTS"):
		return
	var pm_tile = _find_governor_tile(_ca_vp_governor)
	if pm_tile == null:
		return
	if _try_ca_pm_first_meeting(pm_tile): return
	if _try_ca_pm_doubt(pm_tile): return
	if _try_ca_pm_pre_election(pm_tile): return
	if _try_ca_pm_loyalty_test(pm_tile): return
	if _try_ca_pm_counsel(pm_tile): return
	if _try_ca_pm_battlefield(pm_tile): return
	if _try_ca_pm_solidarity(pm_tile): return
	if _try_ca_pm_legacy(pm_tile): return


func _try_ca_pm_first_meeting(pm_tile) -> bool:
	if _event_on_cooldown("CA_PM_FIRST_MEETING"):
		return false
	if currentWorldTurn < 5:
		return false
	return _ca_fire_vp_event("CA_PM_FIRST_MEETING", pm_tile)


func _try_ca_pm_counsel(pm_tile) -> bool:
	if _event_on_cooldown("CA_PM_COUNSEL"):
		return false
	if not playerCountryNode.CountryFlags.has("ca_pm_met"):
		return false
	if playerCountryNode.presidentialClaim >= -2.0:
		return false
	return _ca_fire_vp_event("CA_PM_COUNSEL", pm_tile)


func _try_ca_pm_doubt(pm_tile) -> bool:
	if _event_on_cooldown("CA_PM_DOUBT"):
		return false
	if not playerCountryNode.CountryFlags.has("ca_pm_met"):
		return false
	if pm_tile.tileMoralDecay < 30:
		return false
	return _ca_fire_vp_event("CA_PM_DOUBT", pm_tile)


func _try_ca_pm_loyalty_test(pm_tile) -> bool:
	if _event_on_cooldown("CA_PM_LOYALTY_TEST"):
		return false
	if not playerCountryNode.CountryFlags.has("ca_pm_met"):
		return false
	if _ca_vp_faction == "":
		return false
	for faction in playerCountryNode.countryFactionList:
		if faction.factionName == _ca_vp_faction and faction.factionLoyalty < 20:
			return _ca_fire_vp_event("CA_PM_LOYALTY_TEST", pm_tile)
	return false


func _try_ca_pm_battlefield(pm_tile) -> bool:
	if _event_on_cooldown("CA_PM_BATTLEFIELD"):
		return false
	if not playerCountryNode.CountryFlags.has("ca_pm_met"):
		return false
	if not pm_tile.has_neighbor_owned_by("UK"):
		return false
	if pm_tile.stationedArmy == null:
		return false
	return _ca_fire_vp_event("CA_PM_BATTLEFIELD", pm_tile)


func _try_ca_pm_pre_election(pm_tile) -> bool:
	if _event_on_cooldown("CA_PM_PRE_ELECTION"):
		return false
	if currentWorldTurn < 88 or currentWorldTurn > 92:
		return false
	if not playerCountryNode.CountryFlags.has("ca_pm_met"):
		return false
	return _ca_fire_vp_event("CA_PM_PRE_ELECTION", pm_tile)



func _try_ca_pm_solidarity(pm_tile) -> bool:
	if _event_on_cooldown("CA_PM_SOLIDARITY"):
		return false
	if not playerCountryNode.CountryFlags.has("ca_pm_met"):
		return false
	if _count_ca_agreed_protectors() < 3:
		return false
	return _ca_fire_vp_event("CA_PM_SOLIDARITY", pm_tile)


func _try_ca_pm_legacy(pm_tile) -> bool:
	if _event_on_cooldown("CA_PM_LEGACY"):
		return false
	if currentWorldTurn < 96:
		return false
	if not playerCountryNode.CountryFlags.has("ca_pm_met"):
		return false
	return _ca_fire_vp_event("CA_PM_LEGACY", pm_tile)


func _count_ca_agreed_protectors() -> int:
	var count: int = 0
	for pid in CA_PROT_IDS:
		if playerCountryNode.CountryFlags.has(pid.to_lower() + "_agreed"):
			count += 1
	return count


# ── USA ALLIANCE EVENTS (Canada's perspective when playing as CA) ─────────────

func _fire_usa_alliance_event(event_id: String) -> bool:
	_start_cooldown(event_id, 999)
	_start_cooldown("USA_ALLIANCE_EVENTS", 3)
	createNewEvent(event_id, null)
	print("[USA Alliance] Event fired: ", event_id)
	return true


func _check_usa_alliance_events() -> void:
	if _event_on_cooldown("USA_ALLIANCE_EVENTS"):
		return
	if _try_usa_call(): return
	if _try_usa_summit(): return
	if _try_usa_alliance_signed(): return
	if _try_ca_alone(): return


func _try_usa_call() -> bool:
	if _event_on_cooldown("USA_CALL_01"):
		return false
	if playerCountryNode.CountryFlags.has("usa_contact"):
		return false
	if currentWorldTurn < 8:
		return false
	if not (playerCountryNode.CountryFlags.has("uk_buildup_known") or
			playerCountryNode.CountryFlags.has("uk_declared_war")):
		return false
	return _fire_usa_alliance_event("USA_CALL_01")


func _try_usa_summit() -> bool:
	if _event_on_cooldown("USA_SUMMIT_01"):
		return false
	if not playerCountryNode.CountryFlags.has("usa_contact"):
		return false
	if playerCountryNode.CountryFlags.has("ca_allied") or playerCountryNode.CountryFlags.has("usa_rejected"):
		return false
	if currentWorldTurn < 13:
		return false
	return _fire_usa_alliance_event("USA_SUMMIT_01")


func _try_usa_alliance_signed() -> bool:
	if _event_on_cooldown("USA_ALLIANCE_SIGNED"):
		return false
	if not playerCountryNode.CountryFlags.has("usa_summit_complete"):
		return false
	if playerCountryNode.CountryFlags.has("ca_allied"):
		return false
	return _fire_usa_alliance_event("USA_ALLIANCE_SIGNED")


func _try_ca_alone() -> bool:
	if _event_on_cooldown("CA_ALONE_01"):
		return false
	if not playerCountryNode.CountryFlags.has("usa_rejected"):
		return false
	if _event_on_cooldown("CA_ALONE_01"):
		return false
	return _fire_usa_alliance_event("CA_ALONE_01")


# ── WAR DECLARATION & CANADIAN ALLIANCE ─────────────────────────

func _fire_war_event(event_id: String) -> bool:
	_start_cooldown(event_id, 999)
	createNewEvent(event_id, null)
	print("[War] Event fired: ", event_id)
	return true


func _fire_can_event(event_id: String) -> bool:
	_start_cooldown(event_id, 999)
	_start_cooldown("CAN_EVENTS", 3)
	createNewEvent(event_id, null)
	print("[Canada] Event fired: ", event_id)
	return true


func _check_war_events() -> void:
	_try_uk_buildup()
	_try_uk_declaration()


func _try_uk_buildup() -> bool:
	if _event_on_cooldown("UK_BUILDUP_01"):
		return false
	if currentWorldTurn < 7:
		return false
	return _fire_war_event("UK_BUILDUP_01")


func _try_uk_declaration() -> bool:
	if _event_on_cooldown("UK_DECLARATION_01"):
		return false
	if currentWorldTurn < 10 or currentWorldTurn > 16:
		return false
	if not playerCountryNode.CountryFlags.has("uk_buildup_known"):
		return false
	if randf() > 0.30:
		return false
	return _fire_war_event("UK_DECLARATION_01")


func _check_can_events() -> void:
	if _event_on_cooldown("CAN_EVENTS"):
		return
	if playerCountryNode.CountryFlags.has("can_rejected"):
		return
	var penoit_ready: bool = (playerCountryNode.CountryFlags.has("can_penoit_agreed") or
		playerCountryNode.CountryFlags.has("can_penoit_negotiating"))
	var clearwater_ready: bool = (playerCountryNode.CountryFlags.has("can_clearwater_warm") or
		playerCountryNode.CountryFlags.has("can_clearwater_close"))

	if _try_can_call(): return
	if _try_can_penoit(): return
	if _try_can_clearwater(penoit_ready): return
	if _try_can_joint_ops(penoit_ready, clearwater_ready): return
	if _try_can_summit(clearwater_ready): return
	if _try_can_alliance_signed(): return
	if _try_can_peace(): return
	if _try_can_election_luck(): return


func _try_can_call() -> bool:
	if _event_on_cooldown("CAN_CALL_01"):
		return false
	if playerCountryNode.CountryFlags.has("can_contact"):
		return false
	if currentWorldTurn < 8:
		return false
	if not (playerCountryNode.CountryFlags.has("uk_buildup_known") or
			playerCountryNode.CountryFlags.has("uk_declared_war")):
		return false
	return _fire_can_event("CAN_CALL_01")


func _try_can_penoit() -> bool:
	if _event_on_cooldown("CAN_PENOIT_01"):
		return false
	if not playerCountryNode.CountryFlags.has("can_contact"):
		return false
	if currentWorldTurn < 12:
		return false
	return _fire_can_event("CAN_PENOIT_01")


func _try_can_clearwater(penoit_ready: bool) -> bool:
	if _event_on_cooldown("CAN_CLEARWATER_01"):
		return false
	if not playerCountryNode.CountryFlags.has("can_contact"):
		return false
	if not penoit_ready:
		return false
	return _fire_can_event("CAN_CLEARWATER_01")


func _try_can_joint_ops(penoit_ready: bool, clearwater_ready: bool) -> bool:
	if _event_on_cooldown("CAN_JOINT_OPS_01"):
		return false
	if not penoit_ready or not clearwater_ready:
		return false
	return _fire_can_event("CAN_JOINT_OPS_01")


func _try_can_summit(clearwater_ready: bool) -> bool:
	if _event_on_cooldown("CAN_SUMMIT_01"):
		return false
	if not playerCountryNode.CountryFlags.has("can_penoit_agreed"):
		return false
	if not clearwater_ready:
		return false
	if currentWorldTurn < 13:
		return false
	return _fire_can_event("CAN_SUMMIT_01")


func _try_can_alliance_signed() -> bool:
	if _event_on_cooldown("CAN_ALLIANCE_SIGNED"):
		return false
	if not playerCountryNode.CountryFlags.has("can_summit_complete"):
		return false
	return _fire_can_event("CAN_ALLIANCE_SIGNED")


func _try_can_peace() -> bool:
	if _event_on_cooldown("CAN_PEACE_01"):
		return false
	if not playerCountryNode.CountryFlags.has("can_allied"):
		return false
	if currentWorldTurn < 60:
		return false
	var uk_tiles: int = 0
	for tile in $TileController.get_children():
		if tile.tileOwner == "UK":
			uk_tiles += 1
	if uk_tiles > 20:
		return false
	return _fire_can_event("CAN_PEACE_01")


func _try_can_election_luck() -> bool:
	if _event_on_cooldown("CAN_ELECTION_LUCK"):
		return false
	if not playerCountryNode.CountryFlags.has("can_allied"):
		return false
	if currentWorldTurn < 93:
		return false
	return _fire_can_event("CAN_ELECTION_LUCK")


# ── VICE PRESIDENT & ELECTION SYSTEM ────────────────────────────

func _assign_vice_president() -> void:
	if playerCountry == "CA":
		_assign_ca_vice_president()
		return
	var candidates: Array = []
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null:
			continue
		var gov = tile.tileGovernor
		if gov.governorArchetypeId != "":
			continue  # skip procedural governors
		if gov.governorType == "Ualani Carlisle":
			continue
		candidates.append(gov)
	if candidates.is_empty():
		return
	_vp_governor = candidates[randi() % candidates.size()]
	_vp_governor.isVicePresident = true
	_vp_faction = VP_FACTION_MAP.get(_vp_governor.governorType, "")
		#" | Faction: ", _vp_faction)
		#" | Faction: ", _vp_faction)


func _assign_ca_vice_president() -> void:
	# Marc Penoit is the hardcoded Deputy Governor for Canada
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null:
			continue
		var gov = tile.tileGovernor
		if gov.governorType == "Marc Penoit":
			_ca_vp_governor = gov
			_ca_vp_faction  = "French Habitants"
			gov.isVicePresident = true
			print("[CA PM] Marc Penoit (at tile ", tile.tileName, ") assigned as Deputy Governor.")
			return
	# Fallback: search unlockedGovernors pool
	for gov in playerCountryNode.unlockedGovernors:
		if gov.governorType == "Marc Penoit":
			_ca_vp_governor = gov
			_ca_vp_faction  = "French Habitants"
			gov.isVicePresident = true
			print("[CA PM] Marc Penoit (unassigned) set as Deputy Governor.")
			return


func _election_pressure_total() -> int:
	var total: int = 0
	for tile in playerCountryNode.OwnedTileList:
		total += tile.electionPressure
	return total


func _tick_election_pressure() -> void:
	# King George's Bre-entrance campaign — passive pressure drain from turn 90
	if currentWorldTurn < 90:
		return
	for tile in playerCountryNode.OwnedTileList:
		tile.electionPressure = clampi(tile.electionPressure - 1, -100, 100)
	# UK-owned neighbor tiles push harder against Liberty
	for tile in $TileController.get_children():
		if tile.tileOwner == "UK":
			for neighbor in tile.TileNeighbors:
				if neighbor.tileOwner == playerCountry:
					neighbor.electionPressure = clampi(
						neighbor.electionPressure - 2, -100, 100)


func _check_stump_speech() -> void:
	if currentWorldTurn < 90 or currentWorldTurn > 100:
		return
	if _event_on_cooldown("STUMP_SPEECH_01"):
		return
	var tile: Tile = _find_ualani_tile()
	if tile == null:
		return
	var has_courthouse = false
	for b in tile.tileBuildingsList:
		if b.buildingType == "Courthouse" and not tile.disabled_buildings.has("Courthouse"):
			has_courthouse = true
			break
	if not has_courthouse:
		return
	_start_cooldown("STUMP_SPEECH_01", 2)
	createNewEvent("STUMP_SPEECH_01", tile)
	print("[Election] Stump speech available at ", tile.tileName)


func _check_election_season() -> void:
	if currentWorldTurn < 93 or currentWorldTurn > 95:
		return
	if _event_on_cooldown("ELECTION_SEASON"):
		return
	_start_cooldown("ELECTION_SEASON", 999)
	createNewEvent("ELECTION_SEASON", null)
	_grant_election_season_mods()
	print("[Election] Election season event fired on turn ", currentWorldTurn)

func _grant_election_season_mods() -> void:
	# Give Election Season mod to Ualani and the current VP (the ticket)
	for gov in playerCountryNode.unlockedGovernors:
		if gov.governorType == "Ualani Carlisle" or gov.isVicePresident:
			gov.addMilMod("Election Season", 123)
			print("[Election] Election Season mod granted to ", gov.governorType)


func _check_end_game() -> void:
	if _game_ended or _republic_collapsed or _ca_collapsed:
		return
	if currentWorldTurn < 100:
		return

	var total = _election_pressure_total()

	# Determine peace and UK land status for ending routing
	var uk_country = null
	for c in aliveCountriesList:
		if c.CID == "UK":
			uk_country = c
			break
	var usa_peace: bool = uk_country != null and uk_country.CountryFlags.has("uk_usa_peace")
	var is_allied: bool = playerCountryNode.CountryFlags.has("can_allied")
	var ca_peace:  bool = uk_country != null and uk_country.CountryFlags.has("uk_ca_peace")
	var peace_signed: bool = usa_peace and (not is_allied or ca_peace)
	var uk_tiles_remain: bool = false
	for tile in $TileController.get_children():
		if tile.tileOwner == "UK":
			uk_tiles_remain = true
			break

	if total <= 0:
		# British puppet wins the election
		createNewEvent("ELECTION_NIGHT_LOSE", null)
		print("[EndGame] Crown wins election — pressure total: ", total)
		_trigger_game_over(false, "A Crown puppet has taken the White House.", "britishWhiteHouse")
	elif peace_signed and uk_tiles_remain:
		# Peace signed but UK still holds land — stalemate
		createNewEvent("ELECTION_NIGHT_WIN", null)
		print("[EndGame] Stalemate — peace signed, UK holds land, turn ", currentWorldTurn)
		_trigger_game_over(false, "Peace was signed, but the Crown holds its ground.", "stalemate")
	elif not peace_signed and uk_tiles_remain:
		# War still raging at turn limit — endless battle
		createNewEvent("ELECTION_NIGHT_WIN", null)
		print("[EndGame] Endless battle — war ongoing at turn ", currentWorldTurn)
		_trigger_game_over(false, "The war grinds on. No end in sight.", "endlessBattle")
	else:
		# Liberty wins clean
		createNewEvent("ELECTION_NIGHT_WIN", null)
		print("[EndGame] Liberty Coalition wins — pressure total: ", total)
		_trigger_game_over(true, "The Liberty Coalition has won. The Republic endures.")


# ── COMMANDER PROGRESSION ────────────────────────────────────────

func _commander_key(tile: Tile) -> String:
	return tile.tileName + ":" + tile.tileGovernor.governorType


func _tick_commander_turns() -> void:
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null:
			continue
		if tile.stationedArmy == null or tile.stationedArmy.commander == null:
			continue
		if tile.stationedArmy.commander != tile.tileGovernor:
			continue
		var key = _commander_key(tile)
		_commander_turns[key] = _commander_turns.get(key, 0) + 1


func _check_arc01_objectives() -> void:
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null or tile.stationedArmy == null:
			continue
		if tile.stationedArmy.commander != tile.tileGovernor:
			continue
		var gov = tile.tileGovernor
		var army = tile.stationedArmy

		match gov.governorArchetypeId:
			"ARC_01":
				if tile.tileOwner != playerCountry:
					continue
				if gov.governorLevel == 1:
					if army.manpowerInArmy < 500:
						continue
					var camp_lvl: int = 0
					for b in tile.tileBuildingsList:
						if b.buildingType == "Camp" and b.enabled:
							camp_lvl = maxi(camp_lvl, b.buildingLevel)
					if camp_lvl < 2:
						continue
					createNewEvent("ARC_01_FIRST", tile)
				elif gov.governorLevel == 2:
					if army.manpowerInArmy < 800:
						continue
					var granary_count: int = 0
					for b in tile.tileBuildingsList:
						if b.buildingType == "Granary" and b.enabled:
							granary_count += 1
					if granary_count < 2:
						continue
					createNewEvent("ARC_01_DONE", tile)

			"ARC_02":
				# Obj 1 (lvl 1→2): army stationed + lvl 2 mine + 500 manpower
				if gov.governorLevel == 1:
					if army.manpowerInArmy < 500:
						continue
					var mine_lvl: int = 0
					for b in tile.tileBuildingsList:
						if b.buildingType == "Mine" and b.enabled:
							mine_lvl = maxi(mine_lvl, b.buildingLevel)
					if mine_lvl < 2:
						continue
					createNewEvent("ARC_02_FIRST", tile)
				# Obj 2 (lvl 2→3): own tile + lvl 4 mine + 800 manpower
				elif gov.governorLevel == 2:
					if tile.tileOwner != playerCountry:
						continue
					if army.manpowerInArmy < 800:
						continue
					var mine_lvl: int = 0
					for b in tile.tileBuildingsList:
						if b.buildingType == "Mine" and b.enabled:
							mine_lvl = maxi(mine_lvl, b.buildingLevel)
					if mine_lvl < 4:
						continue
					createNewEvent("ARC_02_DONE", tile)

			"ARC_03":
				# Obj 1 (lvl 1→2): liberate an Ivy League tile from UK + station commander there
				if gov.governorLevel == 1:
					if tile.tileOwner != playerCountry:
						continue
					if not tile.has_special_feature("Ivy League"):
						continue
					if tile.lastConqueror != "UK":
						continue
					createNewEvent("ARC_03_FIRST", tile)
				# Obj 2 (lvl 2→3): library at level 5 in tile + 1000 manpower in army
				elif gov.governorLevel == 2:
					if tile.tileOwner != playerCountry:
						continue
					if army.manpowerInArmy < 1000:
						continue
					var lib_lvl: int = 0
					for b in tile.tileBuildingsList:
						if b.buildingType == "Library" and b.enabled:
							lib_lvl = maxi(lib_lvl, b.buildingLevel)
					if lib_lvl < 5:
						continue
					createNewEvent("ARC_03_DONE", tile)


func _tick_arc03_cultural_corps() -> void:
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null or tile.stationedArmy == null:
			continue
		var gov = tile.tileGovernor
		var army = tile.stationedArmy
		if army.commander != gov:
			continue
		if gov.governorArchetypeId != "ARC_03" or gov.governorLevel < 3:
			continue
		if not army._army_has_active_mod("Cultural Corps"):
			continue
		var culture_gain: int = 0
		for unit in army.unitsList:
			culture_gain += unit.unitLevel
		if culture_gain > 0:
			playerCountryNode.TotalCulture += culture_gain


func _tick_halloween_endorsement() -> void:
	var turns_left: int = playerCountryNode.CountryFlags.get("halloween_endorsement_turns", 0)
	if turns_left <= 0:
		return
	var ualani_tile = _find_ualani_tile()
	if ualani_tile != null and ualani_tile.stationedArmy != null:
		var unit_count: int = ualani_tile.stationedArmy.unitsList.size()
		if unit_count > 0:
			playerCountryNode.TotalHappiness += unit_count
	turns_left -= 1
	if turns_left <= 0:
		playerCountryNode.CountryFlags.erase("halloween_endorsement_turns")
	else:
		playerCountryNode.CountryFlags["halloween_endorsement_turns"] = turns_left


func _tick_civic_pride_mandate() -> void:
	var active := false
	for b in playerCountryNode.selectedBeliefs:
		if b.beliefType == "Civic Pride":
			active = true
			break
	if not active:
		return
	for tile in playerCountryNode.OwnedTileList:
		var monument_level: int = tile.get_building_level("monument")
		if monument_level <= 0:
			continue
		playerCountryNode.civic_pride_mandate_acc += 0.5 * float(monument_level)
	var whole: int = int(playerCountryNode.civic_pride_mandate_acc)
	if whole >= 1:
		playerCountryNode.TotalMandate += whole
		playerCountryNode.civic_pride_mandate_acc -= float(whole)


func _tick_pioneer_heritage_corruption() -> void:
	var active := false
	for b in playerCountryNode.selectedBeliefs:
		if b.beliefType == "Pioneer Heritage":
			active = true
			break
	if not active:
		return
	for tile in playerCountryNode.OwnedTileList:
		var farm_level: int = tile.get_building_level("farm")
		if farm_level <= 0 or tile.corruption <= 0:
			continue
		var key := str(tile.tileNumber)
		var gain: float = 0.1 * float(farm_level)
		playerCountryNode.pioneer_heritage_corrupt_acc[key] = \
			playerCountryNode.pioneer_heritage_corrupt_acc.get(key, 0.0) + gain
		var whole: int = int(playerCountryNode.pioneer_heritage_corrupt_acc[key])
		if whole >= 1:
			tile.corruption = max(0, tile.corruption - whole)
			playerCountryNode.pioneer_heritage_corrupt_acc[key] -= float(whole)
			tile.calculateCorruption()


func _tick_nature_conservationists_corruption() -> void:
	var active := false
	for b in playerCountryNode.selectedBeliefs:
		if b.beliefType == "Nature Conservationists":
			active = true
			break
	if not active:
		return
	for tile in playerCountryNode.OwnedTileList:
		var farm_level: int = tile.get_building_level("farm")
		var camp_level: int = tile.get_building_level("camp")
		var total_levels: int = farm_level + camp_level
		if total_levels <= 0 or tile.corruption <= 0:
			continue
		var key := str(tile.tileNumber)
		var gain: float = 0.1 * float(total_levels)
		playerCountryNode.nature_conservationists_corrupt_acc[key] = 			playerCountryNode.nature_conservationists_corrupt_acc.get(key, 0.0) + gain
		var whole: int = int(playerCountryNode.nature_conservationists_corrupt_acc[key])
		if whole >= 1:
			tile.corruption = max(0, tile.corruption - whole)
			playerCountryNode.nature_conservationists_corrupt_acc[key] -= float(whole)
			tile.calculateCorruption()


func _tick_french_cultural_identity() -> void:
	var active := false
	for law in playerCountryNode.lawsInConstitution:
		if law.lawType == "French Cultural Identity Enshrined":
			active = true
			break
	if not active:
		return
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileOwner != "CA":
			continue
		if not tile.has_building("Resort"):
			continue
		tile.resortDevelopmentPoints += 1
		if tile.resortDevelopmentPoints >= tile.tileResortDevCost:
			tile.levelUpBuilding("Resort")
			tile.resortDevelopmentPoints = 0


func _tick_inland_maritime_expertise() -> void:
	var active := false
	for b in playerCountryNode.selectedBeliefs:
		if b.beliefType == "Inland Maritime Expertise":
			active = true
			break
	if not active:
		return
	for tile in playerCountryNode.OwnedTileList:
		if tile.stationedArmy == null:
			continue
		if tile.tileSpecialFeatures.has("Major River") or tile.tileSpecialFeatures.has("Major Lake"):
			tile.stationedArmy.currentMovementPoints += 1


func _tick_laura_secord_market() -> void:
	var active := false
	for b in playerCountryNode.selectedBeliefs:
		if b.beliefType == "Laura Secord":
			active = true
			break
	if not active:
		return
	for tile in playerCountryNode.OwnedTileList:
		for b in tile.tileBuildingsList:
			if b.buildingType == "Market" and b.enabled:
				playerCountryNode.TotalFood += b.buildingLevel


func _tick_cherry_blossom_prayer() -> void:
	if not playerCountryNode.CountryFlags.get("cherry_blossom_prayer", false):
		return
	var unit_count: int = 0
	for tile in playerCountryNode.OwnedTileList:
		if tile.stationedArmy != null:
			unit_count += tile.stationedArmy.unitsList.size()
	if unit_count == 0:
		return
	playerCountryNode.cherry_blossom_magic_acc += 0.01 * float(unit_count)
	var whole: int = int(playerCountryNode.cherry_blossom_magic_acc)
	if whole >= 1:
		playerCountryNode.TotalMagic += whole
		playerCountryNode.cherry_blossom_magic_acc -= float(whole)


func _check_cmd_merit() -> void:
	pass  # dropped — arc begins at CMD_RECOGNITION


func _check_cmd_recognition() -> void:
	if _event_on_cooldown("CMD_RECOGNITION"):
		return
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null or tile.stationedArmy == null:
			continue
		if tile.stationedArmy.commander != tile.tileGovernor:
			continue
		var gov = tile.tileGovernor
		if gov.governorLevel != 1 or gov.xp < 50.0:
			continue
		gov.governorLevel = 2
		if tile.stationedArmy != null:
			tile.stationedArmy.updateArmyUI()
		_start_cooldown("CMD_RECOGNITION", 10)
		createNewEvent("CMD_RECOGNITION", tile)
		print("[Commander] CMD_RECOGNITION fired for ", gov.governorType, " (XP: ", gov.xp, ")")
		return


func _check_cmd_thanks() -> void:
	if _event_on_cooldown("CMD_THANKS"):
		return
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null or tile.stationedArmy == null:
			continue
		if tile.stationedArmy.commander != tile.tileGovernor:
			continue
		var gov = tile.tileGovernor
		if gov.governorLevel != 2 or gov.xp < 125.0:
			continue
		gov.governorLevel = 3
		gov.questComplete = true
		if tile.stationedArmy != null:
			tile.stationedArmy.updateArmyUI()
		_start_cooldown("CMD_THANKS", 999)
		createNewEvent("CMD_THANKS", tile)
		print("[Commander] CMD_THANKS fired for ", gov.governorType, " (XP: ", gov.xp, ")")
		return


# ── COMMANDER THANKS DYNAMIC EVENT BUILDERS ──────────────────────

func _assign_thanks_content(gov: governor, position: String, portrait_data: Dictionary) -> void:
	var path: String      = portrait_data.get("path", "")
	var portrait_id: String = path.get_file().get_basename()
	gov.thanksImg    = "res://art assets/AmericanRevolutionArt/Panel/cmd_thanks_" + portrait_id + ".png"
	gov.thanksImgExp = "res://art assets/AmericanRevolutionArt/Panel/cmd_thanks_exp_" + portrait_id + ".png"
	gov.thanksTxt    = _build_thanks_txt(position)
	gov.thanksTxtExp = _build_thanks_txt_exp(position)


func _build_cmd_thanks_data(tile, is_exp: bool) -> Dictionary:
	var gov = tile.tileGovernor
	var eid: String = "CMD_THANKS_INTIMATE" if is_exp else "CMD_THANKS"
	return {
		"event_id":    eid,
		"event_type":  "standard",
		"country_cid": "USA",
		"headline":    "PRESIDENT CARLISLE DELIVERS PERSONAL THANKS TO [COMMANDER_NAME] AT [TILE_NAME]",
		"short_desc":  "The President Doesn't Visit Everyone. She Visited [CMD_OBJECT].",
		"long_desc":   gov.thanksTxtExp if is_exp else gov.thanksTxt,
	}


func _build_thanks_txt(position: String) -> String:
	match position:
		"SCOUT":
			return "[COMMANDER_NAME] arrived at the White House press conference with the same directness [CMD_SUBJECT] brings to any terrain: immediately oriented, looking for the exits, and slightly wary of a room with no visible horizon. The press corps, accustomed to commanders who perform comfort, found the lack of performance refreshing. [CMD_SUBJECT] accepted the citation from President Carlisle without ceremony and said three words that the White House stenographer has described, in their personal notes, as the most honest thing said aloud in that room all year. Carlisle said nothing in return. She didn't need to."
		"ORATOR":
			return "There was a moment, approximately four minutes into President Carlisle's remarks, when the press corps quietly shifted their attention from the President to [COMMANDER_NAME]. Carlisle noticed. She finished her remarks, handed over the citation, and said: 'Go ahead.' [COMMANDER_NAME] spoke for eleven minutes. The transcription has been reprinted seventeen times. Carlisle's people later asked [CMD_OBJECT] what [CMD_SUBJECT] was going to say before [CMD_SUBJECT] said it. [CMD_SUBJECT] said [CMD_SUBJECT] didn't know. The press corps doesn't believe that."
		"ENGINEER":
			return "[COMMANDER_NAME] arrived at the White House with a citation in hand — not the one [CMD_SUBJECT] was about to receive, but one [CMD_SUBJECT] had drafted independently, for President Carlisle, for decisions made in the second month of operations that [CMD_SUBJECT] had wanted to acknowledge formally for some time. Carlisle accepted it with visible surprise. The exchange was not on the schedule. The press corps photographed it. The photograph is now in the Smithsonian. The blueprints [COMMANDER_NAME] also brought were not photographed. They were immediately classified."
		"SPY":
			return "The White House security log shows [COMMANDER_NAME] arriving at 9:47. The visitor log shows no entry for [CMD_OBJECT] at any time. The security detail has filed a report. The report contains a notation that reads, in the supervisor's handwriting: 'I believe this is intentional.' President Carlisle presented the citation in front of eighteen members of the press corps. [COMMANDER_NAME] accepted it. Three cameras malfunctioned simultaneously. The working photos show a podium, the President, and an excellent citation being held by someone the photos can't quite bring into focus."
		"SOLDIER":
			return "[COMMANDER_NAME] arrived in full dress uniform forty-five minutes before the press corps and stood at attention in the reception hall while the White House staff finished setting up. Three reporters, arriving early, stood up straighter without being asked. Carlisle walked in, looked at [CMD_OBJECT], and said: 'Stand easy.' [COMMANDER_NAME] said: 'Yes, ma'am,' and stood slightly less like a monument. The citation was presented. The applause was immediate. Carlisle shook [CMD_POSSESSIVE] hand and leaned in and said something nobody else heard. [COMMANDER_NAME] nodded once. That was the ceremony."
		"FARMER":
			return "[COMMANDER_NAME] brought food. Not as a gesture — practically, because [CMD_SUBJECT] had driven two days and figured the White House press corps probably hadn't eaten. [CMD_SUBJECT] was right. The food was gone before the ceremony started. Carlisle's deputy chief of staff asked where [CMD_SUBJECT] had gotten it. [COMMANDER_NAME] explained, briefly, that a revolution is not won on documents alone. Carlisle presented the citation and then, off-record, asked [CMD_OBJECT] to send more. [COMMANDER_NAME] said [CMD_SUBJECT] already had."
		"HEALER":
			return "[COMMANDER_NAME] was the only person in the room who asked President Carlisle how she was holding up. Not as protocol — as a direct question from someone who had been watching people carry too much for too long and knew what it looked like. Carlisle paused. She answered honestly. The press corps didn't catch what she said; [COMMANDER_NAME] had quietly ensured nobody was close enough to hear. The photo of that moment — Carlisle mid-answer, [COMMANDER_NAME] listening — has been called the most human photograph of the war. The citation was almost incidental."
		"DIPLOMAT":
			return "[COMMANDER_NAME] had renegotiated the ceremony format before it officially began. The changes were small: different staging, a brief private moment before the press entered, a different order to the remarks. The White House communications director noticed afterward and asked when this had happened. [COMMANDER_NAME] said it had come up naturally in the pre-event walkthrough. The communications director reviewed the walkthrough schedule. There was no pre-event walkthrough. The ceremony was better for the changes. Carlisle presented the citation and then asked [CMD_OBJECT], privately, if [CMD_SUBJECT] was available for a longer conversation. [COMMANDER_NAME] said [CMD_SUBJECT] had already cleared [CMD_POSSESSIVE] schedule."
		"BUREAUCRAT":
			return "[COMMANDER_NAME] arrived with three copies of every document — the invitation, the agenda, the citation text, the press release, and a four-page addendum [CMD_SUBJECT] had prepared regarding procedural improvements to the commendation process. The addendum was, by all accounts, excellent. Carlisle's chief of staff read it in the car and said nothing for eleven minutes. At the ceremony, Carlisle presented the citation and then, departing from prepared remarks, said: 'The addendum has been accepted.' [COMMANDER_NAME] said: 'I know.' Three members of the White House staff applauded separately, and not for the citation."
		"SCHOLAR":
			return "[COMMANDER_NAME] took notes during [CMD_POSSESSIVE] own commendation ceremony. This was observed by four members of the press corps, who could not agree afterward on what [CMD_SUBJECT] was writing. Carlisle presented the citation, made her remarks, and then asked [CMD_OBJECT] afterward what [CMD_SUBJECT] had written down. [COMMANDER_NAME] showed her. Carlisle read it. She handed it back without comment. The White House archivist, who happened to be present, described the contents as 'the most complete account of the ceremony I have ever read, written by the person being honored, while it was happening.'"
		"ADMIRAL":
			return "[COMMANDER_NAME] arrived by water. The Potomac dock had not been used for official arrivals in fourteen years. The dock master was not notified. The press corps was. The photographs of the approach — [COMMANDER_NAME] standing at the bow in the early morning fog — were on every wire service before the ceremony started. Carlisle was briefed on the arrival method by her deputy, who was trying to suppress a smile and not succeeding. The citation was presented without further incident. The departure, also by water, had better lighting."
		"MAGE":
			return "The White House press corps filed their reports on the commendation ceremony for [COMMANDER_NAME] within the hour. All eighteen reports described an unremarkable event: citation presented, remarks made, photographs taken. Three reporters have since filed amendments. The amendments describe, with some inconsistency, various secondary phenomena the original reports did not include. Carlisle's official statement, when asked, is that the ceremony proceeded as planned. There are no photographs. The press pool photographer says the camera was working. Three technicians confirm it was working. The photographs are simply not there."
		"WARRIOR":
			return "The room went quiet when [COMMANDER_NAME] walked in. Not from uncertainty — from recognition. The press corps, the White House staff, the three generals in the back row: everyone in that room had heard the name, and now they were standing in the same space as the person it belonged to. Carlisle presented the citation without preamble. [COMMANDER_NAME] accepted it without performance. Whatever was said between them was not recorded. The press corps, by unspoken agreement, did not attempt to capture the private exchange. Some moments are not improved by documentation."
		_:
			return "President Carlisle delivered personal thanks to [COMMANDER_NAME] at the White House. The citation was presented, the record was made, and something unscheduled happened in the margins of the ceremony that the official account doesn't fully capture. [COMMANDER_NAME] accepted the commendation without fanfare. Carlisle shook [CMD_POSSESSIVE] hand and held it a moment longer than the cameras expected."


func _build_thanks_txt_exp(position: String) -> String:
	var tag: String = position
	return "The press conference is over. The Oval Office door closes. What happens next belongs to [COMMANDER_NAME] and [CMD_OBJECT] alone.\n\n[ EXPLICIT SCENE PLACEHOLDER — " + tag + " archetype. Oval Office setting. Hand-craft this scene with [COMMANDER_NAME]'s pronouns and personality. ]"


# ── WILD PROTECTOR SYSTEM ────────────────────────────────────────

func _is_protector_wild(pid: String) -> bool:
	var pid_lower = pid.to_lower()
	return (not playerCountryNode.CountryFlags.has(pid_lower + "_tame") and
			not playerCountryNode.CountryFlags.has(pid_lower + "_agreed"))


func _tick_wild_protectors() -> void:
	var owned_tiles: Array = playerCountryNode.OwnedTileList
	if owned_tiles.is_empty():
		return
	for pid in PROTECTOR_IDS:
		if not _is_protector_wild(pid):
			continue
		if randf() < 0.25:
			var target: Tile = owned_tiles[randi() % owned_tiles.size()]
			target.corruption = clampi(target.corruption + 1, 0, 100)
			print("[WildProt] ", pid, " added +1 corruption to ", target.tileName)


func _check_protector_summons() -> void:
	for pid in PROTECTOR_IDS:
		if pid == "PROT_08" or pid == "PROT_17":
			continue  # DMA-investigation gated — handled by dedicated summon functions
		if not _is_protector_wild(pid):
			continue
		var min_turn: int = PROTECTOR_SUMMON_TURNS.get(pid, 999)
		if currentWorldTurn < min_turn:
			continue
		var summon_id = pid + "_SUMMON"
		if _event_on_cooldown(summon_id):
			continue
		_start_cooldown(summon_id, 20)
		createNewEvent(summon_id, null)
		print("[Protector] SUMMON fired: ", summon_id, " on turn ", currentWorldTurn)
		return


func _check_prot08_dma_summon() -> void:
	if not _is_protector_wild("PROT_08"):
		return
	if _event_on_cooldown("PROT_08_SUMMON"):
		return
	# Scan player-owned tiles for a pending DMA investigation on a ship-raid tile
	var dma_tile = null
	for tile in playerCountryNode.OwnedTileList:
		if tile.get("dmaInvestigationPending") and tile.get("hasMysteriousShipRaids"):
			dma_tile = tile
			tile.dmaInvestigationPending = false  # consume the flag
			break
	if dma_tile == null:
		return
	_start_cooldown("PROT_08_SUMMON", 9999)  # fires once
	createNewEvent("PROT_08_SUMMON", dma_tile)
	print("[Protector] PROT_08_SUMMON fired via DMA investigation at ", dma_tile.tileName)


func _check_prot17_dma_summon() -> void:
	if not _is_protector_wild("PROT_17"):
		return
	if _event_on_cooldown("PROT_17_SUMMON"):
		return
	# Scan player-owned tiles for a pending DMA investigation on the DC oration tile
	var dma_tile = null
	for tile in playerCountryNode.OwnedTileList:
		if tile.get("dmaInvestigationPending") and tile.get("hasMysteriousShipRaids"):
			dma_tile = tile
			tile.dmaInvestigationPending = false  # consume the flag
			break
	if dma_tile == null:
		return
	_start_cooldown("PROT_17_SUMMON", 9999)  # fires once
	createNewEvent("PROT_17_SUMMON", dma_tile)
	print("[Protector] PROT_17_SUMMON fired via DMA investigation at ", dma_tile.tileName)


# ── CANADIAN PROTECTOR CHECKS ────────────────────────────────────────────────

func _is_ca_prot_wild(pid: String) -> bool:
	var tame_flag    = pid.to_lower() + "_tame"
	var agreed_flag  = pid.to_lower() + "_agreed"
	return not playerCountryNode.CountryFlags.has(tame_flag) \
		and not playerCountryNode.CountryFlags.has(agreed_flag)


func _get_ca_prot_tile(pid: String):
	var tile_num: int = CA_PROT_TILES.get(pid, 0)
	if tile_num == 0:
		return null
	for tile in $TileController.get_children():
		if tile.tileNumber == tile_num:
			return tile
	return null


func _get_prot_tile(pid: String):
	var tile_num: int = USA_PROT_TILES.get(pid, 0)
	if tile_num == 0:
		return null
	for tile in $TileController.get_children():
		if tile.tileNumber == tile_num:
			return tile
	return null


func _tick_wild_ca_protectors() -> void:
	# Wild CA protectors have a 25% chance per turn to add +1 corruption to a
	# random CA-owned tile (mirrors _tick_wild_protectors for USA).
	var ca_country = null
	for c in aliveCountriesList:
		if c.CID == "CA":
			ca_country = c
			break
	if ca_country == null or ca_country.OwnedTileList.is_empty():
		return
	for pid in CA_PROT_IDS:
		if not _is_ca_prot_wild(pid):
			continue
		if randf() < 0.25:
			var target = ca_country.OwnedTileList[randi() % ca_country.OwnedTileList.size()]
			target.corruption = clampi(target.corruption + 1, 0, 100)
			print("[CA WildProt] ", pid, " added +1 corruption to ", target.tileName)


func _check_ca_protectors() -> void:
	# Fires CA protector summons from USA's perspective (diplomacy from Jessica to Ualani).
	# Don't fire if the Canadian arc was rejected.
	if playerCountryNode.CountryFlags.has("can_rejected"):
		return
	for pid in CA_PROT_IDS:
		if not _is_ca_prot_wild(pid):
			continue
		var min_turn: int = CA_PROT_SUMMON_TURNS.get(pid, 999)
		if currentWorldTurn < min_turn:
			continue
		var summon_id = pid + "_SUMMON"
		if _event_on_cooldown(summon_id):
			continue
		var prot_tile = _get_ca_prot_tile(pid)
		_start_cooldown(summon_id, 15)
		createNewEvent(summon_id, prot_tile)
			  #" at tile ", CA_PROT_TILES.get(pid, 0), " turn ", currentWorldTurn)
			  #" at tile ", CA_PROT_TILES.get(pid, 0), " turn ", currentWorldTurn)
		return


func _check_ca_own_protectors() -> void:
	# Main CA protector summons when playing as Canada — Jessica Commanda Odjick summons them.
	# No alliance gate; these are Canada's own mythological affairs.
	for pid in CA_PROT_IDS:
		if not _is_ca_prot_wild(pid):
			continue
		var min_turn: int = CA_PROT_SUMMON_TURNS.get(pid, 999)
		if currentWorldTurn < min_turn:
			continue
		var summon_id = pid + "_SUMMON"
		if _event_on_cooldown(summon_id):
			continue
		var prot_tile = _get_ca_prot_tile(pid)
		_start_cooldown(summon_id, 15)
		createNewEvent(summon_id, prot_tile)
			  #" at tile ", CA_PROT_TILES.get(pid, 0), " turn ", currentWorldTurn)
			  #" at tile ", CA_PROT_TILES.get(pid, 0), " turn ", currentWorldTurn)
		return


# ── LOYAL GOVERNOR DISPATCH EVENTS ──────────────────────────────────────────

func _check_loyal_governor_events() -> void:
	var tiles_copy: Array = playerCountryNode.OwnedTileList.duplicate()
	tiles_copy.shuffle()
	for tile in tiles_copy:
		if tile.tileGovernor == null:
			continue
		var gov = tile.tileGovernor
		if gov.isVicePresident or gov.isLeader:
			continue
		if gov.governorArchetypeId == "":
			continue  # named governor — skip
		if gov.governorArchetypeId == "ARC_20":
			continue  # Hawaiian Refugee — Ualani's archetype, no loyalty event
		if gov.loyalty < GOV_LOYAL_THRESHOLD:
			continue
		var fired_flag: String = "loyal_event_" + gov.governorArchetypeId + "_" + str(tile.tileNumber)
		if playerCountryNode.CountryFlags.has(fired_flag):
			continue
		if randf() >= GOV_LOYAL_CHANCE:
			continue
		playerCountryNode.CountryFlags[fired_flag] = true
		createNewEvent("GOV_LOYAL_" + gov.governorArchetypeId, tile)
			#") loyal event fired at ", tile.tileName)
			#") loyal event fired at ", tile.tileName)
		return  # one per turn max


func _check_arc03_honorary_event() -> void:
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null:
			continue
		var gov = tile.tileGovernor
		if gov.governorArchetypeId != "ARC_03":
			continue
		if gov.loyalty < 6.0:
			continue
		var flag: String = "arc03_honorary_" + str(tile.tileNumber)
		if playerCountryNode.CountryFlags.has(flag):
			continue
		if randf() >= 0.03:
			continue
		playerCountryNode.CountryFlags[flag] = true
		createNewEvent("ARC_03_HONORARY", tile)
		print("[ARC_03] Honorary degree event fired at ", tile.tileName)
		return


func _check_arc11_monarchist_event() -> void:
	for tile in playerCountryNode.OwnedTileList:
		if tile.tileGovernor == null:
			continue
		var gov = tile.tileGovernor
		if gov.governorArchetypeId != "ARC_11":
			continue
		if gov.loyalty < 5.0:
			continue
		var flag: String = "arc11_monarchists_" + str(tile.tileNumber)
		if playerCountryNode.CountryFlags.has(flag):
			continue
		if randf() >= 0.03:
			continue
		playerCountryNode.CountryFlags[flag] = true
		createNewEvent("ARC_11_MONARCHISTS", tile)
		print("[ARC_11] Monarchist mob event fired at ", tile.tileName)
		return


func _get_tile_resource_output(tile, resource: String) -> int:
	match resource:
		"food":     return max(int(tile.buildingFoodOutput), 2)
		"wood":     return max(int(tile.buildingWoodOutput), 2)
		"metal":    return max(int(tile.buildingMetalOutput), 2)
		"gold":     return max(int(tile.buildingDollarsOutput), 2)
		"weapons":  return max(int(tile.buildingWeaponsOutput), 2)
		"manpower": return max(int(tile.buildingManpowerOutput), 2)
		"culture":  return max(int(tile.buildingCultureOutput), 2)
		"magic":    return max(int(tile.buildingMagicOutput), 2)
		_:          return 2


# ── GEORGE III PEACE OFFER ───────────────────────────────────────────────────

func _check_george_peace_offer() -> void:
	if currentWorldTurn < 75 or currentWorldTurn > 80:
		return
	if _event_on_cooldown("GEORGE_PEACE_01"):
		return
	if playerCountryNode.CountryFlags.has("george_peace_rejected"):
		return
	if playerCountryNode.CountryFlags.has("george_peace_accepted"):
		return

	var uk_country = null
	for c in aliveCountriesList:
		if c.CID == "UK":
			uk_country = c
			break
	if uk_country == null:
		return

	# Don't fire if peace is already settled
	var usa_peace: bool = uk_country.CountryFlags.has("uk_usa_peace")
	var ca_peace:  bool = uk_country.CountryFlags.has("uk_ca_peace")
	var is_allied: bool = playerCountryNode.CountryFlags.has("can_allied")
	if usa_peace and (not is_allied or ca_peace):
		return

	_start_cooldown("GEORGE_PEACE_01", 999)
	createNewEvent("GEORGE_PEACE_01", null)
	print("[George Peace] Turn ", currentWorldTurn, " — peace offer fired")


func _apply_george_peace() -> void:
	var uk_country = null
	for c in aliveCountriesList:
		if c.CID == "UK":
			uk_country = c
			break
	if uk_country == null:
		return

	var is_allied: bool = playerCountryNode.CountryFlags.has("can_allied")

	if not uk_country.CountryFlags.has("uk_usa_peace"):
		uk_country.CountryFlags["uk_usa_peace"] = true

	if is_allied:
		if not uk_country.CountryFlags.has("uk_ca_peace"):
			uk_country.CountryFlags["uk_ca_peace"] = true
		for c in aliveCountriesList:
			if c.CID == "CA":
				if not c.CountryFlags.has("uk_ca_peace"):
					c.CountryFlags["uk_ca_peace"] = true
				break

	if not playerCountryNode.CountryFlags.has("george_peace_accepted"):
		playerCountryNode.CountryFlags["george_peace_accepted"] = true

		#" + uk_ca_peace (allied)" if is_allied else " (USA only)")
		#" + uk_ca_peace (allied)" if is_allied else " (USA only)")


# ── PEACE CONDITIONS ─────────────────────────────────────────────────────────

func _get_peace_tile(tile_num: int):
	for tile in $TileController.get_children():
		if tile.tileNumber == tile_num:
			return tile
	return null


func _check_peace_conditions() -> void:
	var uk_country = null
	for c in aliveCountriesList:
		if c.CID == "UK":
			uk_country = c
			break
	if uk_country == null:
		return

	var usa_peace: bool = uk_country.CountryFlags.has("uk_usa_peace")
	var ca_peace:  bool = uk_country.CountryFlags.has("uk_ca_peace")
	if usa_peace and ca_peace:
		return

	var is_allied: bool = playerCountryNode.CountryFlags.has("can_allied")

	# Update flip tracker — detect which dock tile was most recently freed
	for tile_num in PEACE_DOCK_USA + PEACE_DOCK_CA:
		var tile = _get_peace_tile(tile_num)
		if tile == null:
			continue
		var is_uk: bool = tile.tileOwner == "UK"
		var was_uk: bool = _peace_dock_was_uk.get(tile_num, true)
		if was_uk and not is_uk:
			_peace_last_freed_tile = tile
		_peace_dock_was_uk[tile_num] = is_uk

	# Count remaining UK-owned peace dock tiles per region
	var usa_uk: int = 0
	var ca_uk: int = 0
	for tile_num in PEACE_DOCK_USA:
		var tile = _get_peace_tile(tile_num)
		if tile != null and tile.tileOwner == "UK":
			usa_uk += 1
	for tile_num in PEACE_DOCK_CA:
		var tile = _get_peace_tile(tile_num)
		if tile != null and tile.tileOwner == "UK":
			ca_uk += 1

	var peace_tile = _peace_last_freed_tile

	# Allied peace: ALL USA and CA dock tiles must be liberated together
	if is_allied and not usa_peace and not ca_peace:
		if usa_uk == 0 and ca_uk == 0:
			_execute_allied_peace(uk_country, peace_tile)
			return

	# USA separate peace (only when unallied or CA already at peace separately)
	if not usa_peace and not is_allied:
		if usa_uk == 0:
			_execute_usa_peace(uk_country, peace_tile)

	# CA separate peace
	if not ca_peace and not is_allied:
		if ca_uk == 0:
			_execute_ca_peace(uk_country, peace_tile)


func _execute_allied_peace(uk_country, peace_tile) -> void:
	uk_country.CountryFlags["uk_usa_peace"] = true
	uk_country.CountryFlags["uk_ca_peace"] = true
	for c in aliveCountriesList:
		if c.CID == "CA":
			c.CountryFlags["uk_ca_peace"] = true
			break
	createNewEvent("PEACE_ALLIED_01", peace_tile)
	print("[Peace] Allied peace signed — PEACE_ALLIED_01 fired")


func _execute_usa_peace(uk_country, peace_tile) -> void:
	if not uk_country.CountryFlags.has("uk_usa_peace"):
		uk_country.CountryFlags["uk_usa_peace"] = true
	createNewEvent("PEACE_USA_01", peace_tile)
	print("[Peace] USA separate peace signed — PEACE_USA_01 fired")


func _execute_ca_peace(uk_country, peace_tile) -> void:
	if not uk_country.CountryFlags.has("uk_ca_peace"):
		uk_country.CountryFlags["uk_ca_peace"] = true
	for c in aliveCountriesList:
		if c.CID == "CA":
			c.CountryFlags["uk_ca_peace"] = true
			break
	createNewEvent("PEACE_CA_AI_01", peace_tile)
	print("[Peace] CA separate peace signed — PEACE_CA_AI_01 fired")


func _check_win_conditions() -> void:
	if _game_ended or _republic_collapsed or _ca_collapsed:
		return

	# Single pass: check UK tile presence and DC capture
	var uk_tiles_remain: bool = false
	var dc_captured: bool = false
	for tile in $TileController.get_children():
		if tile.tileOwner == "UK":
			uk_tiles_remain = true
			if tile.tileNumber == 188:
				dc_captured = true

	# DC fallen loss
	if dc_captured:
		_trigger_game_over(false, "Washington DC has fallen to the Crown.", "DCdown")
		return

	var uk_country = null
	for c in aliveCountriesList:
		if c.CID == "UK":
			uk_country = c
			break

	# Peace + clean victory: peace signed AND no UK tiles remain
	if uk_country != null:
		var usa_peace: bool = uk_country.CountryFlags.has("uk_usa_peace")
		var is_allied: bool = playerCountryNode.CountryFlags.has("can_allied")
		var ca_peace:  bool = uk_country.CountryFlags.has("uk_ca_peace")
		if usa_peace and (not is_allied or ca_peace) and not uk_tiles_remain:
			_trigger_game_over(true, "The Crown has acknowledged the Republic. Peace is signed.")
			return

	# Military victory: all UK tiles expelled, no peace needed
	if not uk_tiles_remain:
		_trigger_game_over(true, "Every Crown garrison has fallen. The continent is free.")


func _generate_and_assign_governor(tile: Tile) -> void:
	if _usa_archetypes.is_empty() or _usa_name_pools.is_empty():
		push_warning("_generate_and_assign_governor: archetype data not loaded (call generateBarracksCommanders first)")
		return
	var portrait_placeholder: Texture = load(
		"res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
	var candidates: Array = []
	for arch in _usa_archetypes:
		if tile.terrain in arch["terrain"]:
			candidates.append(arch)
	if candidates.is_empty():
		candidates = _usa_archetypes
	var chosen: Dictionary = candidates[randi() % candidates.size()]
	var pool_id: String = chosen["pools"][randi() % chosen["pools"].size()]
	var fallback_pool_id: String = _usa_name_pools.keys()[0] if not _usa_name_pools.is_empty() else ""
	var pool: Dictionary = _usa_name_pools.get(pool_id, _usa_name_pools.get(fallback_pool_id, {}))
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
	_assign_governor_to_faction(new_gov)
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
		"mandate":         playerCountryNode.TotalMandate   += amount
		"manpower":        playerCountryNode.TotalManpower  += amount

func _apply_morale_boost(amount: int, tile = null) -> void:
	if tile != null and tile.tileGovernor != null:
		tile.tileGovernor.morale = clampi(tile.tileGovernor.morale + amount, 0, 100)
			#" morale → ", tile.tileGovernor.morale)
			#" morale → ", tile.tileGovernor.morale)
	else:
		for t in playerCountryNode.OwnedTileList:
			if t.tileGovernor != null:
				t.tileGovernor.morale = clampi(t.tileGovernor.morale + amount, 0, 100)

func _apply_army_buff(buff_type: String, duration: int, tile) -> void:
	var targets: Array = []
	if tile != null and tile.stationedArmy != null:
		targets = [tile.stationedArmy]
	else:
		targets = playerCountryNode.countryArmyList
	for army in targets:
		army.apply_status(buff_type, duration)
		army.surveySelf()
		army.updateArmyUI()
		#targets.size(), " army/armies")
		#targets.size(), " army/armies")

func _summon_protector(protector_id: String, tile) -> void:
	createNewEvent("PROT_" + protector_id + "_SUMMON", tile)

func _get_spell_school(spell_name: String) -> String:
	match spell_name:
		"MANIFEST DESTINY SUBSIDY PROGRAM":        return "iron"
		"THOUGHTS & PRAYERS (FEDERAL ALLOCATION)": return "spectral"
		"UNAUTHORIZED WEATHER MODIFICATION ACT":   return "storm"
		"EMANCIPATION PROCLAMATION 2: STILL EMANCIPATING": return "liberty"
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
		if _hovered_tile != null and $PathControl.selectedAPF != null:
			if $PathControl.tryMoveSelectedAPFToTile(_hovered_tile):
				return
		resetUI()

func resetUI():
	for Tile in $TileController.get_children():
		Tile.normalMode()
	$PathControl.deselectAll()
	$CanvasLayer.closeAllPanels()

var lastSelectedPathPoint: pathPointButton
func updateArmyFunc(Army, pathPoint):
	$CanvasLayer/ArmyPanel/ArmyNameLabel.text = Army.ArmyName
	$CanvasLayer/ArmyPanel/AttackLabel.text = str(Army.armyPunch)
	$CanvasLayer/ArmyPanel/DefenseLabel.text = str(Army.armyBlock)
	$CanvasLayer/ArmyPanel/RangedAttackLabel.text = str(Army.armyLaunch)
	$CanvasLayer/ArmyPanel/RangedDefenseLabel.text = str(Army.armyDefence)
	$CanvasLayer/ArmyPanel/ManpowerLabel.text = str(Army.manpowerInArmy, " / ", Army.maxManpower)
	$CanvasLayer/ArmyPanel/ShieldLabel.text = str(Army.armyShield, " / ", Army.armyMaxShield)
	_refresh_unit_action_uis(Army)
	#$CanvasLayer/ArmyPanel/LocationLabel.text = str(pathPoint.pathNumber)
	if $CanvasLayer/ArmyPanel.visible == false:
		$CanvasLayer.closeAllPanels()
		$CanvasLayer/ArmyPanel.visible = true
		lastSelectedPathPoint = pathPoint
	else:
		$CanvasLayer/ArmyPanel.visible = false
		lastSelectedPathPoint = null

var _unit_action_uis: Array = []

func _refresh_unit_action_uis(Army) -> void:
	var panel = $CanvasLayer/ArmyPanel
	if _unit_action_uis.is_empty():
		for i in 2:
			var ui = preload("res://unit_action_ui.gd").new()
			ui.name = "UnitActionUI" + str(i)
			ui.position = Vector2(10, 44 + i * 128)
			ui.custom_minimum_size = Vector2(300, 120)
			panel.add_child(ui)
			_unit_action_uis.append(ui)
	for i in 2:
		if i < Army.unitsList.size():
			_unit_action_uis[i].visible = true
			_unit_action_uis[i].setup(Army.unitsList[i])
		else:
			_unit_action_uis[i].visible = false


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

# Attack animation system — melee button sets path_control.melee_mode = true,
# then the next right-click on a neighboring enemy PPB triggers _initiate_attack().
# Battle resolves inline at the animation midpoint via _on_attack_midpoint().
func meleePressed(_armyPath, _thisArmy) -> void:
	pass  # melee_mode flag already set in path_control._on_melee_attack_button_pressed

	pass # Replace with function body.

func _army_has_active_marine(army: Army) -> bool:
	for unit in army.unitsList:
		for mm in unit.militaryModifierList:
			if mm.milModType == "Marine" and not mm.disabled:
				return true
	return false

func rangedPressed(armyPath, thisArmy) -> void:
	if thisArmy.attackBlocked:
		return
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
			spellString = LocBallUI.magicDic.manifest
			spellDesc = LocBallUI.magicDic.manifest
			schoolType = LocBallUI.magicDic.manifest
		"draughtOfKnowledge":
			spellString = LocBallUI.magicDic.manifest
			spellDesc = LocBallUI.magicDic.manifest
			schoolType = LocBallUI.magicDic.manifest
		"fireworks":
			spellString = LocBallUI.magicDic.manifest
			spellDesc = LocBallUI.magicDic.manifest
			schoolType = LocBallUI.magicDic.manifest
		"fleetingFoot":
			spellString = LocBallUI.magicDic.manifest
			spellDesc = LocBallUI.magicDic.manifest
			schoolType = LocBallUI.magicDic.manifest
		"focusingDust":
			spellString = LocBallUI.magicDic.manifest
			spellDesc = LocBallUI.magicDic.manifest
			schoolType = LocBallUI.magicDic.manifest
		"goldenTouch":
			spellString = LocBallUI.magicDic.manifest
			spellDesc = LocBallUI.magicDic.manifest
			schoolType = LocBallUI.magicDic.manifest
		"paralysis":
			spellString = LocBallUI.magicDic.paralysis
			spellDesc = LocBallUI.magicDic.paralysisDesc
			schoolType = LocBallUI.magicDic.manifest
		"poison":
			spellString = LocBallUI.magicDic.poison
			spellDesc = LocBallUI.magicDic.poisonDesc
			schoolType = LocBallUI.magicDic.manifest
		"slimeSoldier":
			spellString = LocBallUI.magicDic.slimeSoldier
			spellDesc = LocBallUI.magicDic.slimeSoldierDesc
			schoolType = LocBallUI.magicDic.manifest
		"slimeSpitter":
			spellString = LocBallUI.magicDic.slimeSpitter
			spellDesc = LocBallUI.magicDic.slimeSpitterDesc
			schoolType = LocBallUI.magicDic.manifest
		"slimeWeapons":
			spellString = LocBallUI.magicDic.slimeWeapons
			spellDesc = LocBallUI.magicDic.slimeWeaponsDesc
			schoolType = LocBallUI.magicDic.manifest
		"waterbreathing":
			spellString = LocBallUI.magicDic.waterbreathing
			spellDesc = LocBallUI.magicDic.waterbreathingDesc
			schoolType = LocBallUI.magicDic.manifest
	spellBranch.giveSpellInfo(schoolPoints, turnsUntil, unlocked, spellString, spellDesc, schoolType)
	pass

func _on_belief_control_purchased_belief(beliefName, beliefCost) -> void:
	playerCountryNode.addReligiousBelief(beliefName)
	playerCountryNode.payBill("faith", beliefCost)
	$CanvasLayer/BeliefControl.updateSelf()
	# Refresh belief mil mods on all player armies when beliefs change.
	for army in playerCountryNode.countryArmyList:
		if army.parentCountry == playerCountryNode:
			army.applyCountryBeliefMilMods()
	pass


func _on_government_control_slider_changed(amount, type) -> void:
	playerCountryNode.setNewTaxAmount(amount, type)
	pass # Replace with function body.

func _on_civilian_button_pressed() -> void:
	$CanvasLayer/CivilianControl.updateCivilians()
	if $CanvasLayer/CivilianControl.visible == true:
		$CanvasLayer/CivilianControl.visible = false
	else:
		$CanvasLayer.closeAllPanels()
		$CanvasLayer/CivilianControl.visible = true

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
	if $CanvasLayer/CivilianUnitControl.visible == false:
		$CanvasLayer.closeAllPanels()
		$CanvasLayer/CivilianUnitControl.visible = true
	else:
		$CanvasLayer/CivilianUnitControl.visible = false

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

func _tile_home_nation(tile) -> String:
	# The tile's rightful owner, derived from its region. Owner-independent.
	var c: String = tile.tileContinent
	if c.begins_with("CA -"):
		return "CA"
	if c == "BA":
		return "UK"
	if c == "" or c == "Neutral":
		return ""
	return "USA"


func _cids_allied(cid_a: String, cid_b: String) -> bool:
	for country in aliveCountriesList:
		if country.CID == cid_a:
			for ally in country.ALLIED:
				if is_instance_valid(ally) and ally.CID == cid_b:
					return true
	return false


func tileSiegeWon(tile, oldCID: String, newCID: String) -> void:
	# Liberation: a tile freed by an ALLY of its home nation returns to that nation.
	# Not allied? The conqueror keeps the spoils (opens the door to conquest-run trickery).
	var finalCID: String = newCID
	var home: String = _tile_home_nation(tile)
	if home != "" and home != newCID and _cids_allied(newCID, home):
		finalCID = home
	for country in aliveCountriesList:
		if country.CID == oldCID:
			country.OwnedTileList.erase(tile)
		if country.CID == finalCID:
			country.addTile(tile)
	tile.record_conquest(finalCID)

	# ── ITEM 3: clean up any APF belonging to the losing side ────────────────
	var ppb = tile.tileSpawnPoint
	if ppb != null and is_instance_valid(ppb) and ppb.stationedAPF != null:
		var apf = ppb.stationedAPF
		if is_instance_valid(apf) and apf.thisArmy != null \
				and apf.thisArmy.parentCountry != null \
				and apf.thisArmy.parentCountry.CID == oldCID:
			ppb.stationedAPF = null
			ppb.stationedArmy = null
			ppb.occupied = false
			apf.thisArmy.deleteMode = true   # APF _process() will queue_free both nodes

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

func _trigger_game_over(won: bool, reason: String = "", end_type: String = "") -> void:
	if _game_ended:
		return
	_game_ended = true
	#AudioManager.play_sfx("victory" if won else "defeat")
	print("[GameOver] won=", won, "  reason=", reason, "  end_type=", end_type)
	if not won and end_type != "":
		var ending = get_node_or_null("CanvasLayer/EndingSceneControl")
		if ending != null:
			ending.endGame(end_type, _format_game_date(), currentWorldTurn)
			return
	var panel = get_node_or_null("CanvasLayer/GameOverPanel")
	if panel != null:
		panel.show_result(won, reason)
	else:
		push_warning("[GameOver] GameOverPanel not found — result: " + ("WIN" if won else "LOSS"))


func _on_next_turn_pressed() -> void:
	if _game_ended:
		return
	#AudioManager.play_sfx("end_turn")
	# End this player's individual turn
	_end_current_player_turn()

	_turn_phase_index += 1

	if _turn_phase_index < _player_turn_order.size():
		# More player turns remain — switch to next player
		_activate_player(_player_turn_order[_turn_phase_index])
	else:
		# All player turns done — run AI and advance the world
		_turn_phase_index = 0
		await _resolve_ai_and_advance_round()
		# Restore first player as active after round ends
		if not _game_ended:
			_activate_player(_player_turn_order[0])

# ── DATE SYSTEM ──────────────────────────────────────────────────────────────
# Each turn represents 9 days.  Real-world calendar (Gregorian leap years).
# Game starts July 4, 2026 (inauguration day).
# 100 turns × 9 days = 900 days → arrives ~December 2028, covering the full
# presidential emergency term and the 2028 election cycle.
func _advance_fortnight() -> void:
	var TURN_DAYS: int = 9
	var days_per_month := [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	# Leap year: divisible by 4, except centuries unless also by 400
	if (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)):
		days_per_month[2] = 29
	day += TURN_DAYS
	dayOfMonth += TURN_DAYS
	if dayOfMonth > days_per_month[month]:
		dayOfMonth -= days_per_month[month]
		month += 1
		if month > 12:
			month = 1
			year += 1
		#AudioManager.play_sfx("season_change")
		emit_signal("calculateSeason", month)

func _format_game_date() -> String:
	var month_names := [
		"January","February","March","April","May","June",
		"July","August","September","October","November","December"
	]
	var mname = month_names[month - 1] if (month >= 1 and month <= 12) else ("Month " + str(month))
	return "%s %d, %d" % [mname, dayOfMonth, year]

# ── OPENING JOURNAL ENTRY ─────────────────────────────────────────────────────
func _seed_opening_journal_entry() -> void:
	var lib = get_node_or_null("/root/LibraryData")
	if lib == null:
		return
	var body := """[b]July 4, 2026 — Washington, D.C.[/b]

President Ualani Carlisle didn't expect to become the leader of the final free coalition on Earth. She was a senator who became a vice president due to her devastating speeches criticizing the colonist King George III. It was when her president had a complete and unexpected medical event that she was suddenly holding the reins on the executive branch, just weeks from the second British invasion.

She was a soldier. She fought the robot redcoats during their first invasion, when America lost her ports to the colonizers. She knew she would have critics who claimed her authority was limited due to the fact that she wasn't elected president. But when she looked out into the Atlantic, when her advisers began detailing her of British troop movements, politics faded from her view.

There was only one person who could steer America through these storm clouds. If it wasn't Ualani, who would it be?"""
	lib.add_journal_entry(
		"JOURNAL_001",
		1,
		"The Inauguration of President Ualani Carlisle",
		body,
		"DECLASSIFIED"
	)

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
		if not is_instance_valid(army) or army.deleteMode:
			continue
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

# ── STORM SYSTEM ─────────────────────────────────────────────────────────────
# Storms spawn on a random tile each turn (chance: 3%).
# A spawn determines type from tile.winterScore and terrain, then
# spreads the storm to all TileNeighbors of the origin tile for a
# duration of 2–6 turns.  Each tick decrements duration; when it
# reaches 0 the storm clears from all tiles in that cluster.

func _tick_storms() -> void:
	# Chance to spawn a new storm this turn
	if randf() < 0.03:
		var tiles = $TileController.get_children()
		if tiles.size() > 0:
			var origin: Tile = tiles[randi() % tiles.size()]
			_spawn_storm(origin)

	# Decrement all active storms and clear expired ones
	for tile in $TileController.get_children():
		if tile.stormActive:
			tile.stormDuration -= 1
			if tile.stormDuration <= 0:
				tile.stormActive    = false
				tile.stormType      = ""
				tile.stormIntensity = 1
				tile.stormOriginId  = ""

func _spawn_storm(origin: Tile) -> void:
	var storm_type: String = _determine_storm_type(origin)
	var duration: int = randi_range(2, 6)
	var intensity: int = randi_range(1, 3)
	var storm_id: String = str(origin.tileNumber) + "_" + str(currentWorldTurn)

	# Stamp origin tile
	origin.stormActive    = true
	origin.stormType      = storm_type
	origin.stormDuration  = duration
	origin.stormIntensity = intensity
	origin.stormOriginId  = storm_id

	# Spread to all neighbors
	_spread_storm(origin, storm_id, storm_type, duration, intensity)
		  #" — intensity ", intensity, ", duration ", duration, " turns.")
		 # " — intensity ", intensity, ", duration ", duration, " turns.")

func _spread_storm(origin: Tile, storm_id: String, storm_type: String,
				   duration: int, intensity: int) -> void:
	for neighbor in origin.TileNeighbors:
		if neighbor == null:
			continue
		# Don't overwrite a stronger or longer storm already present
		if neighbor.stormActive and neighbor.stormDuration >= duration:
			continue
		neighbor.stormActive    = true
		neighbor.stormType      = storm_type
		neighbor.stormDuration  = duration
		neighbor.stormIntensity = intensity
		neighbor.stormOriginId  = storm_id

func _apply_storm_debuffs() -> void:
	for country in aliveCountriesList:
		for army in country.countryArmyList:
			if not is_instance_valid(army) or army.deleteMode:
				continue
			if army.inTile != null and army.inTile.stormActive:
				_apply_storm_status_to_army(army, army.inTile.stormType)

func _apply_storm_status_to_army(army: Army, storm_type: String) -> void:
	match storm_type:
		"Thunderstorm", "Hurricane":
			army.apply_status("Waterlogged", 1)
		"Blizzard", "Nor'easter":
			army.apply_status("Frostbitten", 2)
		"Fog":
			army.apply_status("Blinded", 1)
		"Tornado":
			army.apply_status("Bogged Down", 1)
			army.apply_status("Shaken", 1)

func _determine_storm_type(tile: Tile) -> String:
	# winterScore < 0 = tropical  →  hurricane or thunderstorm
	# winterScore 0-3 = temperate  →  thunderstorm, fog, nor'easter
	# winterScore 4+  = cold       →  blizzard, nor'easter
	# Tornado can appear in Farmlands or Foothills regardless of season
	if tile.terrain == "Farmlands" or tile.terrain == "Foothills":
		if randf() < 0.15:
			return "Tornado"
	if tile.winterScore < 0:
		return "Hurricane" if randf() < 0.5 else "Thunderstorm"
	elif tile.winterScore >= 4:
		return "Blizzard" if randf() < 0.6 else "Nor'easter"
	else:
		var roll: float = randf()
		if roll < 0.33:
			return "Fog"
		elif roll < 0.66:
			return "Thunderstorm"
		else:
			return "Nor'easter"


# ── COMMANDER DEATH MEMO ─────────────────────────────────────────────────────
# Fires when a player army with a named commander is destroyed.
# Generates a short, sad, bureaucratic casualty notice dynamically —
# no CSV entry required.  Uses build_from_data() on the event scene.

# Revolution-era rank by governor level
const _COMMANDER_RANKS: Dictionary = {
	1: "Captain",
	2: "Major",
	3: "Colonel",
}

# Archetype flavor sentence — one line per archetype
const _ARCHETYPE_FLAVOR: Dictionary = {
	"ARC_01": "A scout who knew every marsh, cove, and tidal crossing on the eastern seaboard.",
	"ARC_02": "An engineer who turned knowledge of stone and powder into devastating artillery precision.",
	"ARC_03": "A tactician who traded the lecture hall for the battlefield without regret.",
	"ARC_04": "A warrior who fought this land's invaders long before the revolution had a name.",
	"ARC_05": "A farmer who took up the rifle when the crown came for their land.",
	"ARC_06": "A shipwright who built the guns that now fall silent.",
	"ARC_07": "A spy who knew the enemy's plans because they once wrote them.",
	"ARC_08": "A drifter who covered a thousand miles on foot and asked nothing in return.",
	"ARC_09": "A leader who had already lost everything once and refused to lose again.",
	"ARC_10": "A scout for whom the forest was home, not obstacle.",
	"ARC_11": "An orator whose voice was a weapon — now silenced.",
	"ARC_12": "A healer who saved the wounded so they could fight tomorrow. Today there is no tomorrow.",
	"ARC_13": "A sailor who called no shore home. The sea will remember.",
	"ARC_14": "A preacher who put God and country above all else, in that order.",
	"ARC_15": "An administrator who knew every regulation — and which ones to ignore for the Republic.",
	"ARC_16": "An engineer who built the walls and knew exactly where they would crack.",
	"ARC_17": "A soldier who left at midnight and never looked back. They had come too far to stop.",
	"ARC_18": "A commander of the bayou itself. The swamp mourns with us.",
	"ARC_19": "A privateer who flew no flag but profit. In the end, they fought for something real.",
	"ARC_20": "A soldier who crossed the Pacific once. The Atlantic was nothing. Neither was death.",
	"ARC_21": "A mercenary who fought for whoever paid — until they found something worth fighting for.",
	"ARC_22": "A ranger whose home the British burned. The forest will remember what they gave.",
	"ARC_23": "A soldier whose family name was written in battlefield soil. It is written there again.",
	"ARC_24": "An organizer who built coalitions the old guard called impossible. They proved them wrong until the last.",
	"ARC_25": "An orator who treated every battle as a performance. The curtain has fallen.",
}

func _on_commander_fallen(commander, army_name: String, tile) -> void:
	# Priority 1: head of state death → game over (Ualani for USA)
	if commander.isLeader:
		_handle_president_death(commander, army_name, tile)
		return
	# Priority 2: VP death → special funeral + succession flow
	if commander.isVicePresident:
		_handle_vp_death(commander, army_name, tile)
		return
	# Standard commander death memo
	var data: Dictionary = _build_commander_death_memo(commander, army_name, tile)
	_create_dynamic_event(data, tile)


func _handle_president_death(commander, army_name: String, tile) -> void:
	var name: String = commander.governorType if commander.governorType != "" else "the President"
	print("[GAME OVER] President ", name, " has been killed.")
	var data: Dictionary = {
		"event_id":    "DYNAMIC_PRESIDENT_DEATH",
		"event_type":  "standard",
		"country_cid": "USA",
		"headline":    "THE PRESIDENT IS DEAD",
		"short_desc":  "Continental War Office  ·  Emergency Communiqué  ·  Most Urgent",
		"long_desc":   (
			name + " is gone.\n\n"
			+ "The commanding officer of the " + army_name
			+ " — President of the United States, "
			+ "first among the Republic's defenders — has fallen in battle.\n\n"
			+ "There are no words adequate to this moment.\n\n"
			+ "God save what we have built.\n\n"
			+ "— Continental War Office"
		),
		"buttons": [
			{
				"button_id":         "acknowledge_president_death",
				"button_text":       "God save the Republic.",
				"button_type":       "standard",
				"outcome_type":      "none",
				"outcome_value":     "",
				"outcome_amount":    0,
				"next_event_id":     "",
				"prerequisite_flag": "",
			}
		],
	}
	_trigger_game_over(false, name + " has fallen in battle. The Republic has no President.", "funeral")
	_create_dynamic_event(data, tile)


func _handle_vp_death(commander, army_name: String, tile) -> void:
	var death_data: Dictionary = _build_vp_death_memo(commander, army_name, tile)
	var death_event = eventScene.instantiate()
	death_event.build_from_data(death_data, tile, playerCountryNode)
	# On dismiss → fire the funeral event
	death_event.eventButtonPressed.connect(
		func(_bid, _eid, _ec, _ot, _ov, _oa): _fire_vp_funeral(commander)
	)
	death_event.tileEventButtonPressed.connect(
		func(_bid, _eid, _ec, _ot, _ov, _oa, _t): _fire_vp_funeral(commander)
	)
	$CanvasLayer/EventControl/EventContainer.add_child(death_event)


func _fire_vp_funeral(old_vp) -> void:
	var funeral_data: Dictionary = _build_vp_funeral_data(old_vp)
	var funeral_event = eventScene.instantiate()
	funeral_event.build_from_data(funeral_data, null, playerCountryNode)
	# On dismiss → open VP succession picker
	funeral_event.eventButtonPressed.connect(
		func(_bid, _eid, _ec, _ot, _ov, _oa): _open_vp_picker()
	)
	$CanvasLayer/EventControl/EventContainer.add_child(funeral_event)


func _build_vp_death_memo(commander, army_name: String, tile) -> Dictionary:
	var name: String   = commander.governorType if commander.governorType != "" else "the Vice President"
	var level: int     = clampi(commander.governorLevel, 1, 3)
	var rank: String   = _COMMANDER_RANKS.get(level, "Captain")
	var tile_name: String = (" near " + tile.tileName) if (tile != null and tile.tileName != "") else " in the field"
	return {
		"event_id":    "DYNAMIC_VP_DEATH",
		"event_type":  "standard",
		"country_cid": "USA",
		"headline":    "THE VICE PRESIDENT HAS FALLEN — " + name.to_upper(),
		"short_desc":  "Continental War Office  ·  Official Casualty Record  ·  Urgent",
		"long_desc":   (
			"It is with the deepest grief that this office records the death of "
			+ name + ", Vice President of the United States and "
			+ rank + " of the " + army_name + tile_name + ".\n\n"
			+ "The Vice President gave their life in service to this Republic. "
			+ "They carried the burden of office into the field and did not retreat.\n\n"
			+ "The nation mourns. The office stands vacant.\n\n"
			+ "A state funeral will be arranged.\n\n"
			+ "— War Office, Continental Army"
		),
		"buttons": [
			{
				"button_id":         "acknowledge_vp_death",
				"button_text":       "The Republic mourns.",
				"button_type":       "standard",
				"outcome_type":      "none",
				"outcome_value":     "",
				"outcome_amount":    0,
				"next_event_id":     "",
				"prerequisite_flag": "",
			}
		],
	}


func _build_vp_funeral_data(old_vp) -> Dictionary:
	var name: String = old_vp.governorType if old_vp.governorType != "" else "the Vice President"
	return {
		"event_id":    "DYNAMIC_VP_FUNERAL",
		"event_type":  "standard",
		"country_cid": "USA",
		"headline":    "STATE FUNERAL — " + name.to_upper(),
		"short_desc":  "The nation pauses to honor its fallen Vice President.",
		"long_desc":   (
			"The body of " + name + " was carried through the capital in solemn procession.\n\n"
			+ "Citizens lined the road. Cannons fired a salute. "
			+ "The flag was lowered to half-staff across all Continental territories.\n\n"
			+ "The eulogy was short. The grief was not.\n\n"
			+ "The office of Vice President now stands open. "
			+ "The Republic requires a successor.\n\n"
			+ "— Continental Government, State Record"
		),
		"buttons": [
			{
				"button_id":         "appoint_new_vp",
				"button_text":       "Appoint the New Vice President.",
				"button_type":       "standard",
				"outcome_type":      "none",
				"outcome_value":     "",
				"outcome_amount":    0,
				"next_event_id":     "",
				"prerequisite_flag": "",
			}
		],
	}


func _open_vp_picker() -> void:
	# Remove any stale picker
	var existing = $CanvasLayer.get_node_or_null("VPPickerOverlay")
	if existing:
		existing.queue_free()
	var existing_panel = $CanvasLayer.get_node_or_null("VPPickerPanel")
	if existing_panel:
		existing_panel.queue_free()

	# Dark overlay behind the panel
	var overlay = ColorRect.new()
	overlay.name = "VPPickerOverlay"
	overlay.color = Color(0.0, 0.0, 0.0, 0.62)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	$CanvasLayer.add_child(overlay)

	# Centered panel container
	var panel = PanelContainer.new()
	panel.name = "VPPickerPanel"
	panel.anchor_left   = 0.25
	panel.anchor_top    = 0.08
	panel.anchor_right  = 0.75
	panel.anchor_bottom = 0.92
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical   = Control.GROW_DIRECTION_BOTH
	$CanvasLayer.add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	# Title
	var lbl_title = Label.new()
	lbl_title.text = "SELECT NEW VICE PRESIDENT"
	lbl_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(lbl_title)

	var lbl_sub = Label.new()
	lbl_sub.text = (
		"The office of Vice President stands vacant.\n"
		+ "Choose a governor to serve the Republic."
	)
	lbl_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#lbl_sub.autowrap_mode = TextServer.AUTOWRAP_WORD_ONLY
	vbox.add_child(lbl_sub)

	vbox.add_child(HSeparator.new())

	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 320)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	var list = VBoxContainer.new()
	list.add_theme_constant_override("separation", 6)
	scroll.add_child(list)

	# Populate eligible governors
	var eligible: int = 0
	for gov in playerCountryNode.unlockedGovernors:
		if gov.isLeader or gov.isVicePresident:
			continue
		var rank_str: String = _COMMANDER_RANKS.get(gov.governorLevel, "Officer")
		var btn = Button.new()
		btn.text = "%-28s  —  %s" % [gov.governorType, rank_str]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_on_vp_governor_selected.bind(gov, overlay, panel))
		list.add_child(btn)
		eligible += 1

	if eligible == 0:
		var lbl_none = Label.new()
		lbl_none.text = "No eligible governors available at this time."
		lbl_none.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		list.add_child(lbl_none)


func _on_vp_governor_selected(new_vp, overlay: ColorRect, panel: PanelContainer) -> void:
	# Clear old VP tag from all governors
	for gov in playerCountryNode.unlockedGovernors:
		if gov.isVicePresident:
			gov.isVicePresident = false

	# Appoint new VP and update world tracking vars
	new_vp.isVicePresident = true
	_vp_governor = new_vp
	_vp_faction  = VP_FACTION_MAP.get(new_vp.governorType, "")
		  #" | Faction: ", _vp_faction)
		 # " | Faction: ", _vp_faction)

	# Close picker UI
	overlay.queue_free()
	panel.queue_free()

	# Fire appointment announcement
	var rank_str: String = _COMMANDER_RANKS.get(new_vp.governorLevel, "Officer")
	var name: String = new_vp.governorType
	var announce_data: Dictionary = {
		"event_id":    "DYNAMIC_VP_APPOINTED",
		"event_type":  "standard",
		"country_cid": "USA",
		"headline":    "NEW VICE PRESIDENT — " + name.to_upper(),
		"short_desc":  "Continental Government  ·  Official Appointment Record",
		"long_desc":   (
			name + " has accepted the office of Vice President of the United States.\n\n"
			+ "They take the oath upon the graves of those who served before them.\n\n"
			+ "The Republic endures. The work continues.\n\n"
			+ "— Continental Government, Official Record"
		),
		"buttons": [
			{
				"button_id":         "acknowledge_vp_appointed",
				"button_text":       "Long live the Republic.",
				"button_type":       "standard",
				"outcome_type":      "none",
				"outcome_value":     "",
				"outcome_amount":    0,
				"next_event_id":     "",
				"prerequisite_flag": "",
			}
		],
	}
	_create_dynamic_event(announce_data)

func _build_commander_death_memo(commander, army_name: String, tile) -> Dictionary:
	var level: int     = commander.governorLevel if commander.governorLevel >= 1 else 1
	var rank: String   = _COMMANDER_RANKS.get(level, "Captain")
	var name: String   = commander.governorType if commander.governorType else "Unknown"
	var arc_id: String = commander.governorArchetypeId if commander.governorArchetypeId != "" else "ARC_01"
	var flavor: String = _ARCHETYPE_FLAVOR.get(arc_id,
		"A patriot who gave everything for the Republic.")

	var tile_name: String = ""
	if tile != null and tile.tileName != "":
		tile_name = " near " + tile.tileName
	else:
		tile_name = " in the field"

	var headline: String = "NOTICE OF CASUALTY — %s %s" % [rank.to_upper(), name.to_upper()]

	var short_desc: String = (
		"Continental War Office  ·  Official Field Record  ·  Urgent"
	)

	var long_desc: String = (
		"It is the unfortunate duty of this office to record the loss in action of "
		+ rank + " " + name + ", commanding officer of the " + army_name + tile_name + ".\n\n"
		+ flavor + "\n\n"
		+ "Their unit was overwhelmed and destroyed. "
		+ rank + " " + name + " fell with their men.\n\n"
		+ "The Republic does not forget its dead.\n\n"
		+ "— War Office, Continental Army"
	)

	return {
		"event_id":    "DYNAMIC_COMMANDER_DEATH",
		"event_type":  "standard",
		"country_cid": "USA",
		"headline":    headline,
		"short_desc":  short_desc,
		"long_desc":   long_desc,
		"buttons": [
			{
				"button_id":      "acknowledge",
				"button_text":    "The Republic endures.",
				"button_type":    "standard",
				"outcome_type":   "none",
				"outcome_value":  "",
				"outcome_amount": 0,
				"next_event_id":  "",
				"prerequisite_flag": "",
			}
		],
	}

func _create_dynamic_event(data: Dictionary, tile = null) -> void:
	var newEvent = eventScene.instantiate()
	newEvent.build_from_data(data, tile, playerCountryNode)
	newEvent.eventButtonPressed.connect(_on_event_button_pressed)
	newEvent.tileEventButtonPressed.connect(_on_tile_event_button_pressed)
	$CanvasLayer/EventControl/EventContainer.add_child(newEvent)


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


# ── Presidential Library hooks ────────────────────────────────────────────────

func _library_on_event_fired(event_id: String) -> void:
	if not get_node_or_null("/root/LibraryData"):
		return
	var event := EventDatabase.get_event(event_id)
	if event.is_empty():
		return

	# Gallery unlock — all players reach all scenes; no content gate
	var content_flag: String = event.get("content_flag", "").strip_edges()
	if content_flag != "" and content_flag != "false":
		LibraryData.unlock_gallery(event_id)

	# Journal entry — major Ualani or historical events
	# event_type values come directly from events.csv
	var event_type: String = event.get("event_type", "")
	const JOURNAL_TYPES := [
		"ualani_event",          # Ualani personal arc events
		"white_house_secret",    # White House holiday intimacy events
		"vp_event",              # VP relationship arc
		"protector_agree",       # USA protector agreements
		"ca_protector_agree",    # Canadian protector agreements
		"war_declaration",       # UK declares war
		"war_buildup",           # Pre-war intelligence
		"peace",                 # Peace treaties
		"election_season",       # Election campaigns
		"election_night_win",    # Ualani wins re-election
		"election_night_lose",   # Ualani loses
		"city_liberated",        # Major city liberated
		"city_lost",             # Major city lost to enemy
		"state_liberated",       # Full state liberated
		"collapse",              # Republic collapse event
		"secession",             # State secession
		"reintegration",         # State reintegration
		"commander_complete",    # Commander arc completion
	]
	if event_type in JOURNAL_TYPES:
		LibraryData.add_journal_entry(
			event_id,
			currentWorldTurn,
			event.get("headline", event_id),
			event.get("long_desc", event.get("short_desc", "")),
			_journal_classification(event_type)
		)

func _journal_classification(event_type: String) -> String:
	match event_type:
		"ualani_event":                          return "EYES ONLY"
		"white_house_secret":                    return "EYES ONLY"
		"vp_event":                              return "EYES ONLY"
		"protector_agree", "ca_protector_agree": return "TOP SECRET"
		"war_declaration", "war_buildup":        return "SECRET"
		"peace":                                 return "SECRET"
		"collapse", "secession":                 return "SECRET"
		"election_season", "election_night_win",\
		"election_night_lose":                   return "CONFIDENTIAL"
		"city_lost", "state_liberated",\
		"city_liberated", "reintegration":       return "CONFIDENTIAL"
		"commander_complete":                    return "DECLASSIFIED"
		_:                                       return "DECLASSIFIED"

func _spawn_anarchist_army(source_tile) -> void:
	# Find a UK-owned tile adjacent to the source tile, or any UK tile in the world.
	var uk_tile = null
	if source_tile != null:
		for neighbor in source_tile.TileNeighbors:
			if neighbor.tileOwner == "UK":
				uk_tile = neighbor
				break
	if uk_tile == null:
		for t in $TileController.get_children():
			if t.tileOwner == "UK":
				uk_tile = t
				break
	if uk_tile == null:
		push_warning("spawn_anarchist: no UK tile found")
		return

	# Build the anarchist army on the UK tile via the player country's addArmy machinery,
	# but as an independent rogue unit we manage ourselves.
	var armyInstance = load("res://Game Scenes and Scripts/army.tscn").instantiate()
	var anarch_gov = governor.new()
	anarch_gov.buildSelf("Anarchistic", 1)

	# TileNumber=0 so buildSelf skips the OwnedTileList search (UK tile won't be there)
	add_child(armyInstance)
	armyInstance.buildSelf("Anarchist Cell", playerCountryNode, 0, null)
	armyInstance.is_anarchist = true
	armyInstance.commander = anarch_gov
	armyInstance.armyMaxShield = 0
	armyInstance.armyShield = 0

	playerCountryNode.addNewUnit(armyInstance, "Infantry", 1, "Flintlock", "Iron", "Cloth", 150, 80)
	armyInstance.surveySelf()

	armyInstance.inTile = uk_tile
	uk_tile.addStationedArmy(armyInstance)
	armyInstance.armyDestroyed.connect(_on_anarchist_destroyed.bind(armyInstance))
	_anarchist_armies.append(armyInstance)
	armyInstance.updateArmyUI()
	print("[Anarchist] Cell spawned at ", uk_tile.tileName)

func _on_anarchist_destroyed(army: Army) -> void:
	_anarchist_armies.erase(army)

func _tick_anarchists() -> void:
	var to_remove: Array = []
	for army in _anarchist_armies:
		if not is_instance_valid(army):
			to_remove.append(army)
			continue
		if army.inTile == null:
			to_remove.append(army)
			continue
		# Try to attack an adjacent UK tile or fight whatever is in the current tile.
		var target: Tile = null
		for neighbor in army.inTile.TileNeighbors:
			if neighbor.tileOwner == "UK":
				target = neighbor
				break
		if target != null and target.stationedArmy != null:
			# Trigger a battle against the UK army
			var uk_army = target.stationedArmy
			var attacker_loss: int = randi_range(10, 40)
			var defender_loss: int = randi_range(30, 80)
			army.manpowerInArmy = maxi(army.manpowerInArmy - attacker_loss, 0)
			uk_army.manpowerInArmy = maxi(uk_army.manpowerInArmy - defender_loss, 0)
				#" — loses ", attacker_loss, ", UK loses ", defender_loss)
			#	" — loses ", attacker_loss, ", UK loses ", defender_loss)
			army.updateArmyUI()
			uk_army.updateArmyUI()
			if army.manpowerInArmy <= 0:
				to_remove.append(army)
				army.queue_free()
		elif army.inTile.tileOwner == "UK":
			# Already on UK soil — apply sabotage attrition
			var loss: int = randi_range(5, 20)
			army.manpowerInArmy = maxi(army.manpowerInArmy - loss, 0)
			army.updateArmyUI()
			if army.manpowerInArmy <= 0:
				to_remove.append(army)
				army.queue_free()
	for a in to_remove:
		_anarchist_armies.erase(a)

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


func _on_polis_mode_button_pressed() -> void:
	mapMode = "Polis"
	updateMap()

func _on_states_mode_button_pressed() -> void:
	mapMode = "MapStates"
	updateMap()

func _on_outputs_mode_button_pressed() -> void:
	mapMode = "MapOutputs"
	updateMap()

func _on_terrain_mode_button_pressed() -> void:
	mapMode = "Natural"
	updateMap()


func save_from_pause_menu() -> bool:
	# Persists country state + writes an autosave summary the main menu reads.
	# NOTE: full load-on-Continue is a separate task (load path not yet wired).
	saveCountryStatesToFile()
	var f := FileAccess.open("user://autosave.json", FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"turn": currentWorldTurn}))
		f.close()
		return true
	return false
