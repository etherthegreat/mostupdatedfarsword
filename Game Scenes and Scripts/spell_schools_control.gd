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


signal lvlUpSpell
func spellLevelUp(lvl, type):
	emit_signal("lvlUpSpell", lvl, type)

var player: country

signal calculatePlayerOutputs
func updateMagicAmounts(playerCountryNode):
	player = playerCountryNode
	emit_signal("calculatePlayerOutputs", self)

func returnedOutput(playerOutput):
	magicDic= {
		"MANIFEST" : playerOutput.get("MANIFEST", playerOutput.get("ALC", 0)),
		"LIBERTY"  : playerOutput.get("LIBERTY",  playerOutput.get("DIV", 0)),
		"STORM"    : playerOutput.get("STORM",    playerOutput.get("DRU", 0)),
		"IRON"     : playerOutput.get("IRON",     playerOutput.get("ELE", 0)),
		"SPECTRAL" : playerOutput.get("SPECTRAL", playerOutput.get("ILL", 0)),
		"CRYPTID"  : playerOutput.get("CRYPTID",  playerOutput.get("SUM", 0)),
	}
	for MagicAmountControl in $SpellSchoolsPanel/SchoolsAmounts/SpellsVBox.get_children():
		MagicAmountControl.update(player, magicDic)

signal askForInfo
func askSpellInfo(type, spellBranch):
	print("RETURN ASKINGFORINFO")
	emit_signal("askForInfo", type, spellBranch)
