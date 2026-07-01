extends Control

class_name UIUnitScene

var thisUnit: Unit
var updateControl: bool = false

var playerCountry

var milModList: Array = []
var modListCompare: Array = []

var alwaysFree: bool
var debugMode: bool

var delete: bool #flag used by the army to determine if it will be deleted during the army update
var _stance_buttons: Dictionary = {}  # per-unit Attack/Hold/Charge stance buttons (Phase 2)

const milModScene = preload("res://mil_mod.tscn")

func buildSelf(unit, player):
	playerCountry = player
	debugMode = false
	alwaysFree = false
	thisUnit = unit
	pass

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
	_refresh_stance_buttons()
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
	pass
var weaponButtScene = preload("res://weapon_button.tscn")
var weaponsList: Array = []
func _on_weapon_type_button_pressed() -> void:
	#print("weapons list before", weaponsList)
	if weaponsList != null:
		for WeaponButton in weaponsList:
			WeaponButton.queue_free()
		weaponsList.clear()
	for WeaponTemplate in playerCountry.weaponTemplateList:
		var weaponButton = weaponButtScene.instantiate()
		weaponButton.buildSelf(WeaponTemplate.weaponType, WeaponTemplate.weaponImage)
		weaponButton.giveWeaponName.connect(addWeapon)
		weaponsList.append(weaponButton)
		$WeaponScrollContainer/WeaponContainer.add_child(weaponButton)
	if $WeaponScrollContainer.visible == false:
		$WeaponScrollContainer.visible = true
	else:
		$WeaponScrollContainer.visible = false
	pass # Replace with function body.

var oresList: Array = []
var oreButtonScene = load("res://ore_button.tscn")
func _on_ore_type_button_pressed() -> void:
	if oresList != null:
		for OreButton in oresList:
			OreButton.queue_free()
		oresList.clear()
	for ore in playerCountry.availableOres:
		var newOreButton = oreButtonScene.instantiate()
		newOreButton.buildSelf(ore.oreType, ore.oreImage)
		newOreButton.giveOreName.connect(addOre)
		oresList.append(newOreButton)
		$OreScrollContainer/OreContainer.add_child(newOreButton)
	if $OreScrollContainer.visible == false:
		$OreScrollContainer.visible = true
	else:
		$OreScrollContainer.visible = false
	pass # Replace with function body.

func addOre(oreType):
	if thisUnit.unitOre != null:
		thisUnit.changeOre(oreType)
	$OreScrollContainer.visible = false
	pass

func addWeapon(weaponType):
	#print("Weapon Type", weaponType)
	if thisUnit.unitWeapon != null:
		thisUnit.changeWeapon(weaponType)
	$WeaponScrollContainer.visible = false
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


# ── PHASE 2: per-unit stance buttons (placeholder layout — restyle in the panel redo) ──
func _refresh_stance_buttons() -> void:
	if thisUnit == null:
		return
	if _stance_buttons.is_empty():
		var hbox := HBoxContainer.new()
		hbox.name = "StanceButtons"
		hbox.position = Vector2(0, 250)
		add_child(hbox)
		for st in ["attack", "hold", "charge"]:
			var b := Button.new()
			b.text = st.capitalize()
			b.custom_minimum_size = Vector2(62, 26)
			b.pressed.connect(_on_stance_pressed.bind(st))
			hbox.add_child(b)
			_stance_buttons[st] = b
	var no_melee: bool = thisUnit.unitWeapon != null and thisUnit.unitWeapon.weaponClass == "Artillery"
	if thisUnit.is_reloading() and no_melee:
		thisUnit.unitStance = "hold"
		_stance_buttons["attack"].disabled = true
		_stance_buttons["charge"].disabled = true
	else:
		_stance_buttons["attack"].disabled = false
		_stance_buttons["charge"].disabled = not thisUnit.can_charge_melee()
	for st in _stance_buttons:
		_stance_buttons[st].modulate = Color(1, 1, 0.4) if thisUnit.unitStance == st else Color(1, 1, 1)


func _on_stance_pressed(stance: String) -> void:
	if thisUnit != null:
		thisUnit.unitStance = stance
		_refresh_stance_buttons()
