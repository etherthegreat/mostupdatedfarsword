extends Control

class_name law

var lawType: String
var lawSelected: bool

var lawDescription: String
var lawIcon: Texture

var lawCosts: String

var quadrant: String #can be Order, Freedom, Hierarchy, Equality, each will move one point in that direction upon calculation

func _on_area_2d_mouse_entered() -> void:
	$LawPanel/SelectedPanel/LawDescriptionLabel.text = lawDescription
	$LawPanel/SelectedPanel/LawCostsLabel.text = lawCosts
	$LawPanel/SelectedPanel.visible = true
	pass # Replace with function body.

func buildSelf(newLawType, selected):
	lawType = newLawType
	lawSelected = selected
	match lawType:
		"Armed Peasantry":
			lawDescription = "Citizen Militias will guard their homes with their lives.  All of our centers of government will be stocked with arms for the people to use in case demonic tyranny again shows its face and rears its teeth."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/weapons.png")
			lawCosts = str("Cost: 50 Mandate
						+5 Weapons per Governor's Mansion lvl
						+25 Manpower Per Farm
						-1 Mandate Per Farm
						+1 Mandate Per Forge")
		"Mercantilism":
			lawDescription = "By creating a new corp of bureacratic tax collectors, we can attempt to more directly control the economy.  By pushing exports and minimizing imports, we hope to become quite wealthy."
			quadrant = "Order"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/gold.png")
			lawCosts = str("Cost: 25 Mandate
						-2 Mandate, +2 Gold per Workshop
						+1 Gold Per Farm
						+1 Gold Per Camp")
		"Local Elections":
			lawDescription = "Each of our provinces will hold elections where every single person in the society of voting age may cast a ballot for their preferred candidate."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png")
			lawCosts = str("Cost: 10 Mandate
						-3 Mandate, +1 Harmony from Courthouses
						+1 Haromny Per Farm
						+1 Harmony Per Camp")
		"Democratic Mandate":
			lawDescription = "It is the will of the people which will direct us.  The Demon King is the last tyrant of our world.  Let monarchism die with the Wretched One!"
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
			lawCosts = str("Cost: 30 Mandate
						-1 Mandate Per Province
						+1 Max Level Courthouse")
		"Universal Citizenship":
			lawDescription = "No one shall be turned away from our Republic for any reason which stems from simple personal traits.  All who condemn the Demon King and his Horde are welcome to live and be citizens here."
			quadrant = "Equality"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/manpower 100 x 100.png")
			lawCosts = str("Cost: 15 Mandate
						-1 Mandate Per Population
						+1 Harmony Per Population")
		"Disability Care":
			lawDescription = "Due to the heavy toll Demonic occupation has taken on us, many of our citizens are physically incapable of taking care of their own needs.  By creating a social safety net for our disabled citizens, we can alleviate their suffering."
			quadrant = "Equality"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
			lawCosts = str("Cost: 145 Mandate
						+1 Gold Per Workshop
						-10% cost for population Upgrade")
		"Homeland Defense":
			lawDescription = "Each of our citizens is expected to take up arms against the tyrant Demon King in case of invasion.  Freedom is not something our nation will ever again take for granted."
			quadrant = "Order"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/clubsmall.png")
			lawCosts = str("Cost: 15 Mandate
						-1 Mandate Per Barracks
						+5 Manpower from All buildings")
	$LawPanel/LawSprite.texture = lawIcon
	$LawPanel/LawSelectionButton.icon = lawIcon
	if selected == true:
		$LawPanel/LawSelectionButton.visible = false
		$LawPanel/LawSprite.visible = true
		$LawPanel/Area2D.visible = true
	pass


#func _on_area_2d_mouse_exited() -> void:
	#if $LawPanel/LawInfoPanel.visible == true:
		#$LawPanel/LawInfoPanel.visible = false
	#pass # Replace with function body.

signal lawSelectionButtonPressed
func _on_law_selection_button_pressed() -> void:
	if $LawPanel/LawInfoPanel.visible == false:
		emit_signal("lawSelectionButtonPressed")
		print("lawtype", lawType, "law Description", lawDescription, "lawCosts", lawCosts)
		$LawPanel/LawInfoPanel.visible = true
		$LawPanel/LawInfoPanel/LawInfoLabel.text = lawDescription
		$"LawPanel/LawInfoPanel/Add LawLabel".text = lawCosts
	else:
		$LawPanel/LawInfoPanel.visible = false
	pass # Replace with function body.

func closeTab():
	if $LawPanel/LawInfoPanel != null:
		if $LawPanel/LawInfoPanel.visible == true:
			$LawPanel/LawInfoPanel.visible = false
	pass

func _on_not_now_button_pressed() -> void:
	$LawPanel/LawInfoPanel.visible = false
	pass # Replace with function body.

signal selectThisLaw
func _on_confirm_button_pressed() -> void:
	lawSelected = true
	$LawPanel/LawSelectionButton.visible = false
	$LawPanel/LawSprite.visible = true
	$LawPanel/Area2D.visible = true
	emit_signal("selectThisLaw", lawType)
	pass # Replace with function body.




func _on_area_2d_mouse_exited() -> void:
	$LawPanel/SelectedPanel.visible = false
	pass # Replace with function body.
