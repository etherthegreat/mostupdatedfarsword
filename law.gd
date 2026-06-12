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
		# ── American Laws ────────────────────────────────────────────────────────
		"Second Amendment":
			lawDescription = "The right of the people to keep and bear arms shall not be infringed. Citizen militias stand ready to defend the Republic against all tyranny."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/weapons.png")
			lawCosts = str("Cost: 50 Mandate
						+5 Weapons per Governor's Mansion lvl
						+25 Manpower Per Farm
						-1 Mandate Per Farm
						+1 Mandate Per Forge")
		"Merchant Marine Act":
			lawDescription = "American vessels carry American goods. A strong merchant fleet drives our exports and fills the treasury."
			quadrant = "Order"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/gold.png")
			lawCosts = str("Cost: 25 Mandate
						-2 Mandate, +2 Gold per Workshop
						+1 Gold Per Farm
						+1 Gold Per Camp")
		"Municipal Reform Act":
			lawDescription = "Free and fair elections in every township. No appointed official may replace the voice of the people."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png")
			lawCosts = str("Cost: 10 Mandate
						-3 Mandate, +1 Harmony from Courthouses
						+1 Harmony Per Farm
						+1 Harmony Per Camp")
		"Voting Rights Act":
			lawDescription = "No citizen shall be denied the right to vote. The ballot is the foundation of a free Republic."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
			lawCosts = str("Cost: 30 Mandate
						-1 Mandate Per Province
						+1 Max Level Courthouse")
		"Civil Rights Act":
			lawDescription = "Discrimination based on race, color, or creed is abolished. All citizens stand equal before the law of this Republic."
			quadrant = "Equality"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/manpower 100 x 100.png")
			lawCosts = str("Cost: 15 Mandate
						-1 Mandate Per Population
						+1 Harmony Per Population")
		"Americans with Disabilities Act":
			lawDescription = "No citizen shall be excluded from civic life on account of disability. The Republic provides for all who cannot provide for themselves."
			quadrant = "Equality"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
			lawCosts = str("Cost: 145 Mandate
						+1 Gold Per Workshop
						-10% cost for population Upgrade")
		"National Security Act":
			lawDescription = "A unified national defense apparatus ensures no enemy foreign or domestic can catch the Republic unprepared."
			quadrant = "Order"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/clubsmall.png")
			lawCosts = str("Cost: 15 Mandate
						-1 Mandate Per Barracks
						+5 Manpower from All buildings")
		# ── Canadian Laws ────────────────────────────────────────────────────────
		"Militia Act":
			lawDescription = "Every able-bodied man in the Republic is liable for militia service. Our communities stand ready to defend the Crown's peace."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/weapons.png")
			lawCosts = str("Cost: 50 Mandate
						+5 Weapons per Governor's Mansion lvl
						+25 Manpower Per Farm
						-1 Mandate Per Farm
						+1 Mandate Per Forge")
		"Canada Shipping Act":
			lawDescription = "Canadian waters carry Canadian commerce. The Republic regulates its shipping lanes and expands its mercantile reach."
			quadrant = "Order"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/gold.png")
			lawCosts = str("Cost: 25 Mandate
						-2 Mandate, +2 Gold per Workshop
						+1 Gold Per Farm
						+1 Gold Per Camp")
		"Municipal Elections Act":
			lawDescription = "Responsible government begins at the local level. Each municipality elects its own council to govern in the people's interest."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png")
			lawCosts = str("Cost: 10 Mandate
						-3 Mandate, +1 Harmony from Courthouses
						+1 Harmony Per Farm
						+1 Harmony Per Camp")
		"Republic Elections Act":
			lawDescription = "A single, unified Republic-wide elections code ensures every eligible citizen may cast a ballot for their representatives."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
			lawCosts = str("Cost: 30 Mandate
						-1 Mandate Per Province
						+1 Max Level Courthouse")
		"Canadian Citizenship Act":
			lawDescription = "All who reside within the Republic share equal standing before the law, regardless of origin, language, or background."
			quadrant = "Equality"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/manpower 100 x 100.png")
			lawCosts = str("Cost: 15 Mandate
						-1 Mandate Per Population
						+1 Harmony Per Population")
		"Accessible Canada Act":
			lawDescription = "A barrier-free Canada ensures that disability is no obstacle to full participation in the life of the Republic."
			quadrant = "Equality"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
			lawCosts = str("Cost: 145 Mandate
						+1 Gold Per Workshop
						-10% cost for population Upgrade")
		"National Defence Act":
			lawDescription = "The Canadian Armed Forces stand on a permanent constitutional footing. The Republic's sovereignty is non-negotiable."
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
