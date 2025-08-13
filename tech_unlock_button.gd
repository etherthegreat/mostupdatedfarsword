extends Button

class_name techButton

@export var techCost: int
@export var techID: String
var technologyCost: int
var technologyName: String
var highestAvailable: bool
@export var techDesc: String
var technologyDescription: String 

@export var institutionTech: bool
var institutionTechnology: bool
var institutionUnlockNumber: int
var purchasedTechInTier: int

@export var reqTechs: Array[techButton]

var requiredTechs: Array[techButton]

var purchased: bool

func _ready() -> void:
	institutionTechnology = institutionTech
	if techDesc != null:
		technologyDescription = techDesc
	if institutionTechnology == true:
		institutionUnlockNumber == 0
	purchased = false
	technologyCost = techCost
	technologyName = techID
	requiredTechs = reqTechs
	pass

var blue = Color.BLUE
var white = Color.WHITE
var yellow = Color.YELLOW_GREEN

func _process(delta: float) -> void:
	#print("highestAvailable", technologyName, highestAvailable)
	highestAvailable = true
	if purchased == true:
		add_theme_color_override("icon_normal_color", yellow)
		return
	if institutionTechnology == true && purchased != true:
		institutionUnlockNumber = 0
		for techButton in requiredTechs:
			if techButton.purchased == true:
				institutionUnlockNumber += 1
		if institutionUnlockNumber < 3:
			highestAvailable = false
			add_theme_color_override("icon_normal_color", blue)
			return
		else:
			if purchased != true:
				add_theme_color_override("icon_normal_color", white)
				return
			else:
				add_theme_color_override("icon_normal_color", yellow)
				return
	for techButton in requiredTechs:
		if requiredTechs == null:
			if self.purchased == true:
				highestAvailable = false
				add_theme_color_override("icon_normal_color", blue)
				return
		elif techButton.purchased == false:
			highestAvailable = false
			add_theme_color_override("icon_normal_color", blue)
			return
	if self.purchased == true:
		highestAvailable = false
		add_theme_color_override("icon_normal_color", yellow)
		return
	if highestAvailable == true && self.purchased == false:
		add_theme_color_override("icon_normal_color", white)
		#print("baller", technologyName)
		return
	else:
		add_theme_color_override("icon_normal_color", blue)
	pass


func purchase():
	purchased = true
	pass
