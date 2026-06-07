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
			addMilMod("Visionary", 123)
			addMilMod("Champion of the Sun", 23)
			addMilMod("Healer", 3)
 
		"Abigail Adams":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "Remember the ladies, or we will foment our own rebellion."
			governorBiography = "Wife, intellectual, and the conscience of the revolution. Pushes the movement toward its own stated ideals."
			governorPosition = "DIPLOMAT"
 
		"Thomas Paine":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "Common sense is not so common. Government is a necessary evil at best."
			governorBiography = "English immigrant turned American revolutionary. His pamphlets lit the fire. He believes in the people absolutely."
			governorPosition = "SCHOLAR"
 
		"Mercy Otis Warren":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "The pen is mightier than any redcoat bayonet."
			governorBiography = "Playwright and historian of the revolution. Her sharp political satire keeps the movement honest."
			governorPosition = "SCHOLAR"
 
		"Daniel Shays":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "The farmers have had enough. We will not be taxed into poverty."
			governorBiography = "Veteran of the Continental Army who led a farmers revolt when the revolution forgot the people who fought it."
			governorPosition = "FARMER"

		"Ualani Carlisle":
			governorTexture = load("res://art assets/Placeholder Art/character/4-22-Ikra-Colors - Copy.png")
			governorDescription = "The President does not wait for permission. She leads from the front and the briefing room and, when necessary, the battlefield."
			governorBiography = "Hawaii's finest export and Washington's current occupant — when it is not occupied. President Carlisle commands the APF personally. Her security detail has filed seventeen formal objections. She has read none of them."
			governorPosition = "PRESIDENT & COMMANDER"
	pass

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
