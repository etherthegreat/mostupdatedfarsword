extends Control

class_name EventButton

var eventButtonID: String

var eventButtonType: String

signal EventButtonPressed
signal tileSignalPressed

var eventTile: Tile

func buildSelf(buttonText, buttonID, eventButtonType):
	$EventButton.text = buttonText
	eventButtonID = buttonID
	pass


func buildTileEventButton(buttonText, buttonID, eventTile, eventButtonType):
	
	pass

func _on_event_button_pressed() -> void:
	
	match eventButtonType:
		"governor":
			print("PIRESTS OF THE CARI")
			emit_signal("EventButtonPressed", eventButtonID)
		"tile":
			emit_signal("tileSignalPressed", eventTile, eventButtonID)
			pass
	pass # Replace with function body.
