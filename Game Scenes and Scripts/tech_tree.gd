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
			$TechPanel/InsititutionContainer/LanguageControl/LanguageButton.purchase()
		if Technology.techName == "Writing":
			$TechPanel/InsititutionContainer/WritingControl/WritingButton.purchase()
		if Technology.techName == "Alphabet":
			$TechPanel/InsititutionContainer/AlphabetControl/AlphabetButton.purchase()
		if Technology.techName == "Mathematics":
			$TechPanel/InsititutionContainer/MathematicsControl/MathematicsButton.purchase()
		if Technology.techName == "Agriculture":
			$TechPanel/GridContainer/AgricultureControl/AgricultureUnlockButton.purchase()
		if Technology.techName == "Calendar":
			$TechPanel/GridContainer/CalendarControl/CalendarUnlockButton.purchase()
		if Technology.techName == "Irrigation":
			$TechPanel/GridContainer/IrrigationControl/IrrigationUnlockButton.purchase()
		if Technology.techName == "Engineering":
			$TechPanel/GridContainer/EngineeringControl/EngineeringUnlockButton.purchase()
		if Technology.techName == "Copper Working":
			$TechPanel/GridContainer/CopperWorkingControl/CopperWorkingUnlockButton.purchase()
		if Technology.techName == "Bronze Working":
			$TechPanel/GridContainer/BronzeWorkingControl/BronzeWorkingUnlockButton.purchase()
		if Technology.techName == "Iron Working":
			$TechPanel/GridContainer/IronWorkingControl/IronWorkingUnlockButton.purchase()
		if Technology.techName == "Tempuring":
			$TechPanel/GridContainer/TempuringControl/TempuringUnlockButton.purchase()
		if Technology.techName == "Artistry":
			$TechPanel/GridContainer/ArtistryControl/ArtristryUnlockButton.purchase()
		if Technology.techName == "Masonry":
			$TechPanel/GridContainer/MasonryControl/MasonryUnlockButton.purchase()
		if Technology.techName == "Architecture":
			$TechPanel/GridContainer/ArchitectureControl/ArchitectureUnlockButton.purchase()
		if Technology.techName == "Banking":
			$TechPanel/GridContainer/BankingControl/BankingUnlockButton.purchase()
		if Technology.techName == "Sailing":
			$TechPanel/GridContainer/SailingControl/SailingUnlockButton.purchase()
		if Technology.techName == "Statecraft":
			$TechPanel/GridContainer/StatecraftControl/StatecraftUnlockButton.purchase()
		if Technology.techName == "Shipbuilding":
			$TechPanel/GridContainer/ShipbuildingControl/ShipbuildingUnlockButton.purchase()
		if Technology.techName == "Lenscraft":
			$TechPanel/GridContainer/LenscraftControl/LenscraftUnlockButton.purchase()
		if Technology.techName == "Organization":
			$TechPanel/GridContainer/OrganizationControl/OrganizationUnlockButton.purchase()
		if Technology.techName == "Logistics":
			$TechPanel/GridContainer/LogisticsControl/LogisticsUnlockButton.purchase()
		if Technology.techName == "Tactics":
			$TechPanel/GridContainer/TacticsControl/TacticsUnlockButton.purchase()
		if Technology.techName == "Authority":
			$TechPanel/GridContainer/AuthorityControl/AuthorityUnlockButton.purchase()
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


func _on_agriculture_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/AgricultureControl/AgricultureUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/AgricultureControl.position
	#$TechInfoPanel/TechUnlocksLabel.text = str("[i]Italics[/i]")
	$TechInfoPanel.position.y += 330
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


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
	pass # Replace with function body.



func _on_copper_working_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/CopperWorkingControl/CopperWorkingUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/CopperWorkingControl.position
	$TechInfoPanel.position.y += 330
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_artristry_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/ArtistryControl/ArtristryUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/ArtistryControl.position
	$TechInfoPanel.position.y += 50
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_sailing_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/SailingControl/SailingUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/SailingControl.position
	$TechInfoPanel.position.y -= 330
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_organization_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/OrganizationControl/OrganizationUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/OrganizationControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_language_button_pressed() -> void:
	TechButton = $TechPanel/InsititutionContainer/LanguageControl/LanguageButton
	$TechPanel/InsititutionContainer/LanguageControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_writing_button_pressed() -> void:
	TechButton = $TechPanel/InsititutionContainer/WritingControl/WritingButton
	$TechInfoPanel.position = $TechPanel/InsititutionContainer/WritingControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_alphabet_button_pressed() -> void:
	TechButton = $TechPanel/InsititutionContainer/AlphabetControl/AlphabetButton
	$TechInfoPanel.position = $TechPanel/InsititutionContainer/AlphabetControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.

func _on_mathematics_button_pressed() -> void:
	TechButton = $TechPanel/InsititutionContainer/MathematicsControl/MathematicsButton
	$TechInfoPanel.position = $TechPanel/InsititutionContainer/MathematicsControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_calendar_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/CalendarControl/CalendarUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/CalendarControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_bronze_working_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/BronzeWorkingControl/BronzeWorkingUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/BronzeWorkingControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_masonry_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/MasonryControl/MasonryUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/MasonryControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.



func _on_statecraft_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/StatecraftControl/StatecraftUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/StatecraftControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_logistics_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/LogisticsControl/LogisticsUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/LogisticsControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_irrigation_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/IrrigationControl/IrrigationUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/IrrigationControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.



func _on_iron_working_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/IronWorkingControl/IronWorkingUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/IronWorkingControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_architecture_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/ArchitectureControl/ArchitectureUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/ArchitectureControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_shipbuilding_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/ShipbuildingControl/ShipbuildingUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/ShipbuildingControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.

func _on_tactics_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/TacticsControl/TacticsUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/TacticsControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.

func _on_engineering_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/EngineeringControl/EngineeringUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/EngineeringControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_tempuring_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/TempuringControl/TempuringUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/TempuringControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_banking_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/BankingControl/BankingUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/BankingControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_lenscraft_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/LenscraftControl/LenscraftUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/LenscraftControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_authority_unlock_button_pressed() -> void:
	TechButton = $TechPanel/GridContainer/AuthorityControl/AuthorityUnlockButton
	$TechInfoPanel.position = $TechPanel/GridContainer/AuthorityControl.position
	$TechInfoPanel.position.y -= 325
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_administration_button_pressed() -> void:
	TechButton = $TechPanel/UnlockedContainer/AdministrationControl/AdministrationButton
	$TechInfoPanel.position = $TechPanel/UnlockedContainer/AdministrationControl.position
	$TechInfoPanel.position.y -= 400
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_printing_press_button_pressed() -> void:
	TechButton = $TechPanel/UnlockedContainer/PrintingPressControl/PrintingPressButton
	$TechInfoPanel.position = $TechPanel/UnlockedContainer/PrintingPressControl.position
	$TechInfoPanel.position.y -= 400
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.


func _on_steam_power_button_pressed() -> void:
	TechButton = $TechPanel/UnlockedContainer/SteamPowerControl/SteamPowerButton
	$TechInfoPanel.position = $TechPanel/UnlockedContainer/SteamPowerControl.position
	$TechInfoPanel.position.y -= 400
	$TechInfoPanel.position.x += 200
	updateTechInfoPanel(TechButton)
	if $TechInfoPanel.visible == false:
		$TechInfoPanel.visible = true
	pass # Replace with function body.
