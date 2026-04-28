extends Control


var unlockedTechs: Array = []
var playerNode: country
#signal updateTechTree
var investmentTech: techButton
var costForUnlock: int

var nextTechChange: int

func buildSelf(player):
	#for Control in $TechPanel/GridContainer.get_children():
		#for techButton in Control.get_children():
			#techButton.disabled = true
	playerNode = player
	for Technology in player.unlockedTechnologies:
		unlockedTechs.append(Technology)
	for Technology in unlockedTechs:
		#print("Winner Winner Tech Tech," , Technology.techName)
		if Technology.techName == "Language":
			$TechPanel/InsititutionContainer/LanguageUnlockButton.purchase()
		if Technology.techName == "Writing":
			$TechPanel/InsititutionContainer/WritingUnlockButton.purchase()
		if Technology.techName == "Alphabet":
			$TechPanel/InsititutionContainer/AlphabetUnlockButton.purchase()
		if Technology.techName == "Mathematics":
			$TechPanel/InsititutionContainer/MathematicsUnlockButton.purchase()
		if Technology.techName == "Agriculture":
			$TechPanel/GridContainer/AgricultureTechUnlockButton.purchase()
		if Technology.techName == "Calendar":
			$TechPanel/GridContainer/CalendarTechUnlockButton.purchase()
		if Technology.techName == "Irrigation":
			$TechPanel/GridContainer/IrrigationTechUnlockButton.purchase()
		if Technology.techName == "Engineering":
			$TechPanel/GridContainer/EngineeringTechUnlockButton.purchase()
		if Technology.techName == "Copper Working":
			$TechPanel/GridContainer/CraftmanshipTechUnlockButton.purchase()
		if Technology.techName == "Bronze Working":
			$TechPanel/GridContainer/MetalAlloysTechUnlockButton.purchase()
		if Technology.techName == "Iron Working":
			$TechPanel/GridContainer/ForgingTechUnlockButton.purchase()
		if Technology.techName == "Tempuring":
			$TechPanel/GridContainer/TempuringTechUnlockButton.purchase()
		if Technology.techName == "Artistry":
			$TechPanel/GridContainer/ArtistryTechUnlockButton.purchase()
		if Technology.techName == "Masonry":
			$TechPanel/GridContainer/MasonryTechUnlockButton.purchase()
		if Technology.techName == "Architecture":
			$TechPanel/GridContainer/ArchitectureTechUnlockButton.purchase()
		if Technology.techName == "Banking":
			$TechPanel/GridContainer/BankingTechUnlockButton.purchase()
		if Technology.techName == "Sailing":
			$TechPanel/GridContainer/SailingTechUnlockButton.purchase()
		if Technology.techName == "Statecraft":
			$TechPanel/GridContainer/StatecraftTechUnlockButton.purchase()
		if Technology.techName == "Shipbuilding":
			$TechPanel/GridContainer/ShipbuildingTechUnlockButton.purchase()
		if Technology.techName == "Lenscraft":
			$TechPanel/GridContainer/LenscraftTechUnlockButton.purchase()
		if Technology.techName == "Organization":
			$TechPanel/GridContainer/OrganizationTechUnlockButton.purchase()
		if Technology.techName == "Logistics":
			$TechPanel/GridContainer/LogisticsTechUnlockButton.purchase()
		if Technology.techName == "Tactics":
			$TechPanel/GridContainer/TacticsTechUnlockButton.purchase()
		if Technology.techName == "Authority":
			$TechPanel/GridContainer/AurhorityTechUnlockButton.purchase()
	connectTechButtons()
	pass

signal addTechToPlayer

func connectTechButtons():
	for techButton in $TechPanel/GridContainer.get_children():
		techButton.selectInvestment.connect(selectInvestmentFunc)
		techButton.newTech.connect(unlockTech)
	for techButton in $TechPanel/InsititutionContainer.get_children():
		techButton.selectInvestment.connect(selectInvestmentFunc)
		techButton.newTech.connect(unlockTech)
	for techButton in $TechPanel/UnlockedContainer.get_children():
		techButton.selectInvestment.connect(selectInvestmentFunc)
		techButton.newTech.connect(unlockTech)
	pass

func unlockTech( techID, techButt, change):
	nextTechChange = change
	techButt.purchase()
	emit_signal("addTechToPlayer", techID)
	investmentTech = null
	pass

func selectInvestmentFunc(techbutt):
	investmentTech = techbutt
	if nextTechChange > 0:
		investInTech(nextTechChange)
		nextTechChange = 0
	self.visible = false
	pass

func investInTech(science):
	investmentTech.addScienceInvestment(science)
	pass
