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
	if not is_instance_valid(playerNode):
		push_warning("GovernmentControl.updateGovernmentPanel: playerNode not set yet")
		return
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

#func _process(delta: float) -> void:
	#if playerNode != null:
	#	matchVSliders(playerNode)
	#pass

func closeAllOpenLawTabs():
	for law in $PossibleContainer.get_children():
		law.closeTab()
	pass

signal addToConstitution
func addLawToConstitution(lawType):
	print("kickass", lawType)
	emit_signal("addToConstitution", lawType)
	pass


