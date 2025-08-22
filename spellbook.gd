extends Control

var spellArtScene = load("res://spell_scene.tscn")
func displaySpells(playerCountry):
	$SelectedInfoPanel.visible = false
	if $Panel/TileSpellsGridContainer != null:
		for spellArt in $Panel/TileSpellsGridContainer.get_children():
			spellArt.queue_free()
	#if $Panel/ArmySpellsGridContainer != null:
		#for Control in $Panel/ArmySpellsGridContainer.get_children():
		#	Control.queue_free()
	for spell in playerCountry.unlockedSpells:
		print("spells in playerCountry.unlockedSpells", spell.spellType)
		if spell.militarySpell == false:
			var thisSpellArt = spellArtScene.instantiate()
			thisSpellArt.buildSpell(spell.spellType, spell.spellCastCost, playerCountry, spell)
			thisSpellArt.spellButtonPressed.connect(useThisSpell)
			$Panel/TileSpellsGridContainer.add_child(thisSpellArt)
		elif spell.militarySpell == true:
			var spellControl = Control.new()
			var thisSpellArt = spellArt.new()
			thisSpellArt.texture = spell.spellSprite
			spellControl.add_child(thisSpellArt)
			$Panel/ArmySpellsGridContainer.add_child(spellControl)
	pass

signal spellToUse
func useThisSpell(spell, cost):
	emit_signal("spellToUse", spell, cost)
	$SelectedInfoPanel/Name.text = str(spell.spellType)
	$SelectedInfoPanel/Cost.text = str(cost)
	$SelectedInfoPanel/Sprite.texture = spell.spellSprite
	$SelectedInfoPanel/Description.text = spell.spellShortDescription
	$SelectedInfoPanel.visible = true
	#$Panel/BookSprite.visible = false
	pass
