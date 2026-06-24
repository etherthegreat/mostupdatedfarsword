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
		"PACIFIC NORTHWEST PRIVACY PROTECTION ACT":      # PROT_03 Bigfoot
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 35
			spellShortDescription = "Your armies move unseen, like a large hairy man through the ferns. The tracks are enormous, the evidence abundant, and yet the government swears it isn't there. Your scouts learn from the best."
		"EXECUTIVE WEATHER CONTROL INITIATIVE":          # PROT_04 Thunderbird
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 50
			spellShortDescription = "The Thunderbird, when properly aroused, shall release storms of such fury that enemy formations scatter. He is ancient, tremendous, and requires considerable coaxing. The results are worth the effort."
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
		"DEPARTMENT OF PSYCHOLOGICAL OPERATIONS":        # PROT_07 Bell Witch
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 55
			spellShortDescription = "The Bell Witch shall visit enemy commanders in the night and make herself thoroughly unforgettable. What happened to Andrew Jackson in that farmhouse remains classified. He still flinches at bells."
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
		"MIDNIGHT EMERGENCY MOBILIZATION ORDER":         # PROT_11 Paul Revere
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 40
			spellShortDescription = "Mr. Revere rides through the night in a state of considerable agitation. One if by land, two if by sea, three if everyone should put their breeches on this instant and leave through the back."
		"FREEDOM RESONANCE AMPLIFICATION DECREE":        # PROT_12 Liberty Bell
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 50
			spellShortDescription = "Ring the bell. Let freedom's resonance stir the passions of free men and women everywhere. They are stirred. Vigorously. No one is taking responsibility for the crack."
		"RURAL SPECTRAL INVESTMENT INITIATIVE":          # PROT_13 Green Mountain Ghost
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 30
			spellShortDescription = "The Green Mountain Ghost haunts your forests in a professional capacity, encouraging settlers to greater productivity through nocturnal visitations. Settlers report working harder, sleeping less, and declining to elaborate on specifics."

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
