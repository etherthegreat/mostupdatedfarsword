extends Sprite2D


func displayNationalResource(playerCountry, resourceNumber):
	if resourceNumber == 0:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/gold.png")
		$TotalResourceLabel.text = str("Total Gold: ", playerCountry.TotalGold)
		$ResourceIncomeLab.text = str("Total Gold Income: ", playerCountry.GPM)
		$ResourceExpenseLab.text = str("Total Gold Expenses: ", playerCountry.goldEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 1:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png")
		$TotalResourceLabel.text = str("Total Food Reserves: ", playerCountry.TotalFood)
		$ResourceIncomeLab.text = str("Total Food Income: ", playerCountry.FPM)
		$ResourceExpenseLab.text = str("Total Food Expenses: ", playerCountry.foodEXPM)
		$ResourceMaxLabel.text = str("Max Food Storage: ", playerCountry.foodStorageMax)
	if resourceNumber == 2:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png")
		$TotalResourceLabel.text = str("Total Wood Reserves: ", playerCountry.TotalWood)
		$ResourceIncomeLab.text = str("Total Wood Income: ", playerCountry.WPM)
		$ResourceExpenseLab.text = str("Total Wood Expenses: ", playerCountry.woodEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 3:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/Metal.png")
		$TotalResourceLabel.text = str("Total Metal Reserves: ", playerCountry.TotalMetal)
		$ResourceIncomeLab.text = str("Total Metal Income: ", playerCountry.MPM)
		$ResourceExpenseLab.text = str("Total Metal Expenses: ", playerCountry.metalEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 4:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/weapons.png")
		$TotalResourceLabel.text = str("Total Weapons Reserves: ", playerCountry.TotalWeapons)
		$ResourceIncomeLab.text = str("Total Weapons Income: ", playerCountry.PPM)
		$ResourceExpenseLab.text = str("Total Weapons Expenses: ", playerCountry.weaponsEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 5:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/Science.png")
		$TotalResourceLabel.text = str("Total Science Reserves: ", playerCountry.TotalScience)
		$ResourceIncomeLab.text = str("Total Science Income: ", playerCountry.SPM)
		$ResourceExpenseLab.text = str("Total Science Expenses: ", playerCountry.scienceEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 6:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png")
		$TotalResourceLabel.text = str("Total Faith Reserves: ", playerCountry.TotalFaith)
		$ResourceIncomeLab.text = str("Total Faith Income: ", playerCountry.IPM)
		$ResourceExpenseLab.text = str("Total Faith Expenses: ", playerCountry.faithEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 7:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/Magic.png")
		$TotalResourceLabel.text = str("Total Magic Reserves: ", playerCountry.TotalMagic)
		$ResourceIncomeLab.text = str("Total Magic Income: ", playerCountry.APM)
		$ResourceExpenseLab.text = str("Total Magic Expenses: ", playerCountry.magicEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 8:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/culture 100 x 100.png")
		$TotalResourceLabel.text = str("Total Culture: ", playerCountry.TotalCulture)
		$ResourceIncomeLab.text = str("Total Culture Income: ", playerCountry.CPM)
		$ResourceExpenseLab.text = str("Total Culture Expenses: ", playerCountry.cultureEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 9:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/mandate 100 x 100.png")
		$TotalResourceLabel.text = str("Total Mandate: ", playerCountry.TotalMandate)
		$ResourceIncomeLab.text = str("Total Mandate Income: ", playerCountry.NDT)
		$ResourceExpenseLab.text = str("Total Mandate Expenses: ", playerCountry.mandateEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 10:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/harmony 100 x 100.png")
		$TotalResourceLabel.text = str("Total Harmony: ", playerCountry.TotalHarmony)
		$ResourceIncomeLab.text = str("Total Harmony Income: ", playerCountry.HPM)
		$ResourceExpenseLab.text = str("Total Harmony Expenses: ", playerCountry.harmonyEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 11:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/influence 100 x 100.png")
		$TotalResourceLabel.text = str("Total Influence: ", playerCountry.TotalInfluence)
		$ResourceIncomeLab.text = str("Total Harmony Income: ", playerCountry.NPM)
		$ResourceExpenseLab.text = str("Total Harmony Expenses: ", playerCountry.influenceEXPM)
		$ResourceMaxLabel.text = str("")
	if resourceNumber == 12:
		$ResourceIcon.texture = load("res://art assets/Placeholder Art/UI Art/resources/Older Icons/manpower 100 x 100.png")
		$TotalResourceLabel.text = str("Current Manpower: ", playerCountry.TotalManpower)
		$ResourceIncomeLab.text = str("Total Manpower Increase: ", playerCountry.MAN)
		$ResourceExpenseLab.text = str("Total Manpower Loses: ", playerCountry.manpowerEXPM)
		$ResourceMaxLabel.text = str("")
	pass
