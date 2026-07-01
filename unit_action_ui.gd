extends Control
# Code-built per-unit action control for the bottom-left APF panel.
# Placeholder layout (position/sizes rough) — restyle in the panel redo.

var _unit = null
var _buttons: Dictionary = {}
var _weapon_icon: TextureRect
var _info: Label

func setup(unit) -> void:
	_unit = unit
	if get_child_count() == 0:
		_build()
	refresh()

func _build() -> void:
	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 4)
	add_child(vb)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	vb.add_child(top)
	_weapon_icon = TextureRect.new()
	_weapon_icon.custom_minimum_size = Vector2(46, 46)
	_weapon_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_weapon_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	top.add_child(_weapon_icon)
	_info = Label.new()
	_info.add_theme_font_size_override("font_size", 12)
	_info.add_theme_color_override("font_color", Color(1, 1, 1))
	top.add_child(_info)
	var brow := HBoxContainer.new()
	brow.add_theme_constant_override("separation", 4)
	vb.add_child(brow)
	for act in ["fire", "charge", "hold"]:
		var b := Button.new()
		b.text = act.capitalize()
		b.custom_minimum_size = Vector2(56, 24)
		b.pressed.connect(_on_action.bind(act))
		brow.add_child(b)
		_buttons[act] = b

func refresh() -> void:
	if _unit == null:
		return
	var w = _unit.unitWeapon
	if w != null and w.weaponImage != null:
		_weapon_icon.texture = w.weaponImage
	var wclass: String = w.weaponClass if w != null else ""
	var reload_txt := "melee"
	if w != null and w.reloadTurns > 0:
		reload_txt = "RELOADING" if _unit.is_reloading() else "FIRE READY"
	_info.text = "%s   %d/%d MP\n%d/%d AP   %s" % [wclass, _unit.unitCurrentManpower, _unit.unitMaxManpower, _unit.unitCurrentAP, _unit.get_max_ap(), reload_txt]
	var allow := _allowed_actions(wclass)
	for act in _buttons:
		var b: Button = _buttons[act]
		b.visible = act in allow
		var no_ap: bool = _unit.unitCurrentAP <= 0 and act != "hold"
		var no_power: bool = (act == "fire" and _unit.unitRangedOffence <= 0) or (act == "charge" and _unit.unitOffensiveScore <= 0)
		b.disabled = no_ap or no_power
		b.modulate = Color(1, 1, 0.35) if _unit.unitStance == act else Color(1, 1, 1)

func _allowed_actions(wclass: String) -> Array:
	match wclass:
		"Musket": return ["fire", "charge", "hold"]
		"Artillery": return ["fire", "hold"]
		"Saber": return ["charge"]
		"Legacy": return ["charge", "hold"]
		"Mythic": return ["fire", "charge", "hold"]
		_: return ["fire", "hold"]

func _on_action(act: String) -> void:
	if _unit != null:
		_unit.unitStance = act
		refresh()
