extends Control

class_name TileInfoPanel

var tilesCalculatedBool = false

@export var EXPMthisTile: Tile
var thisTile: Tile

var firstTime: bool

func TilesCalculated():
	tilesCalculatedBool = true
	firstTime = true
	pass


#func _process(delta: float) -> void:
	#if tilesCalculatedBool == true:
		#displayTileInfo()
	#else:
		#return
		#print("still calculating tiles")
	#pass

var selectedTile
signal selectThisTile
func displayTileInfo(tile):
	emit_signal("selectThisTile", tile)
	selectedTile = tile
	if firstTime == false:
		for Control in $TerrainModifiersGridContainer.get_children():
			print(Control)
			#Control.queue_free() #this is really important to come back to.  I'm not removing the nodes, I'm just
			#removing them from being children of the container.  theoretically this could be a huge performance issue 
			$TerrainModifiersGridContainer.remove_child(Control)
		for ModifierSprite in $TerrainModifiersGridContainer.get_children():
			print(ModifierSprite)
			#ModifierSprite.queue_free() #same with this guy
			$TerrainModifiersGridContainer.remove_child(ModifierSprite)
			ModifierSprite.queue_free()
	else:
		firstTime = false
	$Label.text = tile.tileName
	matchTileNaturals()
	if tile.tileOwner == "":
		$colonizationPointsLabel.text = str(tile.colonizationPoints, " / ", tile.colonizationReq)
	if tile.corruption <= 25:
		$CorruptionSprite.texture = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionNo.png")
	elif tile.corruption > 20 && tile.corruption <= 40:
		$CorruptionSprite.texture = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionLight.png")
	elif tile.corruption > 40 && tile.corruption <= 60:
		$CorruptionSprite.texture = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionModerate.png")
	elif tile.corruption > 60 && tile.corruption < 80:
		$CorruptionSprite.texture = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionHeavy.png")
	else:
		$CorruptionSprite.texture = load("res://art assets/ModifierIcons/TileEcoModifiers/CorruptionTotal.png")
	for tileEcoModifier in tile.tileEcoModifiers:
		var modifierControl = Control.new()
		var modiSprite = ModifierSprite.new()
		#var modiSprite = load("res://modifier_sprite.tscn")
		modiSprite.texture = tileEcoModifier.modSprite #problem is the modSprite isn't loading with the rest of its scene
		#that allows it to display info about the modifier.
		modiSprite.buildModifier(tileEcoModifier)
		modifierControl.add_child(modiSprite)
		$TerrainModifiersGridContainer.add_child(modifierControl)
		if selectedTile.tileGovernor != null:
			if selectedTile.tileGovernor.governorTexture != null:
				$governorButton.icon = selectedTile.tileGovernor.governorTexture
				$governorButton/govnameLabel.text = str(selectedTile.tileGovernor.governorType)
				#$governorButton.disabled = true
			else:
				$governorButton.icon = load("res://art assets/Placeholder Art/character/8 11 experimental.png")
				$governorButton/govnameLabel.text = str(selectedTile.tileGovernor.governorType)
				#$governorButton.disabled = true
		else:
			$governorButton.icon = load("res://art assets/Placeholder Art/character/8 11 experimental.png")
			$governorButton/govnameLabel.text = "No Assigned Governor"
		if selectedTile.tileWizard != null:
			$wizardTypeLabel.text = selectedTile.tileWizard.wizardType
		else:
			$wizardTypeLabel.text = str("no wizard :(")
	pass

signal governorButtonPressed
func _on_governor_button_pressed() -> void:
	$GovernorSelection.position = Vector2(356, -369)
	$GovernorSelection.changePanel("governor")
	if selectedTile.tileGovernor == null:
		if $governorTileControlPanel.visible == false:
			emit_signal("governorButtonPressed", selectedTile)
		else:
			$governorTileControlPanel.visible = false
	else:
		$GovernorSelection.buildSelectedSelf(selectedTile.tileGovernor)
		if $GovernorSelection.visible == false:
			$GovernorSelection.visible = true
		else:
			$GovernorSelection.visible = false
		pass
	pass # Replace with function body.

var governorSelectionScene = preload("res://governor_selection.tscn")
func matchTileNaturals():
	if selectedTile.cropSlot != null:
		$CropPanelSprite.texture = load("res://art assets/finishedAssets/religiousIcons/cropIconFilled.PNG")
		match selectedTile.cropSlot.cropType:
			"Bamboo":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Bamboo.PNG")
			"Bananas":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Bananas.PNG")
			"Cannabis":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Cannabis.PNG")
			"Razorberry":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Razorberry.PNG")
			"Seaweed":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Seaweed.PNG")
			"Wereroot":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Wereroot.PNG")
			"Wheat":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Wheat.PNG")
	else:
		$CropPanelSprite.texture = load("res://art assets/finishedAssets/religiousIcons/cropIconEmpty.PNG")
		$CropSprite.texture = null
	if selectedTile.oreSlot != null:
		$OrePanelSprite.texture = load("res://art assets/finishedAssets/religiousIcons/oreIconFilled.PNG")
		$OreSprite.texture = selectedTile.oreSlot.oreImage
	else:
		$OrePanelSprite.texture = load("res://art assets/finishedAssets/religiousIcons/oreIconDisabled.PNG")
		$OreSprite.texture = null
	pass
func calculateAvailableGovernor(playerNode, tile):
	var tileReplica: Tile
	tileReplica = tile
	#print(tile, "fyycjcjjc")
	#print(tileReplica.tileNumber, "fucuucuuc")
	if $governorTileControlPanel/governorVBox.get_children() != null:
		for governorSelectionScene in $governorTileControlPanel/governorVBox.get_children():
			governorSelectionScene.queue_free()
	for governor in playerNode.unlockedGovernors:
		if governor.hired != true:
			var newGovernorSelection = governorSelectionScene.instantiate()
			newGovernorSelection.thisGovernor = governor
			newGovernorSelection.buildSelf(governor)
			$governorTileControlPanel/governorVBox.add_child(newGovernorSelection)
			newGovernorSelection.governorConfirmed.connect(confirmGovernor)
			if governor.coastal == true:# & tileReplica.coastal == false:
				governorSelectionScene.availableForThisTile = false
				governorSelectionScene.onUnavailable()
			newGovernorSelection.onAvailable()
			newGovernorSelection.availableForThisTile = true
			match governor.governorBuildingRequirement:
				"None":
					pass
				"Farm":
					if tileReplica.farmGovernorReq != true:
						newGovernorSelection.availableForThisTile = false
						newGovernorSelection.onUnavailable()
				"Camp":
					if tileReplica.campGovernorReq != true:
						newGovernorSelection.availableForThisTile = false
						newGovernorSelection.onUnavailable()
				"Mine":
					if tileReplica.mineGovernorReq != true:
						newGovernorSelection.availableForThisTile = false
						newGovernorSelection.onUnavailable()
				"Library":
					if tileReplica.libraryGovernorReq != true:
						newGovernorSelection.availableForThisTile = false
						newGovernorSelection.onUnavailable()
				"Tower":
					if tileReplica.towerGovernorReq != true:
						newGovernorSelection.availableForThisTile = false
						newGovernorSelection.onUnavailable()
				"Granary":
					if tileReplica.granaryGovernorReq != true:
						newGovernorSelection.availableForThisTile = false
						newGovernorSelection.onUnavailable()
				"Bath":
					if tileReplica.bathGovernorReq != true:
						newGovernorSelection.availableForThisTile = false
						newGovernorSelection.onUnavailable()
				"Theater":
					if tileReplica.theaterGovernorReq != true:
						newGovernorSelection.availableForThisTile = false
						newGovernorSelection.onUnavailable()
				"Barracks":
					if tileReplica.baccksGovernorReq != true:
						newGovernorSelection.availableForThisTile = false
						newGovernorSelection.onUnavailable()
	$governorTileControlPanel.visible = true
	pass

signal confirmThisGovernor
func confirmGovernor(confirmedGovernor):
	emit_signal("confirmThisGovernor", confirmedGovernor, selectedTile)
	$governorTileControlPanel.visible = false
	pass


func _on_factions_button_pressed() -> void:
	pass # Replace with function body.


func _on_building_info_panel_show_new_building_tab() -> void:
	
	pass # Replace with function body.
