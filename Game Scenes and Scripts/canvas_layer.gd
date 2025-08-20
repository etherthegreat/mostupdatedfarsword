extends CanvasLayer


var playerNode: country

func assignPlayerNode(playerCountryNode):
	playerNode = playerCountryNode
	pass

func _on_tech_tree_button_pressed() -> void:
	if $TechTree.visible == true:
		$TechTree.visible = false
	elif $TechTree.visible == false:
		for Control in get_tree().get_nodes_in_group("ScreenPanels"):
			if Control.visible == true:
				Control.visible = false
		$TechTree.visible = true
	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	$TechTree.visible = false
	pass # Replace with function body.


func _on_spell_book_button_pressed() -> void:
	if $Spellbook.visible == true:
		$Spellbook.visible = false
	elif $Spellbook.visible == false:
		for Control in get_tree().get_nodes_in_group("ScreenPanels"):
			if Control.visible == true:
				Control.visible = false
		$Spellbook.visible = true
	pass # Replace with function body.


func _on_close_spellbook_pressed() -> void:
	$Spellbook.visible = false
	pass # Replace with function body.


func _on_belief_panel_button_pressed() -> void:
	if $BeliefControl.visible == true:
		$BeliefControl.visible = false
	elif $BeliefControl.visible == false:
		for Control in get_tree().get_nodes_in_group("ScreenPanels"):
			if Control.visible == true:
				Control.visible = false
		$BeliefControl.visible = true
	pass # Replace with function body.


func _on_factions_button_pressed() -> void:
	if $FactionControl.visible == true:
		$FactionControl.visible = false
	else:
		$FactionControl.visible = true
	pass # Replace with function body.


func _on_laws_button_pressed() -> void:
	$GovernmentControl.updateGovernmentPanel()
	if $GovernmentControl.visible == true:
		$GovernmentControl.visible = false
	else:
		$GovernmentControl.visible = true
	pass # Replace with function body.


func _on_open_buildings_button_pressed() -> void:
	if $BuildingInfoPanel.visible == false:
		$BuildingInfoPanel.visible = true
	else:
		$BuildingInfoPanel.visible = false
	pass # Replace with function body.


func _on_wizard_button_pressed() -> void:
	
	pass # Replace with function body.

func _on_magic_button_pressed() -> void:
	for MagicAmountControl in $SpellSchoolsControl/SpellSchoolsPanel/SchoolsAmounts/SpellsVBox.get_children():
		MagicAmountControl.update(playerNode)
	if $SpellSchoolsControl.visible == false:
		$SpellSchoolsControl.visible = true
	else:
		$SpellSchoolsControl.visible = false
	pass # Replace with function body.
