extends Control

class_name faction

var factionName: String
var factionLoyalty: int #0-90, every 30 points added (three governor quests) adds a unique modifier

var factionFlag: flag

var factionLeader: governor
var factionGovernorsList: Array = []

var factionRewards: Array = []

var factionReward1: factionReward
var factionReward2: factionReward
var factionReward3: factionReward

func buildSelf(ID, loyalty, newLeader):
	factionName = ID
	factionLoyalty = loyalty
	factionLeader = newLeader
	factionGovernorsList.append(factionLeader)
	visualizeSelf()
	matchFactionRewards()
	pass

func visualizeSelf():
	$FactionPanel/ProgressBar.value = factionLoyalty
	$FactionPanel/LeaderSprite.texture = factionLeader.governorTexture
	$FactionPanel/FactionLeaderNameLabel.text = factionLeader.governorType
	$FactionPanel/FactionNameLabel.text = factionName
	$FactionPanel/ProgressBar.value = factionLoyalty
	pass

var rewardScene = preload("res://faction_reward.tscn")

func matchFactionRewards():
	print(factionLoyalty, "faction Loyalty")
	match factionName:
		#Anlaxia
		"ANL_Republicans":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			var FR_description_1 = str("The Republican alliance of Wello Jenni-Tur, these governors believe in following the wills of the people rather than simply rule by decree.")
			addFactionReward("Local Elections", FR_description_1, FR_texture1, 1)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			var FR_description_2 = str("Citizenship of Anlaxia will not be denied due to any trivial reason.  All who denounce the demon pretender and his cronies are welcome here.")
			addFactionReward("Equality Starts Here", FR_description_2, FR_texture2, 2)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			var FR_description_3 = str("A well armed citizenry will help us repel any of the breakaway demonic states that dare try and reinvade our island.")
			addFactionReward("Citizen Militias", FR_description_3, FR_texture3, 3)
		#"ANL_Zealouts"
		#"ANL_Monarchists"
		#"ANL_Razorbacks"
		#Pender Tal
		
		#Vitherian Order
	pass

func addFactionReward(rewardType, rewardDescription, rewardTexture, slot):
	var newReward = rewardScene.instantiate()
	newReward.buildSelf(rewardType, rewardDescription, rewardTexture)
	newReward.emitRewardType.connect(forwardRewardType)
	match slot:
		1:
			factionReward1 = newReward
		2:
			factionReward2 = newReward
		3:
			factionReward3 = newReward
	$FactionPanel/FactionRewards.add_child(newReward)
	factionRewards.append(newReward)
	pass

func forwardRewardType(factionRewardType):
	print("faction reward type", factionRewardType)
	pass


func _on_progress_bar_area_2d_mouse_entered() -> void:
	$FactionPanel/FactionTutorialPanel.visible = true
	pass # Replace with function body.


func _on_progress_bar_area_2d_mouse_exited() -> void:
	$FactionPanel/FactionTutorialPanel.visible = false
	pass # Replace with function body.

func upgradeFaction(amount):
	factionLoyalty += amount
	match factionLoyalty:
		30:
			factionReward1.rewardUnlocked()
		60:
			factionReward2.rewardUnlocked()
		90:
			factionReward3.rewardUnlocked()
			factionLoyalty
	visualizeSelf()
	pass

func _on_upgrade_faction_button_pressed() -> void:
	upgradeFaction(10)
	pass # Replace with function body.
