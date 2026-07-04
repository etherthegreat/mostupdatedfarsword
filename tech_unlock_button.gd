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
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/uniform 1.png")
			addReward("Tricorne Uniform")
		"Forage Cap":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/uniform 2.png")
			addReward("Forage Cap Uniform")
		"Tombstone Cap":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/uniform 3.png")
			addReward("Tombstone Uniform")
		"Hardee Hat":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/uniform 4.png")
			addReward("Hardee Uniform")
		# --- SABRE row ---
		"Swordsmanship":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/sabre 1.png")
			addReward("Cutlass Unlock")
		"Cavalry Drills":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/sabre 2.png")
			addReward("Cavalry Sword Unlock")
		"Officer Training":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/sabre 3.png")
			addReward("Officer Sword Unlock")
		"Marine Discipline":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/sabre 4.png")
			addReward("Marine Mameluke Unlock")
		# --- RIFLES row ---
		"Muskets":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/rifle 1.png")
			addReward("Muskets Unlock")
		"Breechloaders":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/rifle 2.png")
			addReward("Breechloaders Unlock")
		"Rifles":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/rifle 3.png")
			addReward("Percussion Unlock")
		"Repeaters":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/rifle 4.png")
			addReward("Repeater Unlock")
		# --- ARTILLERY row ---
		"Field Gunnery":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/arty 1.png")
			addReward("Field Gun Unlock")
		"Siege Works":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/arty 2.png")
			addReward("Mortar Unlock")
		"Explosive Charges":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/arty 3.png")
			addReward("CannonBlast Enhanced")
		"Rocket Artillery":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/arty 4.png")
			addReward("Early Rockets Unlock")
		# --- CIVILIAN row ---
		"Agrarian Reform":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/construction I.png")
			addReward("All Buildings Unlock")
			addReward("Seed Bag Tool")
		"Trade Networks":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/construction 2.png")
			addReward("Building Upgrade")
			addReward("Accountant Books Tool")
		"Industrialization":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/construction 3.png")
			addReward("Building Upgrade")
			addReward("Foundry Kit Tool")
		"Infrastructure":
			$Sprite2D.texture = load("res://art assets/AmericanRevolutionArt/technology sprites/construction 4.png")
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
