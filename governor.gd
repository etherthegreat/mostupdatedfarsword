extends Node2D

class_name governor

var governorType: String #used to calculate rewards and quests
var governorPosition: String #used to determine the character's name

var governorLevel: int
var governorTexture: Texture
var governorDescription: String
var governorBiography: String

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
		"Wolverina Gundo":
			governorTexture = load("res://art assets/Placeholder Art/character/F3 - Copy.png")
			governorDescription = "Escaped slave, returning to her homeland to free her hypnotized brethren."
			governorBiography = "born in 1845, pittsburg ohio, sloberina gundo is the son of john f kennedy, also known as professor sex of the sex men.  will wolverina live up to her father's expectations or cum before the lord unashamed and loved dearly."
			coastal = false
			governorBuildingRequirement = "None"
			governorPosition = "FARMER"
			addMilMod("Visionary", 123)
			addMilMod("Champion of the Sun", 23)
			addMilMod("Healer", 3)
		"Wello Jenni-Tur":
			governorTexture = load("res://art assets/Placeholder Art/character/F4 - Copy.png")
			governorDescription = "Robo Cyborg visionary of the science demon wizard goblins."
			governorBiography = "born in 1845, pittsburg ohio, sloberina gundo is the son of john f kennedy, also known as professor sex of the sex men.  will wolverina live up to her father's expectations or cum before the lord unashamed and loved dearly."
			coastal = false
			governorPosition = "FARMER"
			governorBuildingRequirement = "None"
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
