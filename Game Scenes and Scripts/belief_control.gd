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
	if $BeliefPanel/GodsContainer.get_children!=null:
		for beliefButton in $BeliefPanel/GodsContainer.get_children():
			$BeliefPanel/GodsContainer.remove_child(beliefButton)
			beliefButton.queue_free()
	if $BeliefPanel/DoctrineContainer.get_children() != null:
		for beliefButton in $BeliefPanel/DoctrineContainer.get_children():
			$BeliefPanel/DoctrineContainer.remove_child(beliefButton)
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
		$BeliefPanel/DoctrineContainer.add_child(newBB)
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
		$BeliefPanel/GodsContainer.add_child(newBB)
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
	if $BeliefPanel/DoctrineContainer.get_children != null:
		for beliefButton in $BeliefPanel/DoctrineContainer.get_children():
			if beliefButton.bbPurchased != true:
				if beliefButton.bbCost <= player.TotalFaith:
					beliefButton.makePurchaseable()
				else:
					beliefButton.cantAfford()
			else:
				beliefButton.purchased()
	if $BeliefPanel/GodsContainer.get_children != null:
		for beliefButton in $BeliefPanel/GodsContainer.get_children():
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
	pass

signal purchasedBelief
func _on_purchase_button_pressed() -> void:
	emit_signal("purchasedBelief", pendingBelief, pendingCost)
	pendingBelief = ""
	pendingCost = 0
	$BeliefPanel/PurchasePanel.visible = false
	pass # Replace with function body.
