extends Control

var ID: String
var TYPE: String
var COUNTRY: String
var LANGUAGE: String

var targetTile: Tile

#signals
signal eventButtonPressed
signal tileEventButtonPressed

func buildSelf(eventType, eventID, eventCountry, language):
	TYPE = eventType
	ID = eventID
	COUNTRY = eventCountry
	LANGUAGE = language
	var newLocBall = LocBall.new()
	match eventType:
		"governor":
			newLocBall.buildSelf(TYPE, ID, COUNTRY, LANGUAGE)
			for EventButton in newLocBall.eventButtons:
				$EventPanel/eventButtons.add_child(EventButton)
				EventButton.EventButtonPressed.connect(pressedEventButton)
			$EventPanel/EventNameLabel.text = newLocBall.eventName
			$EventPanel/EventShortDescriptionLabel.text = newLocBall.eventShortDescription
			$EventPanel/EventLongDescriptionLabel.text = newLocBall.eventLongDescription
		"spell":
			newLocBall.buildSelf(TYPE, ID, COUNTRY, LANGUAGE)
			for EventButton in newLocBall.eventButtons:
				$SpellSchoolUnlocked/HBoxContainer/SpellButtonControl.add_child(EventButton)
				EventButton.EventButtonPressed.connect(pressedEventButton)
			$EventPanel.visible = false
			$SpellSchoolUnlocked/SpellName.text = newLocBall.unlockableName
			$SpellSchoolUnlocked/EffectsOfSpellLabel.text = newLocBall.eventLongDescription
			$SpellSchoolUnlocked/UnlockedSpell.text = newLocBall.eventName
			$SpellSchoolUnlocked/SpellType.text = newLocBall.eventShortDescription
			$SpellSchoolUnlocked.visible = true
	print(newLocBall.eventName, "event name")
	pass


func buildTileEventSelf(eventType, eventID, eventCountry, tile, language):
	#print("wake up child")
	TYPE = eventType
	ID = eventID
	COUNTRY = eventCountry
	LANGUAGE = language
	targetTile = tile
	var newLocBall = LocBall.new()
	newLocBall.buildTileEvent(TYPE, ID, targetTile, COUNTRY, LANGUAGE)
	for EventButton in newLocBall.eventButtons:
		EventButton.buildTileEventButton
		$EventPanel/eventButtons.add_child(EventButton)
		EventButton.tileSignalPressed.connect(pressedTileEventButton)
	$EventPanel/EventNameLabel.text = newLocBall.eventName
	$EventPanel/EventShortDescriptionLabel.text = newLocBall.eventShortDescription
	$EventPanel/EventLongDescriptionLabel.text = newLocBall.eventLongDescription
	pass

func pressedEventButton(eventButtonID):
	emit_signal("eventButtonPressed", eventButtonID, TYPE, ID, COUNTRY)
	self.queue_free()
	pass

func pressedTileEventButton(tile, buttonID):
	print("Event ID", tile, buttonID)
	emit_signal("tileEventButtonPressed", buttonID, TYPE, COUNTRY, tile)
	self.queue_free()
	pass
