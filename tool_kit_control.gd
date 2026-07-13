extends Control

class_name toolKitButton

var ToolTrue: bool

var ToolType: String


signal toolSelected
signal kitSelected

func buildSelf(toolBool, toolType, kitImage):
	ToolTrue = toolBool
	if ToolTrue == true:
		$ToolKitButton.size.x = 68
		$ToolKitButton.size.y = 68
	else:
		$ToolKitButton.size.x = 77.2
		$ToolKitButton.size.y = 41.5
	ToolType = toolType
	$ToolKitButton.icon = kitImage


func _on_tool_kit_button_pressed() -> void:
	if ToolTrue == true:
		emit_signal("toolSelected", ToolType)
	else:
		emit_signal("kitSelected", ToolType)
