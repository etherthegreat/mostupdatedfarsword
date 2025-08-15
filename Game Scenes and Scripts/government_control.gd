extends Control

var playerNode: country

var implementedLaws: Array = []
var possibleLaws: Array = []

func buildSelf(homeCountry):
	playerNode = homeCountry
	pass

var lawScene = preload("res://law.tscn")

func updateGovernmentPanel():
	implementedLaws.clear()
	possibleLaws.clear()
	for law in playerNode.lawsInConstitution:
		implementedLaws.append(law)
	for law in playerNode.unlockedLaws:
		possibleLaws.append(law)
	for law in $GovernmentPanel/GridContainer.get_children():
		law.queue_free()
	for law in $GovernmentPanel/PossibleContainer.get_children():
		law.queue_free()
	for law in implementedLaws:
		var newLaw = lawScene.instantiate()
		newLaw.buildSelf(law.lawType, true)
		#newLaw.selectThisLaw.connect(addLawToConstitution)
		$GovernmentPanel/GridContainer.add_child(newLaw)
	for law in possibleLaws:
		var newLaw = lawScene.instantiate()
		newLaw.buildSelf(law.lawType, false)
		newLaw.selectThisLaw.connect(addLawToConstitution)
		newLaw.lawSelectionButtonPressed.connect(closeAllOpenLawTabs)
		$GovernmentPanel/PossibleContainer.add_child(newLaw)
	pass

func closeAllOpenLawTabs():
	for law in $GovernmentPanel/PossibleContainer.get_children():
		law.closeTab()
	pass

signal addToConstitution
func addLawToConstitution(lawType):
	print("kickass", lawType)
	emit_signal("addToConstitution", lawType)
	pass
