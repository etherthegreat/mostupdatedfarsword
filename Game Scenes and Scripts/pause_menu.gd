extends Control
# Code-built in-game pause menu (no .tscn needed).
# process_mode ALWAYS so it runs while get_tree().paused is true.

var _world: Node = null
var _settings_panel: Control = null
var _toast: Label = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	_build()

func setup(world_node: Node, settings_panel: Control) -> void:
	_world = world_node
	_settings_panel = settings_panel

func _build() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.72)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 14)
	vb.custom_minimum_size = Vector2(360, 0)
	center.add_child(vb)

	var title := Label.new()
	title.text = "PAUSED"
	title.add_theme_font_size_override("font_size", 44)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vb.add_child(title)

	_add_button(vb, "Resume", _on_resume)
	_add_button(vb, "Settings", _on_settings)
	_add_button(vb, "Save Game", _on_save)
	_add_button(vb, "Quit to Main Menu", _on_quit_menu)
	_add_button(vb, "Quit to Desktop", _on_quit_desktop)

	_toast = Label.new()
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.modulate = Color(0.6, 1.0, 0.6)
	_toast.visible = false
	vb.add_child(_toast)

func _add_button(parent: Node, text: String, cb: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0, 46)
	b.pressed.connect(cb)
	parent.add_child(b)

func open() -> void:
	visible = true
	get_tree().paused = true

func close() -> void:
	get_tree().paused = false
	visible = false

func toggle() -> void:
	if visible:
		close()
	else:
		open()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _settings_panel and _settings_panel.visible:
			_settings_panel.visible = false
			get_viewport().set_input_as_handled()
			return
		toggle()
		get_viewport().set_input_as_handled()

func _on_resume() -> void:
	close()

func _on_settings() -> void:
	if _settings_panel and _settings_panel.has_method("open"):
		_settings_panel.open()
	elif _settings_panel:
		_settings_panel.visible = true

func _on_save() -> void:
	var ok := false
	if _world and _world.has_method("save_from_pause_menu"):
		ok = _world.save_from_pause_menu()
	_show_toast("Game saved." if ok else "Save unavailable.")

func _on_quit_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu Scenes and Scripts/main_menu.tscn")

func _on_quit_desktop() -> void:
	get_tree().quit()

func _show_toast(msg: String) -> void:
	if _toast:
		_toast.text = msg
		_toast.visible = true
