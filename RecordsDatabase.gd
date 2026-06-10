extends Node
## RecordsDatabase — static catalogue of all Civilopedia-style entries.
## Register in Project → AutoLoad as "RecordsDatabase".
##
## HOW TO ADD ENTRIES:
##   Append a dict to the matching category array below.
##   Required keys: id, name, description
##   Optional keys: icon_path, see_also (Array[String] of other entry ids)
##   For mystery entries add: is_mystery = true, mystery_hint = "..."
##                            unlock_flag = "PROT_01" or weapon id

# ── categories (display order) ────────────────────────────────────────────────
const CATEGORIES: Array[String] = [
	"Game Systems",
	"Terrain",
	"Resources & Ores",
	"Buildings",
	"Governor Archetypes",
	"Military Modifiers",
	"Laws & Edicts",
	"Technologies",
	"Factions",
	"Army Units",
	"Magic Schools & Spells",
	"Protectors",
	"Mythic Weapons",
	"Lore & History",
]

# ── entry registry ─────────────────────────────────────────────────────────────
# All entries keyed by id for fast lookup.
var entries: Dictionary = {}

func _ready() -> void:
	_register_all()

func get_entry(id: String) -> Dictionary:
	return entries.get(id, {})

func get_category_entries(category: String) -> Array:
	var result: Array = []
	for id in entries:
		if entries[id].get("category") == category:
			result.append(entries[id])
	result.sort_custom(func(a, b): return a["name"] < b["name"])
	return result

func is_visible(entry: Dictionary) -> bool:
	if not entry.get("is_mystery", false):
		return true
	return LibraryData.is_discovered(entry.get("unlock_flag", ""))

# ── registration helpers ───────────────────────────────────────────────────────
func _add(id: String, category: String, name: String, description: String,
		extra: Dictionary = {}) -> void:
	var e := {"id": id, "category": category, "name": name,
			  "description": description, "is_mystery": false}
	for key in extra:
		e[key] = extra[key]
	entries[id] = e

func _add_mystery(id: String, category: String, mystery_hint: String,
		unlock_flag: String, extra: Dictionary = {}) -> void:
	var e := {
		"id": id, "category": category,
		"name": "???", "description": mystery_hint,
		"is_mystery": true, "unlock_flag": unlock_flag,
	}
	for key in extra:
		e[key] = extra[key]
	entries[id] = e

# ── entries ───────────────────────────────────────────────────────────────────
func _register_all() -> void:

	# ── GAME SYSTEMS ──────────────────────────────────────────────────────────
	_add("sys_turns", "Game Systems", "Turns & Time",
		"Each turn represents a season. Four turns make a year. The game begins in 1782, Year One of the Carlisle Administration. Pressing End Turn advances time, triggers income, building output, army upkeep, event checks, and all AI actions.",
		{"icon_path": ""})

	_add("sys_census", "Game Systems", "Tile Census",
		"At the end of each turn, every tile you own runs a census. Each building on the tile reports its resource output — Food, Dollars, Wood, Metal, Magic, Culture, Weapons, Science, Mandate, Happiness, Manpower, Influence, and Boats. Governor bonuses are applied first. The Tile Info Panel shows the breakdown.",
		{"icon_path": ""})

	_add("sys_governors", "Game Systems", "Governors",
		"Governors are administrators assigned to individual tiles. Each governor has an archetype (FARMER, SCHOLAR, WARRIOR, etc.) that determines which buildings they enhance and which bonuses they provide. Governors have three levels. Leveling up a governor requires specific conditions depending on archetype. A governor can only manage one tile at a time.",
		{"icon_path": ""})

	_add("sys_corruption", "Game Systems", "Corruption",
		"Corruption erodes a tile's productivity and morale. It rises from enemy activity, neglect, and certain events. Above 25 it begins to affect output. Above 60 it becomes serious. At 100 the tile may revolt. Buildings that reduce corruption: Baths, Temples, Libraries.",
		{"icon_path": ""})

	_add("sys_colonization", "Game Systems", "Colonization",
		"Unclaimed tiles can be colonized by accumulating Colonization Points on them. The required points vary by terrain and distance. Once colonized, the tile joins your nation and can receive buildings and a governor. Naval tiles require a Dock presence.",
		{"icon_path": ""})

	_add("sys_factions", "Game Systems", "Factions",
		"Factions are political, military, or social groups with their own agendas. Each faction has a Loyalty score toward the player. High loyalty unlocks faction events and bonuses. Low loyalty causes crises, defections, and armed opposition. Factions are tracked in the Faction Panel.",
		{"icon_path": ""})

	_add("sys_spells", "Game Systems", "Magic & Spells",
		"Spells are unlocked through the Spellbook panel. Each spell belongs to a Magic School (Fire, Ice, Nature, Shadow, Light, Storm). Towers produce magic income. Wizards assigned to tiles amplify that tile's magical output and may cast defensive or offensive spells each turn.",
		{"icon_path": ""})

	_add("sys_autosave", "Game Systems", "Autosave",
		"The game saves automatically at the end of each turn to a single autosave slot. The frequency can be adjusted in Settings. The main menu 'Continue' button always loads the most recent autosave. There is no manual save system.",
		{"icon_path": ""})

	_add("sys_content", "Game Systems", "Content Flags",
		"The game contains optional adult content. Sensual, Explicit, and Kinky/Lewd content flags can be individually enabled or disabled in Settings. Content flagged events will not fire if their flag is disabled. Gallery entries are only unlocked when the corresponding event fires with the flag active.",
		{"icon_path": ""})

	# ── TERRAIN ───────────────────────────────────────────────────────────────
	_add("ter_jungle",     "Terrain", "Jungle",
		"Dense tropical growth. High food output from farms. Movement penalties for armies. Reduces corruption spread. Home to rare botanical ores.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1440.PNG"})

	_add("ter_steppe",     "Terrain", "Steppe",
		"Open grassland ideal for cavalry movement. Moderate food and manpower output. Vulnerable to storm damage.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1422.PNG"})

	_add("ter_bog",        "Terrain", "Bog",
		"Waterlogged ground. Slows all movement. Unique ore deposits. Penalties to building construction speed.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1424.PNG"})

	_add("ter_cold_coast", "Terrain", "Cold Coast",
		"Northern shoreline battered by Atlantic wind. Strong fishing and Boat production from Docks. Army movement unaffected near water.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1426.PNG"})

	_add("ter_drylands",   "Terrain", "Drylands",
		"Arid scrubland with scarce water. Low food output. High weapon and metal production due to mineral deposits. Corruption spreads faster here.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1425.PNG"})

	_add("ter_warm_coast", "Terrain", "Warm Coast",
		"Southern shoreline with fertile soil and warm waters. High food output. Docks produce double the normal Boat yield. Vulnerable to storm events.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1428.PNG"})

	_add("ter_floodplains","Terrain", "Floodplains",
		"River delta terrain. Exceptionally fertile — highest food output in the game. Vulnerable to seasonal flooding events.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1427.PNG"})

	_add("ter_desert",     "Terrain", "Desert",
		"Barren and hostile. Minimal food. Armies suffer attrition here. Unique mineral deposits available. Faith bonuses from Temples are doubled.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1434.PNG"})

	_add("ter_meadow",     "Terrain", "Meadow",
		"Gentle grassland. Balanced output across most resource types. Easy to colonize. Preferred terrain for initial expansion.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1436.PNG"})

	_add("ter_mountaintop","Terrain", "Mountaintop",
		"High peaks. Strong mine output for metal and weapons. Armies move slowly. Difficult to colonize. Defensive bonus for stationed armies.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1437.PNG"})

	_add("ter_mountaintop_cold","Terrain","Frozen Mountaintop",
		"Snow-covered peaks. All mountaintop properties apply, amplified. Higher defensive bonus. Army attrition risk in winter turns.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1439.PNG"})

	_add("ter_hills",      "Terrain", "Hills",
		"Rolling terrain with moderate defensive value. Good for mines and camps. Balanced movement penalty.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1438.PNG"})

	_add("ter_forest",     "Terrain", "Forest",
		"Dense woodland. High Wood output. Army movement penalty. Reduces enemy cavalry effectiveness. Source of herbal and magical ores.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1441.PNG"})

	_add("ter_taiga",      "Terrain", "Taiga",
		"Northern boreal forest. High Wood output. Harsh winter penalties apply here before other terrain types. Unique ores unavailable elsewhere.",
		{"icon_path": "res://art assets/Placeholder Art/UI Art/terrain/IMG_1442.PNG"})

	# ── RESOURCES & ORES ──────────────────────────────────────────────────────
	_add("res_food",      "Resources & Ores", "Food",
		"Feeds the population and sustains armies in the field. Produced by Farms, Granaries, and coastal fishing. Shortfalls cause happiness penalties and army attrition.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/fooda.png"})

	_add("res_dollars",   "Resources & Ores", "Dollars",
		"The lifeblood of the republic. Pays for buildings, armies, and political favors. Produced by Markets, Faires, and trade routes. A negative balance triggers economic crisis events.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/currency.png"})

	_add("res_wood",      "Resources & Ores", "Wood",
		"Essential for construction and naval production. Produced by Camps, Docks, and forest terrain bonuses.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/wood.png"})

	_add("res_metal",     "Resources & Ores", "Metal",
		"Required for Weapons, advanced buildings, and certain tech upgrades. Produced primarily by Mines.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/metal.png"})

	_add("res_weapons",   "Resources & Ores", "Weapons",
		"Equips your armies and funds your war effort. Produced by Forges and Arsenals. Army upkeep consumes Weapons each turn.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/Weapons.png"})

	_add("res_science",   "Resources & Ores", "Science",
		"Powers the research of new Technologies. Produced by Libraries and Schools. Accumulated science is spent on techs in the Tech Tree panel.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/science2.png"})

	_add("res_magic",     "Resources & Ores", "Magic",
		"Fuel for spells and arcane infrastructure. Produced by Towers, Wizards, and certain protectors. Required to cast spells in battle and to maintain magical buildings.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/Magic.png"})

	_add("res_faith",     "Resources & Ores", "Faith",
		"Spiritual capital of the nation. Produced by Temples and Monasteries. Unlocks religious laws and certain diplomatic options with faith-based factions.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/faith.png"})

	_add("res_culture",   "Resources & Ores", "Culture",
		"Represents the artistic and intellectual vitality of the republic. Produced by Theaters, Baths, and cultural buildings. Required for Tradition unlocks.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/Culture.png"})

	_add("res_mandate",   "Resources & Ores", "Mandate",
		"The political authority of the presidency. High Mandate unlocks stronger edicts and expands law options. Produced by government buildings and compliance events.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/Mandate.png"})

	_add("res_happiness", "Resources & Ores", "Happiness",
		"National morale. Affects approval rating, faction loyalty, and productivity. Falls under corruption, war exhaustion, and resource shortfalls.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/Harmony.png"})

	_add("res_manpower",  "Resources & Ores", "Manpower",
		"The pool from which armies are drawn. Produced by Barracks and population-dense tiles. Consumed when armies are recruited or suffer heavy losses.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/manpower.png"})

	_add("res_influence", "Resources & Ores", "Influence",
		"Diplomatic capital. Used to sway factions, broker alliances, and suppress opposition. Produced by Forts, Embassies, and named governor bonuses.",
		{"icon_path": "res://art assets/finishedAssets/manaicons/Influence 1.png"})

	_add("res_boats",     "Resources & Ores", "Boats",
		"Naval capacity. Produced by Docks. Required to move armies across water tiles and to maintain a navy.",
		{"icon_path": ""})  # placeholder — see MAN-001 editor task

	# ── BUILDINGS ─────────────────────────────────────────────────────────────
	_add("bld_farm",      "Buildings", "Farm",
		"The backbone of agricultural production. Generates Food and small amounts of Wood. FARMER archetype governors dramatically increase output. Required for certain FARMER governors to be assignable.",
		{"icon_path": ""})

	_add("bld_mine",      "Buildings", "Mine",
		"Extracts Metal from the earth. Output scales with terrain — Mountains and Hills provide the highest yields. Required for ENGINEER and SCOUT governor assignments.",
		{"icon_path": ""})

	_add("bld_barracks",  "Buildings", "Barracks",
		"Trains and houses soldiers. Produces Manpower each turn. Stationed armies receive a combat bonus when fighting from a tile with a Barracks. Required for WARRIOR and SOLDIER governor assignments.",
		{"icon_path": ""})

	_add("bld_market",    "Buildings", "Market",
		"Generates Dollars through trade. DIPLOMAT and ORATOR governors amplify currency output. Higher-level markets reduce corruption spread.",
		{"icon_path": ""})

	_add("bld_library",   "Buildings", "Library",
		"Produces Science and small amounts of Culture. Required for SCHOLAR governor assignment. Level 3 Libraries also produce Influence.",
		{"icon_path": ""})

	_add("bld_tower",     "Buildings", "Tower",
		"Produces Magic each turn and provides a platform for Wizards. A Wizard assigned to a tower tile casts spells each turn. Protectors who join the republic are bound to a Tower at their home tile.",
		{"icon_path": ""})

	_add("bld_granary",   "Buildings", "Granary",
		"Stores and distributes food surplus. Reduces the penalty of food shortfalls. With the Mandate from Granaries law active, also produces Mandate.",
		{"icon_path": ""})

	_add("bld_forge",     "Buildings", "Forge",
		"Produces Weapons from Metal. Required for WARRIOR governor assignment. Level 2+ Forges also produce a small amount of Science.",
		{"icon_path": ""})

	_add("bld_temple",    "Buildings", "Temple",
		"Produces Faith and Happiness. Reduces corruption. HEALER archetype governors amplify temple output. Required for religious law access.",
		{"icon_path": ""})

	_add("bld_bath",      "Buildings", "Bath",
		"Generates Happiness and reduces corruption. Level 2+ Baths also produce Culture. Required for certain HEALER governor assignments.",
		{"icon_path": ""})

	_add("bld_theater",   "Buildings", "Theater",
		"Cultural hub producing Culture and Happiness. ORATOR governors thrive here. Level 3 Theaters produce Influence.",
		{"icon_path": ""})

	_add("bld_dock",      "Buildings", "Dock",
		"Naval infrastructure on coastal tiles. Produces Boats and Wood. Required for colonizing across water. ADMIRAL archetype governors dramatically amplify output.",
		{"icon_path": ""})

	_add("bld_camp",      "Buildings", "Camp",
		"Frontier outpost. Produces Wood, Manpower, and Weapons. SCOUT governors thrive in Camps.",
		{"icon_path": ""})

	_add("bld_monument",  "Buildings", "Monument",
		"A landmark of national identity. Produces Culture, Mandate, and Happiness. Required for high-level HERALD governor assignment.",
		{"icon_path": ""})

	# ── GOVERNOR ARCHETYPES ───────────────────────────────────────────────────
	_add("arc_farmer",    "Governor Archetypes", "FARMER",
		"Masters of the land. FARMER governors dramatically boost Farm and Granary output at all three levels. Level 3 FARMER governors unlock crop rotation events and reduce food spoilage across the tile.",
		{"icon_path": ""})

	_add("arc_scout",     "Governor Archetypes", "SCOUT",
		"Explorers and frontier agents. Boost Camp and Mine output. Level 2 SCOUT governors reduce colonization costs on adjacent tiles. Level 3 expand tile visibility.",
		{"icon_path": ""})

	_add("arc_warrior",   "Governor Archetypes", "WARRIOR",
		"Combat-focused administrators. Boost Barracks and Forge output and grant a tile defense bonus. Level 3 WARRIOR governors add a standing combat modifier to any army stationed on their tile.",
		{"icon_path": ""})

	_add("arc_scholar",   "Governor Archetypes", "SCHOLAR",
		"Intellectuals and researchers. Boost Library output and generate bonus Science each turn. Level 3 SCHOLAR governors occasionally unlock free Technology events.",
		{"icon_path": ""})

	_add("arc_engineer",  "Governor Archetypes", "ENGINEER",
		"Builders and infrastructure experts. Reduce building construction cost and boost Mine and Dock output. Level 3 ENGINEER governors allow a single free building upgrade per year.",
		{"icon_path": ""})

	_add("arc_diplomat",  "Governor Archetypes", "DIPLOMAT",
		"Political operators. Boost Market and Monument output. Generate Influence passively. Level 3 DIPLOMAT governors add a loyalty buffer to the tile's dominant faction.",
		{"icon_path": ""})

	_add("arc_orator",    "Governor Archetypes", "ORATOR",
		"Speakers and agitators. Boost Theater and Market output. Generate Culture and Happiness. Level 3 ORATOR governors trigger popular approval events.",
		{"icon_path": ""})

	_add("arc_healer",    "Governor Archetypes", "HEALER",
		"Physicians and spiritual leaders. Boost Temple and Bath output. Reduce corruption. Level 3 HEALER governors provide army recovery bonuses when stationed on their tile.",
		{"icon_path": ""})

	_add("arc_spy",       "Governor Archetypes", "SPYMASTER",
		"Intelligence operatives. Generate Influence and reduce enemy spy effectiveness on the tile. Level 3 SPYMASTER governors can intercept enemy events.",
		{"icon_path": ""})

	_add("arc_admiral",   "Governor Archetypes", "ADMIRAL",
		"Naval commanders in civilian governance. Dramatically boost Dock output. Level 3 ADMIRAL governors double Boat production and reduce naval upkeep.",
		{"icon_path": ""})

	_add("arc_mage",      "Governor Archetypes", "MAGE",
		"Arcane administrators. Boost Tower output and Magic generation. Level 3 MAGE governors learn a spell that fires once per year on their tile.",
		{"icon_path": ""})

	_add("arc_soldier",   "Governor Archetypes", "SOLDIER",
		"Veteran fighters in peacetime roles. Boost Barracks and Camp output. Reduce army upkeep on the tile. Level 3 SOLDIER governors grant a morale bonus to stationed armies.",
		{"icon_path": ""})

	_add("arc_bureaucrat","Governor Archetypes", "BUREAUCRAT",
		"Administrative specialists. Boost Mandate and Influence generation. Reduce corruption. Level 3 BUREAUCRAT governors reduce the cost of laws and edicts.",
		{"icon_path": ""})

	_add("arc_herald",    "Governor Archetypes", "HERALD",
		"Messengers and public figures. Boost Monument and Theater output. Generate Happiness and Culture across multiple tiles. Level 3 HERALD governors trigger national morale events.",
		{"icon_path": ""})

	_add("arc_preacher",  "Governor Archetypes", "CIRCUIT PREACHER",
		"Traveling ministers of faith. Boost Temple output significantly. Generate Faith across the region. Level 3 CIRCUIT PREACHER governors can suppress faction unrest through religious revival events.",
		{"icon_path": ""})

	# ── MILITARY MODIFIERS ──────────────────────────────────────────────────

	# Country Modifiers

	_add("milmod_berserkers", "Military Modifiers", "Berserkers",
		"Warriors are expected to kill or die trying. +3 Attack per level, -2 Harmony per level.")

	# Weapon Ore Modifiers

	_add("milmod_club_bleed", "Military Modifiers", "ClubBleed",
		"Club weapon mod. +2 Attack, +1 Defense per level. -1 Weapons per level.")

	_add("milmod_atlatl_pierce", "Military Modifiers", "AtlatlPierce",
		"Atlatl weapon mod. +1 Attack, +2 Defense per level. -1 Weapons per level.")

	_add("milmod_ore_wood", "Military Modifiers", "Wood Weapons",
		"Unit's weapons carved from wood. +1 Attack per level. -1 Wood per level.")

	_add("milmod_ore_copper", "Military Modifiers", "Copper Weapons",
		"Unit's weapons shaped by copper. +2 Attack per level. -1 Metal per level.")

	_add("milmod_ore_iron", "Military Modifiers", "Iron Weapons",
		"Unit's weapons forged from iron. +3 Attack per level. -3 Metal per level.")

	_add("milmod_ore_gold", "Military Modifiers", "Gold Weapons",
		"Unit's weapons built of gold. +2 Attack per level. -1 Metal, -3 Dollars per level.")

	_add("milmod_ore_floodstone", "Military Modifiers", "Floodstone Weapons",
		"Unit's weapons birthed from floodstone. +3 Attack per level. -2 Metal, -2 Magic per level.")

	# Commander Modifiers

	_add("milmod_visionary", "Military Modifiers", "Visionary",
		"Commander mod. This unit's commander is a genius. +3 Attack per level, +10% movement speed.",
		{"see_also": ["arc_spy"]})

	_add("milmod_champion_sun", "Military Modifiers", "Champion of the Sun",
		"Commander mod. While the sun is up, this unit will march. +1 Attack per level, +10% movement speed.")

	_add("milmod_healer", "Military Modifiers", "Healer",
		"Commander mod. This unit heals exceptionally fast. +10 reinforce rate.",
		{"see_also": ["arc_healer", "bld_temple", "bld_bath"]})

	# Civilian Modifiers

	_add("milmod_translator", "Military Modifiers", "Translator",
		"Civilian mod. Unit equipped with reference materials enabling translation of ancient writings. Generates Science.",
		{"see_also": ["arc_scholar", "bld_library"]})

	_add("milmod_seeder", "Military Modifiers", "Seeder",
		"Civilian mod. Unit carries seeds enabling agricultural improvements on the tile. Generates Food.",
		{"see_also": ["arc_farmer", "bld_farm"]})

	# Tool Modifiers

	_add("milmod_wooden_tools", "Military Modifiers", "Wooden Tools",
		"Civilian mod. Unit carries basic wooden tools.")

	_add("milmod_metal_tools", "Military Modifiers", "Metal Tools",
		"Civilian mod. Unit carries metal tools.")

	_add("milmod_steel_tools", "Military Modifiers", "Steel Tools",
		"Civilian mod. Unit carries advanced steel tools.")

	_add("milmod_constructor", "Military Modifiers", "Constructor",
		"Civilian mod. Unit can build and upgrade structures faster.",
		{"see_also": ["arc_engineer"]})

	_add("milmod_adventurer", "Military Modifiers", "Adventurer",
		"Civilian mod. Unit trained in exploring ruins, caves, and frontier territories.")

	_add("milmod_scholar", "Military Modifiers", "Scholar",
		"Civilian mod. Unit spreads literacy and builds library infrastructure.",
		{"see_also": ["arc_scholar", "bld_library"]})

	_add("milmod_entertainer", "Military Modifiers", "Entertainer",
		"Civilian mod. Unit can entertain, soothe, and manage morale in its care.",
		{"see_also": ["arc_diplomat", "arc_orator", "bld_theater"]})

	_add("milmod_harvester", "Military Modifiers", "Harvester",
		"Civilian mod. Unit manages crops, woodcutting, and rural land.",
		{"see_also": ["arc_farmer", "bld_farm", "bld_camp"]})

	_add("milmod_prospector", "Military Modifiers", "Prospector",
		"Civilian mod. Unit trained in prospecting; can build mines and discover mineral deposits.",
		{"see_also": ["arc_scout", "bld_mine"]})

	_add("milmod_druid", "Military Modifiers", "Druid",
		"Civilian mod. Trained in druidic arts; can clear corruption and commune with nature.",
		{"see_also": ["arc_mage", "bld_tower"]})

	_add("milmod_chain", "Military Modifiers", "Chain Armor",
		"Unit wears chain armor. +5% Melee, +40% Ranged, +5% Spell damage block.")

	_add("milmod_shell", "Military Modifiers", "Shell Armor",
		"Unit wears a fully-enclosed shell. +50% Spell damage block.")

	# Tier 1 Modifiers

	_add("milmod_woodsman", "Military Modifiers", "Woodsman",
		"Trained in forest fighting. +2 Attack, +2 Defense per level in Woods terrain.",
		{"see_also": ["arc_scout", "ter_forest", "ter_taiga"]})

	_add("milmod_swamp_legs", "Military Modifiers", "Swamp Legs",
		"At home in the marshes. +2 Attack, +2 Defense per level in Wetlands terrain.",
		{"see_also": ["ter_bog", "milmod_everglades_tracker", "milmod_bayou_warrior"]})

	_add("milmod_hill_runner", "Military Modifiers", "Hill Runner",
		"Born on high ground. +2 Attack, +2 Defense per level in Foothills terrain.",
		{"see_also": ["ter_hills", "ter_mountaintop", "milmod_frontier_marksman"]})

	_add("milmod_street_tough", "Military Modifiers", "Street Tough",
		"Raised fighting in alleyways. +2 Attack per level in Metro or Suburbs terrain.")

	_add("milmod_farmhand", "Military Modifiers", "Farmhand",
		"Knows every row of every field. +1 Attack per level in Farmlands terrain.",
		{"see_also": ["arc_farmer"]})

	_add("milmod_saber_drill", "Military Modifiers", "Saber Drill",
		"Relentless close-combat drilling. +3 Attack per level.",
		{"see_also": ["arc_warrior"]})

	_add("milmod_marksman", "Military Modifiers", "Marksman",
		"Trained to shoot straight and true. +2 Ranged Attack per level.",
		{"see_also": ["arc_scout", "milmod_sharpshooter"]})

	_add("milmod_steady_line", "Military Modifiers", "Steady Line",
		"Hold the line at all costs. +3 Defense per level.",
		{"see_also": ["arc_soldier", "milmod_continental_line"]})

	_add("milmod_quick_reload", "Military Modifiers", "Quick Reload",
		"Powder and ball faster than any rival. Reload reduced by 1 round.",
		{"see_also": ["arc_scout"]})

	_add("milmod_powder_shot", "Military Modifiers", "Powder & Shot",
		"The cannons never run dry. +3 Siege Attack per level.",
		{"see_also": ["milmod_double_shot"]})

	_add("milmod_fortified_position", "Military Modifiers", "Fortified Position",
		"Commander mod. All units +3 Defense per level in tiles with Barracks or Fortress.",
		{"see_also": ["arc_soldier", "bld_barracks"]})

	_add("milmod_coastal_watch", "Military Modifiers", "Coastal Watch",
		"Commander mod. All units +2 Defense per level when adjacent to naval tiles.",
		{"see_also": ["arc_admiral", "bld_dock", "ter_cold_coast", "ter_warm_coast"]})

	# Tier 2 Modifiers

	_add("milmod_marine", "Military Modifiers", "Marine",
		"Commander mod. Army may launch melee attacks into adjacent naval tile neighbors.",
		{"see_also": ["arc_admiral", "bld_dock", "milmod_naval_supremacy"]})

	_add("milmod_guerrilla", "Military Modifiers", "Guerrilla Tactics",
		"+4 Attack, +4 Defense per level in Woods or Wetlands terrain.",
		{"see_also": ["arc_scout", "ter_forest", "ter_bog", "milmod_woodsman"]})

	_add("milmod_double_shot", "Military Modifiers", "Double Shot",
		"Siege fires twice per round — second shot at 50% power.",
		{"see_also": ["milmod_powder_shot", "milmod_double_cannonade"]})

	_add("milmod_iron_bayonet", "Military Modifiers", "Iron Bayonet",
		"+5 Attack per level in first battle round.",
		{"see_also": ["arc_warrior"]})

	_add("milmod_sharpshooter", "Military Modifiers", "Sharpshooter",
		"Ranged attacks ignore 2 enemy Defense per level.",
		{"see_also": ["arc_scout", "milmod_marksman"]})

	_add("milmod_corrupted_ground", "Military Modifiers", "Corrupted Ground",
		"Commander mod. Army presence reduces tile corruption by 1 per turn.",
		{"see_also": ["arc_diplomat", "bld_bath", "bld_temple"]})

	_add("milmod_rallying_voice", "Military Modifiers", "Rallying Voice",
		"Commander mod. Morale loss reduced; rout threshold lowered to 15%.",
		{"see_also": ["arc_diplomat"]})

	_add("milmod_night_raider", "Military Modifiers", "Night Raider",
		"Commander mod. Army may move and attack in the same turn without penalty.",
		{"see_also": ["arc_spy"]})

	_add("milmod_flanking_drill", "Military Modifiers", "Flanking Drill",
		"+3 Attack per level when fighting in a contested tile.",
		{"see_also": ["arc_warrior"]})

	_add("milmod_vanguard", "Military Modifiers", "Vanguard",
		"Commander mod. All units +4 Attack per level on first engagement in a fresh tile.")

	_add("milmod_siege_line", "Military Modifiers", "Siege Line",
		"Siege attacks against fortified tiles suffer no defensive penalty.",
		{"see_also": ["bld_barracks"]})

	_add("milmod_cleaner", "Military Modifiers", "Cleaner",
		"Commander mod. Army presence reduces tile moral decay by 1 per turn.",
		{"see_also": ["arc_diplomat", "bld_bath"]})

	# Tier 3 Modifiers

	_add("milmod_entrenched", "Military Modifiers", "Entrenched",
		"Commander mod. After 3 stationary turns, all units gain +5 Defense per level. Lost on movement.",
		{"see_also": ["bld_barracks"]})

	_add("milmod_continental_line", "Military Modifiers", "Continental Line",
		"Commander mod. All units +2 Attack, +2 Defense per level permanently.",
		{"see_also": ["lore_first_war"]})

	_add("milmod_last_stand", "Military Modifiers", "Last Stand",
		"Units below 25% manpower gain +6 Attack per level.")

	_add("milmod_terror", "Military Modifiers", "Terror",
		"Commander mod. Enemy loses 10 Morale at start of each battle round.")

	_add("milmod_iron_wall", "Military Modifiers", "Iron Wall",
		"Commander mod. +8 Defense per level when defending the commander's home tile.",
		{"see_also": ["arc_soldier"]})

	_add("milmod_rampart", "Military Modifiers", "Rampart",
		"Commander mod. +5 Defense per level in any Fortress tile.",
		{"see_also": ["bld_barracks"]})

	_add("milmod_naval_supremacy", "Military Modifiers", "Naval Supremacy",
		"Commander mod. Marine melee attacks deal +5 additional damage per level.",
		{"see_also": ["arc_admiral", "milmod_marine"]})

	_add("milmod_ghost_march", "Military Modifiers", "Ghost March",
		"Commander mod. Army ignores enemy zone of control.",
		{"see_also": ["arc_spy", "arc_admiral"]})

	_add("milmod_undaunted", "Military Modifiers", "Undaunted",
		"Commander mod. Ignore the first retreat check each battle.")

	_add("milmod_double_cannonade", "Military Modifiers", "Double Cannonade",
		"Siege fires twice per round AND +3 Attack on all shots.",
		{"see_also": ["milmod_double_shot"]})

	_add("milmod_liberators_will", "Military Modifiers", "Liberator's Will",
		"Commander mod. After liberating a tile, +15% manpower and commander gains +2 Loyalty.",
		{"see_also": ["arc_diplomat"]})

	_add("milmod_long_march", "Military Modifiers", "The Long March",
		"Commander mod. +2 Movement Points; full movement may be used before attacking.")

	_add("milmod_bat_sweep", "Military Modifiers", "BatSweep",
		"Baseball Bat mythic mod. +10% attack; first hit ignores shields.")

	_add("milmod_trident_pierce", "Military Modifiers", "TridentPierce",
		"Trident mythic mod. Pierces shields; +3 attack per level near naval tiles.",
		{"see_also": ["bld_dock"]})

	# Mythic Weapon Modifiers

	_add("milmod_mythic_atlatl", "Military Modifiers", "MythicAtlatl",
		"Mythic Atlatl mod. +2 ranged per level; critical hits stun target 1 turn.")

	_add("milmod_sharp_shot", "Military Modifiers", "SharpShot",
		"Sharps Carbine mythic mod. Ignores 4 enemy defense per level; terrain cover ignored.")

	_add("milmod_pirate_volley", "Military Modifiers", "PirateVolley",
		"Blackbeard's Pistols mythic mod. Fires twice per ranged round; +5 enemy morale terror.")

	_add("milmod_cylinder_fire", "Military Modifiers", "CylinderFire",
		"Colt Revolver mythic mod. No reload for first 3 shots; 2-turn reload thereafter.")

	_add("milmod_rocket_barrage", "Military Modifiers", "RocketBarrage",
		"Rocket Artillery mythic mod. Massive area damage; leaves fire modifier on tile for 2 turns.")

	_add("milmod_trebuchet_launch", "Military Modifiers", "TrebuchetLaunch",
		"Trebuchet mythic mod. +50% siege damage vs Fortress tiles; stuns defenders 1 round.")

	_add("milmod_aerial_bombing", "Military Modifiers", "AerialBombing",
		"Wright Flyer mythic mod. Ignores all ground defensive bonuses; terrifies enemy.")

	_add("milmod_quick_draw", "Military Modifiers", "QuickDraw",
		"Tombstone Cap uniform mod. First ranged attack each battle deals +5 bonus damage.")

	_add("milmod_hardee_disc", "Military Modifiers", "HardeeDisc",
		"Hardee Hat uniform mod. +3 defense per level when an adjacent friendly unit is present.")

	# Storm / Weather Modifiers

	_add("milmod_fog_born", "Military Modifiers", "Fog-Born",
		"Commander mod. +5 attack per level in Fog storm tiles.")

	# Storm Counter Modifiers

	_add("milmod_storm_rider", "Military Modifiers", "Storm Rider",
		"Commander mod. Movement not reduced by any active storm.")

	_add("milmod_thunder_proof", "Military Modifiers", "Thunder Proof",
		"Commander mod. Immune to Thunderstorm morale penalty.")

	_add("milmod_blizzard_march", "Military Modifiers", "Blizzard March",
		"Commander mod. No movement or supply penalty in Blizzard tiles. Valley Forge was just training.",
		{"see_also": ["ter_mountaintop_cold"]})

	_add("milmod_hurricane_eyes", "Military Modifiers", "Hurricane Eyes",
		"Commander mod. +5 attack per level in Hurricane storm tiles.",
		{"see_also": ["ter_warm_coast"]})

	_add("milmod_tornado_dancer", "Military Modifiers", "Tornado Dancer",
		"Commander mod. Army ignores Tornado scatter and manpower drain effects.")

	_add("milmod_norester_veteran", "Military Modifiers", "Nor'easter Veteran",
		"Commander mod. +3 defense per level in Nor'easter tiles.",
		{"see_also": ["ter_cold_coast"]})

	_add("milmod_rain_reader", "Military Modifiers", "Rain Reader",
		"Ranged mod. +3 ranged attack per level during Thunderstorm.")

	_add("milmod_white_out_walker", "Military Modifiers", "White Out Walker",
		"Infantry mod. +3 attack per level during Blizzard.",
		{"see_also": ["ter_mountaintop_cold"]})

	_add("milmod_storm_chaser", "Military Modifiers", "Storm Chaser",
		"Commander mod. +1 movement point in any active storm tile.")

	_add("milmod_lightning_rod", "Military Modifiers", "Lightning Rod",
		"Siege mod. Artillery units ignore storm ranged accuracy penalty.")

	_add("milmod_eye_of_storm", "Military Modifiers", "Eye of the Storm",
		"Commander mod. +4 attack, +4 defense per level while any storm is active in tile.")

	# Cultural / State-Specific Modifiers

	_add("milmod_country_musician", "Military Modifiers", "Country Musician",
		"Tennessee cultural mod. +3 morale; +2 attack per level in Farmlands.")

	_add("milmod_virginia_gentry", "Military Modifiers", "Virginia Gentry",
		"Virginia cultural mod. +3 ranged defense per level.")

	_add("milmod_minutemans_pride", "Military Modifiers", "Minuteman's Pride",
		"Massachusetts cultural mod. +5 attack per level in the first 3 battle rounds.",
		{"see_also": ["lore_first_war"]})

	_add("milmod_quaker_steel", "Military Modifiers", "Quaker Steel",
		"Pennsylvania cultural mod. +2 defense per level, -1 attack per level.")

	_add("milmod_georgia_peach", "Military Modifiers", "Georgia Peach",
		"Georgia cultural mod. +3 food efficiency; +1 ranged per level.",
		{"see_also": ["bld_farm"]})

	_add("milmod_backcountry_rider", "Military Modifiers", "Backcountry Rider",
		"South Carolina cultural mod. +4 attack per level in Woods terrain.",
		{"see_also": ["ter_forest"]})

	_add("milmod_harbor_watch", "Military Modifiers", "Harbor Watch",
		"New York cultural/marine mod. +3 attack per level near naval tiles.",
		{"see_also": ["bld_dock"]})

	_add("milmod_chesapeake_sailor", "Military Modifiers", "Chesapeake Sailor",
		"Maryland cultural/marine mod. +2 melee per level; Marine melee attack enabled.",
		{"see_also": ["bld_dock"]})

	_add("milmod_frontier_marksman", "Military Modifiers", "Frontier Marksman",
		"Kentucky cultural mod. +4 ranged per level in Foothills terrain.",
		{"see_also": ["ter_hills"]})

	_add("milmod_river_runner", "Military Modifiers", "River Runner",
		"Ohio cultural mod. +2 movement points; +2 attack per level near water tiles.",
		{"see_also": ["ter_floodplains"]})

	_add("milmod_everglades_tracker", "Military Modifiers", "Everglades Tracker",
		"Florida cultural mod. +4 attack and defense per level in Wetlands.",
		{"see_also": ["ter_bog"]})

	_add("milmod_bayou_warrior", "Military Modifiers", "Bayou Warrior",
		"Louisiana cultural mod. +5 attack per level in Wetlands terrain.",
		{"see_also": ["ter_bog"]})

	_add("milmod_cartographer", "Military Modifiers", "Cartographer",
		"Civilian tool mod. Maps explored tiles, revealing terrain bonuses and hidden resources.",
		{"see_also": ["arc_scout"]})

	_add("milmod_herbalist", "Military Modifiers", "Herbalist",
		"Civilian tool mod. Gathers medicinal herbs, healing +5 manpower per turn in the tile.",
		{"see_also": ["arc_healer", "bld_temple"]})

	_add("milmod_engineer_tool", "Military Modifiers", "Engineer",
		"Civilian tool mod. Builds roads and improves structures faster than standard workers.",
		{"see_also": ["arc_engineer", "bld_camp"]})

	_add("milmod_blacksmith", "Military Modifiers", "Blacksmith",
		"Civilian tool mod. Reduces weapon upkeep costs by 1 per level per turn for stationed armies.",
		{"see_also": ["arc_engineer", "bld_forge"]})

	_add("milmod_physician", "Military Modifiers", "Physician",
		"Civilian tool mod. Provides advanced medical care, restoring +10 manpower per turn.",
		{"see_also": ["arc_healer", "bld_bath"]})

	_add("milmod_merchant", "Military Modifiers", "Merchant",
		"Civilian tool mod. Conducts trade, generating +3 Dollars per turn.",
		{"see_also": ["arc_diplomat", "bld_market"]})

	_add("milmod_preacher", "Military Modifiers", "Preacher",
		"Civilian tool mod. Delivers sermons raising tile governor loyalty by +5 per turn.",
		{"see_also": ["arc_preacher", "bld_temple"]})

	_add("milmod_architect", "Military Modifiers", "Architect",
		"Civilian tool mod. Designs buildings more efficiently, reducing construction costs by 15%.",
		{"see_also": ["arc_engineer"]})

	_add("milmod_hunter", "Military Modifiers", "Hunter",
		"Civilian tool mod. Hunts game in surrounding wilderness, generating +5 Food per turn.",
		{"see_also": ["arc_scout", "ter_forest"]})

	_add("milmod_fisherman", "Military Modifiers", "Fisherman",
		"Civilian tool mod. Fishes from rivers or coastlines, generating +3 Food per turn near water tiles.",
		{"see_also": ["arc_admiral", "ter_cold_coast", "ter_warm_coast"]})

	_add("milmod_surveyor", "Military Modifiers", "Surveyor",
		"Civilian tool mod. Surveys the land, revealing terrain bonuses of all adjacent tiles.",
		{"see_also": ["arc_scout", "arc_engineer"]})

	_add("milmod_trapper", "Military Modifiers", "Trapper",
		"Civilian tool mod. Sets trap lines through wilderness, generating +2 Food and +1 trade per turn.",
		{"see_also": ["arc_scout", "ter_forest", "ter_taiga"]})

	_add("milmod_park_ranger", "Military Modifiers", "Park Ranger",
		"Civilian tool mod. Army is immune to corruption-based disease.",
		{"see_also": ["arc_scout", "ter_forest"]})

	# Presidential Modifiers

	_add("milmod_president", "Military Modifiers", "President",
		"Commander mod. The Republic moves when she moves. +3 movement points per turn.")

	_add("milmod_election_season", "Military Modifiers", "Election Season",
		"Commander mod. History is watching. Keep up. +3 movement points per turn, for the rest of the game.")

	# State Guard Modifiers

	_add("milmod_pa_guard", "Military Modifiers", "Pennsylvania Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Pennsylvania tiles.")

	_add("milmod_va_guard", "Military Modifiers", "Virginia Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Virginia tiles.")

	_add("milmod_ny_guard", "Military Modifiers", "New York Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in New York tiles.")

	_add("milmod_ma_guard", "Military Modifiers", "Massachusetts Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Massachusetts tiles.")

	_add("milmod_md_guard", "Military Modifiers", "Maryland Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Maryland tiles.")

	_add("milmod_nc_guard", "Military Modifiers", "North Carolina Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in North Carolina tiles.")

	_add("milmod_sc_guard", "Military Modifiers", "South Carolina Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in South Carolina tiles.")

	_add("milmod_ga_guard", "Military Modifiers", "Georgia Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Georgia tiles.")

	_add("milmod_ct_guard", "Military Modifiers", "Connecticut Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Connecticut tiles.")

	_add("milmod_nj_guard", "Military Modifiers", "New Jersey Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in New Jersey tiles.")

	_add("milmod_de_guard", "Military Modifiers", "Delaware Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Delaware tiles.")

	_add("milmod_nh_guard", "Military Modifiers", "New Hampshire Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in New Hampshire tiles.")

	_add("milmod_ri_guard", "Military Modifiers", "Rhode Island Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Rhode Island tiles.")

	_add("milmod_vt_guard", "Military Modifiers", "Vermont Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Vermont tiles.")

	_add("milmod_me_guard", "Military Modifiers", "Maine Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Maine tiles.")

	_add("milmod_tn_guard", "Military Modifiers", "Tennessee Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Tennessee tiles.")

	_add("milmod_al_guard", "Military Modifiers", "Alabama Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Alabama tiles.")

	_add("milmod_fl_guard", "Military Modifiers", "Florida Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Florida tiles.")

	_add("milmod_wv_guard", "Military Modifiers", "West Virginia Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in West Virginia tiles.")

	_add("milmod_dc_guard", "Military Modifiers", "DC Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Washington DC tiles.")

	_add("milmod_ca_qb_guard", "Military Modifiers", "Quebec Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Quebec tiles.")

	_add("milmod_ca_ot_guard", "Military Modifiers", "Ontario Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Ontario tiles.")

	_add("milmod_ca_ns_guard", "Military Modifiers", "Nova Scotia Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Nova Scotia tiles.")

	_add("milmod_ca_nb_guard", "Military Modifiers", "New Brunswick Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in New Brunswick tiles.")

	_add("milmod_ca_pei_guard", "Military Modifiers", "Prince Edward Island Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Prince Edward Island tiles.")

	_add("milmod_ba_guard", "Military Modifiers", "Bahamas Guard",
		"Home-soil bonus. +2 Attack, +2 Defence per level when fighting in Bahamas tiles.")

	# Protector Buff Modifiers

	_add("milmod_mothman", "Military Modifiers", "Mothman Presence",
		"Mothman Presence: +20 Ranged Attack, +15 Ranged Defence.",
		{"see_also": ["PROT_01"]})

	_add("milmod_jersey_devil", "Military Modifiers", "Jersey Devil's Fury",
		"Jersey Devil's Fury: +25 Attack, +10 Ranged, +10 Block.",
		{"see_also": ["PROT_02"]})

	_add("milmod_bigfoot", "Military Modifiers", "Bigfoot's Solidarity",
		"Bigfoot's Solidarity: +30 Block, +15 Attack.",
		{"see_also": ["PROT_03"]})

	_add("milmod_thunderbird", "Military Modifiers", "Thunderbird's Sovereignty",
		"Thunderbird's Sovereignty: +25 Ranged Attack, +10 Melee Attack.",
		{"see_also": ["PROT_04"]})

	_add("milmod_headless", "Military Modifiers", "Headless Terror",
		"Headless Terror: +20 Attack, +10 Block; attackers become Terrified.",
		{"see_also": ["PROT_05"]})

	_add("milmod_chessie", "Military Modifiers", "Chessie's Blessing",
		"Chessie's Blessing: +20 Block, +15 Ranged Defence.",
		{"see_also": ["PROT_06"]})

	_add("milmod_bell_witch", "Military Modifiers", "Bell Witch's Harassment",
		"Bell Witch's Harassment: +15 Attack, +20 Defence; attackers become Demoralized.",
		{"see_also": ["PROT_07"]})

	_add("milmod_old_ironsides", "Military Modifiers", "Old Ironsides' Hull",
		"Old Ironsides' Hull: +30 Shield, +20 Block.",
		{"see_also": ["PROT_08"]})

	_add("milmod_valley_forge", "Military Modifiers", "Valley Forge's Will",
		"Valley Forge's Will: +10 Attack, +25 Block, +20 Defence.",
		{"see_also": ["PROT_09"]})

	_add("milmod_snallygaster", "Military Modifiers", "Snallygaster's Claim",
		"Snallygaster's Claim: +20 Attack, +10 Ranged, +10 Block.",
		{"see_also": ["PROT_10"]})

	_add("milmod_paul_revere", "Military Modifiers", "Paul Revere's Ride",
		"Paul Revere's Ride: +15 Ranged, +10 Attack, +3 Movement.",
		{"see_also": ["PROT_11"]})

	_add("milmod_liberty_bell", "Military Modifiers", "Liberty Bell's Resonance",
		"Liberty Bell's Resonance: +25 Block, +15 Ranged Defence.",
		{"see_also": ["PROT_12"]})

	_add("milmod_green_mountain", "Military Modifiers", "Green Mountain Haunting",
		"Green Mountain Haunting: +20 Block, +15 Ranged Defence.",
		{"see_also": ["PROT_13"]})

	_add("milmod_presidential_decree", "Military Modifiers", "Presidential Decree",
		"Presidential Decree: +20 Attack, +20 Block, +15 Ranged, +15 Defence.",
		{"see_also": ["PROT_14"]})

	_add("milmod_skunk_ape", "Military Modifiers", "Skunk Ape's Domain",
		"Skunk Ape's Domain: +20 Attack, +15 Block.",
		{"see_also": ["PROT_15"]})

	_add("milmod_eternal_vigilance", "Military Modifiers", "Eternal Vigilance",
		"Eternal Vigilance: +25 Block, +10 Attack.",
		{"see_also": ["PROT_16"]})

	_add("milmod_lincolns_mandate", "Military Modifiers", "Lincoln's Mandate",
		"Lincoln's Mandate: +15 Attack, +15 Block, +15 Ranged, +10 Defence.",
		{"see_also": ["PROT_17"]})

	_add("milmod_wendigo", "Military Modifiers", "Le Wendigo's Hunger",
		"Le Wendigo's Hunger: +30 Melee Attack.",
		{"see_also": ["CA_PROT_03"]})

	_add("milmod_loup_garou", "Military Modifiers", "Loup-Garou's Frenzy",
		"Loup-Garou's Frenzy: +25 Attack, +15 Block, +10 Defence.",
		{"see_also": ["CA_PROT_01"]})

	_add("milmod_feux_follets", "Military Modifiers", "Feux Follets' Misdirection",
		"Feux Follets' Misdirection: +25 Ranged Defence, +15 Block.",
		{"see_also": ["CA_PROT_07"]})

	_add("milmod_mishepeshu", "Military Modifiers", "Mishepeshu's Depths",
		"Mishepeshu's Depths: +20 Block, +20 Ranged Defence.",
		{"see_also": ["CA_PROT_04"]})

	_add("milmod_la_corriveau", "Military Modifiers", "La Corriveau's Cage",
		"La Corriveau's Cage: +20 Ranged, +15 Attack.",
		{"see_also": ["CA_PROT_05"]})

	_add("milmod_le_carcajou", "Military Modifiers", "Le Carcajou's Tenacity",
		"Le Carcajou's Tenacity: +20 Attack, +15 Block, +10 Defence.",
		{"see_also": ["CA_PROT_06"]})

	_add("milmod_la_chasse_galerie", "Military Modifiers", "La Chasse-Galerie",
		"La Chasse-Galerie: +15 Attack, +15 Ranged, +4 Movement.",
		{"see_also": ["CA_PROT_07"]})

	_add("milmod_le_gougou", "Military Modifiers", "Le Gougou's Terror",
		"Le Gougou's Terror: +15 Attack, +20 Defence; attackers become Terrified for 3 turns.",
		{"see_also": ["CA_PROT_08"]})

	# Negative Status Effects

	_add("milmod_stunned", "Military Modifiers", "Stunned",
		"Dazed and unable to act: Cannot make melee attacks this turn.")

	_add("milmod_suppressed", "Military Modifiers", "Suppressed",
		"Pinned under fire: Cannot fire ranged attacks this turn.")

	_add("milmod_shaken", "Military Modifiers", "Shaken",
		"Formation broken: Melee block halved.")

	_add("milmod_terrified", "Military Modifiers", "Terrified",
		"Frozen in fear: Melee attack -50%, melee block -30%.")

	_add("milmod_routed", "Military Modifiers", "Routed",
		"Fleeing the field: Cannot attack; melee attack zeroed; ranged defence halved.")

	_add("milmod_burning", "Military Modifiers", "Burning",
		"The ranks are on fire: Loses manpower each turn.")

	_add("milmod_blinded", "Military Modifiers", "Blinded",
		"Can't see a thing: Ranged attack and ranged defence halved.")

	_add("milmod_hexed", "Military Modifiers", "Hexed",
		"Cursed by dark magic: Magic defence eliminated.")

	_add("milmod_diseased", "Military Modifiers", "Diseased",
		"Plague has struck the ranks: Loses manpower each turn.")

	_add("milmod_waterlogged", "Military Modifiers", "Waterlogged",
		"Soaked to the bone: Melee and ranged attack -20%.")

	_add("milmod_frostbitten", "Military Modifiers", "Frostbitten",
		"Fingers too cold to hold a weapon: Melee and ranged attack -30%.")

	_add("milmod_demoralized", "Military Modifiers", "Demoralized",
		"Spirit broken: Melee attack -20%, block -20%, all mil mods disabled.")

	_add("milmod_exhausted", "Military Modifiers", "Exhausted",
		"Worn out from the march: Movement reduced to 1 this turn.")

	_add("milmod_bogged_down", "Military Modifiers", "Bogged Down",
		"Stuck fast: Cannot move this turn.")

	_add("milmod_pacified", "Military Modifiers", "Pacified",
		"Ordered to stand down: Cannot initiate attacks this turn.")

	_add("milmod_supply_cut", "Military Modifiers", "Supply Cut",
		"Supplies intercepted: Cannot reinforce or resupply.")

	_add("milmod_quarantined", "Military Modifiers", "Quarantined",
		"Plague quarantine in effect: No reinforcement; manpower drains each turn.")

	_add("milmod_seduced", "Military Modifiers", "Seduced",
		"The commander has found better things to do: Melee zeroed; cannot attack.")

	_add("milmod_starstruck", "Military Modifiers", "Starstruck",
		"Encountered a celebrity. Requested autograph. Please advise: All stats -30%.")

	_add("milmod_hangover", "Military Modifiers", "Hangover",
		"Someone opened the wrong cask: All stats -50%.")

	_add("milmod_love_struck", "Military Modifiers", "Love-Struck",
		"Cupid's arrow strikes without warning: Melee attack -70%, block -70%; cannot attack.")

	_add("milmod_mutinous", "Military Modifiers", "Mutinous",
		"The ranks are restless: Melee attack -40%; 50% chance army refuses orders each turn.")

	# ── FACTIONS ─────────────────────────────────────────────────────────────
	_add("fac_sons_of_liberty", "Factions", "Sons of Liberty",
		"Led by Patrick Henry, the Sons of Liberty are the revolutionary vanguard — the men who lit the fire before anyone else was ready. They believe the republic is won at the barrel of a musket and maintained by the vigilance of armed citizens. Every free man a soldier. Every farm a fortress.\n\nReach 30 loyalty to unlock Militia Muster (Armed Peasantry + Homeland Defense laws; Barracks +50 manpower).\nReach 60 to unlock Merchant Networks (Navigation Acts; Markets and Workshops +1 gold).\nReach 90 to unlock Letters of Marque (Calico Jack joins your governors; Docks produce weapons).",
		{"see_also": ["law_armed_peasantry", "law_homeland_defense", "law_navigation_acts"]})

	_add("fac_continental_congress", "Factions", "Continental Congress",
		"Led by Abigail Adams, the Continental Congress believes the republic must be built on institutions — law, consent, legitimacy. They are the architects. While others fight, they write constitutions.\n\nReach 30 loyalty to unlock Articles of Confederation (Local Elections + Democratic Mandate laws; Courthouses +1 mandate).\nReach 60 to unlock Foreign Diplomacy (Monuments +1 influence).\nReach 90 to unlock Constitutional Convention (Democratic Mandate law; Libraries +1 science).",
		{"see_also": ["law_local_elections", "law_democratic_mandate"]})

	_add("fac_common_cause", "Factions", "Common Cause",
		"Led by Daniel Shays, Common Cause is the faction of the ordinary settler — the farmer, the homesteader, the person who fought a war and came home to find a debt collector. They want land, fairness, and a government that remembers who actually won the revolution.\n\nReach 30 loyalty to unlock Frontier Homesteads (Armed Peasantry law; Farms +1 food).\nReach 60 to unlock The People's Assembly (Universal Citizenship law; Baths and Temples +1 happiness).\nReach 90 to unlock Land Reform (Farms +1 additional food).",
		{"see_also": ["law_armed_peasantry", "law_universal_citizenship"]})

	_add("fac_abolitionist_league", "Factions", "Abolitionist League",
		"Led by Mercy Otis Warren, the Abolitionist League holds that no republic worthy of the name can tolerate slavery. They are the conscience of the revolution — often uncomfortable, always right, and entirely unwilling to wait.\n\nReach 30 loyalty to unlock Freedom Papers (Universal Citizenship + Disability Care laws).\nReach 60 to unlock Underground Railroad (Phillis Wheatley joins your governors; Temples +1 culture).\nReach 90 to unlock Universal Emancipation (Democratic Mandate law; Temples +1 happiness, Courthouses +1 mandate).",
		{"see_also": ["law_universal_citizenship", "law_disability_care", "law_democratic_mandate"]})

	_add("fac_free_workers_union", "Factions", "Free Workers Union",
		"Led by Thomas Paine, the Free Workers Union represents artisans, dockworkers, and the laboring poor. They want the republic to mean something for the people who built it with their hands, not just the people who signed the papers.\n\nReach 30 loyalty to unlock Guild Charters (Forges +1 weapons, Markets and Workshops +1 gold).\nReach 60 to unlock General Strike (Disability Care law; Camps +1 wood, Mines +1 metal).\nReach 90 to unlock Workers Commonwealth (Universal Citizenship law; Farms +1 food, Libraries +1 science).",
		{"see_also": ["law_disability_care", "law_universal_citizenship"]})

	_add("fac_french_habitants", "Factions", "French Habitants",
		"The French-speaking farming communities of Quebec are cautious allies. They want their language, their faith, and their legal traditions respected. Give them that, and they will give you a revolution that runs on wheat.\n\nReach 30 loyalty to unlock Quebec Act Recognition (Local Elections law; Temples +1 culture).\nReach 60 to unlock Habitants Alliance (Pierre Renard joins your governors; Farms +1 food).\nReach 90 to unlock Republic of Quebec (Universal Citizenship + Democratic Mandate laws; Farms +1 additional food, Temples +1 happiness).",
		{"see_also": ["law_local_elections", "law_universal_citizenship", "law_democratic_mandate"]})

	_add("fac_loyalist_settlers", "Factions", "Loyalist Settlers",
		"Not everyone in Canada welcomed the Crown's rule — but they waited to see which way the wind blew. The Loyalist Settlers are pragmatists who have decided the republic is the safer bet. They bring with them British administrative competence and, occasionally, British guilt.\n\nReach 30 loyalty to unlock Crown Defectors (Homeland Defense law; Courthouses +1 mandate).\nReach 60 to unlock Pragmatic Compact (Benjamin Tallmadge joins your governors at level 2; Barracks +50 manpower).\nReach 90 to unlock New Republic Converts (Navigation Acts + Democratic Mandate laws; Libraries +1 science, Markets and Workshops +1 gold).",
		{"see_also": ["law_homeland_defense", "law_navigation_acts", "law_democratic_mandate"]})

	_add("fac_haudenosaunee_confederacy", "Factions", "Haudenosaunee Confederacy",
		"The Haudenosaunee — the Six Nations — have governed this land by confederation for centuries. They have no interest in replacing one empire with another. What they want is sovereignty, respect, and a treaty that is actually honored.\n\nReach 30 loyalty to unlock Treaty of Friendship (Universal Citizenship law; Camps +1 wood).\nReach 60 to unlock Haudenosaunee Alliance (Camps +1 weapons).\nReach 90 to unlock Sovereign Partnership (Universal Citizenship + Disability Care laws; Barracks +50 manpower).",
		{"see_also": ["law_universal_citizenship", "law_disability_care"]})

	_add("fac_coureurs_des_bois", "Factions", "Coureurs des Bois",
		"The woodsmen who mapped the continent before any government claimed it. They trade in furs, information, and silence. Their loyalty is earned slowly and kept carefully. When they commit to a cause, the forest moves with them.\n\nReach 30 loyalty to unlock Trade Routes (Camps +1 wood).\nReach 60 to unlock Frontier Network (Louis Tremblant joins your governors; Camps +2 wood total, Mines +1 metal).\nReach 90 to unlock Continental Reach (Camps +1 weapons).",
		{"see_also": []})

	_add("fac_maritime_patriots", "Factions", "Maritime Patriots",
		"The fishing and trading communities of the Atlantic coast — Nova Scotia, New Brunswick, Prince Edward Island. They have always lived by the sea and by their own rules. The republic offers them something the Crown never did: a charter that treats them as citizens instead of subjects.\n\nReach 30 loyalty to unlock Port Alliance (Docks +1 boats).\nReach 60 to unlock Atlantic Commerce (Navigation Acts law; Markets, Workshops, and Docks +1 gold).\nReach 90 to unlock Maritime Union (Docks +1 additional boats).",
		{"see_also": ["law_navigation_acts"]})

	# ── PROTECTORS (mystery until agree) ─────────────────────────────────────
	_add_mystery("PROT_01", "Protectors",
		"Something moves in the mountain passes of West Virginia at night. Old miners refuse to speak its name.",
		"PROT_01")

	_add_mystery("PROT_02", "Protectors",
		"Hunters along the Pine Barrens have reported a winged figure that leaves no tracks and makes no sound.",
		"PROT_02")

	_add_mystery("PROT_03", "Protectors",
		"The Blue Ridge holds something ancient. Larger than a man. Older than the republic.",
		"PROT_03")

	_add_mystery("PROT_04", "Protectors",
		"Storm riders speak of a great shape seen above the clouds near the Great Lakes. The thunder that follows it is not natural.",
		"PROT_04")

	_add_mystery("PROT_05", "Protectors",
		"A horseman without a head has been reported along the Hudson. It rides hard and it rides at night.",
		"PROT_05")

	_add_mystery("PROT_06", "Protectors",
		"Chesapeake fishermen have stopped working the deep water. Something beneath the surface watches back.",
		"PROT_06")

	_add_mystery("PROT_07", "Protectors",
		"In the hills of Tennessee, a farmhouse was visited nightly by something that could not be touched. It knew names. It remembered.",
		"PROT_07")

	_add_mystery("PROT_08", "Protectors",
		"A ship that cannot be sunk has been sighted in Boston Harbor. Its crew does not age. Its guns never run dry.",
		"PROT_08")

	_add_mystery("PROT_09", "Protectors",
		"Near Valley Forge, sentries report a figure walking the old encampment grounds in the fog. It wears Continental blue.",
		"PROT_09")

	_add_mystery("PROT_10", "Protectors",
		"Something nests in the Catoctin Mountains. Travelers between the capital and the north have gone missing.",
		"PROT_10")

	_add_mystery("PROT_11", "Protectors",
		"A rider was seen near Lexington moving faster than any horse alive. The message he carries has not yet been delivered.",
		"PROT_11")

	_add_mystery("PROT_12", "Protectors",
		"In Philadelphia, on quiet nights, a ringing is heard with no source. It comes from Independence Hall. Nothing is there.",
		"PROT_12")

	_add_mystery("PROT_13", "Protectors",
		"The mountains of Vermont are haunted by something patriotic and enormous. It has opinions about taxation.",
		"PROT_13")

	_add_mystery("PROT_14", "Protectors",
		"The faces in the rock at Gettysburg open their eyes sometimes. Only sometimes. But when they do, they are looking south.",
		"PROT_14")

	_add_mystery("PROT_15", "Protectors",
		"The Everglades hold something enormous and foul-smelling that the local Seminole call very old. They do not explain further.",
		"PROT_15")

	_add_mystery("PROT_16", "Protectors",
		"There is a musket that fires without being loaded, held by someone who cannot be seen, near the Connecticut River valley.",
		"PROT_16")

	_add_mystery("PROT_17", "Protectors",
		"The White House has had a permanent guest since 1862. He walks the halls at night. He is tall. He is patient.",
		"PROT_17")

	_add_mystery("CA_PROT_01", "Protectors",
		"Something pulls the ice floes apart along the St. Lawrence. The voyageurs call it a bad crossing year. It is not a crossing year.",
		"CA_PROT_01")

	_add_mystery("CA_PROT_02", "Protectors",
		"A shape has been seen beneath Lake Ontario for three hundred years. It has not moved. It is waiting.",
		"CA_PROT_02")

	_add_mystery("CA_PROT_03", "Protectors",
		"The Wendigo of the northern forests is not a story parents tell children. It is a warning parents tell each other.",
		"CA_PROT_03")

	_add_mystery("CA_PROT_04", "Protectors",
		"The Ojibwe speak of a great lynx that controls the deep water. It has not been seen since the last winter that killed everyone who saw it.",
		"CA_PROT_04")

	_add_mystery("CA_PROT_05", "Protectors",
		"In the villages near Québec City, they remember a woman who was executed. They do not say she stayed dead.",
		"CA_PROT_05")

	_add_mystery("CA_PROT_06", "Protectors",
		"The wolverine of Moncton is not an animal. The trappers learned this. The trappers are gone now.",
		"CA_PROT_06")

	_add_mystery("CA_PROT_07", "Protectors",
		"The flying canoe that travels the river at night does not appear on maps. The men inside it have been paddling for a very long time.",
		"CA_PROT_07")

	_add_mystery("CA_PROT_08", "Protectors",
		"In the bay, where the Chaleur meets the ocean, fishermen sometimes see a light beneath the water. They go home. They do not explain why.",
		"CA_PROT_08")

	# ── LORE & HISTORY ───────────────────────────────────────────────────────
	_add("lore_first_war", "Lore & History", "The First British Reconquest War",
		"In 1782, following the unexpected death of King George III, the British Parliament authorized a full military reconquest of the former colonies. What followed was the First Reconquest War — a brutal, satirical, and deeply inconvenient reminder that revolution is easier the second time.\n\nPresident Ualani Carlisle, barely a year into her term, faced the full weight of the British Empire with a standing army, a treasury of questionable depth, and the most politically functional cabinet in American history.",
		{"icon_path": ""})

	_add("lore_ualani",   "Lore & History", "President Ualani Carlisle",
		"Hawaii's first President of the United States. Former senator. Former general. Current problem for the British Empire.\n\nUalani Carlisle was elected on a platform of infrastructure, diplomacy, and what her opponents called 'an alarming amount of common sense.' She is known for her directness, her refusal to delegate decisions she considers moral, and her habit of personally responding to threatening letters from foreign heads of state.",
		{"icon_path": ""})
