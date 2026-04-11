extends Control


class_name WeaponButton

var weaponName: String



signal giveWeaponName

func emitWeaponChangeSignal():
	emit_signal("giveWeaponName", weaponName)
	pass



func _on_button_pressed() -> void:
	emitWeaponChangeSignal()
	pass # Replace with function body.
