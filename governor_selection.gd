extends Control

var thisGovernor: governor

var availableForThisTile: bool

func buildSelf(receivedGovernor):
	thisGovernor = receivedGovernor
	$MasterPanel/GovernorNameLabel.text = thisGovernor.governorType
	$MasterPanel/levelLabel.text = str(thisGovernor.governorLevel)
	$MasterPanel/characterInfoPanel/biographyDescLabel.text = str(thisGovernor.governorBiography)
	$MasterPanel/characterInfoPanel/shortDescLabel.text = thisGovernor.governorDescription
	$MasterPanel/selectGovernorPanel/selectGovernorButton.icon = thisGovernor.governorTexture
	fillCommanderMilMods()
	pass

func buildSelectedSelf(receivedGovernor):
	thisGovernor = receivedGovernor
	$MasterPanel/GovernorNameLabel.text = thisGovernor.governorType
	$MasterPanel/levelLabel.text = str(thisGovernor.governorLevel)
	$MasterPanel/characterInfoPanel/biographyDescLabel.text = str(thisGovernor.governorBiography)
	$MasterPanel/characterInfoPanel/shortDescLabel.text = thisGovernor.governorDescription
	$MasterPanel/selectGovernorPanel/selectGovernorButton.visible = false
	fillCommanderMilMods()
	pass
	

func _on_character_info_button_pressed() -> void:
	changePanel("character")
	pass # Replace with function body.

func _on_governor_info_button_pressed() -> void:
	changePanel("governor")
	pass # Replace with function body.

func _on_commander_info_button_pressed() -> void:
	changePanel("commander")
	pass # Replace with function body.

func changePanel(panelType):
	match panelType:
		"character":
			$MasterPanel/characterInfoPanel/characterInfoButton.disabled = true
			$MasterPanel/governorPanel/governorInfoButton.disabled = false
			$MasterPanel/commanderPanel/commanderInfoButton.disabled = false
			$MasterPanel/selectGovernorPanel/selectGovernorButton.disabled= false
			$MasterPanel/characterInfoPanel.z_index = 20
			$MasterPanel/governorPanel.z_index = 10
			$MasterPanel/commanderPanel.z_index = 10
			$MasterPanel/selectGovernorPanel.z_index = 10
			$MasterPanel/selectGovernorPanel/confirmGovernorButton.z_index = 10
			$MasterPanel/selectGovernorPanel/declineGovernorButton.z_index = 10
			$MasterPanel.move_child($MasterPanel/characterInfoPanel, $MasterPanel.get_child_count() - 1)
		"governor":
			$MasterPanel/characterInfoPanel/characterInfoButton.disabled = false
			$MasterPanel/governorPanel/governorInfoButton.disabled = true
			$MasterPanel/commanderPanel/commanderInfoButton.disabled = false
			$MasterPanel/selectGovernorPanel/selectGovernorButton.disabled= false
			$MasterPanel/characterInfoPanel.z_index = 10
			$MasterPanel/governorPanel.z_index = 20
			$MasterPanel/commanderPanel.z_index = 10
			$MasterPanel/selectGovernorPanel.z_index = 10
			$MasterPanel/selectGovernorPanel/confirmGovernorButton.z_index = 10
			$MasterPanel/selectGovernorPanel/declineGovernorButton.z_index = 10
			$MasterPanel.move_child($MasterPanel/governorPanel, $MasterPanel.get_child_count() - 1)
		"commander":
			$MasterPanel/characterInfoPanel/characterInfoButton.disabled = false
			$MasterPanel/governorPanel/governorInfoButton.disabled = false
			$MasterPanel/commanderPanel/commanderInfoButton.disabled = true
			$MasterPanel/selectGovernorPanel/selectGovernorButton.disabled= false
			$MasterPanel/characterInfoPanel.z_index = 10
			$MasterPanel/governorPanel.z_index = 10
			$MasterPanel/commanderPanel.z_index = 20
			$MasterPanel/selectGovernorPanel.z_index = 10
			$MasterPanel/selectGovernorPanel/confirmGovernorButton.z_index = 10
			$MasterPanel/selectGovernorPanel/declineGovernorButton.z_index = 10
			$MasterPanel.move_child($MasterPanel/commanderPanel, $MasterPanel.get_child_count() - 1)
	pass


func _on_select_governor_button_pressed() -> void:
	
	$MasterPanel/characterInfoPanel.z_index = 10
	$MasterPanel/governorPanel.z_index = 10
	$MasterPanel/commanderPanel.z_index = 10
	$MasterPanel/selectGovernorPanel.z_index = 20
	$MasterPanel/selectGovernorPanel/selectGovernorButton.disabled = true
	$MasterPanel/characterInfoPanel/characterInfoButton.disabled = false
	$MasterPanel/governorPanel/governorInfoButton.disabled = false
	$MasterPanel/commanderPanel/commanderInfoButton.disabled = false
	$MasterPanel/selectGovernorPanel/confirmGovernorButton.z_index = 25
	$MasterPanel/selectGovernorPanel/declineGovernorButton.z_index = 25
	$MasterPanel.move_child($MasterPanel/selectGovernorPanel, $MasterPanel.get_child_count() - 1) 
	pass # Replace with function body.

var milModScene = load("res://mil_mod.tscn")
func fillCommanderMilMods():
	if $MasterPanel/commanderPanel/HBoxContainerLVL1.get_children() != null:
		for MilMod in $MasterPanel/commanderPanel/HBoxContainerLVL1.get_children():
			MilMod.queue_free()
	if $MasterPanel/commanderPanel/HBoxContainerLVL2.get_children() != null:
		for MilMod in $MasterPanel/commanderPanel/HBoxContainerLVL2.get_children():
			MilMod.queue_free()
	if $MasterPanel/commanderPanel/HBoxContainerLVL3.get_children() != null:
		for MilMod in $MasterPanel/commanderPanel/HBoxContainerLVL3.get_children():
			MilMod.queue_free()
	for MilMod in thisGovernor.govMilModsLvl1:
		var newMMS = milModScene.instantiate()
		newMMS.buildSelf(MilMod.milModType)
		$MasterPanel/commanderPanel/HBoxContainerLVL1.add_child(newMMS)
	for MilMod in thisGovernor.govMilModsLvl2:
		var newMMS = milModScene.instantiate()
		newMMS.buildSelf(MilMod.milModType)
		$MasterPanel/commanderPanel/HBoxContainerLVL2.add_child(newMMS)
	for MilMod in thisGovernor.govMilModsLvl3:
		var newMMS = milModScene.instantiate()
		newMMS.buildSelf(MilMod.milModType)
		$MasterPanel/commanderPanel/HBoxContainerLVL3.add_child(newMMS)
	pass

signal governorConfirmed
func _on_confirm_governor_button_pressed() -> void:
	emit_signal("governorConfirmed", thisGovernor)
	pass # Replace with function body.

func onAvailable():
	$MasterPanel/selectGovernorPanel/selectGovernorButton.disabled = false
	pass

func onUnavailable():
	$MasterPanel/selectGovernorPanel/selectGovernorButton.disabled = true
	pass


func _on_decline_governor_button_pressed() -> void:
	changePanel("character")
	pass # Replace with function body.
