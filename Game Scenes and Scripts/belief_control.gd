extends Control


var player = country

func buildSelf(playerNode):
	pendingBelief = ""
	pendingCost = 0
	$religionData.buildSelf()
	player = playerNode
	pass

var beliefButt = load("res://belief_button.tscn")
var beliefPD = load("res://purchased_doctrine.tscn")
func updateSelf():
	$BeliefPanel/PurchasePanel.visible = false
	pendingBelief = ""
	pendingCost = 0
	if $BeliefPanel/GodsScrollContainer/GodsContainer.get_children!=null:
		for beliefButton in $BeliefPanel/GodsScrollContainer/GodsContainer.get_children():
			$BeliefPanel/GodsScrollContainer/GodsContainer.remove_child(beliefButton)
			beliefButton.queue_free()
	if $BeliefPanel/DoctrineScrollContainer/DoctrineContainer.get_children() != null:
		for beliefButton in $BeliefPanel/DoctrineScrollContainer/DoctrineContainer.get_children():
			$BeliefPanel/DoctrineScrollContainer/DoctrineContainer.remove_child(beliefButton)
			beliefButton.queue_free()
	for String in player.availableDocs:
		var newBB = beliefButt.instantiate()
		match String:
			"Healing Waters":
				newBB.buildSelf("Healing Waters", $religionData.healingWatersIcon, $religionData.healingWatersBWIcon, false, 100, "We utilize the few fresh water resources to motivate our followers.", $religionData.border1)
			"Standing Stones":
				newBB.buildSelf("Standing Stones", $religionData.standingStonesIcon, $religionData.standingStonesBWIcon, false, 120, "What's up, we are indeed the Standing Stones, the famous band from Farsword.", $religionData.border1)
			"Valued Idolatry":
				newBB.buildSelf("Valued Idolatry", $religionData.valuedIdolatryIcon, $religionData.valuedIdolatryBWIcon, false, 20, "Gold and Silver Artifacts are utilized to show how rich our God is.", $religionData.border1)
			"Sacred Groves":
				newBB.buildSelf("Sacred Groves", $religionData.sacredGrovesIcon, $religionData.sacredGrovesBWIcon, false, 70, "These Groves be sacred as fuck.", $religionData.border1)
			"Midsummer Celebrations":
				newBB.buildSelf("Midsummer Celebrations", $religionData.midsummerCelebrationsIcon, $religionData.midsummerCelebrationsBWIcon, false, 35, "By partying super hard, our people will feel way better about themselvs.", $religionData.border1)
			"Tree of Life":
				newBB.buildSelf("Tree of Life", $religionData.treeOfLifeIcon, $religionData.treeOfLifeBWIcon, false, 160, "Trees are everything and everywhere and make perfect indoctrination imagery for dummies.", $religionData.border1)
			"Tower Control":
				newBB.buildSelf("Tower Control", $religionData.towerControlIcon, $religionData.towerControlBWIcon, false, 250, "The wizards have implemented strict mind control, including the removal of faith from society.", $religionData.border1)
			"Nature Sanctuaries":
				newBB.buildSelf("Nature Sanctuaries", $religionData.natureSanctuariesIcon, $religionData.natureSanctuariesIconBW, false, 100, "By harmonizing our churches with the local environments, we can fight the demon king's corruption from our churches.", $religionData.border1)
			"Conservative Orthodoxy":
				newBB.buildSelf("Conservative Orthodoxy", $religionData.conservativeOrthodoxyIcon, $religionData.conservativeOrthodoxyIconBW, false, 200, "Our Churches do not rely on modern revelation - all of our doctrine was divine and will always be divine.", $religionData.border1)
			"Sanctioned Cadaver Research":
				newBB.buildSelf("Sanctioned Cadaver Research", $religionData.sanctionedCadaverResearchIcon, $religionData.sanctionedCadaverResearchIconBW, false, 200, "Our faith will not interfere with the necessary scientific pursuit of medicine.", $religionData.border1)
			"Temple Height Restrictions":
				newBB.buildSelf("Temple Height Restrictions", $religionData.templeHeightLawsIcon, $religionData.templeHeightLawsIconBW, false, 120, "Our faith decrees no building will be taller than our temples in any tiles.", $religionData.border1)
		$BeliefPanel/DoctrineScrollContainer/DoctrineContainer.add_child(newBB)
		newBB.LabelClicked.connect(purchasePanel)
	for String in player.availableGods:
		var newBB = beliefButt.instantiate()
		match String:
			"Benaxtara":
				newBB.buildSelf("Benaxtara", $religionData.benaxtaraIcon, $religionData.benaxtaraBWIcon, false, 160, "The Great Sleeping Snake of the North - it is believed that once Benaxtara is awoken from their slumber, they will consume the entire universe.", $religionData.border4)
			"Tyla-Dyn":
				newBB.buildSelf("Tyla-Dyn", $religionData.tylaDinIcon, $religionData.tylaDinIconBW, false, 300, "The great gregarious reveler, the provider of wine, of good times, and of fortune.", $religionData.border5)
			"Fa Enepo":
				newBB.buildSelf("Fa Enepo", $religionData.faEnepoIcon, $religionData.faEnepoIconBW, false, 200, "The void wandered, the great summoner, and the rider of the infinite cosmos.", $religionData.border3)
			"Bibwey":
				newBB.buildSelf("Bibwey", $religionData.bibweyIcon, $religionData.bibweyBWIcon, false, 130, "The nightly intruder, the master of dreams, the forbidden hypnotist.  Bibwey knows the minds of all.", $religionData.border3)
			"Dilnith-Amen":
				newBB.buildSelf("Dilnith-Amen", $religionData.dilnithAmenIcon, $religionData.dilnithAmenIconBW, false, 185, "The Enlightened One, the great Meditator.  Dilnith Amen figured out the secrets to enlightenment before the Demon King arrived.", $religionData.border2)
			"Ornil-Ra":
				newBB.buildSelf("Ornil-Ra", $religionData.ornilRaIcon, $religionData.ornilRaIconBW, false, 280, "The great destroyer and the great provider.  The inciter of cycles, of change, of chaos.", $religionData.border4)
			"Vibian Karik":
				newBB.buildSelf("Vibian Karik", $religionData.vibianKarikIcon, $religionData.vibianKarikIconBW, false, 100, "The Great Mother Goddess of the Sea, Vibian Protects Sailors and the moon?", $religionData.border5)
			"Venodam":
				newBB.buildSelf("Venodam", $religionData.venodamIcon, $religionData.venodamIconBW, false, 90, "The Father God of the Sky, Sky Daddy!", $religionData.border5)
			"Jerriwix":
				newBB.buildSelf("Jerriwix", $religionData.jerriwixIcon, $religionData.jerriwixIconBW, false, 135, "The mysterious guide of the Spirit plane, whether Jerriwix eats you or not is up to their hunger levels in the moment of passing through.", $religionData.border3)
			"Qalin Ling & Tyrus":
				newBB.buildSelf("Qalin Ling & Tyrus", $religionData.qalinLingIcon, $religionData.qalinLingIconBW, false, 200, "Qalin Ling, the last Pheonix, rides atop the head of Tyrus, the last leviathan.  Together they hold the final two eggs of their species on a nest, waiting for the demon king to die to let them hatch.", $religionData.border4)
		$BeliefPanel/GodsScrollContainer/GodsContainer.add_child(newBB)
		newBB.LabelClicked.connect(purchasePanel)
	if $BeliefPanel/purchasedBeliefsGrid.get_children() != null:
		for purchasedDoctrine in $BeliefPanel/purchasedBeliefsGrid.get_children():
			$BeliefPanel/purchasedBeliefsGrid.remove_child(purchasedDoctrine)
			purchasedDoctrine.queue_free()
	if $BeliefPanel/purchasedGodsGrid.get_children() != null:
		for purchasedDoctrine in $BeliefPanel/purchasedGodsGrid.get_children():
			$BeliefPanel/purchasedGodsGrid.remove_child(purchasedDoctrine)
			purchasedDoctrine.queue_free()
	for belief in player.selectedBeliefs:
		buildPD(belief.beliefType)
	pass

func buildPD(type):
	var newPD = beliefPD.instantiate()
	match type:
		"Healing Waters":
			newPD.buildSelf("Healing Waters", $religionData.healingWatersIcon, "We utilize the few fresh water resources to motivate our followers.", true, $religionData.border1)
		"Standing Stones":
			newPD.buildSelf("Standing Stones", $religionData.standingStonesIcon, "What's up, we are indeed the Standing Stones, the famous band from Farsword.", true,  $religionData.border1)
		"Valued Idolatry":
			newPD.buildSelf("Valued Idolatry", $religionData.valuedIdolatryIcon, "Gold and Silver Artifacts are utilized to show how rich our God is.", true, $religionData.border1)
		"Sacred Groves":
			newPD.buildSelf("Sacred Groves", $religionData.sacredGrovesIcon, "These Groves be sacred as fuck.", true, $religionData.border1)
		"Midsummer Celebrations":
			newPD.buildSelf("Midsummer Celebrations", $religionData.midsummerCelebrationsIcon, "By partying super hard, our people will feel way better about themselvs.", true, $religionData.border1)
		"Tree of Life":
			newPD.buildSelf("Tree of Life", $religionData.treeOfLifeIcon, "Trees are everything and everywhere and make perfect indoctrination imagery for dummies.", true, $religionData.border1)
		"Tower Control":
			newPD.buildSelf("Tower Control", $religionData.towerControlIcon, "The wizards have implemented strict mind control, including the removal of faith from society.", true, $religionData.border1)
		"Nature Sanctuaries":
			newPD.buildSelf("Nature Sanctuaries", $religionData.natureSanctuariesIcon, "By harmonizing our churches with the local environments, we can fight the demon king's corruption from our churches.", true, $religionData.border1)
		"Conservative Orthodoxy":
			newPD.buildSelf("Conservative Orthodoxy", $religionData.conservativeOrthodoxyIcon, "Our Churches do not rely on modern revelation - all of our doctrine was divine and will always be divine.", true, $religionData.border1)
		"Sanctioned Cadaver Research":
			newPD.buildSelf("Sanctioned Cadaver Research", $religionData.sanctionedCadaverResearchIcon, "Our faith will not interfere with the necessary scientific pursuit of medicine.", true, $religionData.border1)
		"Temple Height Restrictions":
			newPD.buildSelf("Temple Height Restrictions", $religionData.templeHeightLawsIcon, "Our faith decrees no building will be taller than our temples in any tiles.", true, $religionData.border1)
		"Benaxtara":
			newPD.buildSelf("Benaxtara", $religionData.benaxtaraIcon, "The Great Sleeping Snake of the North - it is believed that once Benaxtara is awoken from their slumber, they will consume the entire universe.", false,  $religionData.border4)
		"Tyla-Dyn":
			newPD.buildSelf("Tyla-Dyn", $religionData.tylaDinIcon, "The great gregarious reveler, the provider of wine, of good times, and of fortune.", false,  $religionData.border5)
		"Fa Enepo":
			newPD.buildSelf("Fa Enepo", $religionData.faEnepoIcon, "The void wandered, the great summoner, and the rider of the infinite cosmos.", false,  $religionData.border3)
		"Bibwey":
			newPD.buildSelf("Bibwey", $religionData.bibweyIcon, "The nightly intruder, the master of dreams, the forbidden hypnotist.  Bibwey knows the minds of all.", false, $religionData.border3)
		"Dilnith-Amen":
			newPD.buildSelf("Dilnith-Amen", $religionData.dilnithAmenIcon, "The Enlightened One, the great Meditator.  Dilnith Amen figured out the secrets to enlightenment before the Demon King arrived.", false,  $religionData.border2)
		"Ornil-Ra":
			newPD.buildSelf("Ornil-Ra", $religionData.ornilRaIcon, "The great destroyer and the great provider.  The inciter of cycles, of change, of chaos.", false,  $religionData.border4)
		"Vibian Karik":
			newPD.buildSelf("Vibian Karik", $religionData.vibianKarikIcon, "The Great Mother Goddess of the Sea, Vibian Protects Sailors and the moon?", false, $religionData.border5)
		"Venodam":
			newPD.buildSelf("Venodam", $religionData.venodamIcon, "The Father God of the Sky, Sky Daddy!", false, $religionData.border5)
		"Jerriwix":
			newPD.buildSelf("Jerriwix", $religionData.jerriwixIcon, "The mysterious guide of the Spirit plane, whether Jerriwix eats you or not is up to their hunger levels in the moment of passing through.", false, $religionData.border3)
		"Qalin Ling & Tyrus":
			newPD.buildSelf("Qalin Ling & Tyrus", $religionData.qalinLingIcon, "Qalin Ling, the last Pheonix, rides atop the head of Tyrus, the last leviathan.  Together they hold the final two eggs of their species on a nest, waiting for the demon king to die to let them hatch.", false, $religionData.border4)
	match newPD.doctrineType:
		true:
			$BeliefPanel/purchasedBeliefsGrid.add_child(newPD)
		false:
			$BeliefPanel/purchasedGodsGrid.add_child(newPD)
	newPD.purchasedDoctrineHover.connect(pdPanelUpdate)
	newPD.pdExited.connect(closePurchasePanel)
	pass
	
func closePurchasePanel():
	$BeliefPanel/PurchasePanel.visible = false
	pass

func pdPanelUpdate(title, img, desc, border):
	$BeliefPanel/PurchasePanel/PPSprite.texture = img
	$BeliefPanel/PurchasePanel/RichTextLabel.clear()
	$BeliefPanel/PurchasePanel/RichTextLabel.append_text(desc)
	$BeliefPanel/PurchasePanel/PurchaseButton.visible = false
	$BeliefPanel/PurchasePanel/Price.visible = false
	$BeliefPanel/PurchasePanel/FaithIcon.visible = false
	$BeliefPanel/PurchasePanel/Label.text = title
	$BeliefPanel/PurchasePanel/PPBorderSprite.texture = border
	$BeliefPanel/PurchasePanel.visible = true
	pass

var pendingCost: int
var pendingBelief: String
func purchasePanel(bbName, bbCost, bbImage, beliefDesc, beliefBorder):
	$BeliefPanel/PurchasePanel/PPSprite.texture = bbImage
	$BeliefPanel/PurchasePanel/PurchaseButton.visible = true
	$BeliefPanel/PurchasePanel/Price.visible = true
	$BeliefPanel/PurchasePanel/FaithIcon.visible = true
	$BeliefPanel/PurchasePanel/RichTextLabel.clear()
	$BeliefPanel/PurchasePanel/RichTextLabel.append_text(beliefDesc)
	$BeliefPanel/PurchasePanel/Price.clear()
	$BeliefPanel/PurchasePanel/Price.append_text(str(bbCost))
	pendingCost = bbCost
	pendingBelief = bbName
	$BeliefPanel/PurchasePanel/PPBorderSprite.texture = beliefBorder
	$BeliefPanel/PurchasePanel.visible = true
	pass

func _on_belief_button_mouse_entered() -> void:
	if $BeliefInfoPanel.visible == false:
		$BeliefInfoPanel.visible = true
	
	pass # Replace with function body.

func _on_belief_button_mouse_exited() -> void:
	if $BeliefInfoPanel.visible == true:
		$BeliefInfoPanel.visible = false
	pass # Replace with function body.

func _process(delta: float) -> void:
	if $BeliefPanel/DoctrineScrollContainer/DoctrineContainer.get_children != null:
		for beliefButton in $BeliefPanel/DoctrineScrollContainer/DoctrineContainer.get_children():
			if beliefButton.bbPurchased != true:
				if beliefButton.bbCost <= player.TotalFaith:
					beliefButton.makePurchaseable()
				else:
					beliefButton.cantAfford()
			else:
				beliefButton.purchased()
	if $BeliefPanel/GodsScrollContainer/GodsContainer.get_children != null:
		for beliefButton in $BeliefPanel/GodsScrollContainer/GodsContainer.get_children():
			if beliefButton.bbPurchased != true:
				if beliefButton.bbCost <= player.TotalFaith:
					beliefButton.makePurchaseable()
				else:
					beliefButton.cantAfford()
			else:
				beliefButton.purchased()
	if pendingBelief != "" && pendingCost != 0:
		if player.TotalFaith >= pendingCost:
			$BeliefPanel/PurchasePanel/PurchaseButton.disabled = false
		else:
			$BeliefPanel/PurchasePanel/PurchaseButton.disabled = true
	if self.visible == true:
		$BeliefPanel/testLabel.text = str(player.churchLevel)
		matchFaithPointsIcons()
	pass

signal purchasedBelief
func _on_purchase_button_pressed() -> void:
	#print("purchasedBelief", pendingBelief, pendingCost)
	emit_signal("purchasedBelief", pendingBelief, pendingCost)
	pendingBelief = ""
	pendingCost = 0
	$BeliefPanel/PurchasePanel.visible = false
	pass # Replace with function body.

func matchFaithPointsIcons():
	match player.churchLevel:
		3:
			$"FaithPoints/1LevelSpriteBW".visible = false
			$"FaithPoints/2LevelSpriteBW".visible = false
			$"FaithPoints/3LevelSpriteBW".visible = false
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = true
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		2:
			$"FaithPoints/1LevelSpriteBW".visible = false
			$"FaithPoints/2LevelSpriteBW".visible = false
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = true
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		1:
			$"FaithPoints/1LevelSpriteBW".visible = false
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = true
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		0:
			$"FaithPoints/1LevelSpriteBW".visible = true
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = false
			$"FaithPoints/-1LevelSpriteBW".visible = true
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		-1:
			$"FaithPoints/1LevelSpriteBW".visible = true
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = false
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		-2:
			$"FaithPoints/1LevelSpriteBW".visible = true
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = false
			$"FaithPoints/-2LevelSpriteBW".visible = false
			$"FaithPoints/-3LevelSpriteBW".visible = true
		-3:
			$"FaithPoints/1LevelSpriteBW".visible = true
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = false
			$"FaithPoints/-2LevelSpriteBW".visible = false
			$"FaithPoints/-3LevelSpriteBW".visible = false
	pass


func _on_faith_1_area_2d_mouse_entered() -> void:
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Pantheon Level 2

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Big LaBIIA")
	$FaithPoints/FaithPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_faith_1_area_2d_mouse_exited() -> void:
	$FaithPoints/FaithPointsInfoPanel.visible = false
	pass # Replace with function body.

func _on_faith_2_area_2d_mouse_entered() -> void:
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Pantheon Level 2

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/sword.png[img] [color=purple] Divine Charge")
	$FaithPoints/FaithPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_faith_2_area_2d_mouse_exited() -> void:
	$FaithPoints/FaithPointsInfoPanel.visible = false
	pass # Replace with function body.

func _on_faith_3_area_2d_mouse_entered() -> void:
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Pantheon Level 2

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[img] [color=purple] Wiener Vacuum")
	$FaithPoints/FaithPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_faith_3_area_2d_mouse_exited() -> void:
	$FaithPoints/FaithPointsInfoPanel.visible = false
	pass # Replace with function body.


func _on_church_1_area_2d_mouse_entered() -> void:
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Church Level 1

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Organized Faith")
	$FaithPoints/ChurchPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_church_1_area_2d_mouse_exited() -> void:
	$FaithPoints/ChurchPointsInfoPanel.visible = false
	pass # Replace with function body.

func _on_church_2_area_2d_mouse_entered() -> void:
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Church Level 2

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Organized Priesthood")
	$FaithPoints/ChurchPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_church_2_area_2d_mouse_exited() -> void:
	$FaithPoints/ChurchPointsInfoPanel.visible = false
	pass # Replace with function body.


func _on_church_3_area_2d_mouse_entered() -> void:
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Church Level 3

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Organized Religion")
	$FaithPoints/ChurchPointsInfoPanel.visible = true
	pass # Replace with function body.


func _on_church_3_area_2d_mouse_exited() -> void:
	$FaithPoints/ChurchPointsInfoPanel.visible = false
	pass # Replace with function body.


func _on_balance_area_2d_mouse_entered() -> void:
	$FaithPoints/BalancePointsInfoPanel/BalancePointsInfoPanel/RichTextLabel.clear()
	$FaithPoints/BalancePointsInfoPanel/BalancePointsInfoPanel/RichTextLabel.append_text("[b]Zealous Communion: Church Level 3

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Perfectly Balanced")
	$FaithPoints/BalancePointsInfoPanel.visible = true
	pass # Replace with function body.


func _on_balance_area_2d_mouse_exited() -> void:
	$FaithPoints/BalancePointsInfoPanel.visible = false
	pass # Replace with function body.
