extends Control
# Studio splash — fades in the Ether & Sister Spacedesk signatures, then loads the main menu.

const MAIN_MENU := "res://Menu Scenes and Scripts/main_menu.tscn"
const ETHER  := "res://art assets/AmericanRevolutionArt/sisterspacedesklanding/etherspacedesksignature.png"
const SISTER := "res://art assets/AmericanRevolutionArt/sisterspacedesklanding/sisterspacedesksignature.png"

var _done := false

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var content := Control.new()
	content.set_anchors_preset(Control.PRESET_FULL_RECT)
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.modulate = Color(1, 1, 1, 0)
	add_child(content)

	var vp := get_viewport_rect().size

	var lbl := Label.new()
	lbl.text = "A game by"
	lbl.add_theme_font_size_override("font_size", 44)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.size = Vector2(vp.x, 60)
	lbl.position = Vector2(0, vp.y * 0.18)
	content.add_child(lbl)

	_add_logo(content, ETHER,  vp, vp.y * 0.30)
	_add_logo(content, SISTER, vp, vp.y * 0.56)

	var tw := create_tween()
	tw.tween_property(content, "modulate:a", 1.0, 1.2)
	tw.tween_interval(1.7)
	tw.tween_property(content, "modulate:a", 0.0, 1.0)
	tw.tween_callback(_go_to_menu)

func _add_logo(parent: Control, path: String, vp: Vector2, y: float) -> void:
	if not ResourceLoader.exists(path):
		return
	var tex := TextureRect.new()
	tex.texture = load(path)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var w: float = 900.0
	tex.size = Vector2(w, 220)
	tex.position = Vector2((vp.x - w) / 2.0, y)
	parent.add_child(tex)

func _go_to_menu() -> void:
	if _done:
		return
	_done = true
	get_tree().change_scene_to_file(MAIN_MENU)

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventKey and event.pressed):
		_go_to_menu()
