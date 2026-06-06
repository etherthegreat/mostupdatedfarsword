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
		"Sons of Liberty":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Militia Muster",
				"The Sons call every able man to arms. Colonial militias form faster and cost less manpower.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"Merchant Networks",
				"Patriot merchants open their warehouses. Gold income from market tiles increases.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Letters of Marque",
				"Privateers sail under the rebel flag. Dock tiles produce weapons and the Nassau pirates offer alliance.",
				FR_texture3, 3
			)
 
		"Continental Congress":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Articles of Confederation",
				"A framework for governance. Courthouse tiles produce more mandate and reduce corruption.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"Foreign Diplomacy",
				"Congress sends envoys abroad. Unlock diplomatic options with Canada and other European powers.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Constitutional Convention",
				"The framework of a new nation. Major governance unlock — all laws cost less mandate.",
				FR_texture3, 3
			)
 
		"Common Cause":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Frontier Homesteads",
				"Settlers push into uncontrolled territory. Colonization speed increases significantly.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"The People's Assembly",
				"Direct democracy at the local level. Tiles with liberated status produce more harmony.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Land Reform",
				"Seized loyalist estates redistributed. Farm tiles in liberated territory double food output.",
				FR_texture3, 3
			)
 
		"Abolitionist League":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Freedom Papers",
				"The League issues freedom papers to all who escape occupied territory. Manpower in liberated tiles increases.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"Underground Railroad",
				"Escape networks cross occupied territory. Espionage becomes available in all UK-held tiles.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Universal Emancipation",
				"Freedom for all, everywhere, unconditionally. Liberty score in all tiles increases by 20. Revolutionary hotbed events trigger faster.",
				FR_texture3, 3
			)
 
		"Free Workers Union":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Guild Charters",
				"Artisan guilds organize production. Forge and workshop tiles produce more weapons and gold.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"General Strike",
				"Workers in occupied territory refuse to work for the Crown. Corruption increases in all UK tiles by 10.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Workers Commonwealth",
				"The most radical vision of the new republic. All production buildings output +2 of their primary resource.",
				FR_texture3, 3
			)
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

signal sendRewardType
func forwardRewardType(factionRewardType):
	emit_signal("sendRewardType", factionRewardType)
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
