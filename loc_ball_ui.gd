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
						"alchemy": "Alchemy",
						"divinination": "Divination",
						"druidism" : "Druidism",
						"elementalism": "Elementalism",
						"illusion": "Illusion",
						"summoning":  "Summoning",
						#Spells
						"schoolPoints": "School Points",
						"turnsUntil": "Turns Until Spell Unlock",
						"spellUnlocked": "This Spell Has Been Unlocked!",
						#AlchemySpells
						"draughtOfKnowledge": "Draught of Knowledge",
						"draughtOfKnowledgeDesc": "By consumming strange concoctions brewed up by our most intelligent brewers, we can see deeper and delve further than ever before. [color=purple]Cast on Country[/color] - +[color=purple]1[/color] to all Spellschools - Cost: [color=purple]50",
						"fireworks": "Fireworks",
						"fireworksDesc": "Fireworks Desc Goes Here, [color=purple]Cast on Country[/color]",
						"fleetingFoot": "Fleeting Foot",
						"fleetingFootDesc": "fleeting Foot Desc goes here",
						"focusDust": "Focus Dust",
						"focusDustDesc": "FocusDust Description Goes Here, [color=purple]Cast on Country[/color]",
						"goldenTouch": "Golden Touch",
						"goldenTouchDesc": "GoldenTouch Desc Goes Here, [color=purple]Cast on Country[/color]",
						"healingPotion": "Healing Potion",
						"healingPotionDesc": "We can heal our sick, wounded, and dying with the right combination of herbs, spices, and magicical supplements.[color=purple] Cast on Army[/color] - Restore [color=green]25%[/color] Manpower to owned or allied Army - Cost: [color=purple]40",
						"paralysis": "Paralysis",
						"paralysisDesc": "Paralysis Desc Goes Here, [color=purple]Cast on Country[/color]",
						"poison": "Poison",
						"poisonDesc": "Poison Desc Goes Here, [color=purple]Cast on Country[/color]",
						"slimeSoldier": "Slime Soldier",
						"slimeSoldierDesc": "Slime Soldier Description Goes Here, [color=purple]Cast on Country[/color]",
						"slimeSpitter": "Slime Spitter",
						"slimeSpitterDesc": "Slime Spitter Desc Goes Here, [color=purple]Cast on Country[/color]",
						"slimeWeapons": "Slime Weapons",
						"slimeWeaponsDesc": "By incorporation slime into our weapons crafting techniques, we can drastically cut down on war materials and costs.[color=purple] Cast on Tile [/color]- Forges in this tile produce +[color=silver]1[/color] Weapons and require [color=brown]1[color] less Wood and [color=grey]1[/color] less Metal - Cost: [color=purple] 40 ",
						"waterbreathing": "Concoction of Waterbreathing",
						"waterbreathingDesc": "Waterbreathing Desc Goes Here, [color=purple]Cast on Country[/color]"
					}
	pass
