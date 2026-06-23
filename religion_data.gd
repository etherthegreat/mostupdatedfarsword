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

var CADoc1: Array = []
var CADoc2: Array = []
var CADocSpecial: Array = []
var CAGods1: Array = []
var CAGods2: Array = []

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
var franklinIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/benjamin_franklin.png")
var franklinBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/benjamin_franklin_bw.png")
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
var lincolnBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1755.PNG")
var tubmanIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199.PNG")
var tubmanBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199 - Copy.PNG")
var douglassIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201.PNG")
var douglassBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201 - Copy.PNG")
var sittingBullIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202.PNG")
var sittingBullBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202copy.PNG")
var sojournerTruthIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/sojourner_truth.png")
var sojournerTruthBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/sojourner_truth_bw.png")
var markTwainIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/mark_twain.png")
var markTwainBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/mark_twain_bw.png")
var malcolmXIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/malcolm_x.png")
var malcolmXBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/malcolm_x_bw.png")
var chiefJosephIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157.JPG")
var chiefJosephBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157 - Copy.JPG")
# 20th Century (tier 2)
var teddyRooseveltIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158.JPG")
var teddyRooseveltBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158 - Copy.JPG")
var susanBAnthonyIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1159.JPG")
var susanBAnthonyBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1159 - Copy.JPG")
var idaBWellsIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160.JPG")
var idaBWellsBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160 - Copy.JPG")
var eleanorRooseveltIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/eleanor_roosevelt.png")
var eleanorRooseveltBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/eleanor_roosevelt_bw.png")
var martinLutherKingIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/martin_luther_king.png")
var martinLutherKingBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/martin_luther_king_bw.png")
var cesarChavezIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199.PNG")
var cesarChavezBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199 - Copy.PNG")
var jimmyCarterIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201.PNG")
var jimmyCarterBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201 - Copy.PNG")
var doloresHuertaIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202.PNG")
var doloresHuertaBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202copy.PNG")
var johnBrownIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/john_brown.png")
var johnBrownBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/john_brown_bw.png")
var maryEdwardsWalkerIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/mary_edwards_walker.png")
var maryEdwardsWalkerBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/mary_edwards_walker_bw.png")

# Canadian Icons — placeholder art (reuses American icon textures until portraits are commissioned)
# CAGods1 — Founding Era (6 items): reuse IMG_1156–1161
var macdonaldIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1156.JPG")
var macdonaldBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1156 - Copy.JPG")
var cartierIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157.JPG")
var cartierBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1157 - Copy.JPG")
var laurierIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158.JPG")
var laurierBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1158 - Copy.JPG")
var macphailIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/agnes_macphail.png")
var macphailBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/agnes_macphail_bw.png")
var lauraSecordIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160.JPG")
var lauraSecordBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1160 - Copy.JPG")
var laFontaineIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/louis_hippolyte_lafontaine.png")
var laFontaineBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/louis_hippolyte_lafontaine_bw.png")
# CAGods2 — Modern Era (14 items): reuse IMG_1194, 1199, 1201, 1202 cycling
var tommyDouglasIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194.PNG")
var tommyDouglasBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194 - Copy.PNG")
var violaDesmondIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199.PNG")
var violaDesmondBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199 - Copy.PNG")
var pearsonIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201.PNG")
var pearsonBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201 - Copy.PNG")
var louisRielIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202.PNG")
var louisRielBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202copy.PNG")
var emilyMurphyIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194.PNG")
var emilyMurphyBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194 - Copy.PNG")
var nellieMcClungIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199.PNG")
var nellieMcClungBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199 - Copy.PNG")
var terryFoxIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201.PNG")
var terryFoxBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201 - Copy.PNG")
var chiefDanGeorgeIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202.PNG")
var chiefDanGeorgeBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202copy.PNG")
var buffySaintMarieIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194.PNG")
var buffySaintMarieBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194 - Copy.PNG")
var davidSuzukiIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199.PNG")
var davidSuzukiBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199 - Copy.PNG")
var romeoDallaireIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201.PNG")
var romeoDallaireBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1201 - Copy.PNG")
var thereseCasgrainIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202.PNG")
var thereseCasgrainBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1202copy.PNG")
var maryTwoAxeEarleyIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194.PNG")
var maryTwoAxeEarleyBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1194 - Copy.PNG")
var pierreTrudeauIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199.PNG")
var pierreTrudeauBWIcon: Texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1199 - Copy.PNG")

#borderSprites
var border1 = load("res://art assets/finishedAssets/religiousIcons/IMG_1146.PNG")
var border2 = load("res://art assets/finishedAssets/religiousIcons/IMG_1155.PNG")
var border3 = load("res://art assets/finishedAssets/religiousIcons/IMG_1154.PNG")
var border4 = load("res://art assets/finishedAssets/religiousIcons/IMG_1153.PNG")
var border5 = load("res://art assets/finishedAssets/religiousIcons/IMG_1152.PNG")

func buildSelf():
	genericDoc1 = ["Nature Conservationists", "Civic Pride", "Pioneer Heritage", "Landmark Heritage", "Sherman Antitrust Act", "Social Security Act"]
	PDTDoc1 = ["Defense Production Act"]
	genericGods1 = ["George Washington", "Benjamin Franklin", "Abigail Adams", "Alexander Hamilton", "Phillis Wheatley", "Thomas Jefferson"]
	genericDoc2 = ["Inland Maritime Expertise", "First Amendment", "National Research Act", "Height of Buildings Act"]
	genericGods2 = ["Abraham Lincoln", "Harriet Tubman", "Frederick Douglass", "Sitting Bull", "Sojourner Truth", "Chief Joseph", "Theodore Roosevelt", "Susan B. Anthony", "Ida B. Wells", "Eleanor Roosevelt", "Martin Luther King Jr.", "Cesar Chavez", "Jimmy Carter", "Dolores Huerta", "John Brown", "Mary Edwards Walker", "Mark Twain", "Malcolm X"]
	CADoc1 = ["Nature Conservationists", "Canada Council for the Arts Act", "Republic Lands Act", "Historic Sites and Monuments Act", "Combines Investigation Act", "Canada Health Act"]
	CADoc2 = ["National Parks Act", "Charter of Rights and Freedoms", "Medical Research Council Act", "National Building Code of Canada"]
	CADocSpecial = ["War Measures Act"]
	CAGods1 = ["John A. Macdonald", "George-Étienne Cartier", "Wilfrid Laurier", "Agnes Macphail", "Laura Secord", "Louis-Hippolyte LaFontaine"]
	CAGods2 = ["Tommy Douglas", "Viola Desmond", "Lester B. Pearson", "Louis Riel", "Emily Murphy", "Nellie McClung", "Terry Fox", "Chief Dan George", "Buffy Sainte-Marie", "David Suzuki", "Roméo Dallaire", "Thérèse Casgrain", "Mary Two-Axe Earley", "Pierre Elliott Trudeau"]
	pass
