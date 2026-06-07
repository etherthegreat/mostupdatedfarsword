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
			spellShortDescription = "Increase plant and animal reproduction rates. \nFunding approved. Farmers not consulted."
		"THOUGHTS & PRAYERS (FEDERAL ALLOCATION)":
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 20
			spellShortDescription = "Disperse demonic miasma via officially-sanctioned gusts. \nThe Secretary sends his regards."
		"UNAUTHORIZED WEATHER MODIFICATION ACT":
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 100
			spellShortDescription = "Raise the water table. Officially this is not happening. \nPlease disregard any associated paperwork."
		# ── Protector-Unlocked Presidential Powers ───────────────────────────────
		# Each unlocked by summoning the corresponding Protector (tower placed at origin tile).
		"FEDERAL ATMOSPHERIC SURVEILLANCE ACT":          # PROT_01 Mothman
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 30
			spellShortDescription = "Enhanced sky-watching. The agency denies all knowledge of the asset."
		"PINE BARRENS DEVELOPMENT MORATORIUM":           # PROT_02 Jersey Devil
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 25
			spellShortDescription = "No one develops the Pine Barrens. Not now. Not ever. Don't ask why."
		"PACIFIC NORTHWEST PRIVACY PROTECTION ACT":      # PROT_03 Bigfoot
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 35
			spellShortDescription = "Your armies move unseen. Your tracks are large but officially unconfirmed."
		"EXECUTIVE WEATHER CONTROL INITIATIVE":          # PROT_04 Thunderbird
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 50
			spellShortDescription = "Redirect storms. The Thunderbird does not have a W-2. This is fine."
		"CLASSIFIED TACTICAL TERROR BUDGET":             # PROT_05 Headless Horseman
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 45
			spellShortDescription = "Deploy psychological pressure. Asset is headless. Morale impact: significant."
		"CHESAPEAKE WATERS RECLAMATION PROJECT":         # PROT_06 Chessie
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 40
			spellShortDescription = "Revitalize bay resources. Chessie is cooperative and has been fed."
		"DEPARTMENT OF PSYCHOLOGICAL OPERATIONS":        # PROT_07 Bell Witch
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 55
			spellShortDescription = "Undermine enemy morale through targeted haunting. Budget: classified."
		"NAVAL SUPERIORITY MAINTENANCE DIRECTIVE":       # PROT_08 Old Ironsides
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 60
			spellShortDescription = "She doesn't sink. We have tried to retire her. She refuses."
		"COLD WEATHER RESILIENCE FUNDING ACT":           # PROT_09 Valley Forge Guardian
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 35
			spellShortDescription = "Troops endure winter conditions. Valley Forge: a learning experience, apparently."
		"INTER-AGENCY CRYPTID INTEGRATION PROGRAM":      # PROT_10 Snallygaster
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 45
			spellShortDescription = "Assign a Snallygaster to a region. HR paperwork pending."
		"MIDNIGHT EMERGENCY MOBILIZATION ORDER":         # PROT_11 Paul Revere
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 40
			spellShortDescription = "Move armies at night, very fast, loudly. One if by land, two if by sea, three if extremely urgent."
		"FREEDOM RESONANCE AMPLIFICATION DECREE":        # PROT_12 Liberty Bell
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 50
			spellShortDescription = "Ring the bell. Boost mandate and happiness. The crack is a feature."
		"RURAL SPECTRAL INVESTMENT INITIATIVE":          # PROT_13 Green Mountain Ghost
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 30
			spellShortDescription = "Boost development in forested regions via spectral oversight. Ghost: enthusiastic."
		"MONUMENT-BASED ECONOMIC STIMULUS PACKAGE":      # PROT_14 Mount Rushmore
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 65
			spellShortDescription = "Leverage national monuments for income. The presidents' expressions: unchanged."
		"FLORIDA CRYPTID INTEGRATION TASK FORCE":        # PROT_15 Skunk Ape
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			spellCastCost = 35
			spellShortDescription = "Assign swamp assets to wetland tiles. Smells like success."
		"PERMANENT READINESS MANDATE (EXPIRES NEVER)":   # PROT_16 Eternal Minuteman
			militarySpell = true
			spellSprite = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
			spellCastCost = 75
			spellShortDescription = "Armies are always ready. The Minuteman has been ready since 1775 and is frankly a little intense about it."
		"EMANCIPATION PROCLAMATION 2: STILL EMANCIPATING":  # PROT_17 Lincoln's Ghost
			militarySpell = false
			spellSprite = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
			spellCastCost = 70
			spellShortDescription = "Freedom, again, with feeling. Lincoln is pleased. Also still a ghost. These are related."
	pass
