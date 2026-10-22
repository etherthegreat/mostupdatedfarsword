extends Node2D

class_name locBallUI

var menuDic: Dictionary = {}

var resourcesDic: Dictionary = {}
var tilesDic: Dictionary = {}
var buildingsDic: Dictionary = {}
var technologyDic: Dictionary = {}
var faithDic: Dictionary = {}
var magicDic: Dictionary = {}
var governmentDic: Dictionary = {}

func buildSelf(domain, gameLanguage):
	match domain:
		"Menu":
			match gameLanguage:
				"eng":
					menuDic = {
						"New Game": "New Game",
						"Load Game": "Load Game",
						"Gallery": "Gallery",
						"Settings" : "Settings",
						"Exit" : "Exit"
					}
				"spa":
					menuDic = {
						"New Game": "Juego Nuevo",
						"Load Game": "Cargar",
						"Gallery": "Gallery",
						"Settings" : "Settings",
						"Exit" : "Exit"
					}
		"Game":
			match gameLanguage:
				"eng":
					magicDic = {
						"manifest": "Manifest Doctrine",
						"liberty":  "Liberty Rites",
						"storm":    "Stormcraft",
						"iron":     "Ironclad Arts",
						"spectral": "Spectrology",
						"cryptid":  "Cryptidology",
						#Spells
						"schoolPoints": "School Points",
						"turnsUntil": "Turns Until Spell Unlock",
						"spellUnlocked": "This Spell Has Been Unlocked!",
						#AlchemySpells
						"draughtOfKnowledge": "Draught of Knowledge",
						"draughtOfKnowledgeDesc": "By consumming strange concoctions brewed up by our most intelligent brewers, we can see deeper and delve further than ever before. [color=purple]Cast on Country[/color] - +[color=purple]1[/color] to all Spellschools - Cost: [color=purple]50",
						"fireworks": "Fireworks",
						"fireworksDesc": "Celebratory spellcraft turns folk tradition into fuel for the Continental will. Powder and color and sound — the crowd remembers what it is fighting for. [color=purple]Cast on Country[/color] - +[color=gold]10[/color] Culture and +[color=teal]5[/color] Harmony for [color=purple]2[/color] turns - Cost: [color=purple]35",
						"fleetingFoot": "Fleeting Foot",
						"fleetingFootDesc": "The old road-walkers knew tricks to cover ground before sunrise. With the right preparation, an army can move like rumor through a territory. [color=purple]Cast on Army[/color] - Grant this army +[color=teal]2[/color] Movement Points this turn - Cost: [color=purple]30",
						"focusDust": "Focus Dust",
						"focusDustDesc": "A pinch of silver-ground mineral scattered before the advance. The soldiers feel sharper — eyes clear, hands steady, aim true. [color=purple]Cast on Army[/color] - +[color=orange]3[/color] Attack for [color=purple]2[/color] turns - Cost: [color=purple]35",
						"goldenTouch": "Golden Touch",
						"goldenTouchDesc": "The old alchemists understood that gold was not found — it was made. Our republic has learned to make it flow. [color=purple]Cast on Country[/color] - +[color=gold]25[/color] Gold over the next [color=purple]3[/color] turns - Cost: [color=purple]45",
						"healingPotion": "Healing Potion",
						"healingPotionDesc": "We can heal our sick, wounded, and dying with the right combination of herbs, spices, and magicical supplements.[color=purple] Cast on Army[/color] - Restore [color=green]25%[/color] Manpower to owned or allied Army - Cost: [color=purple]40",
						"paralysis": "Paralysis",
						"paralysisDesc": "A binding hex older than the republic, now harnessed and directed. The enemy army locks in place — unable to march, unable to act. [color=purple]Cast on Enemy Army[/color] - Target army loses all Movement Points for [color=purple]1[/color] turn - Cost: [color=purple]40",
						"poison": "Poison",
						"poisonDesc": "The Continental alchemists refined battlefield toxins from regional plants — sumac, nightshade, hemlock root. Not to kill outright — to wear down and demoralize. [color=purple]Cast on Enemy Army[/color] - Apply [color=green]Poisoned[/color]: -[color=orange]2[/color] Attack and -[color=green]5%[/color] Manpower per turn for [color=purple]3[/color] turns - Cost: [color=purple]45",
						"slimeSoldier": "Slime Soldier",
						"slimeSoldierDesc": "Animate a mass of bog-slime into a fighting shape — crude, tireless, and expendable. It asks no wages and fears no wound. [color=purple]Cast on Allied Tile[/color] - Summon a temporary Slime Soldier unit to reinforce the stationed army for [color=purple]3[/color] turns - Cost: [color=purple]55",
						"slimeSpitter": "Slime Spitter",
						"slimeSpitterDesc": "A smaller construct than the Slime Soldier, but far more useful behind a line — trained to hurl corrosive matter at range before the main ranks close. [color=purple]Cast on Allied Tile[/color] - Summon a Slime Spitter unit with Ranged capability for [color=purple]3[/color] turns - Cost: [color=purple]50",
						"slimeWeapons": "Slime Weapons",
						"slimeWeaponsDesc": "By incorporation slime into our weapons crafting techniques, we can drastically cut down on war materials and costs.[color=purple] Cast on Tile [/color]- Forges in this tile produce +[color=silver]1[/color] Weapons and require [color=brown]1[color] less Wood and [color=grey]1[/color] less Metal - Cost: [color=purple] 40 ",
						"waterbreathing": "Concoction of Waterbreathing",
						"waterbreathingDesc": "The old river-divers of the French settlements knew a formula passed down through generations. With their notes recovered, our armies can push through fords and coastal straits no enemy would expect. [color=purple]Cast on Army[/color] - Grant this army free movement through coastal and river tiles for [color=purple]3[/color] turns - Cost: [color=purple]40"
					}
