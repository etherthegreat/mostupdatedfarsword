extends Control



func buildSelf(playerNode):
	for beliefButton in $BeliefPanel/GridContainer.get_children():
		beliefButton.custom_minimum_size = Vector2(20, 20)
		beliefButton.beliefName = beliefButton.exportBeliefName
		#beliefButton.text = beliefButton.beliefName
		if beliefButton.beliefName == "Benaxtara":
			beliefButton.icon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/god 1 - Copy.png")
		elif beliefButton.beliefName == "Bibwey":
			beliefButton.icon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/god 1 - Copy.png")
	for belief in playerNode.selectedBeliefs:
		if belief.beliefType == "Benaxtara":
			$BeliefPanel/GridContainer/beliefButton.icon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/god 1.png")
			$BeliefPanel/GridContainer/beliefButton.disabled = true
	pass


func _on_belief_button_mouse_entered() -> void:
	if $BeliefInfoPanel.visible == false:
		$BeliefInfoPanel.visible = true
	
	pass # Replace with function body.

func _on_belief_button_mouse_exited() -> void:
	if $BeliefInfoPanel.visible == true:
		$BeliefInfoPanel.visible = false
	pass # Replace with function body.
