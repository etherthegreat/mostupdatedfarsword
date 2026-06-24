extends Control

class_name UIUnitScene

var thisUnit: Unit
var updateControl: bool = false

var milModList: Array = []
var modListCompare: Array = []

var alwaysFree: bool
var debugMode: bool

var delete: bool #flag used by the army to determine if it will be deleted during the army update

const milModScene = preload("res://mil_mod.tscn")

func buildSelf(unit):
	debugMode = false
	alwaysFree = false
	thisUnit = unit

func updateUI():
	$WeaponTypeButton.icon = thisUnit.unitWeapon.weaponImage
	$OreTypeButton.icon = thisUnit.unitOre.oreImage
	$ArmorTypeButton.icon = thisUnit.unitArmor.armorImage
	$UnitStrengthContainer/UnitAttackLabel.text = str(thisUnit.unitOffensiveScore)
	$UnitStrengthContainer/UnitRangedAttack.text = str(thisUnit.unitRangedOffence)
	$UnitStrengthContainer/UnitShield.text = str(thisUnit.unitShield)
	$LevelLabel.text = str(thisUnit.unitLevel)
	$WeaponsLabel.clear()
	$ManpowerLabel.clear()
	var newWeaponText : String
	newWeaponText = str(thisUnit.unitCurrentWeapons, "/",
	thisUnit.unitMaxWeapons)
	var newManpowerText: String
	newManpowerText = str(thisUnit.unitCurrentManpower, "/", 
	thisUnit.unitMaxManpower)
	$WeaponsLabel.add_text(newWeaponText)
	$ManpowerLabel.add_text(newManpowerText)
	findMilMods()

func upgradeButtonCalculation(maxUnitLevel):
	#print(thisUnit.unitLevel, "thisUnit.unitLevel", maxUnitLevel, "maxUnitLevel")
	if thisUnit != null:
		if thisUnit.unitLevel < maxUnitLevel && $UpgradeButton.disabled == true:
			$UpgradeButton.disabled = false
		elif thisUnit.unitLevel >= maxUnitLevel:
			$UpgradeButton.disabled = true


var milModCompare :Array = []


func findMilMods():
	milModCompare.clear()
	print("military modifiers list", thisUnit.militaryModifierList)
	if thisUnit.militaryModifierList != null:
		for MilMod in $GridContainer.get_children():
			milModCompare.append(MilMod)
		if milModCompare == thisUnit.militaryModifierList:
			print("It's a god damn miracle")
			return
		else:
			for MilMod in $GridContainer.get_children():
				if is_instance_valid(MilMod):
					#$Panel/GridContainer.remove_child(MilMod)
					MilMod.queue_free()
					thisUnit.militaryModifierList.erase(MilMod)
				else:
					$GridContainer.remove_child(MilMod)
					thisUnit.militaryModifierList.erase(MilMod)
					MilMod.queue_free()
			for MilMod in thisUnit.militaryModifierList:
				if MilMod != null:
					var newMilMod = milModScene.instantiate()
					var tempType : String = str(MilMod.milModType)
					newMilMod.buildSelf(tempType)
					milModCompare.append(newMilMod)
					$GridContainer.add_child(newMilMod)
				#else:
					#print("NoMilModTypeFound", MilMod.milModType)
	#print("milModCOmpare", milModCompare, "militarymodifierlist", thisUnit.militaryModifierList)
var weaponButtScene = preload("res://weapon_button.tscn")
var weaponsList: Array = []
func _on_weapon_type_button_pressed() -> void:
	#print("weapons list before", weaponsList)
	if weaponsList != null:
		for WeaponButton in weaponsList:
			WeaponButton.queue_free()
		weaponsList.clear()
	print(thisUnit.playerCountry.CID, "CID")
	print(thisUnit.playerCountry.weaponTemplateList, "WTL")
	for WeaponTemplate in thisUnit.playerCountry.weaponTemplateList:
		var weaponButton = weaponButtScene.instantiate()
		weaponButton.buildSelf(WeaponTemplate.weaponType, WeaponTemplate.weaponImage)
		weaponButton.giveWeaponName.connect(addWeapon)
		weaponsList.append(weaponButton)
		$WeaponScrollContainer/WeaponContainer.add_child(weaponButton)
	if $WeaponScrollContainer.visible == false:
		$WeaponScrollContainer.visible = true
	else:
		$WeaponScrollContainer.visible = false

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
		$OreScrollContainer/OreContainer.add_child(newOreButton)
	if $OreScrollContainer.visible == false:
		$OreScrollContainer.visible = true
	else:
		$OreScrollContainer.visible = false

func addOre(oreType):
	if thisUnit.unitOre != null:
		thisUnit.changeOre(oreType)
	$OreScrollContainer.visible = false

func addWeapon(weaponType):
	#print("Weapon Type", weaponType)
	if thisUnit.unitWeapon != null:
		thisUnit.changeWeapon(weaponType)
	$WeaponScrollContainer.visible = false

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

func _on_upgrade_button_pressed():
	thisUnit.unitLevel +=1

func _on_button_pressed() -> void:
	thisUnit.unitCurrentManpower -= 100

func _on_button_2_pressed() -> void:
	thisUnit.unitCurrentManpower += 100

func _on_always_freebutton_pressed() -> void:
	alwaysFree = true
