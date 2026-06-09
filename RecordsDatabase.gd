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
