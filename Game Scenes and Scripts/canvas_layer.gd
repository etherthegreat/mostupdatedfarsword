extends CanvasLayer


var playerNode

func assignPlayerNode(playerCountryNode):
	playerNode = playerCountryNode

func _on_tech_tree_button_pressed() -> void:
	if $TechTree.visible == true:
		$TechTree.visible = false
	elif $TechTree.visible == false:
		for Control in get_tree().get_nodes_in_group("ScreenPanels"):
			if Control.visible == true:
				Control.visible = false
		$TechTree.visible = true


func _on_close_button_pressed() -> void:
	$TechTree.visible = false


func _on_spell_book_button_pressed() -> void:
	$Spellbook.displaySpells(playerNode)
	if $Spellbook.visible == true:
		$Spellbook.visible = false
	elif $Spellbook.visible == false:
		for Control in get_tree().get_nodes_in_group("ScreenPanels"):
			if Control.visible == true:
				Control.visible = false
		$Spellbook.visible = true


func _on_close_spellbook_pressed() -> void:
	$Spellbook.visible = false

signal beliefUpdate
func _on_belief_panel_button_pressed() -> void:
	$BeliefControl.buildSelf(playerNode)
	$BeliefControl.updateSelf()
	if $BeliefControl.visible == true:
		$BeliefControl.visible = false
	elif $BeliefControl.visible == false:
		for Control in get_tree().get_nodes_in_group("ScreenPanels"):
			if Control.visible == true:
				Control.visible = false
		$BeliefControl.visible = true


func _on_factions_button_pressed() -> void:
	if $FactionControl.visible == true:
		$FactionControl.visible = false
	else:
		$FactionControl.visible = true


func _on_laws_button_pressed() -> void:
	$GovernmentControl.buildSelf(playerNode)
	$GovernmentControl.updateGovernmentPanel()
	if $GovernmentControl.visible == true:
		$GovernmentControl.visible = false
	else:
		$GovernmentControl.visible = true


func _on_open_buildings_button_pressed() -> void:
	if $BuildingInfoPanel.visible == false:
		$BuildingInfoPanel.visible = true
	else:
		$BuildingInfoPanel.visible = false


func _on_wizard_button_pressed() -> void:
	var wtc := $TileInfoPanel.get_node_or_null("WizardTileControl")
	if wtc:
		wtc.visible = not wtc.visible

func _on_magic_button_pressed() -> void:
	$SpellSchoolsControl.updateMagicAmounts(playerNode)
	if $SpellSchoolsControl.visible == false:
		$SpellSchoolsControl.visible = true
	else:
		$SpellSchoolsControl.visible = false

func _on_pick_tech_pressed() -> void:
	_on_tech_tree_button_pressed()


func _on_war_room_button_pressed() -> void:
	if $WarRoomPanel.visible == false:
		$WarRoomPanel.visible = true
	else:
		$WarRoomPanel.visible = false
