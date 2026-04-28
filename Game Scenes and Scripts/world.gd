extends Node2D

var locBallUIScene = load("res://loc_ball_ui.tscn")
var gameLanguage: String
var LocBallUI

var playerCountry: String
var playerCountryNode: country
var playerOutputDict: Dictionary
var paused: bool #determines if game is paused or not
var date: int #date of the in-game world
var newGame: bool #whether or not this is a saved game or not
var loadGameFile #file, document, saved in computer
var aliveCountriesList: Array = []

var month: int #25 day months
var year: int #12 month years
var day: int #300 day years
var dayOfMonth: int #25 day months
var age: int #current age, changes when Demon King dies

var worldCreation: bool

var armyMode: bool

var playerCapitalPathButton: pathPointButton 

var mapMode: String
var displayCorruption: bool

func _process(delta: float) -> void:
	if worldCreation == true:
		$CanvasLayer/LoadingSprite.rotation += 1
		return
	else:
		$"CanvasLayer/Resource Bar (TOP)/container/FoodLabel/Label".text = str(playerCountryNode.TotalFood)
		$"CanvasLayer/Resource Bar (TOP)/container/GoldLabel/Label".text = str(playerCountryNode.TotalGold)
		$"CanvasLayer/Resource Bar (TOP)/container/WoodLabel/Label".text = str(playerCountryNode.TotalWood)
		$"CanvasLayer/Resource Bar (TOP)/container/MetalLabel/Label".text = str(playerCountryNode.TotalMetal)
		$"CanvasLayer/Resource Bar (TOP)/container/WeaponsLabel/Label".text = str(playerCountryNode.TotalWeapons)
		$"CanvasLayer/Resource Bar (TOP)/container/ScienceLabel/Label".text = str(playerCountryNode.SPM)
		$"CanvasLayer/Resource Bar (TOP)/container/FaithLabel/Label".text = str(playerCountryNode.TotalFaith)
		$"CanvasLayer/Resource Bar (TOP)/container/MagicLabel/Label".text = str(playerCountryNode.TotalMagic)
		$"CanvasLayer/Resource Bar (TOP)/container/CultureLabel/Label".text = str(playerCountryNode.TotalCulture)
		$"CanvasLayer/Resource Bar (TOP)/container/MandateLabel/Label".text = str(playerCountryNode.TotalMandate)
		$"CanvasLayer/Resource Bar (TOP)/container/HarmonyLabel/Label".text = str(playerCountryNode.TotalHarmony)
		$"CanvasLayer/Resource Bar (TOP)/container/InfluenceLabel/Label".text = str(playerCountryNode.TotalInfluence)
		$"CanvasLayer/Resource Bar (TOP)/container/ManpowerLabel/Label".text = str(playerCountryNode.TotalManpower)
		updateMap()
	if $CanvasLayer/TechTree.investmentTech == null:
		$CanvasLayer/NextTurnControl/NextTurn.visible = false
		$CanvasLayer/NextTurnControl/PickTech.visible = true
	else:
		$CanvasLayer/NextTurnControl/PickTech.visible = false
		$CanvasLayer/NextTurnControl/NextTurn.visible = true
	pass

func updateMap():
	$TileController.updateTiles(mapMode, displayCorruption, playerCountryNode)
	pass



signal calculateSeason
func newGameBuild(CID, gameLang):
	worldCreation = true
	gameLanguage = gameLang
	var locBallUIWorld = locBallUIScene.instantiate()
	locBallUIWorld.buildSelf("Game", gameLanguage)
	LocBallUI = locBallUIWorld
	add_child(locBallUIWorld)
	$CanvasLayer/LoadingLabel.text = "Building World"
	month = 6
	year = 673
	day = 126
	dayOfMonth = 1
	age = 2
	armyMode = false
	$TileController.connectTileSignals()
	$TileController.transfer.connect(calculateTileEvent)
	for Tile in $TileController.get_children():
		Tile.onNewGame()
		Tile.calculateSeason(month)
		Tile.clicked.connect(tileClicked)
		Tile.censusComplete.connect(manaUpdate)
	$CanvasLayer/LoadingLabel.text = "Spawning Countries"
	$CanvasLayer/LoadingProgressBar.value = 25
	spawnNewGameCountries(CID)
	connectCountrySignals()
	$CanvasLayer/BuildingInfoPanel/buildingPanelPanel.player = playerCountryNode
	$CanvasLayer/LoadingLabel.text = "Prospecting for Ores"
	$CanvasLayer/LoadingProgressBar.value = 50
	matchCountryBuildings()
	for country in aliveCountriesList:
		country.prospectForOres()
	emit_signal("calculateSeason", month)
	$CanvasLayer/TileInfoPanel.TilesCalculated()
	#$CanvasLayer/TileInfoPanel.displayTileInfo()
	#$CanvasLayer/BuildingInfoPanel.displayBuildingInfo()
	#$CanvasLayer/Spellbook.displaySpells(playerCountryNode)
	$CanvasLayer/LoadingLabel.text = "Loading UI (Magic)"
	$CanvasLayer/LoadingProgressBar.value = 75
	updatePlayerUI()
	$TileController/Tile4.discoverTile()
	$TileController/Tile5.discoverTile()
	$TileController/Tile6.discoverTile()
	$TileController/Tile7.discoverTile()
	$TileController/Tile8.discoverTile()
	$TileController/Tile9.discoverTile()
	$TileController/Tile10.discoverTile()
	$TileController.discoverTiles(playerCountryNode)
	worldCreation = false
	$RightClickDetector.visible = true
	mapMode = "Polis"
	displayCorruption = true
	$CanvasLayer/LoadingProgressBar.value = 100
	$CanvasLayer/LoadingBackground.visible = false
	$CanvasLayer/LoadingSprite.visible = false
	$CanvasLayer/LoadingProgressBar.visible = false
	$CanvasLayer/LoadingLabel.visible = false
	#for country in aliveCountriesList:
		#for Army in country.countryArmyList:
			#Army.raiseSelf()
	pass

var countryNode = load("res://Game Scenes and Scripts/country.tscn")

func spawnNewGameCountries(CID):
	playerCountry = CID
	var penderTal = countryNode.instantiate()
	if playerCountry == "PDT":
		penderTal.Player = true
		playerCountryNode = penderTal
		playerCapitalPathButton = $"PathControl/PathPointsControl/3"
	else:
		penderTal.Player = false
	penderTal.CID = "PDT"
	for Tile in $TileController.get_children():
		if Tile.tileOwner == "PDT":
			penderTal.OwnedTileList.append(Tile)
	penderTal.NewGameBuild()
	aliveCountriesList.append(penderTal)
	$CountryController.add_child(penderTal)
	
	#penderTal.surveyResources()
	
	var anlaxia = countryNode.instantiate()
	if playerCountry == "ANL":
		anlaxia.Player = true
		playerCountryNode = anlaxia
		playerCapitalPathButton = $"PathControl/PathPointsControl/17"
	else:
		anlaxia.Player = false
	anlaxia.CID = "ANL"
	for Tile in $TileController.get_children():
		if Tile.tileOwner == "ANL":
			anlaxia.OwnedTileList.append(Tile)
	anlaxia.NewGameBuild()
	aliveCountriesList.append(anlaxia)
	$CountryController.add_child(anlaxia)
	#anlaxia.surveyResources()
	
	var vitherianOrder = countryNode.instantiate()
	if playerCountry == "VTO":
		vitherianOrder.Player = true
		playerCountryNode = vitherianOrder
		playerCapitalPathButton = $"PathControl/PathPointsControl/29"
	else:
		vitherianOrder.Player = false
	vitherianOrder.CID = "VTO"
	for Tile in $TileController.get_children():
		if Tile.tileOwner == "VTO":
			vitherianOrder.OwnedTileList.append(Tile)
	vitherianOrder.NewGameBuild()
	aliveCountriesList.append(vitherianOrder)
	$CountryController.add_child(vitherianOrder)
	#vitherianOrder.surveyResources()
	
	var demonEmpire = countryNode.instantiate()
	if playerCountry == "DEM":
		demonEmpire.Player = true
		playerCountryNode = demonEmpire
		playerCapitalPathButton = $"PathControl/PathPointsControl/30"
	else:
		demonEmpire.Player = false
	demonEmpire.CID = "DEM"
	for Tile in $TileController.get_children():
		if Tile.tileOwner == "DEM":
			demonEmpire.OwnedTileList.append(Tile)
	demonEmpire.NewGameBuild()
	aliveCountriesList.append(demonEmpire)
	$CountryController.add_child(demonEmpire)
	#demonEmpire.surveyResources()
	
	var eighthHouse = countryNode.instantiate()
	if playerCountry == "EIG":
		eighthHouse.Player = true
		playerCountryNode = eighthHouse
		playerCapitalPathButton = $"PathControl/PathPointsControl/30"
	else:
		eighthHouse.Player = false
	eighthHouse.CID = "EIG"
	for Tile in $TileController.get_children():
		if Tile.tileOwner == "EIG":
			eighthHouse.OwnedTileList.append(Tile)
	eighthHouse.NewGameBuild()
	aliveCountriesList.append(eighthHouse)
	$CountryController.add_child(eighthHouse)
	#eighthHouse.surveyResources()
	$CameraMovementController/Camera2D.global_position = playerCapitalPathButton.global_position
	
	var dummyCountry = countryNode.instantiate()
	if playerCountry == "DUM":
		dummyCountry.Player = true
		playerCountryNode = dummyCountry
		playerCapitalPathButton = $"PathControl/PathPointsControl/10"
	else:
		dummyCountry.Player = false
	dummyCountry.CID = "DUM"
	for Tile in $TileController.get_children():
		if Tile.tileOwner == "DUM":
			dummyCountry.OwnedTileList.append(Tile)
	dummyCountry.NewGameBuild()
	aliveCountriesList.append(dummyCountry)
	$CountryController.add_child(dummyCountry)
	
	pass

var playerOutput: Dictionary = {}
func calculatePlayerOutputs(caller):
	playerOutput.clear()
	playerCountryNode.outputCheck(caller)
	pass

func returnOutput(outputsDict, caller):
	playerOutput = outputsDict
	caller.returnedOutput(playerOutput)
	pass

func connectCountrySignals():
	for country in aliveCountriesList:
		country.raiseThisArmySignal.connect(raiseArmyFromWorld)
	pass

func updateBeliefControl():
	$CanvasLayer/BeliefControl.updateSelf()
	pass

func updatePlayerUI():
	$CanvasLayer.assignPlayerNode(playerCountryNode)
	$CanvasLayer/TileInfoPanel.selectThisTile.connect(assignSelectedTile)
	$CanvasLayer/TileInfoPanel.governorButtonPressed.connect(openGovernorsPanel)
	$CanvasLayer/TileInfoPanel.confirmThisGovernor.connect(assignGovernor)
	$CanvasLayer/TechTree.buildSelf(playerCountryNode)
	$CanvasLayer/TechTree.addTechToPlayer.connect(newPlayerTech)
	$CanvasLayer/BeliefControl.buildSelf(playerCountryNode)
	$CanvasLayer/BuildingInfoPanel/buildingPanelPanel.player = playerCountryNode
	$PathControl.activateArmyControlMode.connect(activateArmyControl)
	$PathControl.connectPathPoints(playerCountryNode)
	$PathControl.updateArmy.connect(updateArmyFunc)
	$PathControl.updatePathPoints.connect(updatePathPointsFunc)
	$PathControl.updateCivilian.connect(updateCivFunc)
	$PathControl.tileDevelopment.connect(newTileDevelopment)
	$PathControl.meleeButtonPressed.connect(meleePressed)
	$PathControl.rangedButtonPressed.connect(rangedPressed)
	$CanvasLayer/CivilianControl.loadCivilians(playerCountryNode, playerCountryNode.OwnedTileList)
	$CanvasLayer/CivilianControl.raiseThisUnit.connect(raiseCivilianUnit)
	$CanvasLayer/MilitaryPanelControl.buildSelf(playerCountryNode)
	$CanvasLayer/MilitaryPanelControl.newArmySignal.connect(buildNewPlayerArmy)
	playerCountryNode.displayCommander.connect(UICommander)
	playerCountryNode.checkingOutput.connect(returnOutput)
	$CanvasLayer/GovernmentControl.buildSelf(playerCountryNode)
	$CanvasLayer/GovernmentControl.addToConstitution.connect(addLawToCountry)
	$CanvasLayer/FactionControl.newRewardSend.connect(addNewRewards)
	$CanvasLayer/SpellSchoolsControl.connectSchools()
	$CanvasLayer/SpellSchoolsControl.lvlUpSpell.connect(newSpellEvent)
	#$CanvasLayer/SpellSchoolsControl.askForInfo.connect(giveSpellInfo)
	$CanvasLayer/Spellbook.spellToUse.connect(activateSpellMapMode)
	$TileController.spellAssignedToTile.connect(spellPurchased)
	$TileController.colonizeTile.connect(updateCountryTiles)
	$TileController.newTileOwner.connect(tileSiegeWon)
	$PathControl.call_deferred("showPathPoints", playerCapitalPathButton)
	$CanvasLayer/BuildingInfoPanel.buildSelf(playerCountryNode)
	$CanvasLayer/BuildingInfoPanel.newBuildingInTile.connect(addNewBuildingToTile)
	$CanvasLayer/TileInfoPanel.retrieveTileOutputs.connect(retrieveOutputs)
	#$PathControl.makeAllContainersPassable()
	#print("ALL I NEED")
	pass

var thisTileNumber: int
var selectedTile: Tile


func manaUpdate(type, amount, dictionary):
	$CanvasLayer/TileInfoPanel.buildTileOutput(type, amount, dictionary)
	pass

func tileClicked(tile):
	#print("Tile", tile.tileNumber, "Clicked")
	selectedTile = tile
	#$CanvasLayer/TileInfoPanel.thisTile = tile
	
	$CanvasLayer/TileInfoPanel.displayTileInfo(tile)
	if $CanvasLayer/TileInfoPanel.visible == false:
		$CanvasLayer/TileInfoPanel.visible = true
	else:
		$CanvasLayer/TileInfoPanel.visible = false
	#$CanvasLayer/TileInfoPanel.thisTile = tile
	#$CanvasLayer/TileInfoPanel.displayTileInfo()
	#$CanvasLayer/BuildingInfoPanel.thisTile = tile
	#if $CanvasLayer/BuildingInfoPanel.visible == false:
		#$CanvasLayer/BuildingInfoPanel.visible = true
	$CanvasLayer/BuildingInfoPanel.displayBuildingInfo(tile)
	pass

func retrieveOutputs():
	selectedTile.censusTile(playerCountryNode)
	pass

func matchCountryBuildings():
	for country in aliveCountriesList:
		for Tile in $TileController.get_children():
			if Tile.tileOwner == playerCountry:
				for building in Tile.tileBuildingsList:
					playerCountryNode.connectBuilding(building)
					#building.towerBuilding.connect(signalTowerInTile)
	pass

func _on_food_area_2d_mouse_entered():
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 360
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 1)
func _on_food_area_2d_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_wood_area_2d_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 480
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 2)
func _on_wood_area_2d_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_metal_area_2d_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 600
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 3)
func _on_metal_area_2d_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_gold_area_2d_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 240
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 0)
func _on_gold_area_2d_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_weapons_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 720
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 4)
func _on_weapons_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_science_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1000
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 5)
func _on_science_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_faith_control_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1000
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 6)
func _on_faith_control_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_magic_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1000
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 7)
func _on_magic_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
func _on_culture_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1000
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 8)
	pass # Replace with function body.
func _on_culture_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.
func _on_mandate_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1440
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 9)
	pass # Replace with function body.
func _on_mandate_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.
func _on_harmony_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1440
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 10)
	pass # Replace with function body.
func _on_harmony_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.
func _on_influence_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 1440
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 11)
	pass # Replace with function body.
func _on_influence_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.
func _on_manpower_area_mouse_entered() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.position.x = 840
	$CanvasLayer/ResourceInfoControl.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = true
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.displayNationalResource(playerCountryNode, 12)
	pass # Replace with function body.

func _on_manpower_area_mouse_exited() -> void:
	$CanvasLayer/ResourceInfoControl/ResourceInfoPanel.visible = false
	pass # Replace with function body.

#oldnext turn function
func _on_test_resource_button_pressed() -> void:
	
	pass # Replace with function body.

func newPlayerTech(techName) -> void:
	playerCountryNode.addTechnologicalDiscovery(techName)
	pass # Replace with function body.

func _on_building_panel_panel_upgrade_building(thisBuilding) -> void:
	print("thisBuilding", thisBuilding.buildingType, thisBuilding.buildingLevel)
	for Tile in $TileController.get_children():
		if Tile.tileNumber == thisBuilding.number:
			print("tile", Tile.tileNumber)
			for building in Tile.tileBuildingsList:
				if building.buildingType == thisBuilding.buildingType:
					building.upgradeBuilding()
	pass # Replace with function body.


func _on_building_panel_panel_downgrade_building(thisBuilding) -> void:
	for Tile in $TileController.get_children():
		if Tile.tileNumber == thisBuilding.number:
			print("tile", Tile.tileNumber)
			for building in Tile.tileBuildingsList:
				if building.buildingType == thisBuilding.buildingType:
					building.downgradeBuilding()
	pass # Replace with function body.


func assignSelectedTile(tileToSelect):
	#selectedTile = tileToSelect
	pass

func addNewRewards(rewardType):
	playerCountryNode.createFactionReward(rewardType)
	pass

func assignGovernor(governorToAssign, tileToAssignTo):
	tileToAssignTo.assignNewGovernor(governorToAssign)
	governorToAssign.hire()
	$CanvasLayer/TileInfoPanel.displayTileInfo(tileToAssignTo)
	if tileToAssignTo.stationedArmy !=null:
		tileToAssignTo.stationedArmy.addUnitCommander(governorToAssign)
	calculateGovernorEvent(governorToAssign)
	pass

func openGovernorsPanel(tile):
	$CanvasLayer/TileInfoPanel.calculateAvailableGovernor(playerCountryNode, selectedTile)
	pass

#Magic Code

func newSpellEvent(schoolType, currentLvl):
	var sType = schoolType
	var lvl = currentLvl
	match sType:
		"elementalist":
			match lvl:
				0:
					createNewEvent("spell", "GEN_PLENTIFY_UNLOCK", "GEN", gameLanguage)
				1: 
					createNewEvent("spell", "GEN_HEALING_WINDS_UNLOCK", "GEN", gameLanguage)
				2:
					createNewEvent("spell", "GEN_RAISE_SPRING_UNLOCK", "GEN", gameLanguage)
				
	pass

#Government Code
func addLawToCountry(lawType):
	playerCountryNode.addLawToConstitution(lawType)
	$CanvasLayer/GovernmentControl.updateGovernmentPanel()
	pass

#Army World Code
func _on_army_button_pressed() -> void:
	if $CanvasLayer/MilitaryPanelControl.visible == false:
		$CanvasLayer/MilitaryPanelControl.visible = true
		for BarracksButton in $CanvasLayer/MilitaryPanelControl/ScrollContainer/GridContainer.get_children():
			BarracksButton.updateSelf()
	else:
		$CanvasLayer/MilitaryPanelControl.visible = false
	pass # Replace with function body.
	
const armyScene = preload("res://Game Scenes and Scripts/army.tscn")
func buildNewPlayerArmy(barracksBuilding, barracksTile, bbButton, playerNode, newArmyName):
	playerNode.addArmy(newArmyName, barracksTile.tileNumber)
	for Army in playerNode.countryArmyList:
		if Army.ArmyName == newArmyName:
			bbButton.addPrebuiltArmy(Army)
	pass

func UICommander(commander):
	$CanvasLayer/TileInfoPanel/GovernorSelection.buildSelectedSelf(commander)
	$CanvasLayer/TileInfoPanel/GovernorSelection.changePanel("commander")
	$CanvasLayer/TileInfoPanel/GovernorSelection.position = Vector2(-212, -473)
	if $CanvasLayer/TileInfoPanel/GovernorSelection.visible == false:
		$CanvasLayer/TileInfoPanel/GovernorSelection.visible = true
	else:
		$CanvasLayer/TileInfoPanel/GovernorSelection.visible = false
	pass
var pathPointButtonToSend: pathPointButton

func raiseArmyFromWorld(Army, country, Tile):
	
	#this is how the armies spawn into the world, will need a redo soon
	#literally just add a system where tiles have a reference to their pathPointButton instead of this
	#demon AI system will spawn units using raiseArmyFromWorld
	pathPointButtonToSend = Tile.tileSpawnPoint
	if country == playerCountryNode:
		$PathControl.raisePlayerArmy(Army, country, Tile, pathPointButtonToSend)
	else:
		#here is where we will raise either Demonic or nonPlayer Country AIs
		$PathControl.raiseComputerArmy(Army, country, Tile, pathPointButtonToSend)
	pass
func raiseCivilianUnit(civ, country):
	if country == playerCountryNode:
		$PathControl.raisePlayerCiv(civ, country, Tile)
	pass

func activateArmyControl():
	armyMode = true
	pass

var eventScene = load("res://eventScene.tscn")

var temporaryTile: Tile
#MAP INTERACTION
func activateSpellMapMode(spell, cost):
	if spell.militarySpell == false:
		$TileController.spellSelectionMode(spell, cost, playerCountryNode)
	else:
		$PathControl.spellSelectionMode(spell, cost, playerCountryNode)
	pass

func spellPurchased(cost):
	playerCountryNode.TotalMagic -= cost
	$TileController.normalMode()
	$CanvasLayer/Spellbook.displaySpells(playerCountryNode)
	pass

#EVENT SYSTEM
func calculateTileEvent(tile, type):
	print("most up to date", tile.tileName, type)
	match type:
		"wizard":
			createNewTileEvent("tile", "wizardSelect", "GEN", tile, gameLanguage)
	pass

func calculateGovernorEvent(governor):
	match governor.governorType:
		"Wolverina Gundo":
			match governor.governorLevel:
				1:
					createNewEvent("governor", "PDT_Wolverina0", "PDT", gameLanguage)
	pass

func createNewEvent(type, id, CID, language):
	var newEvent = eventScene.instantiate()
	match type:
		"governor":
			#print(type, id, CID, language, "looking gay")
			newEvent.buildSelf(type, id, CID, language)
			newEvent.eventButtonPressed.connect(matchEventOutcome)
			$CanvasLayer/EventControl/EventContainer.add_child(newEvent)
		"spell":
			newEvent.buildSelf(type, id, CID, language)
			newEvent.eventButtonPressed.connect(matchEventOutcome)
			$CanvasLayer/EventControl/EventContainer.add_child(newEvent)
	pass

func createNewTileEvent(type, id, CID, tile, language):
	#print("like a door", type, id, CID, tile, language)
	var newEvent = eventScene.instantiate()
	newEvent.buildTileEventSelf(type, id, CID, tile, language)
	newEvent.tileEventButtonPressed.connect(matchTileEventOutcome)
	$CanvasLayer/EventControl/EventContainer.add_child(newEvent)
	pass

func matchEventOutcome(eventButtonID, eventType, eventID, eventCountry):
	print("signal received ")
	match eventCountry:
		"GEN":
			match eventType:
				"spell":
					match eventID:
						"GEN_PLENTIFY_UNLOCK":
							match eventButtonID:
								"GEN_Plentify_Unlock_1":
									playerCountryNode.addSpellToSpellbook("Plentify", 1, 0)
									playerCountryNode.levelUpSchool("elementalist")
						"GEN_HEALING_WINDS_UNLOCK":
							match eventButtonID:
								"GEN_Healing_Winds_Unlock_1":
									playerCountryNode.addSpellToSpellbook("Healing Winds", 1, 0)
									playerCountryNode.levelUpSchool("elementalist")
						"GEN_RAISE_SPRING_UNLOCK":
							match eventButtonID:
								"GEN_Raise_Spring_Unlock_1":
									playerCountryNode.addSpellToSpellbook("Raise Spring", 1, 0)
									playerCountryNode.levelUpSchool("elementalist")
			pass
		"PDT":
			match eventType:
				"governor":
					match eventID:
						"PDT_Wolverina0":
							match eventButtonID:
								"PDT_Wolverina0-1":
									print("YOUVE COMPLETED THE CHAIN")
									var tempGov = governor.new()
									for Tile in playerCountryNode.OwnedTileList:
										if Tile.tileGovernor != null:
											match Tile.tileGovernor.governorType:
												"Wolverina Gundo":
													tempGov = Tile.tileGovernor
									$CanvasLayer/FactionControl.addFaction("ANL_Republicans", 10, tempGov)
								"PDT_Wolverina0-2":
									print("What's UP Chump?")
	pass

func matchTileEventOutcome(eventButtonID, eventType, eventCountry, eventTile):
	print(eventButtonID, "marvel rivals")
	match eventCountry:
		"GEN":
			match eventButtonID:
				"GEN_AssignDruidWizard":
					eventTile.addWizard("druid")
				"GEN_AssignElementalWizard":
					eventTile.addWizard("elementalist")
				"GEN_AssignIllusionWizard":
					eventTile.addWizard("illusionist")
				"GEN_AssignDivinerWizard":
					eventTile.addWizard("diviner")
				"GEN_AssignSummonerWizard":
					eventTile.addWizard("summoner")
				"GEN_AssignAlchemistWizard":
					eventTile.addWizard("alchemist")
			print(eventTile.tileWizard, "tileWizard")
	pass


func _on_right_click_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed('Right Click'):
		resetUI()
	pass # Replace with function body.

func resetUI():
	for Tile in $TileController.get_children():
		Tile.visible = true
	$TileController.normalMode()
	for Control in $CanvasLayer.get_children():
		Control.visible = false
		$CanvasLayer/PanelOpenerControl.visible = true
		$"CanvasLayer/Resource Bar (TOP)".visible = true
	pass

var lastSelectedPathPoint: pathPointButton
func updateArmyFunc(Army, pathPoint):
	$CanvasLayer/ArmyPanel/ArmyNameLabel.text = Army.ArmyName
	$CanvasLayer/ArmyPanel/AttackLabel.text = str(Army.armyPunch)
	$CanvasLayer/ArmyPanel/DefenseLabel.text = str(Army.armyBlock)
	$CanvasLayer/ArmyPanel/RangedAttackLabel.text = str(Army.armyLaunch)
	$CanvasLayer/ArmyPanel/RangedDefenseLabel.text = str(Army.armyDefence)
	$CanvasLayer/ArmyPanel/ManpowerLabel.text = str(Army.manpowerInArmy, " / ", Army.maxManpower)
	$CanvasLayer/ArmyPanel/ShieldLabel.text = str(Army.armyShield, " / ", Army.armyMaxShield)
	#$CanvasLayer/ArmyPanel/LocationLabel.text = str(pathPoint.pathNumber)
	if $CanvasLayer/ArmyPanel.visible == false:
		$CanvasLayer/ArmyPanel.visible = true
		lastSelectedPathPoint = pathPoint
	else:
		$CanvasLayer/ArmyPanel.visible = false
		lastSelectedPathPoint = null
	pass

func _on_path_control_show_army_info(key) -> void:
	match key:
		"Wait":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 60
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Wait"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Pause this unit for the turn."
		"Hold":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 110
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Hold"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Hold this unit indefinitely."
		"Melee":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 160
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Melee Attack"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Attack using this unit's melee strength - unit will sustain manpower casualties!"
		"Ranged":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 210
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Ranged Attack"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Attack using this unit's ranged strength - unit will lose weapons!"
		"Reinforce":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 260
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Reinforce"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Rebuild the manpower reserves of this unit."
		"Weapons":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 310
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Resupply"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Build up the supplies and weapons of this unit."
		"Shield":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = true
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.position.x = 360
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionNameLabel.text = "Shield"
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl/ActionDescriptionLabel.text = "Grant half of this unit's defense to a nearby unit for this turn."
		"Close":
			$CanvasLayer/ArmyPanel/ActionInfoPanelControl.visible = false
	pass # Replace with function body.

#this is where the battles for melee are calculated
var calculateMelee: bool
func meleePressed(armyPath, thisArmy) -> void:
	if lastSelectedPathPoint != null:
		for pathPointButton in lastSelectedPathPoint.neighborPathPoints:
			pathPointButton.calculateBattle(armyPath, "melee", thisArmy, lastSelectedPathPoint)
	#set all apfs that are not neighbors to 'disabled' which makes them unclickable
	#set the world to 'melee attack calc' bool
	#if an apf is hovered over while in melee attack calc, build a battle and display results
	#if an apf is clicked while in melee attack calc, enact the battle and add damage/results
	
	pass # Replace with function body.

func rangedPressed(armyPath, thisArmy) -> void:
	if lastSelectedPathPoint != null:
		for pathPointButton in lastSelectedPathPoint.neighborPathPoints:
			pathPointButton.calculateBattle(armyPath, "ranged", thisArmy, lastSelectedPathPoint)
	pass # Replace with function body.

func updatePathPointsFunc(visibility):
	if visibility == false:
		$CanvasLayer/ArmyPanel/ArmyButtonsContainer.visible = false
	else:
		$CanvasLayer/ArmyPanel/ArmyButtonsContainer.visible = true
	pass

func newTileDevelopment(tileToDev, devType, devCivilian):
	for Tile in $TileController.get_children():
		if Tile.tileNumber == tileToDev.tileNumber:
			Tile.devChange(devType, devCivilian)
	pass


func giveSpellInfo(type, spellBranch):
	print("RETURN GIVE SPELL")
	var schoolPoints: String = LocBallUI.magicDic.schoolPoints
	var turnsUntil: String = LocBallUI.magicDic.turnsUntil
	var unlocked: String = LocBallUI.magicDic.spellUnlocked
	print("RETURN GIVE SPELL")
	var spellString: String
	var spellDesc: String
	var schoolType: String
	match type:
		"healingPotion":
			spellString = LocBallUI.magicDic.healingPotion
			spellDesc = LocBallUI.magicDic.healingPotionDesc
			schoolType = LocBallUI.magicDic.alchemy
		"draughtOfKnowledge":
			spellString = LocBallUI.magicDic.draughtOfKnowledge
			spellDesc = LocBallUI.magicDic.draughtOfKnowledgeDesc
			schoolType = LocBallUI.magicDic.alchemy
		"fireworks":
			spellString = LocBallUI.magicDic.fireworks
			spellDesc = LocBallUI.magicDic.fireworksDesc
			schoolType = LocBallUI.magicDic.alchemy
		"fleetingFoot":
			spellString = LocBallUI.magicDic.fleetingFoot
			spellDesc = LocBallUI.magicDic.fleetingFootDesc
			schoolType = LocBallUI.magicDic.alchemy
		"focusingDust":
			spellString = LocBallUI.magicDic.focusDust
			spellDesc = LocBallUI.magicDic.focusDustDesc
			schoolType = LocBallUI.magicDic.alchemy
		"goldenTouch":
			spellString = LocBallUI.magicDic.goldenTouch
			spellDesc = LocBallUI.magicDic.goldenTouchDesc
			schoolType = LocBallUI.magicDic.alchemy
		"paralysis":
			spellString = LocBallUI.magicDic.paralysis
			spellDesc = LocBallUI.magicDic.paralysisDesc
			schoolType = LocBallUI.magicDic.alchemy
		"poison":
			spellString = LocBallUI.magicDic.poison
			spellDesc = LocBallUI.magicDic.poisonDesc
			schoolType = LocBallUI.magicDic.alchemy
		"slimeSoldier":
			spellString = LocBallUI.magicDic.slimeSoldier
			spellDesc = LocBallUI.magicDic.slimeSoldierDesc
			schoolType = LocBallUI.magicDic.alchemy
		"slimeSpitter":
			spellString = LocBallUI.magicDic.slimeSpitter
			spellDesc = LocBallUI.magicDic.slimeSpitterDesc
			schoolType = LocBallUI.magicDic.alchemy
		"slimeWeapons":
			spellString = LocBallUI.magicDic.slimeWeapons
			spellDesc = LocBallUI.magicDic.slimeWeaponsDesc
			schoolType = LocBallUI.magicDic.alchemy
		"waterbreathing":
			spellString = LocBallUI.magicDic.waterbreathing
			spellDesc = LocBallUI.magicDic.waterbreathingDesc
			schoolType = LocBallUI.magicDic.alchemy
	spellBranch.giveSpellInfo(schoolPoints, turnsUntil, unlocked, spellString, spellDesc, schoolType)
	pass

func _on_belief_control_purchased_belief(beliefName, beliefCost) -> void:
	#print(beliefName, beliefCost, "WORLD SIGNALRECEIVED")
	playerCountryNode.addReligiousBelief(beliefName)
	playerCountryNode.payBill("faith", beliefCost)
	$CanvasLayer/BeliefControl.updateSelf()
	pass # Replace with function body.


func _on_government_control_slider_changed(amount, type) -> void:
	playerCountryNode.setNewTaxAmount(amount, type)
	pass # Replace with function body.

func _on_civilian_button_pressed() -> void:
	$CanvasLayer/CivilianControl.updateCivilians()
	if $CanvasLayer/CivilianControl.visible == true:
		$CanvasLayer/CivilianControl.visible = false
	else:
		$CanvasLayer/CivilianControl.visible = true
	pass # Replace with function body.

var milModScene = load("res://mil_mod.tscn")

func updateCivFunc(civ, pathPoint):
	$CanvasLayer/CivilianUnitControl/ToolIcon.texture = civ.civilianTool.toolImage
	$CanvasLayer/CivilianUnitControl/KitIton.texture = civ.civilianKit.kitImage
	if $CanvasLayer/CivilianUnitControl/MilModGridContainer.get_children != null:
		for MilMod in $CanvasLayer/CivilianUnitControl/MilModGridContainer.get_children():
			$CanvasLayer/CivilianUnitControl/MilModGridContainer.remove_child(MilMod)
	for MilMod in civ.milMods:
		var newMilMod = milModScene.instantiate()
		newMilMod.buildSelf(MilMod.milModType)
		$CanvasLayer/CivilianUnitControl/MilModGridContainer.add_child(newMilMod)
	calculateCivilianButtons(civ, pathPoint.ppbTile)
	if $CanvasLayer/ArmyPanel.visible == true:
		$CanvasLayer/ArmyPanel.visible = false
	if $CanvasLayer/CivilianUnitControl.visible == false:
		$CanvasLayer/CivilianUnitControl.visible = true
	else:
		$CanvasLayer/CivilianUnitControl.visible = false
	pass

func calculateCivilianButtons(civ, ppbTile):
	$CanvasLayer/CivilianUnitControl/CivilianActionButtons.updateUI(playerCountryNode.CID, civ, civ.civilianTool.toolName, civ.civilianKit.kitType, ppbTile)
	pass

func _on_colonize_button_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.colonizeTile()
	pass # Replace with function body.

func updateCountryTiles(colonizedTile):
	if colonizedTile.tileOwner != null:
		for country in aliveCountriesList:
			if country.CID == colonizedTile.tileOwner:
				country.addTile(colonizedTile)
	pass

func _on_increase_agricultural_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.agricultureTile()
	pass # Replace with function body.

func _on_increase_resource_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.resourceTile()
	pass # Replace with function body.

func _on_increase_urban_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.urbanTile()
	pass # Replace with function body.

func _on_increase_elite_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.eliteTile()
	pass # Replace with function body.

func _on_increase_military_development_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.militaryTile()
	pass # Replace with function body.

func _on_clear_corruption_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.fightCorruptionTile()
	pass # Replace with function body.

func _on_discover_nearby_tiles_button_pressed() -> void:
	$CanvasLayer/CivilianUnitControl.visible = false
	$PathControl.discoverNearby()
	pass # Replace with function body.

func _on_building_info_panel_fill_with_unlocked_buildings() -> void:
	for building in playerCountryNode.unlockedBuildings:
		$CanvasLayer/BuildingInfoPanel.addNewBuildingButton(building)
	pass # Replace with function body.

func addNewBuildingToTile(buildingType, goldCalculatedCost, foodCalculatedCost, woodCalculatedCost, metalCalculatedCost, thisTile,player):
	thisTile.addBuilding(buildingType, 1)
	playerCountryNode.TotalGold -= goldCalculatedCost
	playerCountryNode.TotalFood -= foodCalculatedCost
	playerCountryNode.TotalWood -= woodCalculatedCost
	playerCountryNode.TotalMetal -= metalCalculatedCost
	$CanvasLayer/BuildingInfoPanel/AddBuildingControl.visible = false
	$CanvasLayer/BuildingInfoPanel.displayBuildingInfo(thisTile)
	pass

func _on_spell_schools_control_ask_for_info(type, SpellUnlock) -> void:
	giveSpellInfo(type, SpellUnlock)
	pass # Replace with function body.

func _on_spell_schools_control_calculate_player_outputs(spellSchools) -> void:
	calculatePlayerOutputs(spellSchools)
	pass # Replace with function body.

func tileSiegeWon(tile, oldCID, newCID):
	print("TileSiegeWon WORLD")
	for country in aliveCountriesList:
		if country.CID == oldCID:
			aliveCountriesList.erase(tile)
		if country.CID == newCID:
			country.addTile(tile)
	pass

func _on_next_turn_pressed() -> void:
	playerCountryNode.surveyResources()
	for pathPointButton in $PathControl/PathPointsControl.get_children():
		if pathPointButton.get_children() != null:
			#print(pathPointButton.get_children(), "DEBUG PATHPOINTBUTTONCHILDREN")
			for civilianPathFollow in pathPointButton.get_children():
				if civilianPathFollow.is_class("Button") != true:
					civilianPathFollow.emitTileChange()
	$CanvasLayer/SpellSchoolsControl.updateMagicAmounts(playerCountryNode)
	for country in aliveCountriesList:
		if country != playerCountryNode:
			country.calculateTurn()
	$CanvasLayer/TechTree.investInTech(playerCountryNode.SPM)
	pass # Replace with function body.
