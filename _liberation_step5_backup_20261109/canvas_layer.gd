extends CanvasLayer


var playerNode

func assignPlayerNode(playerCountryNode):
	playerNode = playerCountryNode

func closeAllPanels() -> void:
	$TileInfoPanel.visible = false
	$BuildingInfoPanel.visible = false
	$BeliefControl.visible = false
	$TechTree.visible = false
	$SpellSchoolsControl.visible = false
	$Spellbook.visible = false
	$MilitaryPanelControl.visible = false
	$FactionControl.visible = false
	$GovernmentControl.visible = false
	$TraditionsControl.visible = false
	$WarRoomPanel.visible = false
	$ResourceInfoControl.visible = false
	$ArmyPanel.visible = false
	$CivilianControl.visible = false
	$CivilianUnitControl.visible = false

func _on_tech_tree_button_pressed() -> void:
	if $TechTree.visible:
		$TechTree.visible = false
	else:
		closeAllPanels()
		$TechTree.visible = true


func _on_close_button_pressed() -> void:
	$TechTree.visible = false


func _on_spell_book_button_pressed() -> void:
	$Spellbook.displaySpells(playerNode)
	if $Spellbook.visible:
		$Spellbook.visible = false
	else:
		closeAllPanels()
		$Spellbook.visible = true


func _on_close_spellbook_pressed() -> void:
	$Spellbook.visible = false

signal beliefUpdate
func _on_belief_panel_button_pressed() -> void:
	$BeliefControl.buildSelf(playerNode)
	$BeliefControl.updateSelf()
	if $BeliefControl.visible:
		$BeliefControl.visible = false
	else:
		closeAllPanels()
		$BeliefControl.visible = true


func _on_factions_button_pressed() -> void:
	if $FactionControl.visible:
		$FactionControl.visible = false
	else:
		closeAllPanels()
		$FactionControl.visible = true


func _on_laws_button_pressed() -> void:
	$GovernmentControl.buildSelf(playerNode)
	$GovernmentControl.updateGovernmentPanel()
	if $GovernmentControl.visible:
		$GovernmentControl.visible = false
	else:
		closeAllPanels()
		$GovernmentControl.visible = true


func _on_open_buildings_button_pressed() -> void:
	if $BuildingInfoPanel.visible:
		$BuildingInfoPanel.visible = false
	else:
		closeAllPanels()
		$BuildingInfoPanel.visible = true


func _on_wizard_button_pressed() -> void:
	var wtc = $TileInfoPanel.get_node_or_null("WizardTileControl")
	if wtc:
		wtc.visible = not wtc.visible

func _on_magic_button_pressed() -> void:
	$SpellSchoolsControl.updateMagicAmounts(playerNode)
	if $SpellSchoolsControl.visible:
		$SpellSchoolsControl.visible = false
	else:
		closeAllPanels()
		$SpellSchoolsControl.visible = true

func _on_pick_tech_pressed() -> void:
	_on_tech_tree_button_pressed()


func _on_war_room_button_pressed() -> void:
	if $WarRoomPanel.visible:
		$WarRoomPanel.visible = false
	else:
		closeAllPanels()
		$WarRoomPanel.visible = true


func _ready() -> void:
	_build_pause_system()


func _build_pause_system() -> void:
	var menu_btn := Button.new()
	menu_btn.name = "PauseMenuButton"
	menu_btn.text = "Menu"
	menu_btn.anchor_left = 1.0
	menu_btn.anchor_right = 1.0
	menu_btn.offset_left = -122.0
	menu_btn.offset_right = -12.0
	menu_btn.offset_top = 12.0
	menu_btn.offset_bottom = 50.0

	var settings_panel = preload("res://Game Scenes and Scripts/audio_settings_panel.gd").new()
	settings_panel.name = "SettingsPanel"
	settings_panel.visible = false

	var pause_menu = preload("res://Game Scenes and Scripts/pause_menu.gd").new()
	pause_menu.name = "PauseMenu"

	add_child(menu_btn)
	add_child(pause_menu)
	add_child(settings_panel)

	pause_menu.setup(get_parent(), settings_panel)
	menu_btn.pressed.connect(pause_menu.toggle)
