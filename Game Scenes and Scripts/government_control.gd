extends Control

var playerNode: country

var implementedLaws: Array = []
var possibleLaws: Array = []

func buildSelf(homeCountry):
	playerNode = homeCountry
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
	updateQuadrantDisplay()
	pass

#func _process(delta: float) -> void:
	#if playerNode != null:
	#	matchVSliders(playerNode)
	#pass

func closeAllOpenLawTabs():
	for law in $PossibleContainer.get_children():
		law.closeTab()
	pass

# Called after updateGovernmentPanel() whenever laws change.
# Requires a TextureRect named CompassSprite and a ColorRect named Marker
# as children of a node named QuadrantDisplay under this panel.
# lawQuadrantX: Reformatory(+1) to Conservatory(-1)
# lawQuadrantY: Revolutionary(+1) to Liberator(-1)
func updateQuadrantDisplay() -> void:
	if not is_instance_valid(playerNode):
		return
	var display = get_node_or_null("QuadrantDisplay")
	if display == null:
		return
	var sprite = display.get_node_or_null("CompassSprite")
	var marker = display.get_node_or_null("Marker")
	if sprite == null or marker == null:
		return
	var w: float = sprite.size.x
	var h: float = sprite.size.y
	var mx: float = w * 0.5 + playerNode.lawQuadrantX * w * 0.5
	var my: float = h * 0.5 - playerNode.lawQuadrantY * h * 0.5
	marker.position = Vector2(mx - marker.size.x * 0.5, my - marker.size.y * 0.5)

signal addToConstitution
func addLawToConstitution(lawType):
	print("kickass", lawType)
	emit_signal("addToConstitution", lawType)
	pass


