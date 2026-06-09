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
var sacredGrovesBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1150 - Copy.JPG")
var midsummerCelebrationsIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1147.JPG")
var midsummerCelebrationsBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1147 - Copy.JPG")
var treeOfLifeIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1143.JPG")
var treeOfLifeBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1143 - Copy.JPG")
var standingStonesIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1144.JPG")
var standingStonesBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1144 - Copy.JPG")
var valuedIdolatryIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1145.JPG")
var valuedIdolatryBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1145 - Copy.JPG")
var healingWatersIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1148.JPG")
var healingWatersBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1148 - Copy.JPG")
var towerControlIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/tower1.JPG")
var towerControlBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1149.JPG")
var natureSanctuariesIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1195.PNG")
var natureSanctuariesIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1195 - Copy.PNG")
var conservativeOrthodoxyIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1196.PNG")
var conservativeOrthodoxyIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1196 - Copy.PNG")
var sanctionedCadaverResearchIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1197.PNG")
var sanctionedCadaverResearchIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1197 - Copy.PNG")
var templeHeightLawsIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1198.PNG")
var templeHeightLawsIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1198 - Copy.PNG")

# American Icons — placeholder art reusing existing textures until portraits are commissioned
# Founding Era (tier 1)
var washingtonIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1156.JPG")
var washingtonBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1156 - Copy.JPG")
var franklinIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157.JPG")
var franklinBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157 - Copy.JPG")
var abigailAdamsIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158.JPG")
var abigailAdamsBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158 - Copy.JPG")
var hamiltonIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1159.JPG")
var hamiltonBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1159 - Copy.JPG")
var phillisWheatleyIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160.JPG")
var phillisWheatleyBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160 - Copy.JPG")
var jeffersonIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1161.JPG")
var jeffersonBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1161 - Copy.JPG")
# 1800s (tier 2)
var lincolnIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194.PNG")
var lincolnBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194 - Copy.PNG")
var tubmanIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199.PNG")
var tubmanBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199 - Copy.PNG")
var douglassIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201.PNG")
var douglassBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201 - Copy.PNG")
var sittingBullIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202.PNG")
var sittingBullBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202copy.PNG")
var sojournerTruthIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1156.JPG")
var sojournerTruthBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1156 - Copy.JPG")
var chiefJosephIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157.JPG")
var chiefJosephBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157 - Copy.JPG")
# 20th Century (tier 2)
var teddyRooseveltIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158.JPG")
var teddyRooseveltBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158 - Copy.JPG")
var susanBAnthonyIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1159.JPG")
var susanBAnthonyBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1159 - Copy.JPG")
var idaBWellsIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160.JPG")
var idaBWellsBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160 - Copy.JPG")
var eleanorRooseveltIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1161.JPG")
var eleanorRooseveltBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1161 - Copy.JPG")
var martinLutherKingIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194.PNG")
var martinLutherKingBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194 - Copy.PNG")
var cesarChavezIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199.PNG")
var cesarChavezBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199 - Copy.PNG")
var jimmyCarterIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201.PNG")
var jimmyCarterBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201 - Copy.PNG")
var doloresHuertaIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202.PNG")
var doloresHuertaBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202copy.PNG")

#borderSprites
var border1 = load("res://art assets/finishedAssets/religiousIcons/IMG_1146.PNG")
var border2 = load("res://art assets/finishedAssets/religiousIcons/IMG_1155.PNG")
var border3 = load("res://art assets/finishedAssets/religiousIcons/IMG_1154.PNG")
var border4 = load("res://art assets/finishedAssets/religiousIcons/IMG_1153.PNG")
var border5 = load("res://art assets/finishedAssets/religiousIcons/IMG_1152.PNG")

func buildSelf():
	genericDoc1 = ["Sacred Groves", "Midsummer Celebrations", "Tree of Life", "Standing Stones", "Valued Idolatry", "Healing Waters"]
	PDTDoc1 = ["Tower Control"]
	genericGods1 = ["George Washington", "Benjamin Franklin", "Abigail Adams", "Alexander Hamilton", "Phillis Wheatley", "Thomas Jefferson"]
	genericDoc2 = ["Nature Sanctuaries", "Conservative Orthodoxy", "Sanctioned Cadaver Research", "Temple Height Restrictions"]
	genericGods2 = ["Abraham Lincoln", "Harriet Tubman", "Frederick Douglass", "Sitting Bull", "Sojourner Truth", "Chief Joseph", "Theodore Roosevelt", "Susan B. Anthony", "Ida B. Wells", "Eleanor Roosevelt", "Martin Luther King Jr.", "Cesar Chavez", "Jimmy Carter", "Dolores Huerta"]
	pass
