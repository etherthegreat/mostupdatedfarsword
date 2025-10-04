extends Control


var player = country

func buildSelf(playerNode):
	$religionData.buildSelf()
	player = playerNode
	pass

var beliefButt = load("res://belief_button.tscn")

func updateSelf():
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
		$BeliefPanel/DoctrineContainer.add_child(newBB)
		newBB.LabelClicked.connect(purchasePanel)
	pass

var pendingCost: int
var pendingBelief: String
func purchasePanel(bbName, bbCost, bbImage, beliefDesc):
	$BeliefPanel/PurchasePanel/PPSprite.texture = bbImage
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
	if pendingBelief != null && pendingCost != null:
		if pendingCost >= player.TotalFaith:
			$BeliefPanel/PurchasePanel/PurchaseButton.disabled = false
		else:
			$BeliefPanel/PurchasePanel/PurchaseButton.disabled = true
	pass
