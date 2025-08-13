extends Control

class_name MilMod



var milModType : String

var milModDescription : String

var milModTexture: Texture

var infantryMod: bool
var rangedMod: bool
var siegeMod: bool

var commanderMod: bool

var resourceMod: bool

var milModResource: String

var disabled: bool

var newArea2D: Area2D
var newCollissionArea2D: CollisionShape2D

func buildSelf(Type):
	#print("AHHHHHHHHHHHH", Type)
	milModType = Type
	infantryMod = false
	rangedMod = false
	siegeMod = false
	resourceMod = false
	commanderMod = false
	#$Sprite2D/InfoPanel.visible = false
	match milModType:
		#COUNTRY MILMODS
		"Berserkers":
			infantryMod = true
			milModDescription = str("[i]Warriors are expected to kill or die trying:[/i][color= green] + 3 attack per level[/color],[color= red] -2 Harmony Per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/manpowerREALLYSMALL.png")
			milModResource = "Harmony"
		#WEAPONS
		"ClubBleed":
			infantryMod = true
			milModDescription = str("CLUB: [color=green] +2 Attack, +1 Defense per Level[/color], [color= red] -1 Weapons per Level")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Weapons"
		"AtlatlPierce":
			rangedMod = true
			milModDescription = str("ATLATL: [color=green] +1 Attack, +2 Defense per Level[/color], [color= red] -1 Weapons per Level")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/atlatlreallysmall.png")
			milModResource = "Weapons"
		#WEAPONORE
		"Wood":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are carved from wood[i]:[color= green] + 1 Attack per Level[/color], [color= red] -1 Wood per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Wood"
		"Copper":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are shaped by copper[i]:[color= green] + 2 Attack per Level[/color],[color= red] -1 Metal per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Metal"
		"Iron":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are forged from iron[i]:[color= green] + 3 Attack per Level[/color],[color= red] -3 Metal per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Metal"
		"Gold":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are built of gold,[i]:[color= green] + 2 Attack per Level[/color],[color= red] -1 Metal, -3 Gold per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Metal"
		"Floodstone":
			resourceMod = true
			milModDescription = str("[i]This unit's weapons are birthed from floodstone,[i]:[color= green] + 3 Attack per Level[/color],[color= red] -2 Metal, -2 Magic per Level[/color]")
			milModTexture = load("res://art assets/Placeholder Art/UI Art/resources/bleed.png")
			milModResource = "Metal"
		#CommanderMods
		"Visionary":
			commanderMod = true
			milModDescription = str("[i]This Unit's commander is a genius,[i]:[color= green] + 3 Attack per Level, + 10% speed[/color],")
			milModTexture = load("res://art assets/ModifierIcons/milMods/weird shape.png")
			milModResource = "None"
		"Champion of the Sun":
			commanderMod = true
			milModDescription = str("[i]While the sun is up, this unit will march,[i]:[color= green] + 1 Attack per Level, + 10% speed[/color],")
			milModTexture = load("res://art assets/ModifierIcons/milMods/sun.png")
			milModResource = "None"
		"Healer":
			commanderMod = true
			milModDescription = str("[i]This unit can heal super quick like da flash,[i]:[color= green] +10 reinforce rate,")
			milModTexture = load("res://art assets/ModifierIcons/milMods/green cross.png")
			milModResource = "None"
	#if milModType != null:
		#print(milModType, "MILMODTYPE")
	$Sprite2D/InfoPanel/MilModNameLabel.text = str(milModType)
	$Sprite2D/InfoPanel/MilModDescriptionLabel.text = str(milModDescription)
	$Sprite2D.texture = milModTexture
	newArea2D = $Area2D
	newCollissionArea2D = $Area2D/CollisionShape2D
	#print("Area2D", newArea2D, "newCollisionarea2d", newCollissionArea2D)
	pass

var mouseDetected: bool

func disableMilModType(ResourceType):
	if ResourceType == milModResource:
		disabled = true
	elif ResourceType == "All":
		disabled = true
	pass

func enableMilModType(ResourceType):
	if ResourceType == milModResource:
		disabled = false
	elif ResourceType == "All":
		disabled = false
	pass

func _process(delta: float) -> void:
	if mouseDetected == true:
		if $Sprite2D/InfoPanel.visible == false:
			$Sprite2D/InfoPanel.show()
			#print("what the fuck")
			return
		else:
			return
	else:
		if $Sprite2D/InfoPanel.visible == true:
			$Sprite2D/InfoPanel.hide()
			return
		else:
			return


func _on_area_2d_mouse_entered() -> void:
	mouseDetected = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	mouseDetected = false
	pass # Replace with function body.
