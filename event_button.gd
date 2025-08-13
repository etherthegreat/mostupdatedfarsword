extends Control

class_name EventButton

var eventButtonID: String

signal EventButtonPressed

func buildSelf(buttonText, buttonID):
	$EventButton.text = buttonText
	eventButtonID = buttonID
	pass


func _on_event_button_pressed() -> void:
	
	print("PIRESTS OF THE CARI")
	emit_signal("EventButtonPressed", eventButtonID)
	
	pass # Replace with function body.
