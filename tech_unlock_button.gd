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
		# --- UNIFORM row (armor hats; effects/icons wired later) ---
		"Tricorne Hat":
			addReward("Tricorne Uniform")
		"Forage Cap":
			addReward("Forage Cap Uniform")
		"Tombstone Cap":
			addReward("Tombstone Uniform")
		"Hardee Hat":
			addReward("Hardee Uniform")
		# --- SABRE row ---
		"Swordsmanship":
			addReward("Cutlass Unlock")
		"Cavalry Drills":
			addReward("Cavalry Sword Unlock")
		"Officer Training":
			addReward("Officer Sword Unlock")
		"Marine Discipline":
			addReward("Marine Mameluke Unlock")
		# --- RIFLES row ---
		"Muskets":
			addReward("Muskets Unlock")
		"Breechloaders":
			addReward("Breechloaders Unlock")
		"Rifles":
			addReward("Percussion Unlock")
		"Repeaters":
			addReward("Repeater Unlock")
		# --- ARTILLERY row ---
		"Field Gunnery":
			addReward("Field Gun Unlock")
		"Siege Works":
			addReward("Mortar Unlock")
		"Explosive Charges":
			addReward("CannonBlast Enhanced")
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

const COLOR_PURCHASED := Color(0.5, 0.45, 0.88)  # deep indigo = owned/selected
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
		modulate = COLOR_PURCHASED
		$UnlockButton.disabled = true
		$UnlockButton.add_theme_color_override("icon_normal_color", Color.WHITE)
	elif _requirements_met():
		modulate = Color.WHITE
		$UnlockButton.disabled = false
		$UnlockButton.add_theme_color_override("icon_normal_color", COLOR_AVAILABLE)
	else:
		modulate = Color.WHITE
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
