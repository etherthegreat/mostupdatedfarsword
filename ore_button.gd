extends Button


class_name OreButton

var oreName: String


func _pressed() -> void:
	emitOreChangeSignal()
	pass

signal giveOreName

func emitOreChangeSignal():
	emit_signal("giveOreName", oreName)
	pass
