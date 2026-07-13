extends Control

class_name buildingButton

var buildingType: String

var buildingTexture: Texture

var foodCost: float
var goldCost: float
var woodCost: float
var metalCost: float
var foodCalculatedCost: float
var goldCalculatedCost: float
var woodCalculatedCost: float
var metalCalculatedCost: float

var player: country



func buildSelf(building, playerCountry):
	buildingType = building.buildingType
	buildingTexture = building.buildingSprite
	$Button.icon = buildingTexture
	foodCost = building.foodPurchaseCost
	goldCost = building.goldPurchaseCost
	woodCost = building.woodPurchaseCost
	metalCost = building.metalPurchaseCost
	player = playerCountry
	

signal newBuilding
func _on_button_pressed() -> void:
	emit_signal("newBuilding",buildingType, goldCalculatedCost, foodCalculatedCost, woodCalculatedCost, metalCalculatedCost)

func updateUI():
	goldCalculatedCost = goldCost * player.countryConstructionCostMod
	foodCalculatedCost = foodCost * player.countryConstructionCostMod
	woodCalculatedCost = woodCost * player.countryConstructionCostMod
	metalCalculatedCost = metalCost * player.countryConstructionCostMod
	$Button.disabled = false
	if goldCost != 0:
		$GoldCostLabel.text = str(goldCalculatedCost)
		$GoldCostLabel.visible = true
		$GoldCostSprite.visible = true
	else:
		$GoldCostLabel.visible = false
		$GoldCostSprite.visible = false
	if foodCost != 0:
		$FoodCostLabel.text = str(foodCalculatedCost)
		$FoodCostLabel.visible = true
		$FoodCostSprite.visible = true
	else:
		$FoodCostLabel.visible = false
		$FoodCostSprite.visible = false
	if woodCost != 0:
		$WoodCostLabel.text = str(woodCalculatedCost)
		$WoodCostLabel.visible = true
		$WoodCostSprite.visible = true
	else:
		$WoodCostLabel.visible = false
		$WoodCostSprite.visible = false
	if metalCost != 0:
		$MetalCostLabel.text = str(metalCalculatedCost)
		$MetalCostLabel.visible = true
		$MetalCostSprite.visible = true
	else:
		$MetalCostLabel.visible = false
		$MetalCostSprite.visible = false
	if player.TotalDollars <= goldCost:
		$Button.disabled = true
	if player.TotalFood <= foodCost:
		$Button.disabled = true
	if player.TotalWood <= woodCost:
		$Button.disabled = true
	if player.TotalMetal <= metalCost:
		$Button.disabled = true
