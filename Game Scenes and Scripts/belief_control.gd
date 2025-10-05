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
	if $BeliefPanel/DoctrineContainer.get_children() != null:
		for beliefButton in $BeliefPanel/DoctrineContainer.get_children():
			$BeliefPanel/DoctrineContainer.remove_child(beliefButton)
			beliefButton.queue_free()
	for String in player.availableDocs:
		var newBB = beliefButt.instantiate()
		match String:
			"Healing Waters":
				newBB.buildSelf("Healing Waters", $religionData.healingWatersIcon, $religionData.healingWatersBWIcon, false, 100, "We utilize the few fresh water resources to motivate our followers.")
			"Standing Stones":
				newBB.buildSelf("Standing Stones", $religionData.standingStonesIcon, $religionData.standingStonesBWIcon, false, 120, "What's up, we are indeed the Standing Stones, the famous band from Farsword.")
			"Valued Idolatry":
				newBB.buildSelf("Valued Idolatry", $religionData.valuedIdolatryIcon, $religionData.valuedIdolatryBWIcon, false, 20, "Gold and Silver Artifacts are utilized to show how rich our God is.")
			"Sacred Groves":
				newBB.buildSelf("Sacred Groves", $religionData.sacredGrovesIcon, $religionData.sacredGrovesBWIcon, false, 70, "These Groves be sacred as fuck.")
			"Midsummer Celebrations":
				newBB.buildSelf("Midsummer Celebrations", $religionData.midsummerCelebrationsIcon, $religionData.midsummerCelebrationsBWIcon, false, 35, "By partying super hard, our people will feel way better about themselvs.")
			"Tree of Life":
				newBB.buildSelf("Tree of Life", $religionData.treeOfLifeIcon, $religionData.treeOfLifeBWIcon, false, 160, "Trees are everything and everywhere and make perfect indoctrination imagery for dummies.")
			"Tower Control":
				newBB.buildSelf("Tower Control", $religionData.towerControlIcon, $religionData.towerControlBWIcon, false, 250, "The wizards have implemented strict mind control, including the removal of faith from society.")
		$BeliefPanel/DoctrineContainer.add_child(newBB)
		newBB.LabelClicked.connect(purchasePanel)
	if $BeliefPanel/purchasedBeliefsGrid.get_children() != null:
		for purchasedDoctrine in $BeliefPanel/purchasedBeliefsGrid.get_children():
			$BeliefPanel/purchasedBeliefsGrid.remove_child(purchasedDoctrine)
			purchasedDoctrine.queue_free()
	for belief in player.selectedBeliefs:
		buildPD(belief.beliefType)
	pass

func buildPD(type):
	var newPD = beliefPD.instantiate()
	match type:
		"Healing Waters":
			newPD.buildSelf("Healing Waters", $religionData.healingWatersIcon, "We utilize the few fresh water resources to motivate our followers.")
		"Standing Stones":
			newPD.buildSelf("Standing Stones", $religionData.standingStonesIcon, "What's up, we are indeed the Standing Stones, the famous band from Farsword.")
		"Valued Idolatry":
			newPD.buildSelf("Valued Idolatry", $religionData.valuedIdolatryIcon, "Gold and Silver Artifacts are utilized to show how rich our God is.")
		"Sacred Groves":
			newPD.buildSelf("Sacred Groves", $religionData.sacredGrovesIcon, "These Groves be sacred as fuck.")
		"Midsummer Celebrations":
			newPD.buildSelf("Midsummer Celebrations", $religionData.midsummerCelebrationsIcon, "By partying super hard, our people will feel way better about themselvs.")
		"Tree of Life":
			newPD.buildSelf("Tree of Life", $religionData.treeOfLifeIcon, "Trees are everything and everywhere and make perfect indoctrination imagery for dummies.")
		"Tower Control":
			newPD.buildSelf("Tower Control", $religionData.towerControlIcon, "The wizards have implemented strict mind control, including the removal of faith from society.")
	$BeliefPanel/purchasedBeliefsGrid.add_child(newPD)
	newPD.purchasedDoctrineHover.connect(pdPanelUpdate)
	newPD.pdExited.connect(closePurchasePanel)
	pass
	
func closePurchasePanel():
	$BeliefPanel/PurchasePanel.visible = false
	pass

func pdPanelUpdate(title, img, desc):
	$BeliefPanel/PurchasePanel/PPSprite.texture = img
	$BeliefPanel/PurchasePanel/RichTextLabel.clear()
	$BeliefPanel/PurchasePanel/RichTextLabel.append_text(desc)
	$BeliefPanel/PurchasePanel/PurchaseButton.visible = false
	$BeliefPanel/PurchasePanel/Price.visible = false
	$BeliefPanel/PurchasePanel/FaithIcon.visible = false
	$BeliefPanel/PurchasePanel/Label.text = title
	$BeliefPanel/PurchasePanel.visible = true
	pass

var pendingCost: int
var pendingBelief: String
func purchasePanel(bbName, bbCost, bbImage, beliefDesc):
	$BeliefPanel/PurchasePanel/PPSprite.texture = bbImage
	$BeliefPanel/PurchasePanel/PurchaseButton.visible = true
	$BeliefPanel/PurchasePanel/Price.visible = true
	$BeliefPanel/PurchasePanel/FaithIcon.visible = true
	$BeliefPanel/PurchasePanel/PPBorderSprite.texture = load("res://art assets/finishedAssets/religiousIcons/IMG_1146.PNG")
	$BeliefPanel/PurchasePanel/RichTextLabel.clear()
	$BeliefPanel/PurchasePanel/RichTextLabel.append_text(beliefDesc)
	$BeliefPanel/PurchasePanel/Price.clear()
	$BeliefPanel/PurchasePanel/Price.append_text(str(bbCost))
	pendingCost = bbCost
	pendingBelief = bbName
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
	if pendingBelief != "" && pendingCost != 0:
		if player.TotalFaith >= pendingCost:
			$BeliefPanel/PurchasePanel/PurchaseButton.disabled = false
		else:
			$BeliefPanel/PurchasePanel/PurchaseButton.disabled = true
	pass

signal purchasedBelief
func _on_purchase_button_pressed() -> void:
	emit_signal("purchasedBelief", pendingBelief, pendingCost)
	pendingBelief = ""
	pendingCost = 0
	$BeliefPanel/PurchasePanel.visible = false
	pass # Replace with function body.
