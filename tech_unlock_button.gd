extends Control

class_name techButton

@export var techCost: int
@export var techID: String
@export var techDesc: String
@export var institutionTech: bool
@export var reqTechs: Array[techButton]

var techScienceInvestment: int
var purchased: bool = false

func _ready() -> void:
	purchased = false
	buildSelf()
	refresh_visual()

var rewardScene = load("res://tech_reward_icon.tscn")

func buildSelf():
	$Label.text = techID
	$CostLabel.text = str(techCost)
	match techID:
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
			addReward("Flintlock Unlock")
		"Volley Tactics":
			addReward("Volley Bonus")
		"Percussion Ignition":
			addReward("Breechloader Unlock")
		"Repeating Mechanisms":
			addReward("Lever Repeater Unlock")
		# --- ARTILLERY row ---
		"Field Gunnery":
			addReward("Field Gun Unlock")
		"Siege Works":
			addReward("Siege Cannon Unlock")
		"Explosive Charges":
			addReward("Mortar Unlock")
		"Rocket Artillery":
			addReward("Early Rockets Unlock")
		# --- CIVILIAN row ---
		"Agrarian Reform":
			addReward("All Buildings Unlock")
			addReward("Seed Bag Tool")
		"Trade Networks":
			addReward("Building Upgrade")
			addReward("Accountant Books Tool")
		"Industrialization":
			addReward("Building Upgrade")
			addReward("Foundry Kit Tool")
		"Infrastructure":
			addReward("Building Upgrade")
			addReward("Rails and Engines Tool")
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

const COLOR_PURCHASED := Color.LIGHT_BLUE
const COLOR_AVAILABLE := Color.WHITE
const COLOR_LOCKED    := Color.DARK_GRAY

func _requirements_met() -> bool:
	if institutionTech:
		var count := 0
		for btn in reqTechs:
			if btn.purchased:
				count += 1
		return count >= 3
	for btn in reqTechs:
		if not btn.purchased:
			return false
	return true

func refresh_visual() -> void:
	if purchased:
		$UnlockButton.disabled = true
		$UnlockButton.add_theme_color_override("icon_normal_color", COLOR_PURCHASED)
	elif _requirements_met():
		$UnlockButton.disabled = false
		$UnlockButton.add_theme_color_override("icon_normal_color", COLOR_AVAILABLE)
	else:
		$UnlockButton.disabled = true
		$UnlockButton.add_theme_color_override("icon_normal_color", COLOR_LOCKED)

func purchase() -> void:
	purchased = true
	refresh_visual()

signal newTech
func unlockTech(change):
	emit_signal("newTech", techID, self, change)

signal selectInvestment
func _on_unlock_button_pressed() -> void:
	emit_signal("selectInvestment", self)

func addScienceInvestment(amount: int) -> void:
	techScienceInvestment += amount
	if techScienceInvestment > techCost:
		unlockTech(techScienceInvestment - techCost)
