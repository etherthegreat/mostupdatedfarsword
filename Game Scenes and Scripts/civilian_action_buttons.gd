extends Control

func updateUI(toolName, kitType):
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
	pass
