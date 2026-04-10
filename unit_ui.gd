extends Control

#@class_name UIUnitScene

var thisUnit: Unit
var updateControl: bool = false

var milModList: Array = []
var modListCompare: Array = []

var alwaysFree: bool
var debugMode: bool

const milModScene = preload("res://mil_mod.tscn")

func buildSelf():
	debugMode = false
	alwaysFree = false
	
	pass

func assignUnit(unitforTransfer):
	thisUnit = unitforTransfer
	print(thisUnit, thisUnit.unitType, "DEBUG thisUnit")
	pass

func upgradeButtonCalculation(maxUnitLevel):
	#print(thisUnit.unitLevel, "thisUnit.unitLevel", maxUnitLevel, "maxUnitLevel")
	if thisUnit != null:
		if thisUnit.unitLevel < maxUnitLevel && $UpgradeButton.disabled == true:
			$UpgradeButton.disabled = false
		elif thisUnit.unitLevel >= maxUnitLevel:
			$UpgradeButton.disabled = true
	pass


var milModCompare :Array = []

func armyUpdateMilMods():
	findMilMods(thisUnit)
	pass

func findMilMods(thisUnit):
	milModCompare.clear()
	print("military modifiers list", thisUnit.militaryModifierList)
	if thisUnit.militaryModifierList != null:
		for MilMod in $Panel/GridContainer.get_children():
			milModCompare.append(MilMod)
		if milModCompare == thisUnit.militaryModifierList:
			print("It's a god damn miracle")
			return
		else:
			for MilMod in $Panel/GridContainer.get_children():
				if is_instance_valid(MilMod):
					#$Panel/GridContainer.remove_child(MilMod)
					MilMod.queue_free()
					thisUnit.militaryModifierList.erase(MilMod)
				else:
					$Panel/GridContainer.remove_child(MilMod)
					thisUnit.militaryModifierList.erase(MilMod)
					MilMod.queue_free()
			for MilMod in thisUnit.militaryModifierList:
				if MilMod != null:
					var newMilMod = milModScene.instantiate()
					var tempType : String = str(MilMod.milModType)
					newMilMod.buildSelf(tempType)
					milModCompare.append(newMilMod)
					$Panel/GridContainer.add_child(newMilMod)
				#else:
					#print("NoMilModTypeFound", MilMod.milModType)
	#print("milModCOmpare", milModCompare, "militarymodifierlist", thisUnit.militaryModifierList)
	pass

var weaponsList: Array = []
func _on_weapon_type_button_pressed() -> void:
	#print("weapons list before", weaponsList)
	if weaponsList != null:
		for WeaponButton in weaponsList:
			WeaponButton.queue_free()
		weaponsList.clear()
	for WeaponTemplate in thisUnit.playerCountry.weaponTemplateList:
		var weaponButton = WeaponButton.new()
		weaponButton.icon = WeaponTemplate.weaponImage
		weaponButton.weaponName = WeaponTemplate.weaponType
		weaponButton.giveWeaponName.connect(addWeapon)
		weaponsList.append(weaponButton)
		$WeaponsChoicePanel/GridContainer.add_child(weaponButton)
	if $WeaponsChoicePanel.visible == false:
		$WeaponsChoicePanel.visible = true
	else:
		$WeaponsChoicePanel.visible = false
	pass # Replace with function body.

var oresList: Array = []
var oreButtonScene = load("res://ore_button.tscn")
func _on_ore_type_button_pressed() -> void:
	if oresList != null:
		for OreButton in oresList:
			OreButton.queue_free()
		oresList.clear()
	#print("DEBUG AVAILABLE ORES", thisUnit.playerCountry.availableOres)
	for ore in thisUnit.playerCountry.availableOres:
		var newOreButton = oreButtonScene.instantiate()
		newOreButton.buildSelf(ore.oreType, ore.oreImage)
		newOreButton.giveOreName.connect(addOre)
		oresList.append(newOreButton)
		$OresChoicePanel/ScrollContainer/GridContainer.add_child(newOreButton)
	if $OresChoicePanel.visible == false:
		$OresChoicePanel.visible = true
	else:
		$OresChoicePanel.visible = false
	pass # Replace with function body.

func addOre(oreType):
	if thisUnit.unitMetal != null:
		thisUnit.removeOreMilMod(oreType)
	
	thisUnit.addOreMilMod(oreType)
	$OresChoicePanel.visible = false
	findMilMods(thisUnit)
	pass

func addWeapon(weaponType):
	#print("Weapon Type", weaponType)
	if thisUnit.unitWeapon != null:
		thisUnit.removeWeaponAdditions()
	thisUnit.addWeapon(weaponType)
	$WeaponsChoicePanel.visible = false
	findMilMods(thisUnit)
	pass


#debug menu operations

func _on_debug_menu_button_pressed() -> void:
	if $Button.visible == false:
		$Button.visible = true
		$Button2.visible = true
		$UpgradeButton.visible = true
	else:
		$Button.visible = false
		$Button2.visible = false
		$UpgradeButton.visible = false
	pass # Replace with function body.

func _on_upgrade_button_pressed():
	thisUnit.unitLevel +=1
	pass # Replace with function body.

func _on_button_pressed() -> void:
	thisUnit.unitCurrentManpower -= 100
	pass # Replace with function body.

func _on_button_2_pressed() -> void:
	thisUnit.unitCurrentManpower += 100
	pass # Replace with function body.

func _on_always_freebutton_pressed() -> void:
	alwaysFree = true
	pass # Replace with function body.
