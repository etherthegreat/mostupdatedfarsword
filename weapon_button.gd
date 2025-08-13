extends Button


class_name WeaponButton

var weaponName: String


func _pressed() -> void:
	emitWeaponChangeSignal()
	pass

signal giveWeaponName

func emitWeaponChangeSignal():
	emit_signal("giveWeaponName", weaponName)
	pass
