extends Control


class_name WeaponButton

var weaponName: String




signal giveWeaponName

func emitWeaponChangeSignal():
	emit_signal("giveWeaponName", weaponName)
func buildSelf(type, icon):
	$Button.icon = icon
	weaponName = type


func _on_button_pressed() -> void:
	emitWeaponChangeSignal()
