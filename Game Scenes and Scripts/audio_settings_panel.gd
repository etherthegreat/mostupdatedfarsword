extends Control
# Code-built AUDIO settings overlay (no .tscn needed).
# Instanced and named "SettingsPanel" so main_menu's existing
# _on_settings_button_pressed() finds it; also reused by the pause menu.

const ROWS := [
	{"label": "Master",   "bus": "Master",  "key": "master_volume",  "def": 80},
	{"label": "Music",    "bus": "Music",   "key": "music_volume",   "def": 70},
	{"label": "Sound FX", "bus": "SFX",     "key": "sfx_volume",     "def": 90},
	{"label": "Ambient",  "bus": "Ambient", "key": "ambient_volume", "def": 60},
]

var _sliders: Dictionary = {}
var _value_labels: Dictionary = {}

signal closed

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build()

func _build() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.8)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(540, 0)
	center.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 32)
	margin.add_theme_constant_override("margin_right", 32)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_bottom", 28)
	panel.add_child(margin)

	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 18)
	margin.add_child(vb)

	var title := Label.new()
	title.text = "AUDIO"
	title.add_theme_font_size_override("font_size", 34)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vb.add_child(title)

	for row in ROWS:
		var hb := HBoxContainer.new()
		hb.add_theme_constant_override("separation", 14)

		var lbl := Label.new()
		lbl.text = str(row["label"])
		lbl.custom_minimum_size = Vector2(130, 0)
		hb.add_child(lbl)

		var sl := HSlider.new()
		sl.min_value = 0
		sl.max_value = 100
		sl.step = 1
		sl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sl.custom_minimum_size = Vector2(260, 0)
		hb.add_child(sl)

		var vlbl := Label.new()
		vlbl.custom_minimum_size = Vector2(46, 0)
		vlbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		hb.add_child(vlbl)

		sl.value_changed.connect(_on_changed.bind(str(row["bus"]), str(row["key"]), vlbl))
		_sliders[row["key"]] = sl
		_value_labels[row["key"]] = vlbl
		vb.add_child(hb)

	var close := Button.new()
	close.text = "CLOSE"
	close.custom_minimum_size = Vector2(0, 42)
	close.pressed.connect(_on_close)
	vb.add_child(close)

func _on_changed(value: float, bus: String, key: String, vlbl: Label) -> void:
	var v := int(value)
	if vlbl:
		vlbl.text = str(v)
	LibraryData.set_setting(key, v)
	AudioManager.set_bus_volume_pct(bus, float(v))

func populate_from_settings() -> void:
	for row in ROWS:
		var key: String = str(row["key"])
		var v: int = int(LibraryData.get_setting(key, row["def"]))
		if _sliders.has(key):
			_sliders[key].set_value_no_signal(v)
		if _value_labels.has(key):
			_value_labels[key].text = str(v)

func open() -> void:
	visible = true
	populate_from_settings()

func _on_close() -> void:
	visible = false
	closed.emit()
