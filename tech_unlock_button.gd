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

var rewardScene = load("res://tech_reward_icon.tscn")

func buildSelf():
	$Label.text = technologyName
	$CostLabel.text = str(technologyCost)
	match technologyName:
		# --- SABRE row ---
		"Swordsmanship":
			addReward("Cutlass Unlock")
			addReward("Cavalry Sword Unlock")
		"Cavalry Drills":
			addReward("Cavalry Sword Upgrade")
		"Officer Training":
			addReward("Officer Sword Unlock")
		"Marine Discipline":
			addReward("Marine Mameluke Unlock")
		# --- RIFLES row ---
		"Musket Drilling":
			addReward("Musket Unlock")
		"Volley Tactics":
			addReward("Volley Bonus")
		"Percussion Ignition":
			addReward("Rifle Unlock")
		"Repeating Mechanisms":
			addReward("Repeating Rifle Unlock")
		# --- ARTILLERY row ---
		"Field Gunnery":
			addReward("Field Gun Unlock")
		"Artillery Corps":
			addReward("Artillery Upgrade")
		"Siege Works":
			addReward("Siege Cannon Unlock")
		"Mortar Tactics":
			addReward("Mortar Unlock")
		# --- CIVILIAN row ---
		"Agrarian Reform":
			addReward("Farm Upgrade")
			addReward("Granary Upgrade")
		"Trade Networks":
			addReward("Market Upgrade")
			addReward("Faire Upgrade")
		"Industrialization":
			addReward("Workshop Upgrade")
			addReward("Forge Upgrade")
		"Infrastructure":
			addReward("Road Upgrade")
			addReward("Bath Upgrade")
		# --- DEFENSE row ---
		"Organization":
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/organization.png")
			addReward("Barracks Upgrade")
		"Logistics":
			addReward("Barracks Upgrade")
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/logistics.png")
		"Tactics":
			addReward("Barracks Upgrade")
		"Authority":
			addReward("Barracks Upgrade")
			addReward("Courthouse Upgrade")
			$Sprite2D.texture = load("res://art assets/finishedAssets/technology images/authority.png")

func addReward(type):
	var newReward = rewardScene.instantiate()
	newReward.buildSelf(type)
	$HBoxContainer.add_child(newReward)

var blue = Color.LIGHT_BLUE
var white = Color.WHITE
var yellow = Color.YELLOW_GREEN
var grey = Color.DARK_GRAY
var black = Color.BLACK

func _process(delta: float) -> void:
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
		
		return
	else:
		$UnlockButton.add_theme_color_override("icon_normal_color", grey)

func purchase():
	purchased = true
	$UnlockButton.disabled = true

signal newTech
func unlockTech(change):
	emit_signal("newTech", techID, self, change)

signal selectInvestment
func _on_unlock_button_pressed() -> void:
	emit_signal("selectInvestment", self)

var change: int
func addScienceInvestment(amount):
	techScienceInvestment += amount
	if techScienceInvestment > technologyCost:
		change = techScienceInvestment - technologyCost
		unlockTech(change)
