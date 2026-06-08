extends Node2D

class_name governor

var governorType: String     # display name OR archetype name for named governors
var governorArchetypeId: String = ""  # set by procedural generation — overrides archetype lookup
var governorPosition: String # title / role (ORATOR, SCOUT, etc.)

var governorLevel: int
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
var questComplete: bool = false
var _loyalty_acc: float = 0.0  # accumulates sub-integer deltas between turns

func buildSelf(gT, gL):
	governorType = gT
	governorLevel = gL
	hired = false
	match governorType:
		"Patrick Henry":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "Give me liberty or give me death. Henry brooks no compromise with tyranny."
			governorBiography = "Virginia orator and patriot. His fury at the crown is matched only by his suspicion of centralized power in any form."
			governorPosition = "ORATOR"
			governorFaction = "Patriot"
			loyalty = 8.0
			addMilMod("Visionary", 123)
			addMilMod("Champion of the Sun", 23)
			addMilMod("Healer", 3)

		"Abigail Adams":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "Remember the ladies, or we will foment our own rebellion."
			governorBiography = "Wife, intellectual, and the conscience of the revolution. Pushes the movement toward its own stated ideals."
			governorPosition = "DIPLOMAT"
			governorFaction = "Moderate"
			loyalty = 7.0

		"Thomas Paine":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "Common sense is not so common. Government is a necessary evil at best."
			governorBiography = "English immigrant turned American revolutionary. His pamphlets lit the fire. He believes in the people absolutely."
			governorPosition = "SCHOLAR"
			governorFaction = "Radical"
			loyalty = 4.0  # Loyal but independently principled — will balk at overreach

		"Mercy Otis Warren":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "The pen is mightier than any redcoat bayonet."
			governorBiography = "Playwright and historian of the revolution. Her sharp political satire keeps the movement honest."
			governorPosition = "SCHOLAR"
			governorFaction = "Patriot"
			loyalty = 7.0

		"Daniel Shays":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "The farmers have had enough. We will not be taxed into poverty."
			governorBiography = "Veteran of the Continental Army who led a farmers revolt when the revolution forgot the people who fought it."
			governorPosition = "FARMER"
			governorFaction = "Populist"
			loyalty = 1.0  # Has real grievances; loyalty fragile under low claim

		"Ualani Carlisle":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "The President does not wait for permission. She leads from the front and the briefing room and, when necessary, the battlefield."
			governorBiography = "Hawaii's finest export and Washington's current occupant — when it is not occupied. President Carlisle commands the APF personally. Her security detail has filed seventeen formal objections. She has read none of them."
			governorPosition = "PRESIDENT & COMMANDER"
			governorFaction = "Federal"
			loyalty = 20.0  # Absolute personal loyalty — this is her Republic
			questComplete = true  # Her loyalty is uncapped from the start

		"Benjamin Tallmadge":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "The Culper Ring never stopped running. It merely changed names."
			governorBiography = "Washington's spymaster and the architect of America's first intelligence network. Tallmadge ran agents behind Crown lines for six years without losing one. He is methodical, loyal, and deeply suspicious of everyone — including himself. The Codebook is his invention. The Ring is his life's work. He keeps a ledger. The ledger is encrypted. He is the only one who knows the key."
			governorPosition = "SPYMASTER"
			governorFaction = "Patriot"
			loyalty = 9.0
			addMilMod("Translator", 123)

		"Phillis Wheatley":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "Liberty and peace are not decorative concepts. They are demands."
			governorBiography = "The first published African American poet and the revolution's most inconvenient mirror. She met Washington and wrote him a poem and the poem was better than the war. Her work is circulating in British-held territories. Crown officers have begun confiscating it, which, historically speaking, is how you know a poem is working. She does not fight with a musket. She does not need to."
			governorPosition = "HERALD"
			governorFaction = "Abolitionist League"
			loyalty = 6.0

		"Francis Asbury":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "I have traveled three hundred thousand miles in this country and I am not done yet."
			governorBiography = "The Father of American Methodism arrived from England in 1771 and proceeded to cover every inch of the new nation on horseback at a pace that worried his horse. He preaches liberation theology in territories where armies cannot follow. His circuits reach the frontier settlements, the Appalachian hollows, the farmlands between battlefields. He is anti-slavery, democratic, tireless, and genuinely impossible to stop. Crown forces have twice tried to arrest him. He preached at both arresting officers. One converted."
			governorPosition = "CIRCUIT PREACHER"
			governorFaction = "Common Cause"
			loyalty = 5.0
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
	#newMM.buildSelf(type)
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
