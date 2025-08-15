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
		"Citizen Militia":
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
