extends Node2D

class_name LocBall

var eventType: String
var eventID: String
var eventCountry: String
var eventLanguage: String

#events
var eventName: String
var eventShortDescription: String
var eventLongDescription: String

var eventButtons: Array = []

func buildSelf(eT, eID, eC, eL):
	eventType = eT
	eventID = eID
	eventCountry = eC
	eventLanguage = eL
	matchEventLabels()
	pass

func matchEventLabels():
	match eventCountry:
		"GEN":#general, all countries can have gen events
			match eventType:
				"governor":
					pass
				"national":
					pass
				"military":
					pass
				"tile":
					pass
				"religion":
					pass
				"faction":
					pass
				"magic":
					pass
				"expedition":
					pass
		"PDT":
			match eventType:
				"governor":
					match eventID:
						"PDT_Wolverina0":
							match eventLanguage:
								"eng":
									eventName = "Wolverina Dreams of Freedom..."
									eventShortDescription = "...for her comrades still enslaved in the Anlaxian Estates."
									eventLongDescription = "I wasn't truly born until I was eleven or twelve years old.  Until then, I wasn't anything except a flesh puppet for the demonic wizards to twist and ruin.  But for some reason, either by divine intervention or random chance, I awoke.  When the wizards discovered me, they chased me and attempted to murder their failure.  But through sheer force of will I escaped and found the others who were like me, living here in this mountain pass.  Surrounded by corruption on all sides and constantly under threat of wandering demonic gangs, we do not know how much longer we can survive like this."
									newEventButton("Something Must Change", "PDT_Wolverina0-1")
									
					pass
				"national":
					pass
				"military":
					pass
				"tile":
					pass
				"religion":
					pass
				"faction":
					pass
				"magic":
					pass
		"ANL":
			match eventType:
				"governor":
					pass
				"national":
					pass
				"military":
					pass
				"tile":
					pass
				"religion":
					pass
				"faction":
					pass
				"magic":
					pass
		"VAL":
			match eventType:
				"governor":
					pass
				"national":
					pass
				"military":
					pass
				"tile":
					pass
				"religion":
					pass
				"faction":
					pass
				"magic":
					pass
	pass

var eventButtonScene = load("res://event_button.tscn")

func newEventButton(buttonText, buttonID):
	var buttonOption = eventButtonScene.instantiate()
	buttonOption.buildSelf(buttonText, buttonID)
	eventButtons.append(buttonOption)
	pass
