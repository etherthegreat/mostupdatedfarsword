extends Control

class_name manaPanel

var manaType: String
var formatted_text = ""

var sortingInt: int

func buildSelf(type, amount, dictionary):
	sortingInt = amount
	$DictionaryLabel.visible = false
	$DictionaryPanelSprite.visible = false
	if amount >-1: 
		$ManaLabel.text = str(amount)
	else:
		$ManaLabel.text = str(amount)
		$ManaLabel["theme_override_colors/font_color"] = Color.RED
		$panelbackground.texture = load("res://art assets/finishedAssets/Panels/topbarresources/IMG_1546.PNG")
	match type:
		"Currency", "Dollars":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/currency.png")
		"Food":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/fooda.png")
		"Wood":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/wood.png")
		"Metal":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/metal.png")
		"Manpower":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/manpower.png")
		"Weapons":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/Weapons.png")
		"Science":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/science2.png")
		"Faith":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/faith.png")
		"Magic":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/Magic.png")
		"Culture":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/Culture.png")
		"Mandate":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/Mandate.png")
		"Harmony", "Happiness":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/Harmony.png")
		"Influence":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/Influence 1.png")
		"Boats":
			$ManaIcon.texture = load("res://art assets/finishedAssets/manaicons/manpower.png")
	for key in dictionary:
		var newDic = dictionary[key]
		for sub_key in newDic:
			var value = newDic[sub_key]
			if value > 0:
				formatted_text += "[p]" + "[color=green]" + "+" + str(value) + "[/color]" +  str(sub_key) + "[/p]"
			else:
				formatted_text += "[p]" + "[color=red]" + "-" + str(value) + "[/color]" +  str(sub_key) + "[/p]"
	$DictionaryLabel.append_text(formatted_text)


signal manaLook

func _on_areaola_2d_mouse_entered() -> void:
	emit_signal("manaLook", formatted_text)

signal closeManaLook
func _on_areaola_2d_mouse_exited() -> void:
	emit_signal("closeManaLook")
