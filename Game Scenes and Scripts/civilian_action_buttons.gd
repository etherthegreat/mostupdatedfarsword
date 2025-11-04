extends Control

var neighborTest: bool

func updateUI(CID, civ, toolName, kitType, ppbTile):
	$IncreaseAgriculturalDevelopment.visible = false
	$IncreaseResourceDevelopment.visible = false
	$IncreaseUrbanDevelopment.visible = false
	$IncreaseEliteDevelopment.visible = false
	$IncreaseMilitaryDevelopment.visible = false
	match toolName:
		"Seedbag":
			$IncreaseAgriculturalDevelopment.visible = true
		"Dictionary":
			$IncreaseEliteDevelopment.visible = true
		"Wooden Tools":
			$IncreaseResourceDevelopment.visible = true
		"Metal Tools":
			$IncreaseUrbanDevelopment.visible = true
		"Steel Tools":
			$IncreaseMilitaryDevelopment.visible = true
	match kitType:
		"Constructor":
			$IncreaseAgriculturalDevelopment.visible = true
			$IncreaseResourceDevelopment.visible = true
			$IncreaseUrbanDevelopment.visible = true
			$IncreaseEliteDevelopment.visible = true
			$IncreaseMilitaryDevelopment.visible = true
		"Prospector":
			$IncreaseResourceDevelopment.visible = true
	neighborTest = false
	for Tile in ppbTile.TileNeighbors:
		if Tile.tileOwner == CID:
			neighborTest = true
	if neighborTest == true:
		$ColonizeButton.visible = true
	else:
		$ColonizeButton.visible = false
	pass
