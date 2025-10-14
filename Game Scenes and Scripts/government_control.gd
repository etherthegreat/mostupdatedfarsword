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
	matchVSliders(playerNode)
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


var farmGoldTax: float
var farmHarmonyTax: float
var campGoldTax: float
var campHarmonyTax: float
var mineGoldTax: float
var mineHarmonyTax: float
var libraryGoldTax: float
var libraryHarmonyTax: float
var templeGoldTax: float
var templeHarmonyTax: float
var towerGoldTax: float
var towerHarmonyTax: float
var forgeGoldTax: float
var forgeHarmonyTax: float
var workshopGoldTax: float
var workshopHarmonyTax: float
var bathGoldTax: float
var bathHarmonyTax: float

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
	$TaxationControl/AmountLabelFarm.text = str($TaxationControl/FarmVSlider.max_value)
	$TaxationControl/AmountLabelCamp.text = str($TaxationControl/CampVSlider.max_value)
	$TaxationControl/AmountLabelMine.text = str($TaxationControl/MineVSlider.max_value)
	$TaxationControl/AmountLabelLibrary.text = str($TaxationControl/LibraryVSlider.max_value)
	$TaxationControl/AmountLabelTemple.text = str($TaxationControl/TempleVSlider.max_value)
	$TaxationControl/AmountLabelTower.text = str($TaxationControl/TowerVSlider.max_value)
	$TaxationControl/AmountLabelForge.text = str($TaxationControl/ForgeVSlider.max_value)
	$TaxationControl/AmountLabelWorkshop.text = str($TaxationControl/WorkshopVSlider.max_value)
	$TaxationControl/AmountLabelBath.text = str($TaxationControl/BathVSlider.max_value)
	$TaxationControl/AmountLabelFarm2.text = str($TaxationControl/FarmVSlider.value, "%")
	$TaxationControl/AmountLabelCamp2.text = str($TaxationControl/CampVSlider.value, "%")
	$TaxationControl/AmountLabelMine2.text = str($TaxationControl/MineVSlider.value, "%")
	$TaxationControl/AmountLabelLibrary2.text = str($TaxationControl/LibraryVSlider.value, "%")
	$TaxationControl/AmountLabelTemple2.text = str($TaxationControl/TempleVSlider.value, "%")
	$TaxationControl/AmountLabelTower2.text = str($TaxationControl/TowerVSlider.value, "%")
	$TaxationControl/AmountLabelForge2.text = str($TaxationControl/ForgeVSlider.value, "%")
	$TaxationControl/AmountLabelWorkshop2.text = str($TaxationControl/WorkshopVSlider.value, "%")
	$TaxationControl/AmountLabelBath2.text = str($TaxationControl/BathVSlider.value, "%")
	farmGoldTax = 0
	farmHarmonyTax = 0
	campGoldTax = 0
	campHarmonyTax = 0
	mineGoldTax = 0
	mineHarmonyTax = 0
	libraryGoldTax = 0
	libraryHarmonyTax = 0
	templeGoldTax = 0
	templeHarmonyTax = 0
	towerGoldTax = 0
	towerHarmonyTax = 0
	forgeGoldTax = 0
	forgeHarmonyTax = 0
	workshopGoldTax = 0
	workshopHarmonyTax = 0
	bathGoldTax = 0
	bathHarmonyTax = 0
	for building in playerNode.countryBuildingList:
		match building.buildingType:
			"Farm":
				farmGoldTax += building.goldTax
				farmHarmonyTax += building.harmonyTax
			"Camp":
				campGoldTax += building.goldTax
				campHarmonyTax += building.harmonyTax
			"Mine":
				mineGoldTax += building.goldTax
				mineHarmonyTax += building.harmonyTax
			"Library":
				libraryGoldTax += building.goldTax
				libraryHarmonyTax += building.harmonyTax
			"Temple":
				templeGoldTax += building.goldTax
				templeHarmonyTax += building.harmonyTax
			"Tower":
				towerGoldTax += building.goldTax
				towerHarmonyTax += building.harmonyTax
			"Forge":
				forgeGoldTax += building.goldTax
				forgeHarmonyTax += building.harmonyTax
			"Workshop":
				workshopGoldTax += building.goldTax
				workshopHarmonyTax += building.harmonyTax
			"Bath":
				bathGoldTax += building.goldTax
				bathHarmonyTax += building.harmonyTax
	$TaxationControl/FoodTaxReturnLabel.text = str("+", farmGoldTax)
	$TaxationControl/FoodHarmonyReturnLabel.text = str("-", farmHarmonyTax)
	$TaxationControl/WoodTaxReturnLabel.text = str("+", campGoldTax)
	$TaxationControl/WoodHarmonyReturnLabel.text = str("-", campHarmonyTax)
	$TaxationControl/MetalTaxReturnLabel.text = str("+", mineGoldTax)
	$TaxationControl/MetalHarmonyReturnLabel.text = str("-", mineHarmonyTax)
	$TaxationControl/ScienceTaxReturnLabel.text = str("+", libraryGoldTax)
	$TaxationControl/ScienceHarmonyReturnLabel.text = str("-", libraryHarmonyTax)
	$TaxationControl/FaithTaxReturnLabel.text = str("+", templeGoldTax)
	$TaxationControl/FaithHarmonyReturnLabel.text = str("-", templeHarmonyTax)
	$TaxationControl/MagicTaxReturnLabel.text = str("+", towerGoldTax)
	$TaxationControl/MagicHarmonyReturnLabel.text = str("-", towerHarmonyTax)
	$TaxationControl/WeaponsTaxReturnLabel.text = str("+", forgeGoldTax)
	$TaxationControl/WeaponsHarmonyReturnLabel.text = str("-", forgeHarmonyTax)
	$TaxationControl/GoldTaxReturnLabel.text = str("+", workshopGoldTax)
	$TaxationControl/GoldHarmonyReturnLabel.text = str("-", workshopHarmonyTax)
	$TaxationControl/CorruptionTaxReturnLabel.text = str("+", bathGoldTax)
	$TaxationControl/CorruptionHarmonyReturnLabel.text = str("-", bathHarmonyTax)
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
