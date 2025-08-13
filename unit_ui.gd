extends Control

#@class_name UIUnitScene

var thisUnit: Unit
var updateControl: bool

var milModList: Array = []
var modListCompare: Array = []

const milModScene = preload("res://mil_mod.tscn")

func startUpdating():
	updateControl = true
	pass

func stopUpdating():
	updateControl= false
	pass

func _process(delta: float) -> void:
	if updateControl == false:
		return
	else:
		$Panel/UnitNameLabel.text = thisUnit.unitType
		if thisUnit.unitWeapon != null:
			$Panel/WeaponTypeButton.icon = thisUnit.unitWeapon.weaponImage
		else:
			$Panel/WeaponTypeButton.icon = null
		if thisUnit.unitMetal != null:
			$Panel/OreTypeButton.icon = thisUnit.unitMetal.oreImage
		$Panel/LevelLabel.text = str(thisUnit.unitLevel)
		$Panel/UnitStrengthContainer/UnitAttackLabel.text = str("Attack: ", thisUnit.unitOffensiveScore)
		$Panel/UnitStrengthContainer/UnitDefenceLabel.text = str("Defence: ", thisUnit.unitDefensiveScore)
		$Panel/ManpowerLabel.text = str("Strength: ", thisUnit.unitCurrentManpower, "/", thisUnit.unitMaxManpower)
		#print("UPdating UI UNit HAHAHAA!")
		#print(self, "I am here, ya ya ya", thisUnit.unitType)
		
	pass

func assignUnit(unitforTransfer):
	thisUnit = unitforTransfer
	pass

func upgradeButtonCalculation(maxUnitLevel):
	#print(thisUnit.unitLevel, "thisUnit.unitLevel", maxUnitLevel, "maxUnitLevel")
	if thisUnit.unitLevel < maxUnitLevel && $UpgradeButton.disabled == true:
		$UpgradeButton.disabled = false
	elif thisUnit.unitLevel >= maxUnitLevel:
		$UpgradeButton.disabled = true
	pass


func _on_button_pressed() -> void:
	thisUnit.unitCurrentManpower -= 100
	pass # Replace with function body.

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
		for weaponButton in weaponsList:
			weaponButton.queue_free()
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
func _on_ore_type_button_pressed() -> void:
	if oresList != null:
		for OreButton in oresList:
			OreButton.queue_free()
		oresList.clear()
	for ore in thisUnit.playerCountry.availableOres:
		var newOreButton = OreButton.new()
		newOreButton.icon = ore.oreImage
		newOreButton.oreName = ore.oreType
		newOreButton.giveOreName.connect(addOre)
		oresList.append(newOreButton)
		$OresChoicePanel/GridContainer.add_child(newOreButton)
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


func _on_upgrade_button_pressed():
	thisUnit.unitLevel +=1
	pass # Replace with function body.
