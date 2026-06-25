extends Control

class_name Civilian

var civilianTool: Tool
var civilianKit: kit
var player

var stationTile: Tile
var stationNode: pathPointButton

var foodCost: int
var woodCost: int
var goldCost: int
var metalCost: int
var scienceCost: int
var magicCost: int
var faithCost: int
var cultureCost: int
var weaponsCost: int
var mandateCost: int
var manpowerCost: int
var harmonyCost: int
var influenceCost: int

var milMods: Array

# ── ACTION POINTS ─────────────────────────────────────────────────────────────
# Mirrors the army movement-point system. Civilians spend 1 point per tile
# moved; spy actions (Codebook) also cost 1 and consume the unit.
var maxActionPoints: int = 2
var currentActionPoints: int = 2

var toolScene = load("res://tool.tscn")
var kitScene = load("res://kit.tscn")

var maxHealth: int
var currentHealth: int

func buildSelf(toolKey, kitKey, homeTile, spawnNode, playerCountry):
	maxHealth = 100
	currentHealth = maxHealth
	stationTile = homeTile
	player = playerCountry
	$CivilianTileName.text = str(homeTile.tileName)
	stationNode = spawnNode
	addTool(toolKey)
	addKit(kitKey)
	pass

func addTool(toolKey):
	if civilianTool != null:
		civilianTool.queue_free()
	var newTool = toolScene.instantiate()
	newTool.buildSelf(toolKey)
	civilianTool = newTool
	pass

func addKit(kitKey):
	if civilianKit != null:
		civilianKit.queue_free()
	var newKit = kitScene.instantiate()
	newKit.buildSelf(kitKey)
	civilianKit = newKit
	pass

var milModScene = load("res://mil_mod.tscn")

func updatePanelUI():
	if $MilModsContainer.get_children() != null:
		for MilMod in $MilModsContainer.get_children():
			$MilModsContainer.remove_child(MilMod)
			MilMod.call_deferred("queue_free")
	if civilianTool != null:
		var newToolMilMod = milModScene.instantiate()
		newToolMilMod.buildSelf(civilianTool.toolName)
		$MilModsContainer.add_child(newToolMilMod)
		$ToolButton.icon = civilianTool.toolImage
	if civilianKit !=null:
		var newKitMilMod = milModScene.instantiate()
		newKitMilMod.buildSelf(civilianKit.kitType)
		$MilModsContainer.add_child(newKitMilMod)
		$KitButton.icon = civilianKit.kitImage
	pass

var toolKitButtonScene = load("res://tool_kit_control.tscn")

func displayAvailableKits(playerCountryNode):
	if $ToolsAndKitsChange/KitGridContainer.get_children() != null:
		for toolKitButton in $ToolsAndKitsChange/KitGridContainer.get_children():
			$ToolsAndKitsChange/KitGridContainer.remove_child(toolKitButton)
			toolKitButton.queue_free()
	for kit in playerCountryNode.availableKits:
		var newKitButton = toolKitButtonScene.instantiate()
		newKitButton.buildSelf(false, kit.kitType, kit.kitImage)
		newKitButton.kitSelected.connect(addKit)
		$ToolsAndKitsChange/KitGridContainer.add_child(newKitButton)
	if $ToolsAndKitsChange.visible == false:
		$ToolsAndKitsChange.visible = true
	else:
		$ToolsAndKitsChange.visible = false
	pass

func displayAvailableTools(playerCountryNode):
	if $ToolsAndKitsChange/ToolsGridContainer.get_children() != null:
		for toolKitButton in $ToolsAndKitsChange/ToolsGridContainer.get_children():
			$ToolsAndKitsChange/ToolsGridContainer.remove_child(toolKitButton)
			toolKitButton.queue_free()
	for Tool in playerCountryNode.availableTools:
		var newToolButton = toolKitButtonScene.instantiate()
		newToolButton.buildSelf(true, Tool.toolName, Tool.toolImage)
		newToolButton.toolSelected.connect(addTool)
		$ToolsAndKitsChange/ToolsGridContainer.add_child(newToolButton)
	if $ToolsAndKitsChange.visible == false:
		$ToolsAndKitsChange.visible = true
	else:
		$ToolsAndKitsChange.visible = false
	pass
	pass

func onTurnEnd():
	currentActionPoints = maxActionPoints

func calculateCivilianCost():
	pass

func calculateCivilianAttributes():
	pass


signal kitSignal

func _on_kit_button_pressed() -> void:
	emit_signal("kitSignal", self)
	$ToolsAndKitsChange/ToolsGridContainer.visible = false
	$ToolsAndKitsChange/KitGridContainer.visible = true
	pass # Replace with function body.

signal toolSignal
func _on_tool_button_pressed() -> void:
	emit_signal("toolSignal", self)
	$ToolsAndKitsChange/KitGridContainer.visible = false
	$ToolsAndKitsChange/ToolsGridContainer.visible = true
	pass # Replace with function body.

signal raiseSignal
func _on_raise_button_pressed() -> void:
	emit_signal("raiseSignal", self)
	pass # Replace with function body.
