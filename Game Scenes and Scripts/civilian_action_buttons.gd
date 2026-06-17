extends Control

var neighborTest: bool

func updateUI(CID, civ, toolName, kitType, ppbTile):
	$IncreaseAgriculturalDevelopment.visible = false
	$IncreaseResourceDevelopment.visible = false
	$IncreaseUrbanDevelopment.visible = false
	$IncreaseEliteDevelopment.visible = false
	$IncreaseMilitaryDevelopment.visible = false
	if $BuildRoad != null:
		$BuildRoad.visible = false
	match toolName:
		"Seed Bag":
			$IncreaseAgriculturalDevelopment.visible = true
		"Dictionary":
			$IncreaseEliteDevelopment.visible = true
		"Wooden Tools":
			$IncreaseResourceDevelopment.visible = true
		"Metal Tools":
			$IncreaseUrbanDevelopment.visible = true
		"Steel Tools":
			$IncreaseMilitaryDevelopment.visible = true
		"Pickaxe":
			if $BuildRoad != null:
				$BuildRoad.visible = true
		"Codebook":
			# Spy action buttons — add SabotageButton, ContactTurncoatsButton,
			# and ReconnaissanceButton to this scene to activate them.
			if has_node("SabotageButton"):
				$SabotageButton.visible = true
			if has_node("ContactTurncoatsButton"):
				$ContactTurncoatsButton.visible = true
			if has_node("ReconnaissanceButton"):
				$ReconnaissanceButton.visible = true
		"DMA Badge":
			# DMA field agent — add InvestigateSightingsButton to this scene to activate it.
			# When pressed, sets ppbTile.dmaInvestigationPending = true; world checks this
			# at turn start and fires the associated protector summon event.
			if has_node("InvestigateSightingsButton"):
				$InvestigateSightingsButton.visible = ppbTile.hasMysteriousShipRaids or ppbTile.dmaInvestigationPending == false
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
