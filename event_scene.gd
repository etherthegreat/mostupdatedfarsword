extends Control

var ID: String
var TYPE: String
var COUNTRY: String
var LANGUAGE: String


#signals
signal eventButtonPressed

func buildSelf(eventType, eventID, eventCountry, language):
	TYPE = eventType
	ID = eventID
	COUNTRY = eventCountry
	LANGUAGE = language
	var newLocBall = LocBall.new()
	newLocBall.buildSelf(eventType, eventID, eventCountry, language)
	$EventPanel/EventNameLabel.text = newLocBall.eventName
	$EventPanel/EventShortDescriptionLabel.text = newLocBall.eventShortDescription
	$EventPanel/EventLongDescriptionLabel.text = newLocBall.eventLongDescription
	for EventButton in newLocBall.eventButtons:
		$EventPanel/eventButtons.add_child(EventButton)
		EventButton.EventButtonPressed.connect(pressedEventButton)
		print("event button", EventButton.eventButtonID)
	pass

func pressedEventButton(eventButtonID):
	print("Event ID", eventButtonID, TYPE, ID, COUNTRY)
	emit_signal("eventButtonPressed", eventButtonID, TYPE, ID, COUNTRY)
	pass
