extends Control

<<<<<<< Updated upstream

var unlockedTechs: Array = []
var playerNode: country
#signal updateTechTree
=======
var playerNode
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
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
=======
func buildSelf(player) -> void:
	playerNode = player
	_build_grid()
	_mark_purchased(player)
	_connect_signals()

func _build_grid() -> void:
	_buttons.clear()
	var grid := $TechPanel/GridContainer
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	var button_scene := load("res://tech_unlock_button.tscn")

	for row_idx in range(TECH_ROWS.size()):
		var row_data: Array = TECH_ROWS[row_idx]
		var row_label_text: String = row_data[0]

		# Column 0: row label
		var lbl := Label.new()
		lbl.text = row_label_text
		lbl.add_theme_font_size_override("font_size", 14)
		lbl.add_theme_color_override("font_color", Color(0.95, 0.88, 0.62, 1))
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		lbl.custom_minimum_size = Vector2(120, 0)
		grid.add_child(lbl)

		var row_btns: Array[techButton] = []

		for col_idx in range(1, 5):
			var tech_name: String = row_data[col_idx]
			var cost: int = TECH_COSTS[col_idx - 1]

			var btn: techButton = button_scene.instantiate()
			btn.techID = tech_name
			btn.techCost = cost

			# Each tech requires only the previous one in the same row
			if col_idx > 1:
				btn.reqTechs = [row_btns[col_idx - 2]]

			grid.add_child(btn)
			row_btns.append(btn)
			_buttons[tech_name] = btn

func _mark_purchased(player) -> void:
	for tech in player.unlockedTechnologies:
		if tech.techName in _buttons:
			_buttons[tech.techName].purchase()

func _connect_signals() -> void:
	for btn in _buttons.values():
		btn.selectInvestment.connect(selectInvestmentFunc)
		btn.newTech.connect(unlockTech)

func unlockTech(techID: String, techButt: techButton, change: int) -> void:
>>>>>>> Stashed changes
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
