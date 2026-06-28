extends Control

class_name BarracksButton

var barracksBuilding
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

func addPrebuiltArmy(Army):
	$AddNewArmyButton.visible = false
	$Panel/builtArmyInfoPanel.visible = true
	$Panel/builtArmyInfoPanel/armyName.text = str(Army.ArmyName)
	$ArmyContainer.add_child(Army)
	barracksArmy = Army

func buildSelf():
	$Panel/tileName.text = barracksTile.tileName
	$Panel/barrackslvl.text = str("Barracks Level: ", barracksBuilding.buildingLevel)

func updateSelf():
	$Panel/barrackslvl.text = str("Barracks Level: ", barracksBuilding.buildingLevel)
	if is_instance_valid(barracksArmy):
		barracksArmy.updateArmyUI()
	else:
		# Army died or was never raised — restore the "Add New Army" affordance
		barracksArmy = null
		$AddNewArmyButton.visible = true
		$Panel/builtArmyInfoPanel.visible = false
		$Panel/builtArmyInfoPanel/armyName.text = ""

func _on_text_edit_text_changed():
	newArmyName = $NameAndConfirmPanel/TextEdit.text


func _on_confirm_button_pressed():
	emit_signal("addNewArmy", barracksBuilding, barracksTile, self, newArmyName)
	$NameAndConfirmPanel/TextEdit.clear()
	$NameAndConfirmPanel.visible = false
