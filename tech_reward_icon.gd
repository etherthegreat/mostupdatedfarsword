extends Control

class_name techReward

var techRewardType: String

var techRewardImage: Texture

var techRewardDescription: String

func buildSelf(type):
	techRewardType = type
	match techRewardType:
		"Farm Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/farm.png")
			techRewardDescription = str("Max Farm Level: [color=yellow]+10[/color],
			Farm Food Per Level: [color=green]+1[/color]")
		"Granary Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/granary.png")
			techRewardDescription = str("Max Granary Level: [color=yellow]+4[/color],
			Granary Gold Cost Per Level: [color=red]-1[/color]
			Granary Max Food Per Level: [color=green]+100[/color]
			Granary Mandate Bonus: [color=green]+1[/color]")
		"Camp Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/camp.png")
			techRewardDescription = str("Max Camp Level: [color=yellow]+10[/color],
			Camp Wood Per Level: [color=green]+1[/color]")
		"Mine Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/mine.png")
			techRewardDescription = str("Max Mine Level: [color=yellow]+6[/color]
			Mine Metal Per Level: [color=green]+1[/color]
			Mine Wood Cost Per Level:[color=red]-1[/color]")
		"Temple Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/temple.png")
			techRewardDescription = str("Max Temple Level: [color=yellow]+6[/color]
			Temple Faith Per Level: [color=green]+1[/color]
			Temple Gold Cost Per Level:[color=red]-1[/color]
			Temple Food Cost Per Level:[color=red]-1[/color]")
		"Tower Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/tower.png")
			techRewardDescription = str("Max Temple Level: [color=yellow]+4[/color]
			Tower Magic Per Level: [color=green]+1[/color]
			Tower Gold Cost Per Level:[color=red]-1[/color]
			Tower Food Cost Per Level:[color=red]-1[/color]
			Tower Metal Cost Per Level:[color=red]-1[/color]
			Tower Wood Cost Per Level:[color=red]-1[/color]")
		"Bath Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/bath.png")
			techRewardDescription = str("Max Bath Level: [color=yellow]+6[/color]
			Bath [i]Corruption in Tile[/i] Per Level: [color=green]-1[/color]
			Bath Gold Cost Per Level:[color=red]-2[/color]
			Bath Food Cost Per Level:[color=red]-2[/color]")
		"Library Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/library.png")
			techRewardDescription = str("Max Library Level: [color=yellow]+6[/color]
			Temple Faith Per Level: [color=green]+1[/color]
			Temple Gold Cost Per Level:[color=red]-1[/color]
			Temple Wood Cost Per Level:[color=red]-1[/color]")
		"Faire Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/faire.png")
			techRewardDescription = str("Max Faire Level: [color=yellow]+6[/color]
			Faire Harmony Per Level: [color=green]+1[/color]
			Faire Gold Cost Per Level:[color=red]-1[/color]
			Faire Food Cost Per Level:[color=red]-1[/color]
			Faire Wood Cost Per Level:[color=red]-1[/color]")
		"Barracks Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/barracks.png")
			techRewardDescription = str("Max Barracks Level: [color=yellow]+2[/color]
			Barracks Manpower Per Level: [color=green]+100[/color]
			Barracks Gold Cost Per Level:[color=red]-1[/color]
			Barracks Food Cost Per Level:[color=red]-1[/color]
			Barracks Weapons Cost Per Level:[color=red]-1[/color]")
		"Courthouse Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/courthouse.png")
			techRewardDescription = str("Max Courthouse Level: [color=yellow]+4[/color]
			Courthouse Mandate Per Level: [color=green]+1[/color]
			Courthouse Gold Cost Per Level:[color=red]-2[/color]")
		"Dock Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/dock.png")
			techRewardDescription = str("Max Dock Level: [color=yellow]+2[/color]
			Dock Food Per Level: [color=green]+1[/color]
			Dock Manpower Per Level: [color=green]+50[/color]
			Dock Wood Cost Per Level:[color=red]-3[/color]")
		"Forge Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/forge.png")
			techRewardDescription = str("Max Forge Level: [color=yellow]+6[/color]
			Forge Weapons Per Level: [color=green]+1[/color]
			Forge Wood Cost Per Level:[color=red]-1[/color]
			Forge Metal Cost Per Level:[color=red]-1[/color]")
		"Workshop Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/workshop.png")
			techRewardDescription = str("Max Workshop Level: [color=yellow]+6[/color],
			Workshop Gold Per Level: [color=green]+1[/color],
			Workshop Wood Cost Per Level:[color=red]-1[/color],
			Workshop Food Cost Per Level:[color=red]-1[/color],")
		#non-generic upgrades
		"Banking Upgrade 1":
			techRewardImage = load("res://art assets/finishedAssets/ores/Gold.PNG")
			techRewardDescription = str("Triggers an event allowing us to pick one of four economic policies:
				Universal Taxation: [color=green]+10%[/color] Max Taxation for all buildings
				Urban Taxation: [color=green]+25%[/color]% Gold from every level of workshop, forge, library, bath, and faire
				Mercantilism: [color=green]+40%[/color] Max Taxation for farms, camps, mines, and docks
				Elite Taxation: [color=green]+60%[/color] Max Taxation for temples, libraries, and towers
				")
	$Control/DescriptionRichLabel.text = techRewardDescription
	$Control/TypeLabel.text = techRewardType
	$TechRewardSprite.texture = techRewardImage
	pass


func _on_area_2d_mouse_entered() -> void:
	$Control.visible = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	$Control.visible = false
	pass # Replace with function body.
