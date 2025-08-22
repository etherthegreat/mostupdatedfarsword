extends Control

signal levelUpSpell

func connectSchools():
	for MagicAmountControl in $SpellSchoolsPanel/SchoolsAmounts/SpellsVBox.get_children():
		MagicAmountControl.spellSchoolLevelUp.connect(spellLevelUp)
	pass


signal lvlUpSpell
func spellLevelUp(lvl, type):
	emit_signal("lvlUpSpell", lvl, type)
	pass

func updateMagicAmounts(playerCountryNode):
	for MagicAmountControl in $SpellSchoolsPanel/SchoolsAmounts/SpellsVBox.get_children():
		MagicAmountControl.update(playerCountryNode)
	pass
