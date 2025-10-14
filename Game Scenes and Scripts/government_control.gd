extends Control

var playerNode: country

var implementedLaws: Array = []
var possibleLaws: Array = []

func buildSelf(homeCountry):
	playerNode = homeCountry
	$TaxationControl/FarmVSlider.value = playerNode.setFarmTaxAmount
	$TaxationControl/CampVSlider.value = playerNode.setCampTaxAmount
	$TaxationControl/MineVSlider.value = playerNode.setMineTaxAmount
	$TaxationControl/LibraryVSlider.value = playerNode.setLibraryTaxAmount
	$TaxationControl/TempleVSlider.value = playerNode.setTempleTaxAmount
	$TaxationControl/TowerVSlider.value = playerNode.setTowerTaxAmount
	$TaxationControl/ForgeVSlider.value = playerNode.setForgeTaxAmount
	$TaxationControl/WorkshopVSlider.value = playerNode.setWorkshopTaxAmount
	$TaxationControl/BathVSlider.value = playerNode.setBathTaxAmount
	pass

var lawScene = preload("res://law.tscn")

func updateGovernmentPanel():
	implementedLaws.clear()
	possibleLaws.clear()
	for law in playerNode.lawsInConstitution:
		implementedLaws.append(law)
	for law in playerNode.unlockedLaws:
		possibleLaws.append(law)
	for law in $GridContainer.get_children():
		law.queue_free()
	for law in $PossibleContainer.get_children():
		law.queue_free()
	for law in implementedLaws:
		var newLaw = lawScene.instantiate()
		newLaw.buildSelf(law.lawType, true)
		#newLaw.selectThisLaw.connect(addLawToConstitution)
		$GridContainer.add_child(newLaw)
	for law in possibleLaws:
		var newLaw = lawScene.instantiate()
		newLaw.buildSelf(law.lawType, false)
		newLaw.selectThisLaw.connect(addLawToConstitution)
		newLaw.lawSelectionButtonPressed.connect(closeAllOpenLawTabs)
		$PossibleContainer.add_child(newLaw)
	pass

func closeAllOpenLawTabs():
	for law in $PossibleContainer.get_children():
		law.closeTab()
	pass

signal addToConstitution
func addLawToConstitution(lawType):
	print("kickass", lawType)
	emit_signal("addToConstitution", lawType)
	pass

func _process(delta: float) -> void:
	if playerNode != null:
		matchVSliders(playerNode)
	else:
		print("DEBUG FAILURE TO FINDPLAYERNODE")
	pass

func matchVSliders(playerNode):
	$TaxationControl/FarmVSlider.max_value = playerNode.minFarmTaxAmount
	$TaxationControl/CampVSlider.max_value = playerNode.minCampTaxAmount
	$TaxationControl/MineVSlider.max_value = playerNode.minMineTaxAmount
	$TaxationControl/LibraryVSlider.max_value = playerNode.minLibraryTaxAmount
	$TaxationControl/TempleVSlider.max_value = playerNode.minTempleTaxAmount
	$TaxationControl/TowerVSlider.max_value = playerNode.minTowerTaxAmount
	$TaxationControl/ForgeVSlider.max_value = playerNode.minForgeTaxAmount
	$TaxationControl/WorkshopVSlider.max_value = playerNode.minWorkshopTaxAmount
	$TaxationControl/BathVSlider.max_value = playerNode.minBathTaxAmount
	pass


signal sliderChanged
func changedSlider(amount, type):
	emit_signal("sliderChanged", amount, type)
	pass

func _on_farm_v_slider_value_changed(value: float) -> void:
	changedSlider($TaxationControl/FarmVSlider.value, "Farm")
	pass # Replace with function body.


func _on_camp_v_slider_value_changed(value: float) -> void:
	changedSlider($TaxationControl/CampVSlider.value, "Camp")
	pass # Replace with function body.


func _on_mine_v_slider_value_changed(value: float) -> void:
	changedSlider($TaxationControl/MineVSlider.value, "Mine")
	pass # Replace with function body.

func _on_library_v_slider_value_changed(value: float) -> void:
	changedSlider($TaxationControl/FarmVSlider.value, "Library")
	pass # Replace with function body.
	
func _on_temple_v_slider_value_changed(value: float) -> void:
	changedSlider($TaxationControl/TempleVSlider.value, "Temple")
	pass # Replace with function body.

func _on_tower_v_slider_value_changed(value: float) -> void:
	changedSlider($TaxationControl/TowerVSlider.value, "Tower")
	pass # Replace with function body.

func _on_forge_v_slider_value_changed(value: float) -> void:
	changedSlider($TaxationControl/ForgeVSlider.value, "Forge")
	pass # Replace with function body.

func _on_workshop_v_slider_value_changed(value: float) -> void:
	changedSlider($TaxationControl/WorkshopVSlider.value, "Workshop")
	pass # Replace with function body.

func _on_bath_v_slider_value_changed(value: float) -> void:
	changedSlider($TaxationControl/BathVSlider.value, "Bath")
	pass # Replace with function body.
