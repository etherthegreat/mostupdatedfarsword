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
	pass
