extends Control

class_name armyCostUI

@export var tempType: String
var newType: String

var amount: int
var maxAmount: int

var image: Texture2D

func buildSelf():
	newType = tempType
	match newType:
		"Punch":
			image = load("res://art assets/finishedAssets/Panels/armypanelfinishedui/IMG_1561.PNG")
			$amountlabel.set("theme_override_colors/font_color", Color.SILVER)
		"Launch":
			image = load("res://art assets/finishedAssets/Panels/armypanelfinishedui/IMG_1559.PNG")
			$amountlabel.set("theme_override_colors/font_color", Color.GOLDENROD)
		"Shield":
			image= load("res://art assets/finishedAssets/Panels/armypanelfinishedui/IMG_1558.PNG")
			$amountlabel.set("theme_override_colors/font_color", Color.SKY_BLUE)
		"Guard":
			image = load("res://art assets/finishedAssets/Panels/armypanelfinishedui/IMG_1563.PNG")
			$amountlabel.set("theme_override_colors/font_color", Color.SADDLE_BROWN)
		"Catch":
			image = load("res://art assets/finishedAssets/Panels/armypanelfinishedui/IMG_1562.PNG")
			$amountlabel.set("theme_override_colors/font_color", Color.DARK_RED)
		"Spell":
			image = load("res://art assets/finishedAssets/Panels/armypanelfinishedui/IMG_1558.PNG")
			$amountlabel.set("theme_override_colors/font_color", Color.PURPLE)
	$Sprite2D2.texture = image
	pass

func updateSelf(numb, maxNumb):
	if newType == "Shield":
		amount = numb
		maxAmount = maxNumb
		$amountlabel.text = str(amount, " / ", maxAmount)
	elif newType == "Punch" || newType == "Launch":
		amount = numb
		$amountlabel.text = str(amount)
	else:
		amount = numb
		$amountlabel.text = str(amount, "%")
	pass
