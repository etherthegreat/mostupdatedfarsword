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
			lawDescription = "The right of the people to keep and bear arms shall not be infringed. Every farm a muster point, every mansion an armoury — a Republic that arms its citizens does not ask permission to defend itself."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/weapons.png")
			lawCosts = str("Cost: 50 Mandate
						+5 Weapons per Governor's Mansion lvl
						+25 Manpower Per Farm
						-1 Mandate Per Farm
						+1 Mandate Per Forge")
		"Merchant Marine Act":
			lawDescription = "American vessels carry American goods. The workshops that outfit the fleet answer to one flag, keep more of what they earn, and the river towns and frontier camps collect a share of every voyage."
			quadrant = "Order"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/gold.png")
			lawCosts = str("Cost: 25 Mandate
						-2 Mandate, +2 Gold per Workshop
						+1 Gold Per Farm
						+1 Gold Per Camp")
		"Municipal Reform Act":
			lawDescription = "No appointed official may replace the voice of the people. Free elections in every township mean the courthouse runs on consent, not mandate — and the farms and camps that send their people there are better for it."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png")
			lawCosts = str("Cost: 10 Mandate
						-3 Mandate, +1 Harmony from Courthouses
						+1 Harmony Per Farm
						+1 Harmony Per Camp")
		"Voting Rights Act":
			lawDescription = "No citizen shall be denied the ballot on account of race or condition of previous servitude. The franchise is the foundation of the Republic — and the courthouse is where that foundation is enforced."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
			lawCosts = str("Cost: 30 Mandate
						-1 Mandate Per Province
						+1 Max Level Courthouse")
		"Civil Rights Act":
			lawDescription = "Discrimination based on race, color, or creed is abolished. Every person the Republic governs is a person the Republic answers to — the mandate drops because the people it covers are finally counted."
			quadrant = "Equality"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/manpower 100 x 100.png")
			lawCosts = str("Cost: 15 Mandate
						-1 Mandate Per Population
						+1 Harmony Per Population")
		"Americans with Disabilities Act":
			lawDescription = "No citizen is excluded from civic life on account of disability. The workshops that adapt their operations keep more of what they produce, and the cost of bringing more people into the Republic's economy falls."
			quadrant = "Equality"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
			lawCosts = str("Cost: 145 Mandate
						+1 Gold Per Workshop
						-10% cost for population Upgrade")
		"National Security Act":
			lawDescription = "One command, no gaps. The Republic draws its defence under the executive — the barracks run leaner, and every settlement from the frontier to the capital becomes a source of trained manpower."
			quadrant = "Order"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/clubsmall.png")
			lawCosts = str("Cost: 15 Mandate
						-1 Mandate Per Barracks
						+5 Manpower from All buildings")
		# ── Canadian Laws ────────────────────────────────────────────────────────
		"Militia Act":
			lawDescription = "From Confederation onward, the Republic's defence rests on its people. Every farm a recruiting ground, every estate an armoury — the Militia Act turns the countryside into a reserve force that moves the moment the call goes out."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/weapons.png")
			lawCosts = str("Cost: 50 Mandate
						+5 Weapons per Governor's Mansion lvl
						+25 Manpower Per Farm
						-1 Mandate Per Farm
						+1 Mandate Per Forge")
		"Canada Shipping Act":
			lawDescription = "Every vessel on Canadian waters submits to Republic safety standards — commercial freighters, fishing trawlers, and the pleasure yachts of whoever thought the St. Lawrence was a private amenity. The docks keep more of what they earn. In exchange, they fill out the forms."
			quadrant = "Order"
			lawIcon = load("res://art assets/finishedAssets/lawIcons/can_shipping_act.png")
			lawCosts = str("Cost: 25 Mandate
						-1 Mandate Per Dock
						+2 Gold Per Dock
						+1 Happiness Per Dock")
		"Municipal Elections Act":
			lawDescription = "Responsible government runs all the way down. From Baldwin's day onward, every township elects its own council — the courthouse serves the community, not the administrator, and the people who work the land have a say in how it's governed."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png")
			lawCosts = str("Cost: 10 Mandate
						-3 Mandate, +1 Harmony from Courthouses
						+1 Harmony Per Farm
						+1 Harmony Per Camp")
		"Republic Elections Act":
			lawDescription = "One franchise, one standard, coast to coast. Ottawa's elections code unifies the ballot under federal law and elevates the courthouse as the seat of the democratic compact — no Province stands apart."
			quadrant = "Freedom"
			lawIcon = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
			lawCosts = str("Cost: 30 Mandate
						-1 Mandate Per Province
						+1 Max Level Courthouse")
		"Canadian Citizenship Act":
			lawDescription = "For the first time, to live in the Republic is to belong to it. The British subject is gone; in its place, the Canadian citizen — French, Indigenous, newcomer alike, equal before every law that follows."
			quadrant = "Equality"
			lawIcon = load("res://art assets/finishedAssets/lawIcons/can_citizenship_act.png")
			lawCosts = str("Cost: 15 Mandate
						-10% Mandate Cost (All Buildings)")
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
