extends Control

signal levelUpSpell

var magicDic: Dictionary = {}

func connectSchools():
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Alchemy.spellSchoolLevelUp.connect(spellLevelUp)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Alchemy.askSpellBranchInfo.connect(askSpellInfo)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Alchemy.buildSelf()
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Divination.spellSchoolLevelUp.connect(spellLevelUp)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Divination.askSpellBranchInfo.connect(askSpellInfo)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Divination.buildSelf()
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Druidism.spellSchoolLevelUp.connect(spellLevelUp)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Druidism.askSpellBranchInfo.connect(askSpellInfo)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Druidism.buildSelf()
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Elementalism.spellSchoolLevelUp.connect(spellLevelUp)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Elementalism.askSpellBranchInfo.connect(askSpellInfo)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Elementalism.buildSelf()
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Illusion.spellSchoolLevelUp.connect(spellLevelUp)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Illusion.askSpellBranchInfo.connect(askSpellInfo)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Illusion.buildSelf()
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Summoning.spellSchoolLevelUp.connect(spellLevelUp)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Summoning.askSpellBranchInfo.connect(askSpellInfo)
	$SpellSchoolsPanel/SchoolsAmounts/SpellsVBox/Summoning.buildSelf()
	pass


signal lvlUpSpell
func spellLevelUp(lvl, type):
	emit_signal("lvlUpSpell", lvl, type)
	pass

var player: country

signal calculatePlayerOutputs
func updateMagicAmounts(playerCountryNode):
	player = playerCountryNode
	emit_signal("calculatePlayerOutputs", self)
	pass

func returnedOutput(playerOutput):
	magicDic= {
		"ALC" : playerOutput.ALC,
		"DIV" : playerOutput.DIV,
		"DRU" : playerOutput.DRU,
		"ELE" : playerOutput.ELE,
		"ILL" : playerOutput.ILL,
		"SUM" : playerOutput.SUM
	}
	for MagicAmountControl in $SpellSchoolsPanel/SchoolsAmounts/SpellsVBox.get_children():
		MagicAmountControl.update(player, magicDic)
	pass

signal askForInfo
func askSpellInfo(type, spellBranch):
	print("RETURN ASKINGFORINFO")
	emit_signal("askForInfo", type, spellBranch)
	pass
