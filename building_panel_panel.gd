extends Control


var buildingUnderInspection: building

signal upgradeBuilding
signal downgradeBuilding
signal requestPlayerCountry
var bPPLevelList: Array = []

var player: country
var red = Color(1.0,0.0,0.0,1.0)
var white = Color(1.0,1.0,1.0,1.0)
var green = Color(0, 1, 0, 1)

func updateInspector(building):
	print("dkdkdkdkdkd")
	self.visible = true
	buildingUnderInspection = building
	if buildingUnderInspection != null:
		calculateUpgradeCost(buildingUnderInspection)
		$Panel/BuildingTypeLabel.text = str(building.buildingType)
		$Panel/BuildingLevelLabel.text = str(building.buildingLevel)
		$Panel/BuildingSprite.texture = building.buildingSprite
		$Panel/FoodLabel.text = str(foodUpgradeCost)
		#Outputs Text Edits
		$Panel/OutputsControl/FoodOutputLabel.text = str(building.totalBuildingFood)
		if building.totalBuildingFood > 0:
			$Panel/OutputsControl/FoodOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingFood == 0:
			$Panel/OutputsControl/FoodOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/FoodOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/WoodOutputLabel.text = str(building.totalBuildingWood)
		if building.totalBuildingWood > 0:
			$Panel/OutputsControl/WoodOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingWood == 0:
			$Panel/OutputsControl/WoodOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/WoodOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/MetalOutputLabel.text = str(building.totalBuildingMetal)
		if building.totalBuildingMetal > 0:
			$Panel/OutputsControl/MetalOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingMetal == 0:
			$Panel/OutputsControl/MetalOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/MetalOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/GoldOutputLabel.text = str(building.totalBuildingGold)
		if building.totalBuildingGold > 0:
			$Panel/OutputsControl/GoldOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingGold == 0:
			$Panel/OutputsControl/GoldOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/GoldOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/ManpowerOutputLabel.text = str(building.totalBuildingManpower)
		if building.totalBuildingManpower > 0:
			$Panel/OutputsControl/ManpowerOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingManpower == 0:
			$Panel/OutputsControl/ManpowerOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/ManpowerOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/WeaponsOutputLabel.text = str(building.totalBuildingWeapons)
		if building.totalBuildingWeapons > 0:
			$Panel/OutputsControl/WeaponsOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingWeapons == 0:
			$Panel/OutputsControl/WeaponsOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/WeaponsOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/ScienceOutputLabel.text = str(building.totalBuildingScience)
		if building.totalBuildingScience > 0:
			$Panel/OutputsControl/ScienceOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingScience == 0:
			$Panel/OutputsControl/ScienceOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/ScienceOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/CultureOutputLabel.text = str(building.totalBuildingCulture)
		if building.totalBuildingCulture > 0:
			$Panel/OutputsControl/CultureOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingCulture == 0:
			$Panel/OutputsControl/CultureOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/CultureOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/FaithOutputLabel.text = str(building.totalBuildingFaith)
		if building.totalBuildingFaith > 0:
			$Panel/OutputsControl/FaithOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingFaith == 0:
			$Panel/OutputsControl/FaithOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/FaithOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/MagicOutputLabel.text = str(building.totalBuildingMagic)
		if building.totalBuildingMagic > 0:
			$Panel/OutputsControl/MagicOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingMagic == 0:
			$Panel/OutputsControl/MagicOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/MagicOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/MandateOutputLabel.text = str(building.totalBuildingMandate)
		if building.totalBuildingMandate > 0:
			$Panel/OutputsControl/MandateOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingMandate == 0:
			$Panel/OutputsControl/MandateOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/MandateOutputLabel.set("theme_override_colors/font_color",red)
		$Panel/OutputsControl/InfluenceOutputLabel.text = str(building.totalBuildingInfluence)
		if building.totalBuildingInfluence > 0:
			$Panel/OutputsControl/InfluenceOutputLabel.set("theme_override_colors/font_color",green)
		elif building.totalBuildingInfluence == 0:
			$Panel/OutputsControl/InfluenceOutputLabel.set("theme_override_colors/font_color",white)
		else:
			$Panel/OutputsControl/InfluenceOutputLabel.set("theme_override_colors/font_color",red)
		if foodUpgradeCost > player.TotalFood:
			$Panel/FoodLabel.set("theme_override_colors/font_color",red)
			$Panel/Upgrade.disabled = true
		else:
			$Panel/FoodLabel.set("theme_override_colors/font_color",white)
			$Panel/Upgrade.disabled = false
		$Panel/MetalLabel.text = str(metalUpgradeCost)
		if metalUpgradeCost > player.TotalMetal:
			$Panel/MetalLabel.set("theme_override_colors/font_color",red)
			$Panel/Upgrade.disabled = true
		else:
			$Panel/MetalLabel.set("theme_override_colors/font_color",white)
			$Panel/Upgrade.disabled = false
		$Panel/WoodLabel.text = str(woodUpgradeCost)
		if woodUpgradeCost > player.TotalWood:
			$Panel/WoodLabel.set("theme_override_colors/font_color",red)
			$Panel/Upgrade.disabled = true
		else:
			$Panel/WoodLabel.set("theme_override_colors/font_color",white)
			$Panel/Upgrade.disabled = false
		$Panel/GoldLabel.text = str(goldUpgradeCost)
		if goldUpgradeCost > player.TotalGold:
			$Panel/GoldLabel.set("theme_override_colors/font_color",red)
			$Panel/Upgrade.disabled = true
		else:
			$Panel/GoldLabel.set("theme_override_colors/font_color",white)
			$Panel/Upgrade.disabled = false
		print("Success")
		bPPLevelList = player.buildingLevelList
		for buildingLevel in bPPLevelList:
			if buildingLevel.buildingType == buildingUnderInspection.buildingType:
				$Panel/BuildingMaxLevelLabel.text = str("Max:", buildingLevel.maxLevel)
				if buildingUnderInspection.buildingLevel >= buildingLevel.maxLevel:
					$Panel/Upgrade.disabled = true
				if buildingUnderInspection.buildingLevel < buildingLevel.maxLevel:
					$Panel/Upgrade.disabled = false
	else:
		#print("no inspector")
		pass
	pass




func _process(delta: float) -> void:
	if self.visible == true:
		updateInspector(buildingUnderInspection)
	pass

func _on_upgrade_pressed() -> void:
	emit_signal("upgradeBuilding", buildingUnderInspection)
	player.TotalFood -= foodUpgradeCost
	player.TotalWood -= woodUpgradeCost
	player.TotalGold -= goldUpgradeCost
	player.TotalMetal -= metalUpgradeCost
	pass # Replace with function body.


func _on_downgrade_pressed() -> void:
	emit_signal("downgradeBuilding", buildingUnderInspection)
	pass # Replace with function body.

var goldUpgradeCost: int
var foodUpgradeCost: int
var woodUpgradeCost: int
var metalUpgradeCost: int

func calculateUpgradeCost(building):
	goldUpgradeCost = 0
	foodUpgradeCost = 0
	woodUpgradeCost = 0
	metalUpgradeCost = 0
	if building.buildingType == "Farm":
		woodUpgradeCost += (15 + (15 * building.buildingLevel))
		if building.buildingLevel > 4:
			goldUpgradeCost += (20 + (20 * building.buildingLevel))
		if building.buildingLevel > 8:
			metalUpgradeCost += (20 + (20 * building.buildingLevel))
		return
	if building.buildingType == "Camp":
		foodUpgradeCost += (25 + (25 * building.buildingLevel))
		if building.buildingLevel > 4:
			metalUpgradeCost += (15 + (15 * building.buildingLevel))
		if building.buildingLevel > 8:
			metalUpgradeCost += (15 + (15 * building.buildingLevel))
		return
	if building.buildingType == "Mine":
		foodUpgradeCost += (35 + (35 * building.buildingLevel))
		woodUpgradeCost += (45 + (45 * building.buildingLevel))
		if building.buildingLevel > 4:
			foodUpgradeCost += (30 + (30 * building.buildingLevel))
			woodUpgradeCost += (30 + (30 * building.buildingLevel))
		if building.buildingLevel > 8:
			goldUpgradeCost += (40 + (40 * building.buildingLevel))
		return
	if building.buildingType == "Granary":
		foodUpgradeCost += (20 + (20 * building.buildingLevel))
		woodUpgradeCost += (15 + (15 * building.buildingLevel))
		if building.buildingLevel > 4:
			foodUpgradeCost += (20 + (20 * building.buildingLevel))
			woodUpgradeCost += (20 + (20 * building.buildingLevel))
			goldUpgradeCost += (20 + (20 * building.buildingLevel))
		if building.buildingLevel > 8:
			foodUpgradeCost += (20 + (20 *  building.buildingLevel))
			woodUpgradeCost += (20 + (20 * building.buildingLevel))
			goldUpgradeCost += (20 + (20 * building.buildingLevel))
			metalUpgradeCost += (20 + (20 * building.buildingLevel))
	if building.buildingType == "Library":
		foodUpgradeCost += (25 + (25 * building.buildingLevel))
		woodUpgradeCost += (35 + (35 * building.buildingLevel))
		goldUpgradeCost += (30 + (30 * building.buildingLevel))
		if building.buildingLevel > 4:
			foodUpgradeCost += (10 + (10 * building.buildingLevel))
			woodUpgradeCost += (35 + (35 * building.buildingLevel))
			goldUpgradeCost += (30 + (30 * building.buildingLevel))
		if building.buildingLevel > 8:
			foodUpgradeCost += (15 + (15 * building.buildingLevel))
			woodUpgradeCost += (40 + (40 * building.buildingLevel))
			goldUpgradeCost += (35 + (35 * building.buildingLevel))
			
	else:
		print("no building recognized")
	pass
