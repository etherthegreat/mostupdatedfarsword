extends Control

class_name BarracksButton

var barracksBuilding: building
var barracksTile: Tile

var barracksArmy: Army

var newArmyName: String

signal addNewArmy

func _on_add_new_army_button_pressed():
	if $NameAndConfirmPanel.visible == true:
		$NameAndConfirmPanel.visible = false
	else:
		$NameAndConfirmPanel.visible = true
	#var newArmy = Army
	pass # Replace with function body.

func addPrebuiltArmy(Army):
	$AddNewArmyButton.visible = false
	$Panel/builtArmyInfoPanel.visible = true
	$Panel/builtArmyInfoPanel/armyName.text = str(Army.ArmyName)
	$ArmyContainer.add_child(Army)
	barracksArmy = Army
	pass

func buildSelf():
	$Panel/tileName.text = barracksTile.tileName
	$Panel/barrackslvl.text = str("Barracks Level: ", barracksBuilding.buildingLevel)
	pass

func updateSelf():
	$Panel/barrackslvl.text = str("Barracks Level: ", barracksBuilding.buildingLevel)
	if barracksArmy != null:
		barracksArmy.updateArmyUI()
	pass

func _on_text_edit_text_changed():
	newArmyName = $NameAndConfirmPanel/TextEdit.text
	print("text edit changed, new name is ", newArmyName)
	pass # Replace with function body.


func _on_confirm_button_pressed():
	emit_signal("addNewArmy", barracksBuilding, barracksTile, self, newArmyName)
	$NameAndConfirmPanel/TextEdit.clear()
	$NameAndConfirmPanel.visible = false
	pass # Replace with function body.
