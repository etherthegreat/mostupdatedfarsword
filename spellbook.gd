extends Control


func displaySpells(playerCountry):
	for spell in playerCountry.unlockedSpells:
		if spell.militarySpell == false:
			var spellControl = Control.new()
			var thisSpellArt = spellArt.new()
			thisSpellArt.texture = spell.spellSprite
			spellControl.add_child(thisSpellArt)
			$Panel/TileSpellsGridContainer.add_child(spellControl)
		elif spell.militarySpell == true:
			var spellControl = Control.new()
			var thisSpellArt = spellArt.new()
			thisSpellArt.texture = spell.spellSprite
			spellControl.add_child(thisSpellArt)
			$Panel/ArmySpellsGridContainer.add_child(spellControl)
	pass
