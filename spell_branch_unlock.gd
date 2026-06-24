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
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Health Potion.PNG")
		"draughtOfKnowledge":
			#spellLevel = 2
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Draught of Knowledge.PNG")
		"fireworks":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Fireworks.PNG")
		"fleetingFoot":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Fleeting Foot.PNG")
		"focusingDust":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Focus Dust.PNG")
		"goldenTouch":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Golden Touch.PNG")
		"paralysis":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Paralysis.PNG")
		"poison":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Poison.PNG")
		"slimeSoldier":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Slime Soldier.PNG")
		"slimeWeapons":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Slime Weapons.PNG")
		"slimeSpitter":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Slime Spitter.PNG")
		"fleetingFoot":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Fleeting Foot.PNG")
		"waterbreathing":
			spellSchool = "Manifest Doctrine"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/Waterbreathing.PNG")
		"zodiacReadings":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1316.PNG")
		"visitOracle":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1317.PNG")
		"foretellCareer":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1318.PNG")
		"diviningRods":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1322.PNG")
		"interpretCitizensDreams":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1320.PNG")
		"longTermPlanning":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1321.PNG")
		"revealPotentialFuture":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1319.PNG")
		"palantirExpedition":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1323.PNG")
		"revealDemonicPlans":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1325.PNG")
		"proclaimProphecy":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1324.PNG")
		"grantClairvoyance":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1326.PNG")
		"ominscientGaze":
			spellSchool = "Liberty Rites"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1327.PNG")
		"birdfeeders":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1328.PNG")
		"newMoonFast":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1330.PNG")
		"consecrateLand":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1329.PNG")
		"vineTangle":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1331.PNG")
		"beehives":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1332.PNG")
		"fullMoonBath":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1333.PNG")
		"spiritQuest":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1334.PNG")
		"sharkWhistle":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1335.PNG")
		"lanternbugs":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1336.PNG")
		"packLeader":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1337.PNG")
		"creatureCall":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1338.PNG")
		"freedomFire":
			spellSchool = "Stormcraft"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1339.PNG")
		"magmaWall":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1351.PNG")
		"dislodgingWinds":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1352.PNG")
		"avalanche":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1353.PNG")
		"lightningRain":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1354.PNG")
		"heatwave":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1355.PNG")
		"lightningBolt":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1356.PNG")
		"fireGeysers":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1357.PNG")
		"manaSteal":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1358.PNG")
		"manaShield":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1359.PNG")
		"frostFall":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1360.PNG")
		"frontSlip":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1361.PNG")
		"tidalShift":
			spellSchool = "Ironclad Arts"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1362.PNG")
		"celebration":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1363.PNG")
		"bravery":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1364.PNG")
		"attract":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1365.PNG")
		"uncontrollableLaughter":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1366.PNG")
		"nightmare":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1367.PNG")
		"galvanize":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1369.PNG")
		"darkVision":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1368.PNG")
		"solidarity":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1370.PNG")
		"depression":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1371.PNG")
		"fakeArmy":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1373.PNG")
		"perspectiveShift":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1372.PNG")
		"hypnoticControl":
			spellSchool = "Spectrology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1374.PNG")
		"summonMegaCactus":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1375.PNG")
		"summonHypoZebra":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1376.PNG")
		"summonPets":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1377.PNG")
		"summonMounts":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1378.PNG")
		"summonLawCode":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1379.PNG")
		"summonMotherload":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/Spells/Green 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/Spells/Green 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/Spells/Green 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1380.PNG")
		"summonMercenaryArmy":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Orange 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Orange 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Orange 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1381.PNG")
		"summonVoidWeapons":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Yellow 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1382.PNG")
		"summonKraken":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Red 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Red 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Red 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1383.PNG")
		"summonVessel":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Purple 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Purple 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Purple 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1384.PNG")
		"summonMuses":
			spellSchool = "Cryptidology"
			layer1tex = load("res://art assets/Placeholder Art/spellbacks/Blue 1.PNG")
			layer2tex = load("res://art assets/Placeholder Art/spellbacks/Blue 2.PNG")
			layer3tex = load("res://art assets/Placeholder Art/spellbacks/Blue 3.PNG")
			spellImage = load("res://art assets/Placeholder Art/Spells/IMG_1385.PNG")
		"summonMeteor":
			spellSchool = "Cryptidology"
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

func giveSpellInfo(schoolPoints, turnsUntil, unlocked, spellStr, spellDesc, schoolType):
	infoDic= {
		"schoolPoints": schoolPoints,
		"turnsUntil": turnsUntil,
		"unlocked": unlocked,
		"spell": spellStr,
		"description": spellDesc,
		"type": schoolType
	}
	if infoDic.description != null:
		$SpellDescription.append_text(infoDic.description)
		$SpellNameLabel.text = infoDic.spell
	
	$schoolpointslabel.text = infoDic.schoolPoints
	$turnsuntillabel.text = infoDic.turnsUntil


func update(amount, amountPerTurn):
	$SchoolPointsRichTextLabel.clear()
	$unlocksRichTextLabel2.clear()
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


func _on_area_2d_mouse_entered() -> void:
	$PanelSprite.visible = true
	$SpellDescription.visible = true
	$SpellNameLabel.visible = true
	$SpellIconSpritepanel.visible = true
	$SchoolPointsRichTextLabel.visible = true
	$unlocksRichTextLabel2.visible = true
	$schoolpointslabel.visible = true
	$turnsuntillabel.visible = true


func _on_area_2d_mouse_exited() -> void:
	$PanelSprite.visible = false
	$SpellDescription.visible = false
	$SpellNameLabel.visible = false
	$SpellIconSpritepanel.visible = false
	$SchoolPointsRichTextLabel.visible = false
	$unlocksRichTextLabel2.visible = false
	$schoolpointslabel.visible = false
	$turnsuntillabel.visible = false
