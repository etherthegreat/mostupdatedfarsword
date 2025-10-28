extends Control


var unlockedTechs: Array = []
var playerNode: country
#signal updateTechTree

var costForUnlock: int

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
var TechButton: techButton

var TechToDisplay: String
func updateTechInfoPanel(TechButton):
	if TechButton.purchased == true:
		$TechInfoPanel/PurchaseTechButton.text = str("Purchased")
	else:
		$TechInfoPanel/PurchaseTechButton.text = str("Cost: ", TechButton.technologyCost)
	$TechInfoPanel/TechNameLabel.text = str(TechButton.technologyName)
	if TechButton.technologyDescription != null:
		$TechInfoPanel/TechDescriptionLabel.text = str(TechButton.technologyDescription)
	else:
		$TechInfoPanel/TechDescriptionLabel.text = str("Error:  No Technology Description Found")
	pass



func _process(delta: float) -> void:
	if $TechInfoPanel.visible == true && TechButton != null:
		if TechButton.purchased == true || playerNode.TotalScience < TechButton.technologyCost:
			$TechInfoPanel/PurchaseTechButton.disabled = true
		else:
			for techButton in TechButton.requiredTechs:
				if techButton.purchased == false:
					$TechInfoPanel/PurchaseTechButton.disabled = true
					return
				$TechInfoPanel/PurchaseTechButton.disabled = false
				return
	pass

func _on_close_panel_button_pressed() -> void:
	TechButton = null
	$TechInfoPanel.visible = false
	pass # Replace with function body.


func _on_purchase_tech_button_pressed() -> void:
	if TechButton == null:
		print("Missing TechNology Error")
	else:
		TechButton.purchase()
		emit_signal("addTechToPlayer", TechButton.technologyName)
		playerNode.TotalScience -= TechButton.technologyCost
		updateTechInfoPanel(TechButton)
		$TechInfoPanel.visible = false
	pass # Replace with function body.

func connectTechButtons():
	for techButton in $TechPanel/GridContainer.get_children():
		techButton.newTech.connect(techButtonPressed)
	for techButton in $TechPanel/InsititutionContainer.get_children():
		techButton.newTech.connect(techButtonPressed)
	for techButton in $TechPanel/UnlockedContainer.get_children():
		techButton.newTech.connect(techButtonPressed)
	pass

func techButtonPressed(type, button):
	TechButton = button
	$TechInfoPanel.position = button.position
	$TechInfoPanel.position.y += 330
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass
