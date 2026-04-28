extends Control

class_name techButton

@export var techCost: int
@export var techID: String
var techScienceInvestment: int
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
	buildSelf()
	pass

var rewardScene = load("res://tech_reward_icon.tscn")

func buildSelf():
	$Label.text = technologyName
	$CostLabel.text = str(technologyCost)
	match technologyName:
		"Language":
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/language.png")
		"Agriculture":
			addReward("Farm Upgrade")
		"Copper Working":
			addReward("Camp Upgrade")
			addReward("Mine Upgrade")
			$Label.text = "Craftmanship"
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/craftmanship.png")
		"Artistry":
			addReward("Temple Upgrade")
			addReward("Workshop Upgrade")
		"Sailing":
			addReward("Dock Upgrade")
		"Organization":
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/organization.png")
			addReward("Barracks Upgrade")
		"Writing":
			addReward("Library Upgrade")
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/writing.png")
		"Calendar":
			addReward("Tower Upgrade")
			addReward("Granary Upgrade")
		"Bronze Working":
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/metal casting.png")
			addReward("Forge Upgrade")
			addReward("Camp Upgrade")
			$Label.text = "Metal Casting"
		"Masonry":
			addReward("Bath Upgrade")
			addReward("Temple Upgrade")
		"Statecraft":
			addReward("Courthouse Upgrade")
			addReward("Faire Upgrade")
		"Logistics":
			addReward("Barracks Upgrade")
			addReward("Dock Upgrade")
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/logistics.png")
		"Alphabet":
			addReward("Library Upgrade")
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/alphabet.png")
		"Irrigation":
			addReward("Farm Upgrade")
			addReward("Bath Upgrade")
		"Iron Working":
			addReward("Mine Upgrade")
			addReward("Forge Upgrade")
			$Label.text = "Forging"
		"Architecture":
			addReward("Workshop Upgrade")
			addReward("Temple Upgrade")
		"Shipbuilding":
			addReward("Dock Upgrade")
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/shipbuilding.png")
		"Tactics":
			addReward("Barracks Upgrade")
		"Mathematics":
			addReward("Library Upgrade")
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/mathematics.png")
		"Engineering":
			addReward("Farm Upgrade")
			addReward("Camp Upgrade")
			addReward("Faire Upgrade")
			addReward("Bath Upgrade")
		"Tempuring":
			addReward("Workshop Upgrade")
			addReward("Forge Upgrade")
		"Banking":
			addReward("Banking Upgrade 1")
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/banking.png")
		"Lenscraft":
			addReward("Tower Upgrade")
			addReward("Dock Upgrade")
		"Authority":
			addReward("Barracks Upgrade")
			addReward("Courthouse Upgrade")
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/authority.png")
	pass

func addReward(type):
	var newReward = rewardScene.instantiate()
	newReward.buildSelf(type)
	$HBoxContainer.add_child(newReward)
	pass

var blue = Color.LIGHT_BLUE
var white = Color.WHITE
var yellow = Color.YELLOW_GREEN
var grey = Color.DARK_GRAY
var black = Color.BLACK

func _process(delta: float) -> void:
	#print("highestAvailable", technologyName, highestAvailable)
	highestAvailable = true
	if purchased == true:
		$UnlockButton.add_theme_color_override("icon_normal_color", blue)
		return
	if institutionTechnology == true && purchased != true:
		institutionUnlockNumber = 0
		for techButton in requiredTechs:
			if techButton.purchased == true:
				institutionUnlockNumber += 1
		if institutionUnlockNumber < 3:
			highestAvailable = false
			$UnlockButton.add_theme_color_override("icon_normal_color", grey)
			return
		else:
			if purchased != true:
				$UnlockButton.add_theme_color_override("icon_normal_color", white)
				return
			else:
				$UnlockButton.add_theme_color_override("icon_normal_color", blue)
				return
	for techButton in requiredTechs:
		if requiredTechs == null:
			if self.purchased == true:
				highestAvailable = false
				add_theme_color_override("icon_normal_color", grey)
				return
		elif techButton.purchased == false:
			highestAvailable = false
			$UnlockButton.add_theme_color_override("icon_normal_color", grey)
			return
	if self.purchased == true:
		highestAvailable = false
		$UnlockButton.add_theme_color_override("icon_normal_color", blue)
		return
	if highestAvailable == true && self.purchased == false:
		$UnlockButton.add_theme_color_override("icon_normal_color", white)
		#print("baller", technologyName)
		
		return
	else:
		$UnlockButton.add_theme_color_override("icon_normal_color", grey)
	pass

func purchase():
	purchased = true
	$UnlockButton.disabled = true
	pass

signal newTech
func unlockTech(change):
	emit_signal("newTech", techID, self, change)
	pass

signal selectInvestment
func _on_unlock_button_pressed() -> void:
	emit_signal("selectInvestment", self)
	pass # Replace with function body.

var change: int
func addScienceInvestment(amount):
	techScienceInvestment += amount
	if techScienceInvestment > technologyCost:
		change = techScienceInvestment - technologyCost
		unlockTech(change)
	pass
