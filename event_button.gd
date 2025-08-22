extends Control

class_name EventButton

var eventButtonID: String

var eventButtonType: String

signal EventButtonPressed
signal tileSignalPressed

var eventTile: Tile

func buildSelf(buttonText, buttonID, buttonType):
	eventButtonType = buttonType
	$EventButton.text = buttonText
	eventButtonID = buttonID
	pass


func buildTileEventButton(buttonText, buttonID, tile, buttonType):
	$EventButton.text = buttonText
	eventButtonID = buttonID
	eventTile = tile
	eventButtonType = buttonType
	pass

func _on_event_button_pressed() -> void:
	
	match eventButtonType:
		"governor":
			print("PIRESTS OF THE CARI")
			emit_signal("EventButtonPressed", eventButtonID)
		"spell":
			emit_signal("EventButtonPressed", eventButtonID)
		"tile":
			emit_signal("tileSignalPressed", eventTile, eventButtonID)
			print("gangnam style")
			pass
	pass # Replace with function body.
