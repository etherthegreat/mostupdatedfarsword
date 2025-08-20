extends Node2D

var gameLanguage: String

var playerCountry: String
var playerCountryNode: country
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


func _process(delta: float) -> void:
	if worldCreation == true:
		return
	else:
		$"CanvasLayer/Resource Bar (TOP)/container/FoodLabel/Label".text = str(playerCountryNode.TotalFood)
		$"CanvasLayer/Resource Bar (TOP)/container/GoldLabel/Label".text = str(playerCountryNode.TotalGold)
		$"CanvasLayer/Resource Bar (TOP)/container/WoodLabel/Label".text = str(playerCountryNode.TotalWood)
		$"CanvasLayer/Resource Bar (TOP)/container/MetalLabel/Label".text = str(playerCountryNode.TotalMetal)
		$"CanvasLayer/Resource Bar (TOP)/container/WeaponsLabel/Label".text = str(playerCountryNode.TotalWeapons)
		$"CanvasLayer/Resource Bar (TOP)/container/ScienceLabel/Label".text = str(playerCountryNode.TotalScience)
		$"CanvasLayer/Resource Bar (TOP)/container/FaithLabel/Label".text = str(playerCountryNode.TotalFaith)
		$"CanvasLayer/Resource Bar (TOP)/container/MagicLabel/Label".text = str(playerCountryNode.TotalMagic)
		$"CanvasLayer/Resource Bar (TOP)/container/CultureLabel/Label".text = str(playerCountryNode.TotalCulture)
		$"CanvasLayer/Resource Bar (TOP)/container/MandateLabel/Label".text = str(playerCountryNode.TotalMandate)
		$"CanvasLayer/Resource Bar (TOP)/container/HarmonyLabel/Label".text = str(playerCountryNode.TotalHarmony)
		$"CanvasLayer/Resource Bar (TOP)/container/InfluenceLabel/Label".text = str(playerCountryNode.TotalInfluence)
		$"CanvasLayer/Resource Bar (TOP)/container/ManpowerLabel/Label".text = str(playerCountryNode.TotalManpower)
	pass

func _ready() -> void:
	worldCreation = true
	newGameBuild()
	worldCreation = false
	pass

signal calculateSeason
func newGameBuild():
	gameLanguage = "eng"
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
	spawnNewGameCountries()
	connectCountrySignals()
	$CanvasLayer/BuildingInfoPanel/buildingPanelPanel.player = playerCountryNode
	matchCountryBuildings()
	for country in aliveCountriesList:
		country.prospectForOres()
	emit_signal("calculateSeason", month)
	$CanvasLayer/TileInfoPanel.TilesCalculated()
	#$CanvasLayer/TileInfoPanel.displayTileInfo()
	#$CanvasLayer/BuildingInfoPanel.displayBuildingInfo()
	$CanvasLayer/Spellbook.displaySpells(playerCountryNode)
	updatePlayerUI()
	pass

func spawnNewGameCountries():
	var penderTal = country.new()
	if playerCountry == "PDT":
		penderTal.Player = true
	else:
		penderTal.Player = false
	penderTal.CID = "PDT"
	for Tile in $TileController.get_children():
		if Tile.tileOwner == "PDT":
			penderTal.OwnedTileList.append(Tile)
	penderTal.NewGameBuild()
	aliveCountriesList.append(penderTal)
	$CountryController.add_child(penderTal)
	playerCountryNode = penderTal
	#penderTal.surveyResources()
	print("pender tal tile list:", penderTal.OwnedTileList)
	pass

func connectCountrySignals():
	for country in aliveCountriesList:
		country.raiseThisArmySignal.connect(raiseArmyFromWorld)
	pass

func updatePlayerUI():
	$CanvasLayer/TileInfoPanel.selectThisTile.connect(assignSelectedTile)
	$CanvasLayer/TileInfoPanel.governorButtonPressed.connect(openGovernorsPanel)
	$CanvasLayer/TileInfoPanel.confirmThisGovernor.connect(assignGovernor)
	$CanvasLayer/TechTree.buildSelf(playerCountryNode)
	$CanvasLayer/BeliefControl.buildSelf(playerCountryNode)
	$CanvasLayer/BuildingInfoPanel/buildingPanelPanel.player = playerCountryNode
	$PathControl.activateArmyControlMode.connect(activateArmyControl)
	$PathControl.connectPathPoints()
	$CanvasLayer/MilitaryPanelControl.buildSelf(playerCountryNode)
	$CanvasLayer/MilitaryPanelControl.newArmySignal.connect(buildNewPlayerArmy)
	playerCountryNode.displayCommander.connect(UICommander)
	$CanvasLayer/GovernmentControl.buildSelf(playerCountryNode)
	$CanvasLayer/GovernmentControl.addToConstitution.connect(addLawToCountry)
	$CanvasLayer/FactionControl.newRewardSend.connect(addNewRewards)
	#print("ALL I NEED")
	pass

var thisTileNumber: int
var selectedTile: Tile

func tileClicked(tile):
	print("Tile", tile.tileNumber, "Clicked")
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


func matchCountryBuildings():
	for country in aliveCountriesList:
		for Tile in $TileController.get_children():
			if Tile.tileOwner == playerCountryNode.CID:
				for building in Tile.tileBuildingsList:
					playerCountryNode.connectBuilding(building)
					#building.towerBuilding.connect(signalTowerInTile)
	if playerCountryNode.CID == "PDT":
		#print("country building List for PDT:", playerCountryNode.countryBuildingList)
		pass
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

func _on_test_resource_button_pressed() -> void:
	playerCountryNode.surveyResources()
	playerCountryNode.payUnitMaintenance()
	playerCountryNode.collectTaxes()
	pass # Replace with function body.

func _on_tech_tree_add_tech_to_player(techName) -> void:
	playerCountryNode.addTechnologicalDiscovery(techName)
	print("message received")
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

#Government Code
func addLawToCountry(lawType):
	playerCountryNode.addLawToConstitution(lawType)
	$CanvasLayer/GovernmentControl.updateGovernmentPanel()
	pass

#Army World Code
func _on_army_button_pressed() -> void:
	if $CanvasLayer/MilitaryPanelControl.visible == false:
		$CanvasLayer/MilitaryPanelControl.visible = true
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

func raiseArmyFromWorld(Army, country, Tile):
	var pathToSend: Path2D
	match Tile.tileSpawnPath:
		"Pender Tal":
			pathToSend = $"PathControl/Pender Tal Path"
		"Pender Tal South":
			pathToSend = $"PathControl/Pender Tal South Path"
	var pathNumberToSend: int
	pathNumberToSend = Tile.tileSpawnPathPoint
	if country == playerCountryNode:
		$PathControl.raisePlayerArmy(Army, country, Tile, pathToSend, pathNumberToSend)
	else:
		print("woah we're at this stage, good work dude")
	pass

func activateArmyControl():
	armyMode = true
	pass

var eventScene = load("res://eventScene.tscn")

var temporaryTile: Tile
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
			newEvent.buildSelf(type, id, CID, language)
			newEvent.eventButtonPressed.connect(matchEventOutcome)
			$CanvasLayer/EventControl/EventContainer.add_child(newEvent)
			
	pass

func createNewTileEvent(type, id, CID, tile, language):
	var newEvent = eventScene.instantiate()
	newEvent.buildTileEventSelf(type, id, CID, tile, language)
	newEvent.tileEventButtonPressed.connect(matchTileEventOutcome)
	$CanvasLayer/EventControl/EventContainer.add_child(newEvent)
	pass

func matchEventOutcome(eventButtonID, eventType, eventID, eventCountry):
	match eventCountry:
		"GEN":
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
	match eventCountry:
		"GEN":
			match eventButtonID:
				"GEN_AssignDruidWizard":
					eventTile.addWizard("Druid")
				"GEN_AssignElementalWizard":
					eventTile.addWizard("Elementalist")
				"GEN_AssignIllusionWizard":
					eventTile.addWizard("Illusionist")
				"GEN_AssignDivinerWizard":
					eventTile.addWizard("Diviner")
				"GEN_AssignSummonerWizard":
					eventTile.addWizard("Summoner")
				"GEN_AssignAlchemistWizard":
					eventTile.addWizard("Alchemist")
	pass
