extends Node2D

#genericCollections

var genericDoc1: Array = []
var genericDoc2: Array = []

var genericGods1: Array = []
var genericGods2: Array = []


 #countrySpecificCollections
var PDTDoc1: Array = []
var PDTDoc2: Array = []

var PDTGods1: Array = []
var PDTGods2: Array = []

#visualIconsLoaded
var sacredGrovesIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1150.JPG")
var midsummerCelebrationsIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1147.JPG")
var treeOfLifeIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1143.JPG")

var standingStonesIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1144.JPG")
var standingStonesBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1144 - Copy.JPG")
var valuedIdolatryIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1145.JPG")
var healingWatersIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1148.JPG")
var healingWatersBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1148 - Copy.JPG")
var towerControlIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1149.JPG")

#borderSprites
var border1 = load("res://art assets/finishedAssets/religiousIcons/IMG_1146.PNG")

func buildSelf():
	genericDoc1 = ["Sacred Groves", "Midsummer Celebrations", "Tree of Life", "Standing Stones", "Valued Idolatry", "Healing Waters"]
	PDTDoc1 = ["Tower Control"]
	pass
