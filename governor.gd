extends Node2D

class_name governor

var governorType: String     # display name OR archetype name for named governors
var governorArchetypeId: String = ""  # set by procedural generation — overrides archetype lookup
var governorPosition: String # title / role (ORATOR, SCOUT, etc.)

var governorLevel: int
var xp: float = 0.0         # accumulated combat XP; 50 → level 2, 125 → level 3
var governorTexture: Texture
var governorDescription: String
var governorBiography: String
var governorFaction: String

#requirements
var coastal: bool = false #if yes, only allowed in coastal tiles
var governorBuildingRequirement: String

#governorTraits

#militaryTraits
var govMilModsLvl1: Array = []
var govMilModsLvl2: Array = []
var govMilModsLvl3: Array = []

var hired: bool

var loyalty: float = 0.0      # –20 to +20; passive cap of 10 without questComplete
var morale: int = 50          # 0–100; multiplies army armyPunch/armyDefence by up to +25%
var isVicePresident: bool = false  # true for one randomly-assigned named governor per game
var isLeader: bool = false         # true for the named head-of-state of any country
var questComplete: bool = false
var _loyalty_acc: float = 0.0  # accumulates sub-integer deltas between turns
var governor_perks: Array = []  # unlocked via set_governor_perk outcome (e.g. "community_steel")

const GOVERNOR_PORTRAITS: Dictionary = {
	# Named governors — portraits confirmed
	"Mothman":                   "res://art assets/finishedAssets/governors/mothman.png",
	"Lincoln's Ghost":           "res://art assets/finishedAssets/governors/lincolns_ghost.png",
	"Turkey God":                "res://art assets/finishedAssets/governors/turkey_god.png",
	"Secret Service Detail":     "res://art assets/finishedAssets/governors/secret_service_detail.png",
	"Baseball Legend":           "res://art assets/finishedAssets/governors/baseball_legend.png",
	# Named governors — sprites pending
	"Patrick Henry":             "res://art assets/finishedAssets/governors/patrick_henry.png",
	"Abigail Adams":             "res://art assets/finishedAssets/governors/abigail_adams.png",
	"Thomas Paine":              "res://art assets/finishedAssets/governors/thomas_paine.png",
	"Mercy Otis Warren":         "res://art assets/finishedAssets/governors/mercy_otis_warren.png",
	"Daniel Shays":              "res://art assets/finishedAssets/governors/daniel_shays.png",
	"Ualani Carlisle":           "res://art assets/finishedAssets/governors/ualani_carlisle.png",
	"Benjamin Tallmadge":        "res://art assets/finishedAssets/governors/benjamin_tallmadge.png",
	"Phillis Wheatley":          "res://art assets/finishedAssets/governors/phillis_wheatley.png",
	"Francis Asbury":            "res://art assets/finishedAssets/governors/francis_asbury.png",
	"Jessica Commanda Odjick":   "res://art assets/finishedAssets/governors/jessica_commanda_odjick.png",
	"Marc Penoit":               "res://art assets/finishedAssets/governors/marc_penoit.png",
	"Calico Jack":               "res://art assets/finishedAssets/governors/calico_jack.png",
	"Pierre Renard":             "res://art assets/finishedAssets/governors/pierre_renard.png",
	"Louis Tremblant":           "res://art assets/finishedAssets/governors/louis_tremblant.png",
}
var culture: String   = ""
var pronouns: Dictionary = {}   # subject/object/possessive/reflexive/plural
var portrait_entry: Dictionary = {}  # set by pick_procedural_portrait; drives Vermont reskin

var thanksTxt: String    = ""   # SFW press conference scene, generated at creation
var thanksImg: String    = ""   # path to SFW Oval Office art (portrait-paired)
var thanksTxtExp: String = ""   # intimate scene, generated at creation
var thanksImgExp: String = ""   # path to intimate Oval Office art (portrait-paired)

# ── Static dedup tracker — reset at game start via reset_portrait_pool() ─────
static var _used_portrait_paths: Array = []

static func reset_portrait_pool() -> void:
	_used_portrait_paths.clear()

# ── Procedural portrait pool — portrait drives name + pronouns + culture ──────
# Each entry: { path, culture, pronouns:{subject,object,possessive,reflexive,plural},
#               first:[...], last:[...] }
const PROCEDURAL_PORTRAIT_DATA: Array = [
	{
		"path":    "res://art assets/finishedAssets/governors/minuteman_01.png",
		"culture": "Mexican",
		"pronouns": {"subject":"she","object":"her","possessive":"her","reflexive":"herself","plural":false},
		"first": ["Rosa","Elena","Carmen","Isabel","Valentina","Lucia","Sofia","Adriana","Catalina","Marisol"],
		"last":  ["Reyes","Flores","Morales","Vega","Cruz","Rivera","Torres","Vargas","Mendez"],
	},
	{
		"path":    "res://art assets/finishedAssets/governors/minuteman_02.png",
		"culture": "Lebanese",
		"pronouns": {"subject":"they","object":"them","possessive":"their","reflexive":"themselves","plural":true},
		"first": ["Noor","Rima","Sami","Dani","Yara","Tarek","Layla","Ziad","Hana","Karim"],
		"last":  ["Khoury","Haddad","Habib","Nassar","Khalil","Rahal","Aoun","Gemayel"],
	},
	{
		"path":    "res://art assets/finishedAssets/governors/minuteman_03.png",
		"culture": "Irish",
		"pronouns": {"subject":"she","object":"her","possessive":"her","reflexive":"herself","plural":false},
		"first": ["Brigid","Siobhan","Fiona","Aoife","Niamh","Roisin","Maeve","Clodagh","Sinead","Orla"],
		"last":  ["O'Brien","Murphy","Walsh","Kelly","Flynn","Doyle","Sullivan","Brennan"],
	},
	{
		"path":    "res://art assets/finishedAssets/governors/minuteman_04.png",
		"culture": "Chinese",
		"pronouns": {"subject":"he","object":"him","possessive":"his","reflexive":"himself","plural":false},
		"first": ["Wei","Jun","Ming","Hao","Chen","Feng","Liang","Zheng","Kai","Bo"],
		"last":  ["Li","Wang","Zhang","Liu","Yang","Zhou","Huang","Wu","Xu"],
	},
	{
		"path":         "res://art assets/finishedAssets/governors/minuteman_05.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_minuteman_05.png",
		"culture": "Vietnamese",
		"pronouns": {"subject":"she","object":"her","possessive":"her","reflexive":"herself","plural":false},
		"first": ["Lan","Linh","Huong","Phuong","Mai","Thao","Ngoc","Hoa","Tuyen","Bich"],
		"last":  ["Nguyen","Tran","Le","Pham","Hoang","Phan","Vu","Dang","Bui"],
	},
	{
		"path":         "res://art assets/finishedAssets/governors/minuteman_06.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_minuteman_06.png",
		"culture": "Unknown",
		"pronouns": {"subject":"they","object":"them","possessive":"their","reflexive":"themselves","plural":true},
		"first": ["Ash","Ember","Flint","Cipher","Veil","Shade","Rook","Wren","Birch","Slate"],
		"last":  [],
	},
	{
		"path":         "res://art assets/finishedAssets/governors/minuteman_07.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_minuteman_07.png",
		"culture": "English",
		"pronouns": {"subject":"they","object":"them","possessive":"their","reflexive":"themselves","plural":true},
		"first": ["Morgan","Robin","Avery","Taylor","Quinn","Lark","Blair","Cary","Devon","Reeve"],
		"last":  ["Alderton","Whitfield","Hatch","Morse","Sears","Brewster","Alden","Coffin"],
	},
	{
		"path":         "res://art assets/finishedAssets/governors/minuteman_08.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_minuteman_08.png",
		"culture": "West African",
		"pronouns": {"subject":"he","object":"him","possessive":"his","reflexive":"himself","plural":false},
		"first": ["Kofi","Kwame","Ayo","Emeka","Chidi","Seun","Tobi","Dele","Femi","Ola"],
		"last":  ["Osei","Mensah","Asante","Adeyemi","Okafor","Nwosu","Eze","Abiodun"],
	},
	{
		"path":         "res://art assets/finishedAssets/governors/minuteman_09.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_minuteman_09.png",
		"culture": "Scottish",
		"pronouns": {"subject":"he","object":"him","possessive":"his","reflexive":"himself","plural":false},
		"first": ["Alistair","Callum","Hamish","Fergus","Ewan","Angus","Rory","Duncan","Malcolm","Murdoch"],
		"last":  ["MacLeod","MacDonald","Campbell","Fraser","Ross","Grant","Mackenzie","Stewart"],
	},
	{
		"path":         "res://art assets/finishedAssets/governors/minuteman_10.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_minuteman_10.png",
		"culture": "South Asian",
		"pronouns": {"subject":"he","object":"him","possessive":"his","reflexive":"himself","plural":false},
		"first": ["Arjun","Rohan","Dev","Kiran","Vikram","Anand","Raj","Sai","Jai","Neel"],
		"last":  ["Patel","Sharma","Singh","Kumar","Gupta","Rao","Mehta","Nair","Reddy"],
	},
	{
		"path":         "res://art assets/finishedAssets/governors/minuteman_11.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_minuteman_11.png",
		"culture": "Caribbean",
		"pronouns": {"subject":"he","object":"him","possessive":"his","reflexive":"himself","plural":false},
		"first": ["Marcus","Isaiah","Elijah","Nathan","Solomon","Tobias","Levi","Micah","Ezra","Jude"],
		"last":  ["Williams","Johnson","Brown","Thompson","Clarke","Campbell","Henry","Lewis"],
	},
	{
		"path":         "res://art assets/finishedAssets/governors/minuteman_12.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_minuteman_12.png",
		"culture": "Aboriginal Australian",
		"pronouns": {"subject":"he","object":"him","possessive":"his","reflexive":"himself","plural":false},
		"first": ["Jarrah","Warrick","Daku","Mirri","Yarra","Warra","Mulga","Wirra","Bindi","Kuri"],
		"last":  [],
	},
	{
		"path":         "res://art assets/finishedAssets/governors/minuteman_13.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_minuteman_13.png",
		"culture": "French",
		"pronouns": {"subject":"she","object":"her","possessive":"her","reflexive":"herself","plural":false},
		"first": ["Marguerite","Colette","Elise","Brigitte","Vivienne","Celine","Aurelie","Mathilde","Camille","Claudette"],
		"last":  ["Dupont","Martin","Bernard","Dubois","Laurent","Simon","Michel","Lefevre"],
	},
	{
		# Default (non-Vermont) portrait is blue; Vermont reskin is the original green
		"path":         "res://art assets/finishedAssets/governors/blue_mountaineer_01.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_mountaineer_01.png",
		"culture": "Angolan",
		"pronouns": {"subject":"she","object":"her","possessive":"her","reflexive":"herself","plural":false},
		"first": ["Amara","Zola","Nkechi","Adaeze","Ifunanya","Chisom","Nneka","Obioma","Adanna","Ngozi"],
		"last":  ["Mateus","Ferreira","Santos","Rodrigues","Costa","Lopes","Alves"],
	},
	{
		# Default (non-Vermont) portrait is blue; Vermont reskin is the original green
		"path":         "res://art assets/finishedAssets/governors/blue_mountaineer_02.png",
		"vermont_path": "res://art assets/finishedAssets/governors/green_mountaineer_02.png",
		"culture": "Quebecois",
		"pronouns": {"subject":"he","object":"him","possessive":"his","reflexive":"himself","plural":false},
		"first": ["Jean-Pierre","Luc","Etienne","Benoit","Gaston","Rene","Fernand","Emile","Henri","Armand"],
		"last":  ["Tremblay","Gagnon","Roy","Cote","Bouchard","Gauthier","Morin","Lavoie"],
	},
]

func pick_procedural_portrait() -> Dictionary:
	# Build list of available (not yet used) portraits
	var available: Array = []
	for entry in PROCEDURAL_PORTRAIT_DATA:
		if not _used_portrait_paths.has(entry["path"]):
			available.append(entry)
	# If exhausted, reset and reuse (edge case: more commanders than portraits)
	if available.is_empty():
		_used_portrait_paths.clear()
		available = PROCEDURAL_PORTRAIT_DATA.duplicate()
	var chosen: Dictionary = available[randi() % available.size()]
	_used_portrait_paths.append(chosen["path"])
	portrait_entry = chosen
	return chosen

func _get_portrait(name: String) -> Texture:
	var path: String = GOVERNOR_PORTRAITS.get(name, "")
	if path != "" and ResourceLoader.exists(path):
		return load(path)
	return null

# Returns the correct portrait for a given tile region.
# Procedural governors stationed in Vermont ("VT") show their green coat version.
func get_portrait_for_region(region: String) -> Texture:
	if region == "VT" and portrait_entry.has("vermont_path"):
		var vp: String = portrait_entry["vermont_path"]
		if ResourceLoader.exists(vp):
			return load(vp)
	return governorTexture

func buildSelf(gT, gL):
	governorType = gT
	governorLevel = gL
	hired = false
	match governorType:
		"Patrick Henry":
			governorTexture = _get_portrait(governorType)
			governorDescription = "Give me liberty or give me death. Henry brooks no compromise with tyranny."
			governorBiography = "Virginia orator and patriot. His fury at the crown is matched only by his suspicion of centralized power in any form."
			governorPosition = "ORATOR"
			governorFaction = "Patriot"
			loyalty = 8.0
			addMilMod("Visionary", 123)
			addMilMod("Champion of the Sun", 23)
			addMilMod("Healer", 3)

		"Abigail Adams":
			governorTexture = _get_portrait(governorType)
			governorDescription = "Remember the ladies, or we will foment our own rebellion."
			governorBiography = "Wife, intellectual, and the conscience of the revolution. Pushes the movement toward its own stated ideals."
			governorPosition = "DIPLOMAT"
			governorFaction = "Moderate"
			loyalty = 7.0

		"Thomas Paine":
			governorTexture = _get_portrait(governorType)
			governorDescription = "Common sense is not so common. Government is a necessary evil at best."
			governorBiography = "English immigrant turned American revolutionary. His pamphlets lit the fire. He believes in the people absolutely."
			governorPosition = "SCHOLAR"
			governorFaction = "Radical"
			loyalty = 4.0  # Loyal but independently principled — will balk at overreach

		"Mercy Otis Warren":
			governorTexture = _get_portrait(governorType)
			governorDescription = "The pen is mightier than any redcoat bayonet."
			governorBiography = "Playwright and historian of the revolution. Her sharp political satire keeps the movement honest."
			governorPosition = "SCHOLAR"
			governorFaction = "Patriot"
			loyalty = 7.0

		"Daniel Shays":
			governorTexture = _get_portrait(governorType)
			governorDescription = "The farmers have had enough. We will not be taxed into poverty."
			governorBiography = "Veteran of the Continental Army who led a farmers revolt when the revolution forgot the people who fought it."
			governorPosition = "FARMER"
			governorFaction = "Populist"
			loyalty = 1.0  # Has real grievances; loyalty fragile under low claim

		"Ualani Carlisle":
			governorTexture = _get_portrait(governorType)
			governorDescription = "The President does not wait for permission. She leads from the front and the briefing room and, when necessary, the battlefield."
			governorBiography = "Hawaii's finest export and Washington's current occupant — when it is not occupied. President Carlisle commands the APF personally. Her security detail has filed seventeen formal objections. She has read none of them."
			governorPosition = "PRESIDENT & COMMANDER"
			governorFaction = "Federal"
			pronouns = {"subject":"she","object":"her","possessive":"her","reflexive":"herself","plural":false}
			loyalty = 20.0  # Absolute personal loyalty — this is her Republic
			questComplete = true  # Her loyalty is uncapped from the start
			isLeader = true
			addMilMod("President", 123)

		"Benjamin Tallmadge":
			governorTexture = _get_portrait(governorType)
			governorDescription = "The Culper Ring never stopped running. It merely changed names."
			governorBiography = "Washington's spymaster and the architect of America's first intelligence network. Tallmadge ran agents behind Crown lines for six years without losing one. He is methodical, loyal, and deeply suspicious of everyone — including himself. The Codebook is his invention. The Ring is his life's work. He keeps a ledger. The ledger is encrypted. He is the only one who knows the key."
			governorPosition = "SPYMASTER"
			governorFaction = "Patriot"
			loyalty = 9.0
			addMilMod("Translator", 123)

		"Phillis Wheatley":
			governorTexture = _get_portrait(governorType)
			governorDescription = "Liberty and peace are not decorative concepts. They are demands."
			governorBiography = "The first published African American poet and the revolution's most inconvenient mirror. She met Washington and wrote him a poem and the poem was better than the war. Her work is circulating in British-held territories. Crown officers have begun confiscating it, which, historically speaking, is how you know a poem is working. She does not fight with a musket. She does not need to."
			governorPosition = "HERALD"
			governorFaction = "Abolitionist League"
			loyalty = 6.0

		"Francis Asbury":
			governorTexture = _get_portrait(governorType)
			governorDescription = "I have traveled three hundred thousand miles in this country and I am not done yet."
			governorBiography = "The Father of American Methodism arrived from England in 1771 and proceeded to cover every inch of the new nation on horseback at a pace that worried his horse. He preaches liberation theology in territories where armies cannot follow. His circuits reach the frontier settlements, the Appalachian hollows, the farmlands between battlefields. He is anti-slavery, democratic, tireless, and genuinely impossible to stop. Crown forces have twice tried to arrest him. He preached at both arresting officers. One converted."
			governorPosition = "CIRCUIT PREACHER"
			governorFaction = "Common Cause"
			loyalty = 5.0

		"Jessica Commanda Odjick":
			governorTexture = _get_portrait(governorType)
			governorDescription = "The colony belongs to no crown. The land remembers who tended it long before London drew a line."
			governorBiography = "Algonquin leader and the voice the Continental Republic actually needs to hear. Commanda grew up on the waterways between territories London calls borders and her people call home. She speaks three languages and none of them are asking permission. She came to Ottawa not as a supplicant but as the only person in the room who has been right about every British promise for forty years. The Governor's Council objected to her presence at the table. The Governor's Council is no longer at the table."
			governorPosition = "PRIME MINISTER"
			governorFaction = "Algonquin Nation"
			loyalty = 20.0
			questComplete = true
			isLeader = true

		"Marc Penoit":
			governorTexture = _get_portrait(governorType)
			governorDescription = "I did not march this far to hand the colony back to London in a different hat."
			governorBiography = "Québécois militia commander and deputy to Clear-Water. Penoit spent two winters at the siege of Saint-Georges before the Continental Republic knew his name. Pragmatic where Clear-Water is principled, military where she is diplomatic, and entirely convinced that the French Habitants will only survive this war if someone is watching the eastern flank. He disagrees with the alliance about once a week. He never disagreed enough to leave."
			governorPosition = "DEPUTY GOVERNOR"
			governorFaction = "French Habitants"
			loyalty = 15.0
			isVicePresident = true

		"Mothman":
			governorTexture = _get_portrait(governorType)
			governorDescription = "It appeared before the bridge fell. It appears now. Draw your own conclusions."
			governorBiography = "The Mothman of Point Pleasant has haunted the Ohio River valley since before the revolution. Its warning cries precede disasters — or cause them, depending on who you ask. It does not speak. It does not need to. When it stands at your side on the battlefield, the enemy sees it too."
			governorPosition = "OMEN"
			governorFaction = "Protector"
			loyalty = 20.0
			questComplete = true

		"Lincoln's Ghost":
			governorTexture = _get_portrait(governorType)
			governorDescription = "The first time was unfinished business. The second time, he came back to finish it."
			governorBiography = "Abe Lincoln died in Washington once. Now he haunts the White House and the war rooms and the places where decisions are made badly. He does not give orders. He stands behind you when you are about to make a mistake and says nothing at all, which is somehow worse. Carlisle finds him unnerving. He finds that funny."
			governorPosition = "SPECTER"
			governorFaction = "Protector"
			pronouns = {"subject":"he","object":"him","possessive":"his","reflexive":"himself","plural":false}
			loyalty = 20.0
			questComplete = true

		"Turkey God":
			governorTexture = _get_portrait(governorType)
			governorDescription = "Ben Franklin was right. Nobody respected him until they needed him."
			governorBiography = "Ancient, enormous, and profoundly unimpressed. The Turkey God is older than the republic, older than the colonies, older than the name for any of this. It arrived at the first Thanksgiving with an agenda nobody asked about and has been watching since. It does not fight. It makes the land remember what it owes the people who tended it."
			governorPosition = "ELDER"
			governorFaction = "Protector"
			loyalty = 20.0
			questComplete = true

		"Secret Service Detail":
			governorTexture = _get_portrait(governorType)
			governorDescription = "She has kept Carlisle alive through four assassination attempts. The fifth one hasn't tried yet."
			governorBiography = "She doesn't have a name on the record, a file in the system, or a rank on the org chart. She has a job. The job is the President. She is very good at her job."
			governorPosition = "DETAIL"
			governorFaction = "Patriot"
			loyalty = 20.0
			questComplete = true

		"Baseball Legend":
			governorTexture = _get_portrait(governorType)
			governorDescription = "She hit .340 in a league that told her she couldn't play. She wasn't listening then either."
			governorBiography = "The most famous athlete in a country currently at war. She showed up with a bat, a grievance, and no patience for the idea that the revolution didn't need her. She was right. The morale she brings to a garrison is measurable. The morale she takes from the enemy is also measurable. Different units of measurement."
			governorPosition = "LEGEND"
			governorFaction = "Patriot"
			loyalty = 10.0

		"Anarchistic":
			governorTexture = load("res://art assets/finishedAssets/governors/anarchist.png")
			governorDescription = "No country. No crown. No compromise."
			governorBiography = "They came from the occupied territories — from plantations and prisons and Crown-held towns where the revolution never arrived. They do not fight for any republic. They fight against everything that calls itself a government. They are ungovernable by design."
			governorPosition = "AGITATOR"
			governorFaction = "Radical"
			loyalty = 0.0
	pass


func update_loyalty(claim: float) -> void:
	var rate: float
	if claim >= 6.0:
		rate = 0.25
	elif claim >= 1.0:
		rate = 0.1
	elif claim <= -6.0:
		rate = -0.25
	elif claim <= -1.0:
		rate = -0.1
	else:
		rate = 0.0

	_loyalty_acc += rate
	if absf(_loyalty_acc) >= 1.0:
		loyalty += float(int(_loyalty_acc))
		_loyalty_acc -= float(int(_loyalty_acc))

	if not questComplete:
		loyalty = minf(loyalty, 10.0)
	loyalty = clampf(loyalty, -20.0, 20.0)

func addMilMod(type, levels):
	var newMM = MilMod.new()
	newMM.milModType = type
	newMM.buildSelf(type)
	match levels:
		123:
			govMilModsLvl1.append(newMM)
			govMilModsLvl2.append(newMM)
			govMilModsLvl3.append(newMM)
		23:
			govMilModsLvl2.append(newMM)
			govMilModsLvl3.append(newMM)
		3:
			govMilModsLvl3.append(newMM)
	pass

func hire():
	hired = true
	pass
