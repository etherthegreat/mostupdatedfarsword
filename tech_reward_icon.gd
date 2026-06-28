extends Control

class_name techReward

var techRewardType: String

var techRewardImage: Texture

var techRewardDescription: String

func buildSelf(type):
	techRewardType = type
	match techRewardType:
		# ===== Tech-tree unlock rewards (weapons / uniforms / tools) =====
		"Muskets Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Brown_Bess.png")
			techRewardDescription = str("[b]Muskets[/b] — smoothbore line-infantry arm. Reliable [color=green]volley fire[/color].")
		"Breechloaders Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Flintlock.png")
			techRewardDescription = str("[b]Breechloaders[/b] — load from the rear. [color=green]Faster reload[/color].")
		"Percussion Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Percussion_Cap.png")
			techRewardDescription = str("[b]Percussion Rifles[/b] — reliable ignition, [color=green]all-weather[/color] firing.")
		"Repeater Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Lever_Repeater.png")
			techRewardDescription = str("[b]Repeaters[/b] — rapid-fire rifle. [color=yellow]Multiple shots[/color] per reload.")
		"Cutlass Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/cutlass.png")
			techRewardDescription = str("[b]Cutlass[/b] — light infantry sabre. Quick melee; [color=green]bonus vs reloading foes[/color].")
		"Cavalry Sword Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/cavalry_sword.png")
			techRewardDescription = str("[b]Cavalry Sword[/b] — mounted blade. Amplifies the [color=yellow]Cavalry Charge[/color].")
		"Cavalry Sword Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/cavalry_sword.png")
			techRewardDescription = str("[b]Cavalry Sword+[/b] — sharper steel. [color=green]Improved charge damage[/color].")
		"Officer Sword Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/officer_sword.png")
			techRewardDescription = str("[b]Officer Sword[/b] — command blade. Boosts nearby [color=green]morale[/color].")
		"Marine Mameluke Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/marine_mameluke.png")
			techRewardDescription = str("[b]Marine Mameluke[/b] — elite marine sabre. Excels in [color=yellow]boarding actions[/color].")
		"Flintlock Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Flintlock.png")
			techRewardDescription = str("[b]Flintlock Musket[/b] — standard ranged arm. Reliable [color=green]volley fire[/color].")
		"Volley Bonus":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Brown_Bess.png")
			techRewardDescription = str("[b]Volley Drill[/b] — massed-fire training. [color=green]+Ranged damage[/color] in formation.")
		"Breechloader Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Percussion_Cap.png")
			techRewardDescription = str("[b]Breechloader[/b] — percussion ignition. [color=green]Faster reload[/color], all-weather.")
		"Lever Repeater Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Lever_Repeater.png")
			techRewardDescription = str("[b]Lever Repeater[/b] — rapid-fire rifle. [color=yellow]Multiple shots[/color] per reload.")
		"Field Gun Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Howitzer.png")
			techRewardDescription = str("[b]Field Gun[/b] — mobile artillery. [color=yellow]Area damage[/color] vs massed infantry.")
		"Siege Cannon Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Howitzer.png")
			techRewardDescription = str("[b]Siege Cannon[/b] — heavy gun. [color=green]Bonus siege progress[/color] vs forts.")
		"Mortar Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Mortar.png")
			techRewardDescription = str("[b]Mortar[/b] — high-arc shell. [color=yellow]Area + siege[/color] damage.")
		"Early Rockets Unlock":
			techRewardImage = load("res://art assets/finishedAssets/Weapons/Early_Rocket.png")
			techRewardDescription = str("[b]Early Rockets[/b] — incendiary barrage. Wide [color=yellow]area damage[/color].")
		"All Buildings Unlock":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/farm.png")
			techRewardDescription = str("[color=green]All buildings unlocked[/color] + each reaches [color=yellow]Level 5[/color].")
		"Seed Bag Tool":
			techRewardImage = load("res://art assets/finishedAssets/civilians/civilian_farmer.png")
			techRewardDescription = str("[b]Seed Bag[/b] — civilian tool. [color=green]Boosts farm output[/color].")
		"Building Upgrade":
			techRewardImage = load("res://art assets/finishedAssets/buildingsketches/workshop.png")
			techRewardDescription = str("[color=green]+5 max Level[/color] for all your buildings.")
		"Accountant Books Tool":
			techRewardImage = load("res://art assets/finishedAssets/technology images/banking.png")
			techRewardDescription = str("[b]Accountant Books[/b] — civilian tool. [color=green]+Gold[/color] from trade.")
		"Foundry Kit Tool":
			techRewardImage = load("res://art assets/finishedAssets/technology images/metal casting.png")
			techRewardDescription = str("[b]Foundry Kit[/b] — civilian tool. [color=green]+Metal & weapons[/color] output.")
		"Rails and Engines Tool":
			techRewardImage = load("res://art assets/finishedAssets/technology images/craftmanship.png")
			techRewardDescription = str("[b]Rails & Engines[/b] — civilian tool. [color=green]Industrial logistics[/color].")
		"Tricorne Uniform":
			techRewardImage = load("res://art assets/finishedAssets/governors/green_minuteman_05.png")
			techRewardDescription = str("[b]Tricorne[/b] uniform (Lvl 1). Melee [color=yellow]8[/color] / Ranged [color=yellow]12[/color] / Magic [color=yellow]4[/color].")
		"Forage Cap Uniform":
			techRewardImage = load("res://art assets/finishedAssets/governors/green_minuteman_06.png")
			techRewardDescription = str("[b]Forage Cap[/b] uniform (Lvl 2). Melee [color=yellow]10[/color] / Ranged [color=yellow]16[/color] / Magic [color=yellow]6[/color].")
		"Tombstone Uniform":
			techRewardImage = load("res://art assets/finishedAssets/governors/green_minuteman_07.png")
			techRewardDescription = str("[b]Tombstone Cap[/b] uniform (Lvl 3). Melee [color=yellow]10[/color] / Ranged [color=yellow]20[/color] / Magic [color=yellow]5[/color].")
		"Hardee Uniform":
			techRewardImage = load("res://art assets/finishedAssets/governors/green_minuteman_08.png")
			techRewardDescription = str("[b]Hardee Hat[/b] uniform (Lvl 4). Melee [color=yellow]15[/color] / Ranged [color=yellow]25[/color] / Magic [color=yellow]10[/color].")
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
		"SaberCharge Enhanced":
			techRewardImage = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			techRewardDescription = str("[b]SaberCharge[/b] — Cavalry Charge Upgrade:
				vs. Reloading Enemies: [color=green]x2[/color] → [color=yellow]x3[/color] Melee Damage")
		"CannonBlast Enhanced":
			techRewardImage = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			techRewardDescription = str("[b]CannonBlast[/b] — Artillery Upgrade:
				vs. Unshielded Enemies: [color=green]x3[/color] → [color=yellow]x5[/color] Ranged Damage
				Siege Progress bonus: [color=yellow]Doubled[/color]")
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
	$Control/BigSprite.texture = techRewardImage
	# Shrink lettering for long entries so text never spills past the panel
	var tlen := techRewardType.length()
	$Control/TypeLabel.add_theme_font_size_override("font_size", 24 if tlen <= 14 else (20 if tlen <= 18 else 16))
	var dlen := techRewardDescription.length()
	var dfont := 12 if dlen <= 55 else (10 if dlen <= 90 else 9)
	$Control/DescriptionRichLabel.add_theme_font_size_override("normal_font_size", dfont)
	$Control/DescriptionRichLabel.add_theme_font_size_override("bold_font_size", dfont)


func _on_area_2d_mouse_entered() -> void:
	$Control.visible = true


func _on_area_2d_mouse_exited() -> void:
	$Control.visible = false
