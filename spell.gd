extends Node2D

class_name spell

var spellType: String
var spellLevel: int
#var countryID: country
var experience: int #spells gain experience when used.  experience levels up a character

var spellUnlockCost: int
var spellCastCost: int
var spellCastCostPerMonth: int

var spellLongDescription: String  = "This spell has not been assigned a long description"
var spellShortDescription: String ="This spell has not been assigned a short description"
var spellSprite: Texture

var militarySpell: bool


func newGameSpellAssignment():
	match spellType:
		# ── Baseline Presidential Powers (available from game start) ─────────────
		"MANIFEST DESTINY SUBSIDY PROGRAM":
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 15
			spellShortDescription = "By executive order, plants, animals, and colonists shall reproduce with renewed vigor. The Secretary asks no questions and keeps his breeches on. Mostly."
		"THOUGHTS & PRAYERS (FEDERAL ALLOCATION)":
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 20
			spellShortDescription = "A righteous gust purges the land of foul miasma, demonic vapors, and whatever General Knox left in the tent. The Lord works in flatulent ways."
		"UNAUTHORIZED WEATHER MODIFICATION ACT":
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 100
			spellShortDescription = "Our wizards shall coax the earth's most intimate waters to the surface. She was reluctant. They were persistent. A spring has emerged. The surveyor is not asking follow-up questions."
		# ── Protector-Unlocked Presidential Powers ───────────────────────────────
		# Each unlocked by summoning the corresponding Protector (tower placed at origin tile).
		"FEDERAL ATMOSPHERIC SURVEILLANCE ACT":          # PROT_01 Mothman
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 30
			spellShortDescription = "Mothman observes all movements from great height. He sees everything. He has seen YOU. He does not look away. He does not sleep. He is looking right now. He might be judging you a little."
		"PINE BARRENS DEVELOPMENT MORATORIUM":           # PROT_02 Jersey Devil
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 25
			spellShortDescription = "The Jersey Devil holds dominion over these woods. He was born there under highly controversial circumstances and considers the territory personally his. Trespassers are corrected. Vigorously."
		"APPALACHIAN PRIVACY PROTECTION ACT":            # PROT_03 Wood Booger
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 35
			spellShortDescription = "Your armies move unseen through the Blue Ridge. The Wood Booger is enormous, silent, and extremely private about the Appalachians. The tracks are larger than logic permits. The DMA has no record of anything moving through those ridgelines. Neither will anyone else."
		"EXECUTIVE WEATHER CONTROL INITIATIVE":          # PROT_04 Pamola
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 50
			spellShortDescription = "Pamola has come down from Katahdin. The storm that arrives does not distinguish between an army and a hillside — it simply arrives, total and sudden, from a direction that was not in any forecast. Enemy formations scatter. The mountain does not file reports."
		"CLASSIFIED TACTICAL TERROR BUDGET":             # PROT_05 Headless Horseman
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 45
			spellShortDescription = "The Horseman rides at full gallop toward enemy lines. He cannot aim, having no head, but compensates with enthusiasm. Enemy commanders report being unsettled in ways they decline to specify in their reports."
		"GOATMAN'S JUDGEMENT":                           # PROT_06 Goatman
			militarySpell = true
			spellSprite = load("res://art assets/finishedAssets/governors/goatman.png")
			spellCastCost = 50
			spellShortDescription = "Cast on any army at 20% shield or below. The Goatman emerges from the Maryland treeline and finishes the job. He does not negotiate at this stage. He does not have to."
		"BELL WITCH'S GIFT":                             # PROT_07 Bell Witch
			militarySpell = true
			spellSprite = load("res://art assets/finishedAssets/governors/bell_witch.png")
			spellCastCost = 55
			spellShortDescription = "Cast on an allied army. The Bell Witch produces a gift from a velvet case that smells of Tennessee cedar. Recipients report +3 Attack across all units for 3 turns. The DMA field report describes the gift only as 'non-standard configuration.' The army reports no complaints. Several enthusiastic ones, actually."
		"NAVAL SUPERIORITY MAINTENANCE DIRECTIVE":       # PROT_08 Old Ironsides
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 60
			spellShortDescription = "Old Ironsides has survived more broadsides than any man of war in history and still cuts a fine figure in harbor. She has eaten three admirals who tried to retire her. Her timbers have endured all manner of insult and request more."
		"COLD WEATHER RESILIENCE FUNDING ACT":           # PROT_09 Valley Forge Guardian
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 35
			spellShortDescription = "Our men survived Valley Forge with frozen breeches and fierce determination. They shall endure again. Extra breeches have been procured. The Commissary General assures us they are mostly dry this time."
		"INTER-AGENCY CRYPTID INTEGRATION PROGRAM":      # PROT_10 Snallygaster
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 45
			spellShortDescription = "A Snallygaster has been assigned to this region and has signed the relevant articles. He is enormous, many-tentacled, and surprisingly diligent. The other clerks avoid his desk area. The smell is distinct."
		"BLACK DOG WATCH PROTOCOL":                      # PROT_11 Black Dog
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 40
			spellShortDescription = "The Black Dog of the Hanging Hills has been observed in the target area. This is either the first sighting or the third, depending on enemy scouting records. Advise Crown patrols to stop counting their encounters. They are unlikely to do so. The DMA considers this satisfactory."
		"MERCY BROWN'S COMPACT":                         # PROT_12 Mercy Brown
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 50
			spellShortDescription = "Mercy Brown's interests in the area have been formalized. She operates nocturnally, which is when Crown supply convoys believe they are unobserved. Crown units in the target area begin filing medical reports describing chronic fatigue of unknown origin. The DMA has stopped asking her to specify what she is doing. She finds the question unnecessary."
		"LAKE CHAMPLAIN SOVEREIGNTY DECREE":             # PROT_13 Champ
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 30
			spellShortDescription = "Lake Champlain is controlled by a large aquatic entity with territorial opinions and first-documented-sighting credentials dating to 1609. Crown vessels attempting transit report structural complications. Champ does not file explanations. The admiralty has stopped requesting them."

		"FLORIDA CRYPTID INTEGRATION TASK FORCE":        # PROT_15 Skunk Ape
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 35
			spellShortDescription = "The Skunk Ape has been deployed to your wetlands. He is massive, fragrant, and passionate about swamp sovereignty. Enemy scouts report being overwhelmed on two fronts: the creature's considerable size and its personal scent, which lingers for three turns."
		"CULPER RING":   # PROT_16 Agent 355
			militarySpell = false
			spellSprite = load("res://art assets/finishedAssets/governors/agent_355.png")
			spellCastCost = 60
			spellShortDescription = "The Culper Ring's network is activated on the target tile. All enemy units stationed there suffer -5% shield loss per turn as their movements, supply lines, and communications are exposed. The tile is permanently revealed to Continental intelligence. She does not need to be in the room."
		"EMANCIPATION PROCLAMATION 2: STILL EMANCIPATING":  # PROT_17 Lincoln's Ghost
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 70
			spellShortDescription = "The President, speaking from beyond mortality, assures us the work of freedom is never finished. He is still haunting the White House. He has strong opinions about the East Bedroom and will express them in full to anyone who enters, at any hour of the night."
	pass
