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

var bibweyIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1156.JPG")
var bibweyBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1156 - Copy.JPG")
var tylaDinIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157.JPG")
var tylaDinIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157 - Copy.JPG")
var ornilRaIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158.JPG")
var ornilRaIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158 - Copy.JPG")
var dilnithAmenIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1159.JPG")
var dilnithAmenIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1159 - Copy.JPG")
var faEnepoIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160.JPG")
var faEnepoIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160 - Copy.JPG")
var benaxtaraIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1161.JPG")
var benaxtaraBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1161 - Copy.JPG")
var vibianKarikIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194.PNG")
var vibianKarikIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194 - Copy.PNG")
var venodamIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199.PNG")
var venodamIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199 - Copy.PNG")
var jerriwixIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201.PNG")
var jerriwixIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201 - Copy.PNG")
var qalinLingIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202.PNG")
var qalinLingIconBW: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202copy.PNG")

#borderSprites
var border1 = load("res://art assets/finishedAssets/religiousIcons/IMG_1146.PNG")
var border2 = load("res://art assets/finishedAssets/religiousIcons/IMG_1155.PNG")
var border3 = load("res://art assets/finishedAssets/religiousIcons/IMG_1154.PNG")
var border4 = load("res://art assets/finishedAssets/religiousIcons/IMG_1153.PNG")
var border5 = load("res://art assets/finishedAssets/religiousIcons/IMG_1152.PNG")

func buildSelf():
	genericDoc1 = ["Sacred Groves", "Midsummer Celebrations", "Tree of Life", "Standing Stones", "Valued Idolatry", "Healing Waters"]
	PDTDoc1 = ["Tower Control"]
	genericGods1 = ["Benaxtara", "Tyla-Dyn", "Fa Enepo", "Bibwey", "Dilnith-Amen", "Ornil-Ra"]
	genericDoc2 = ["Nature Sanctuaries", "Conservative Orthodoxy", "Sanctioned Cadaver Research", "Temple Height Restrictions"]
	genericGods2 = ["Vibian Karik", "Venodam", "Jerriwix", "Qalin Ling & Tyrus"]
	pass
