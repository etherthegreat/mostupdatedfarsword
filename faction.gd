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

func visualizeSelf():
	$FactionPanel/ProgressBar.value = factionLoyalty
	$FactionPanel/LeaderSprite.texture = factionLeader.governorTexture
	$FactionPanel/FactionLeaderNameLabel.text = factionLeader.governorType
	$FactionPanel/FactionNameLabel.text = factionName
	$FactionPanel/ProgressBar.value = factionLoyalty

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
				"Workers in occupied territory refuse to work for the Crown. Camps and Mines produce more raw materials.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Workers Commonwealth",
				"The most radical vision of the new republic. Farms and Libraries produce more food and science.",
				FR_texture3, 3
			)

		"French Habitants":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Quebec Act Recognition",
				"The habitants demand recognition of their language, religion, and laws. Temples produce more culture.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"Habitants Alliance",
				"The farming communities pledge full support. Farm yields increase and a new governor joins the cause.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Republic of Quebec",
				"Quebec declares itself a free republic in solidarity with the American cause. Farm and Temple output surge.",
				FR_texture3, 3
			)

		"Loyalist Settlers":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Crown Defectors",
				"Former Crown loyalists switch sides. Courthouse mandate increases and a defensive law is enacted.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"Pragmatic Compact",
				"The settlers strike a practical deal. British-trained officers defect and barracks output surges.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"New Republic Converts",
				"The settlers fully embrace the new republic. Trade and governance laws are enacted.",
				FR_texture3, 3
			)

		"Haudenosaunee Confederacy":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Treaty of Friendship",
				"A treaty of mutual respect is signed. Woodland camps produce more lumber.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"Haudenosaunee Alliance",
				"The Confederacy shares military knowledge. Camps produce weapons alongside lumber.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Sovereign Partnership",
				"Full partnership between the nations. Barracks are reinforced and citizenship laws are enacted.",
				FR_texture3, 3
			)

		"Coureurs des Bois":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Trade Routes",
				"The woodsmen open their trade networks. Camps produce more lumber throughout the territory.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"Frontier Network",
				"The forest network expands. A veteran guide joins your governors and camp production doubles.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Continental Reach",
				"The network stretches from Quebec to the Mississippi. Camps now supply weapons alongside raw materials.",
				FR_texture3, 3
			)

		"Maritime Patriots":
			var FR_texture1 = preload("res://art assets/ModifierIcons/milMods/green cross.png")
			addFactionReward(
				"Port Alliance",
				"Maritime communities pledge their harbors. Dock output increases.",
				FR_texture1, 1
			)
			var FR_texture2 = preload("res://art assets/ModifierIcons/milMods/portal.png")
			addFactionReward(
				"Atlantic Commerce",
				"Trade routes along the Atlantic coast are secured. Markets and docks generate more gold.",
				FR_texture2, 2
			)
			var FR_texture3 = preload("res://art assets/ModifierIcons/milMods/purple vines.png")
			addFactionReward(
				"Maritime Union",
				"All maritime provinces unite under a single trade charter. Dock output surges.",
				FR_texture3, 3
			)

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

signal sendRewardType
func forwardRewardType(factionRewardType):
	emit_signal("sendRewardType", factionRewardType)
	print("faction reward type", factionRewardType)


func _on_progress_bar_area_2d_mouse_entered() -> void:
	$FactionPanel/FactionTutorialPanel.visible = true


func _on_progress_bar_area_2d_mouse_exited() -> void:
	$FactionPanel/FactionTutorialPanel.visible = false

func upgradeFaction(amount):
	factionLoyalty += amount
	if factionLoyalty >= 30 and factionReward1 != null and not factionReward1.factionRewardActivated:
		factionReward1.rewardUnlocked()
		factionReward1.factionRewardActivated = true
	if factionLoyalty >= 60 and factionReward2 != null and not factionReward2.factionRewardActivated:
		factionReward2.rewardUnlocked()
		factionReward2.factionRewardActivated = true
	if factionLoyalty >= 90 and factionReward3 != null and not factionReward3.factionRewardActivated:
		factionReward3.rewardUnlocked()
		factionReward3.factionRewardActivated = true
	visualizeSelf()

func _on_upgrade_faction_button_pressed() -> void:
	upgradeFaction(10)
