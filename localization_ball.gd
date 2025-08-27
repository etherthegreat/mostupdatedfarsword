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

var unlockableName: String

var eventButtons: Array = []

var eventTile: Tile

func buildSelf(eT, eID, eC, eL):
	print(eT, eID, eC, eL, "kangaroo")
	eventType = eT
	eventID = eID
	eventCountry = eC
	eventLanguage = eL
	matchEventLabels()
	pass

func buildTileEvent(eT, eID, eTile, eC, eL):
	eventType = eT
	eventID = eID
	eventTile = eTile
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
					match eventID:
						"wizardSelect":
							match eventLanguage:
								"eng":
									eventName = "Assigning a Wizard to Our New Tower"
									eventShortDescription = "This will affect our magic for years to come"
									eventLongDescription = "With the completions of our new tower, it is time to assign it a spell school."
									newEventButton("For the Druid cause!", "GEN_AssignDruidWizard")
									newEventButton("Assign a Master Elementalist", "GEN_AssignElementalWizard")
									newEventButton("An Illusionist will do quite nicely", "GEN_AssignIllusionWizard")
									newEventButton("Only a Diviner is worthy to sit atop this Tower", "GEN_AssignDivinerWizard")
									newEventButton("Summon a summoner to come summon for us", "GEN_AssignSummonerWizard")
									newEventButton("Build a new laboratory, we are giving this tower to the alchemists", "GEN_AssignAlchemistWizard")
					pass
				"religion":
					pass
				"faction":
					pass
				"spell":
					match eventID:
						"GEN_PLENTIFY_UNLOCK":
							match eventLanguage:
								"eng":
									eventName = "New Elementalism Spell Unlocked"
									eventShortDescription = "Focus: Tiles"
									unlockableName = "PLENTIFY"
									eventLongDescription = "+1 Food Per Farm
										+1 Food Per Dock
										+1 Culture Per Farm
										+1 Culture Per Dock
										-2 Magic Per Farm
										-2 Magic Per Dock"
									newEventButton("Plenty More Where That Came From", "GEN_Plentify_Unlock_1")
						"GEN_HEALING_WINDS_UNLOCK":
							match eventLanguage:
								"eng":
									eventName = "New Elementalism Spell Unlocked"
									eventShortDescription = "Focus: Corruption"
									unlockableName = "HEALING WINDS"
									eventLongDescription = str("-2 corruption in per turn in this tile
										-4 magic per turn")
									newEventButton("Who Smelt it Dealt It", "GEN_Healing_Winds_Unlock_1")
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
									newEventButton("TheEndTimes Approach", "PDT_Wolverina0-2")
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
	match eventType:
		"governor":
			var buttonOption = eventButtonScene.instantiate()
			buttonOption.buildSelf(buttonText, buttonID, "governor")
			eventButtons.append(buttonOption)
		"tile":
			var buttonOption = eventButtonScene.instantiate()
			buttonOption.buildTileEventButton(buttonText, buttonID, eventTile, "tile")
			eventButtons.append(buttonOption)
		"spell":
			var buttonOption = eventButtonScene.instantiate()
			buttonOption.buildSelf(buttonText, buttonID, "spell")
			eventButtons.append(buttonOption)
	pass
