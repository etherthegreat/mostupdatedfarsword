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
signal retrieveTileOutputs
func displayTileInfo(tile):
	emit_signal("selectThisTile", tile)
	selectedTile = tile
	if firstTime == false:
		for ModifierSprite in $TerrainModifiersGridContainer.get_children():
			$TerrainModifiersGridContainer.remove_child(ModifierSprite)
			ModifierSprite.queue_free()
	else:
		firstTime = false
	$Label.text = tile.tileName
	matchTileNaturals()
	if tile.tileOwner == "":
		$colonizationPointsLabel.visible = true
		$colonizationPointsLabel.text = str(tile.colonizationPoints, " / ", tile.colonizationReq)
	else:
		$colonizationPointsLabel.visible = false
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
			$WizardButton.text = selectedTile.tileWizard.wizardType
		else:
			$WizardButton.text = str("no wizard :(")
	if $ManaPanelContainer.get_child_count() > 0:
		for manaPanel in $ManaPanelContainer.get_children():
			$ManaPanelContainer.remove_child(manaPanel)
			manaPanel.queue_free()
	emit_signal("retrieveTileOutputs")
	pass

var manaPanelScene = preload("res://mana_panel.tscn")

func buildTileOutput(type, amount, dictionary):
	var newManaPanel = manaPanelScene.instantiate()
	newManaPanel.buildSelf(type, amount, dictionary)
	newManaPanel.manaLook.connect(showTileOutput)
	newManaPanel.closeManaLook.connect(closeTileOutput)
	$ManaPanelContainer.add_child(newManaPanel)
	pass

func showTileOutput(fText):
	$Outputs.clear()
	$Outputs.append_text(fText)
	pass

func closeTileOutput():
	$Outputs.clear()
	pass

signal governorButtonPressed
func _on_governor_button_pressed() -> void:
	#$GovernorSelection.position = Vector2(356, -369)
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
	if selectedTile.tileCrop != null:
		$CropPanelSprite.texture = load("res://art assets/finishedAssets/religiousIcons/cropIconFilled.PNG")
		match selectedTile.tileCrop:
			"Soybeans":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Bamboo.PNG")
			"Peanuts":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Bananas.PNG")
			"Cannabis":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Cannabis.PNG")
			"Peaches":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Razorberry.PNG")
			"Apples":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Seaweed.PNG")
			"Mushrooms":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Wereroot.PNG")
			"Hay":
				$CropSprite.texture = load("res://art assets/finishedAssets/ores/Wheat.PNG")
	if selectedTile.terrain != null:
		match selectedTile.terrain:
			"jungle":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1440.PNG")
			"steppe":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1422.PNG")
			"bog":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1424.PNG")
			"cold_coast":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1426.PNG")
			"drylands":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1425.PNG")
			"warm_coast":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1428.PNG")
			"floodplanes":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1427.PNG")
			"desert":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1434.PNG")
			"meadow":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1436.PNG")
			"mountaintop":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1437.PNG")
			"mountaintop_cold":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1439.PNG")
			"hills":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1438.PNG")
			"forest":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1441.PNG")
			"taiga":
				$TerrainSprite.texture = load("res://art assets/Placeholder Art/UI Art/terrain/IMG_1442.PNG")
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
