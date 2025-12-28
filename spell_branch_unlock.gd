extends Control

class_name spellBranchUnlock

@export var typeEXP: String
@export var costEXP: int

var spellType: String
var spellLevel: int
var spellCost: int
var spellSchool: String

var layer1tex: Texture
var layer2tex: Texture
var layer3tex: Texture

var spellImage: Texture

var infoDic: Dictionary = {
}

var magicDic: Dictionary = {
}

signal returnTranslatedInfo
func buildSelf():
	spellCost = costEXP
	spellType = typeEXP
	match spellType:
		"healingPotion":
			#spellLevel = 1
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
		"draughtOfKnowledge":
			#spellLevel = 2
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
			print("RETURNDEBUG 1221", spellType)
		"fireworks":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
		"fleetingFoot":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Fleeting Foot.PNG")
		"focusingDust":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Focus Dust.PNG")
		"goldenTouch":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Golden Touch.PNG")
		"paralysis":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Paralysis.PNG")
		"poison":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Poison.PNG")
		"slimeSoldier":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Slime Soldier.PNG")
		"slimeWeapons":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Slime Weapons.PNG")
		"slimeSpitter":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Slime Spitter.PNG")
		"fleetingFoot":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Fleeting Foot.PNG")
		"waterbreathing":
			spellSchool = "Alchemy"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Waterbreathing.PNG")
		"zodiacReadings":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1316.PNG")
		"visitOracle":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1317.PNG")
		"foretellCareer":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1318.PNG")
		"diviningRods":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1322.PNG")
		"interpretCitizensDreams":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1320.PNG")
		"longTermPlanning":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1321.PNG")
		"revealPotentialFuture":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1319.PNG")
		"palantirExpedition":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1323.PNG")
		"revealDemonicPlans":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1325.PNG")
		"proclaimProphecy":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1324.PNG")
		"grantClairvoyance":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1326.PNG")
		"ominscientGaze":
			spellSchool = "Divination"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1327.PNG")
		"birdfeeders":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1328.PNG")
		"newMoonFast":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1330.PNG")
		"consecrateLand":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1329.PNG")
		"vineTangle":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1331.PNG")
		"beehives":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1332.PNG")
		"fullMoonBath":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1333.PNG")
		"spiritQuest":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1334.PNG")
		"sharkWhistle":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1335.PNG")
		"lanternbugs":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1336.PNG")
		"packLeader":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1337.PNG")
		"creatureCall":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1338.PNG")
		"freedomFire":
			spellSchool = "Druidism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1339.PNG")
		"magmaWall":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1351.PNG")
		"dislodgingWinds":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1352.PNG")
		"avalanche":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1353.PNG")
		"lightningRain":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1354.PNG")
		"heatwave":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1355.PNG")
		"lightningBolt":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1356.PNG")
		"fireGeysers":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1357.PNG")
		"manaSteal":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1358.PNG")
		"manaShield":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1359.PNG")
		"frostFall":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1360.PNG")
		"frontSlip":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1361.PNG")
		"tidalShift":
			spellSchool = "Elementalism"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1362.PNG")
		"celebration":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1363.PNG")
		"bravery":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1364.PNG")
		"attract":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1365.PNG")
		"uncontrollableLaughter":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1366.PNG")
		"nightmare":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1367.PNG")
		"galvanize":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1369.PNG")
		"darkVision":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1368.PNG")
		"solidarity":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1370.PNG")
		"depression":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1371.PNG")
		"fakeArmy":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1373.PNG")
		"perspectiveShift":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1372.PNG")
		"hypnoticControl":
			spellSchool = "Illusion"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1374.PNG")
		"summonMegaCactus":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1375.PNG")
		"summonHypoZebra":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1376.PNG")
		"summonPets":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1377.PNG")
		"summonMounts":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1378.PNG")
		"summonLawCode":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1379.PNG")
		"summonMotherload":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1380.PNG")
		"summonMercenaryArmy":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1381.PNG")
		"summonVoidWeapons":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1382.PNG")
		"summonKraken":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1383.PNG")
		"summonVessel":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1384.PNG")
		"summonMuses":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1385.PNG")
		"summonMeteor":
			spellSchool = "Summoning"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1386.PNG")
	$Tex1.texture = layer1tex
	$Tex2.texture = layer2tex
	$Tex3.texture = layer3tex
	$spelliconsprite.texture = spellImage
	$SpellIconSpritepanel.texture = spellImage
	emit_signal("returnTranslatedInfo", spellType, self)
	pass

func giveSpellInfo(schoolPoints, turnsUntil, unlocked, spellStr, spellDesc, schoolType):
	print("RETURN DEBUG GIVESPELL INFO")
	infoDic= {
		"schoolPoints": schoolPoints,
		"turnsUntil": turnsUntil,
		"unlocked": unlocked,
		"spell": spellStr,
		"description": spellDesc,
		"type": schoolType
	}
	print("RETURN DESCRIPTION", infoDic.description)
	if infoDic.description != null:
		$SpellDescription.append_text(infoDic.description)
		$SpellNameLabel.text = infoDic.spell
	
	$schoolpointslabel.text = infoDic.schoolPoints
	$turnsuntillabel.text = infoDic.turnsUntil
	print("RETURNTTRANSLATED INFO DEBUG")
	pass


func update(amount, amountPerTurn):
	$SchoolPointsRichTextLabel.clear()
	$unlocksRichTextLabel2.clear()
	print("DEBUG RETURN UPDATE")
	$SchoolPointsRichTextLabel.append_text(str(amount, "/", spellCost))
	if amount >= spellCost:
		$unlocksRichTextLabel2.append_text("unlocked")
		$Tex1.modulate = Color(1, 1, 1)
		$Tex2.modulate = Color(1, 1, 1)
		$Tex3.modulate = Color(1, 1, 1)
	else:
		$Tex1.modulate = Color(0, 0, 0)
		$Tex2.modulate = Color(0, 0, 0)
		$Tex3.modulate = Color(0, 0, 0)
		if amount > 0:
			var turnsUntilVar: int = (spellCost - amount) / amountPerTurn
			$unlocksRichTextLabel2.append_text(str(turnsUntilVar))
	pass


func _on_area_2d_mouse_entered() -> void:
	$PanelSprite.visible = true
	$SpellDescription.visible = true
	$SpellNameLabel.visible = true
	$SpellIconSpritepanel.visible = true
	$SchoolPointsRichTextLabel.visible = true
	$unlocksRichTextLabel2.visible = true
	$schoolpointslabel.visible = true
	$turnsuntillabel.visible = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	$PanelSprite.visible = false
	$SpellDescription.visible = false
	$SpellNameLabel.visible = false
	$SpellIconSpritepanel.visible = false
	$SchoolPointsRichTextLabel.visible = false
	$unlocksRichTextLabel2.visible = false
	$schoolpointslabel.visible = false
	$turnsuntillabel.visible = false
	pass # Replace with function body.
