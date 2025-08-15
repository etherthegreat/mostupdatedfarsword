extends Panel

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
		for Control in $Panel/TerrainModifiersGridContainer.get_children():
			print(Control)
			#Control.queue_free() #this is really important to come back to.  I'm not removing the nodes, I'm just
			#removing them from being children of the container.  theoretically this could be a huge performance issue 
			$Panel/TerrainModifiersGridContainer.remove_child(Control)
		for ModifierSprite in $Panel/TerrainModifiersGridContainer.get_children():
			print(ModifierSprite)
			#ModifierSprite.queue_free() #same with this guy
			$Panel/TerrainModifiersGridContainer.remove_child(ModifierSprite)
	else:
		firstTime = false
	$Panel/Label.text = tile.tileName
	for tileEcoModifier in tile.tileEcoModifiers:
		var modifierControl = Control.new()
		var modiSprite = ModifierSprite.new()
		#var modiSprite = load("res://modifier_sprite.tscn")
		modiSprite.texture = tileEcoModifier.modSprite #problem is the modSprite isn't loading with the rest of its scene
		#that allows it to display info about the modifier.
		modiSprite.buildModifier(tileEcoModifier)
		modifierControl.add_child(modiSprite)
		$Panel/TerrainModifiersGridContainer.add_child(modifierControl)
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
