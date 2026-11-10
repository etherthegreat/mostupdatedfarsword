extends Control

const EventButtonScene = preload("res://event_button.tscn")

var event_id: String
var event_type: String
var event_country: String
var target_tile: Tile
var event_data: Dictionary
var button_data: Array = []
var player_country = null   # set by createNewEvent so prerequisites can check CountryFlags

# Holds button metadata while scene navigation UI is open
var _pending: Dictionary = {}

# Signals carry next_event_id so scene nav can override it per choice
signal eventButtonPressed(button_id, event_id, event_country, outcome_type, outcome_value, outcome_amount, next_event_id)
signal tileEventButtonPressed(button_id, event_id, event_country, outcome_type, outcome_value, outcome_amount, next_event_id, tile)


func build_from_data(data: Dictionary, tile = null, player = null) -> void:
	target_tile    = tile
	player_country = player
	event_id       = data.get("event_id", "DYNAMIC")
	event_type     = data.get("event_type", "standard")
	event_country  = data.get("country_cid", "GEN")
	event_data     = data
	# Use inline buttons if supplied; otherwise fall back to CSV lookup by event_id
	if data.has("buttons"):
		button_data = data["buttons"]
	else:
		button_data = EventDatabase.get_buttons_for_event(event_id)

	_apply_headline(_substitute(data.get("headline",   "")))
	$EventPanel/EventShortDescriptionLabel.text = _substitute(data.get("short_desc", ""))
	_apply_long_desc(_substitute(data.get("long_desc",  "")))
	_apply_event_image(str(data.get("image_tag", "")))

	_build_buttons()
	_queue_intro()


func build_from_csv(eid: String, tile = null, player = null) -> void:
	event_id       = eid
	target_tile    = tile
	player_country = player
	event_data  = EventDatabase.get_event(eid)
	button_data = EventDatabase.get_buttons_for_event(eid)

	if event_data.is_empty():
		push_warning("eventScene: No event data found for ID: " + eid)
		queue_free()
		return

	event_type    = event_data.get("event_type", "standard")
	event_country = event_data.get("country_cid", "GEN")

	_apply_headline(_substitute(event_data.get("headline", "")))
	$EventPanel/EventShortDescriptionLabel.text = _substitute(event_data.get("short_desc", ""))
	_apply_long_desc(_substitute(event_data.get("long_desc", "")))
	_apply_event_image(str(event_data.get("image_tag", "")))

	_build_buttons()
	_queue_intro()


# ══ ENTRANCE ══════════════════════════════════════════════════════════════════
# The panel settles in softly, then a one-two-three: the writing, the image, the
# choices — each ghosts from transparent to opaque while drifting a few pixels
# up into place. Any click or key during the entrance finishes it instantly.

const INTRO_PANEL := 0.18    # panel fade
const INTRO_START := 0.08    # first beat begins
const INTRO_FADE  := 0.45    # each beat's fade/drift time
const INTRO_GAP   := 0.30    # delay between beats
const INTRO_RISE  := 8.0     # px each beat drifts up as it settles

var _intro_tween: Tween = null
var _intro_pending: bool = false


func _ready() -> void:
	if _intro_pending:
		_start_intro()


func _queue_intro() -> void:
	modulate.a = 0.0                 # no one-frame flash before the tween starts
	if is_inside_tree():
		_start_intro()
	else:
		_intro_pending = true        # world builds before add_child; start in _ready


func _start_intro() -> void:
	_intro_pending = false
	if _intro_tween != null and _intro_tween.is_valid():
		_intro_tween.kill()
	var text_nodes: Array = [
		get_node_or_null("EventPanel/EventNameLabel"),
		get_node_or_null("EventPanel/EventShortDescriptionLabel"),
		get_node_or_null("EventPanel/EventLongDescriptionLabel"),
	]
	var img = get_node_or_null("EventPanel/EventSprite2D")
	var btns = get_node_or_null("EventPanel/eventButtons")

	var t := create_tween().set_parallel(true)
	t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_intro_tween = t
	t.tween_property(self, "modulate:a", 1.0, INTRO_PANEL)
	_ghost_in(t, text_nodes, INTRO_START)                      # one
	_ghost_in(t, [img],      INTRO_START + INTRO_GAP)          # two
	_ghost_in(t, [btns],     INTRO_START + INTRO_GAP * 2.0)    # three
	# Choices go live halfway through their fade, so no accidental early clicks.
	_set_buttons_live(false)
	t.tween_callback(_set_buttons_live.bind(true)).set_delay(INTRO_START + INTRO_GAP * 2.0 + INTRO_FADE * 0.5)
	t.finished.connect(func(): _intro_tween = null)


func _ghost_in(t: Tween, nodes: Array, delay: float) -> void:
	for n in nodes:
		if n == null:
			continue
		var home: Vector2 = n.position
		n.modulate.a = 0.0
		n.position = home + Vector2(0.0, INTRO_RISE)
		t.tween_property(n, "modulate:a", 1.0, INTRO_FADE).set_delay(delay)
		t.tween_property(n, "position", home, INTRO_FADE).set_delay(delay)


func _set_buttons_live(on: bool) -> void:
	var c = get_node_or_null("EventPanel/eventButtons")
	if c == null:
		return
	for child in c.get_children():
		var b = child.get_node_or_null("EventButton")
		if b != null:
			b.mouse_filter = Control.MOUSE_FILTER_STOP if on else Control.MOUSE_FILTER_IGNORE


func _input(event: InputEvent) -> void:
	# Impatient click/key during the entrance: snap everything into place.
	if _intro_tween == null or not _intro_tween.is_valid():
		return
	if (event is InputEventMouseButton or event is InputEventKey) and event.is_pressed():
		_intro_tween.custom_step(10.0)
		get_viewport().set_input_as_handled()


# ══ EVENT ART ═════════════════════════════════════════════════════════════════
# Resolution order:
#   1. the event's image_tag (a PNG, or a FOLDER of PNGs = short sprite sequence)
#   2. data/event_art_map.csv  (event_id -> borrowed art from the assets folder)
#   3. commander events ([COMMANDER_NAME] in the text) -> that commander's portrait
#   4. the Republic's eagle seal, dimmed, as quiet letterhead
# New art dropped in under an event's image_tag always wins over 2-4.

const EVENT_ART_DIR := "res://art assets/AmericanRevolutionArt/EventArt/"
const ART_SEARCH_DIRS := [
	EVENT_ART_DIR,
	"res://art assets/AmericanRevolutionArt/Panel/",
	"res://art assets/finishedAssets/civilians/",
	"res://art assets/finishedAssets/governors/",
]
const ART_MAP_PATH := "res://data/event_art_map.csv"
const ART_FALLBACK := "res://art assets/PresidentialLibrary/eagle_seal_transparent.png"
const ART_FALLBACK_ALPHA := 0.45
const EVENT_ART_FPS := 12.0      # sprite sequences: frames play alphabetically and loop

# Display box for event art: any source resolution is scaled down to fit inside
# this width/height and centered here, so large images never spill over the text
# or the buttons.  Sits in the right-hand column, above the button row.
const IMG_BOX := Vector2(350.0, 400.0)
const IMG_CENTER := Vector2(1095.0, 290.0)

static var _art_map: Dictionary = {}
static var _art_map_loaded: bool = false

var _frames: Array = []
var _frame_i: int = 0
var _frame_t: float = 0.0


func _apply_event_image(tag: String) -> void:
	var spr = get_node_or_null("EventPanel/EventSprite2D")
	if spr == null:
		return
	spr.self_modulate.a = 1.0
	var frames: Array = _resolve_art(tag.strip_edges())
	if frames.is_empty() and ResourceLoader.exists(ART_FALLBACK):
		frames = [load(ART_FALLBACK)]
		spr.self_modulate.a = ART_FALLBACK_ALPHA
	_frames = frames
	_frame_i = 0
	_frame_t = 0.0
	spr.texture = frames[0] if not frames.is_empty() else null
	_fit_event_sprite(spr)


func _resolve_art(tag: String) -> Array:
	if tag != "":
		for nm in [tag, tag.replace(" ", "_"), tag.replace("_", " ")]:
			for dir in ART_SEARCH_DIRS:
				var f: Array = _load_art(dir + nm)
				if not f.is_empty():
					return f
	_ensure_art_map()
	if _art_map.has(event_id):
		var m: Array = _load_art(_art_map[event_id])
		if not m.is_empty():
			return m
	if target_tile != null and target_tile.tileGovernor != null \
			and target_tile.tileGovernor.governorTexture != null:
		var raw: String = str(event_data.get("headline", "")) + str(event_data.get("long_desc", ""))
		if raw.contains("[COMMANDER_NAME]"):
			return [target_tile.tileGovernor.governorTexture]
	return []


# `base` is a res:// path with or without .png. A folder at that path is a sprite sequence.
func _load_art(base: String) -> Array:
	if base.get_extension().to_lower() == "png":
		base = base.get_basename()
	if DirAccess.dir_exists_absolute(base):
		var seq: Array = _load_sequence(base)
		if not seq.is_empty():
			return seq
	for ext in [".png", ".PNG"]:
		if ResourceLoader.exists(base + ext):
			return [load(base + ext)]
	return []


func _load_sequence(dir: String) -> Array:
	var d := DirAccess.open(dir)
	if d == null:
		return []
	var names: Array = []
	for f in d.get_files():
		# Exported builds list "x.png.import"/"x.png.remap" instead of the PNG itself.
		var n: String = f.trim_suffix(".import").trim_suffix(".remap")
		if n.get_extension().to_lower() == "png" and not names.has(n):
			names.append(n)
	names.sort()
	var out: Array = []
	for n in names:
		var p: String = dir.path_join(n)
		if ResourceLoader.exists(p):
			out.append(load(p))
	return out


static func _ensure_art_map() -> void:
	if _art_map_loaded:
		return
	_art_map_loaded = true
	var file := FileAccess.open(ART_MAP_PATH, FileAccess.READ)
	if file == null:
		return
	file.get_csv_line()   # header: event_id,art,note
	while not file.eof_reached():
		var row := file.get_csv_line()
		if row.size() >= 2 and row[0].strip_edges() != "" and row[1].strip_edges() != "":
			var art: String = row[1].strip_edges()
			if not art.begins_with("res://"):
				art = "res://" + art
			_art_map[row[0].strip_edges()] = art
	file.close()


func _process(delta: float) -> void:
	if _frames.size() < 2:
		return
	_frame_t += delta
	var step: float = 1.0 / EVENT_ART_FPS
	if _frame_t >= step:
		_frame_t -= step
		_frame_i = (_frame_i + 1) % _frames.size()
		var spr = get_node_or_null("EventPanel/EventSprite2D")
		if spr != null:
			spr.texture = _frames[_frame_i]


# Scale the sprite so its texture fits within IMG_BOX (preserving aspect) and
# recenter it, regardless of the source image's native resolution.
func _fit_event_sprite(spr) -> void:
	if spr == null or spr.texture == null:
		return
	var tex_size: Vector2 = spr.texture.get_size()
	if tex_size.x <= 0 or tex_size.y <= 0:
		return
	var s: float = min(IMG_BOX.x / tex_size.x, IMG_BOX.y / tex_size.y)
	spr.scale = Vector2(s, s)
	spr.position = IMG_CENTER


# ══ BUTTONS ═══════════════════════════════════════════════════════════════════

func _build_buttons() -> void:
	var btn_container = get_node_or_null("EventPanel/eventButtons")
	if btn_container == null:
		push_error("event_scene: eventButtons node not found!")
		return
	for child in btn_container.get_children():
		child.queue_free()

	for btn_data in button_data:
		var prereq = btn_data.get("prerequisite_flag", "")
		if prereq != "" and not _check_prerequisite(prereq):
			continue

		var btype: String = btn_data.get("button_type", "standard")
		if btype == "explicit"    and not Settings.content_explicit:
			continue
		if btype == "kinky_lewd"  and not Settings.content_kinky_lewd:
			continue
		if btype == "sensual"     and not Settings.content_sensual:
			continue

		var shown: Dictionary = btn_data.duplicate()
		shown["button_text"] = _substitute(str(btn_data.get("button_text", "Choose")))   # [TILE_NAME] etc. on buttons too
		var btn_node = EventButtonScene.instantiate()
		btn_node.setup(shown)
		btn_node.button_chosen.connect(_on_event_button_chosen)
		btn_container.add_child(btn_node)


func _on_event_button_chosen(btn_data: Dictionary) -> void:
	var btype: String = btn_data.get("button_type", "standard")
	_pending = {
		"button_id":      btn_data.get("button_id", ""),
		"button_type":    btype,
		"outcome_type":   btn_data.get("outcome_type", ""),
		"outcome_value":  btn_data.get("outcome_value", ""),
		"outcome_amount": btn_data.get("outcome_amount", 0),
		"next_event_id":  btn_data.get("next_event_id", ""),
	}
	if btype in ["explicit", "kinky_lewd", "sensual"]:
		_show_scene_nav()
	else:
		_emit_resolved(_pending["next_event_id"])


func _show_scene_nav() -> void:
	var nav: Control = load("res://scene_navigation.gd").new()
	var s = get_node_or_null("/root/Settings")
	nav.streaming_mode = s != null and s.streaming_mode
	nav.scene_choice_made.connect(_on_scene_choice)
	add_child(nav)


func _on_scene_choice(choice: String) -> void:
	var next_id: String = _pending.get("next_event_id", "")
	match choice:
		"intimate":
			var iid := event_id + "_INTIMATE"
			next_id = iid if not EventDatabase.get_event(iid).is_empty() else ""
		"skip":
			next_id = ""
		# "full": keep original next_event_id unchanged

	if get_node_or_null("/root/LibraryData") != null:
		LibraryData.record_scene(event_id, choice, 0)

	_emit_resolved(next_id)


func _emit_resolved(next_id: String) -> void:
	if target_tile != null:
		tileEventButtonPressed.emit(
			_pending["button_id"], event_id, event_country,
			_pending["outcome_type"], _pending["outcome_value"],
			_pending["outcome_amount"], next_id, target_tile)
	else:
		eventButtonPressed.emit(
			_pending["button_id"], event_id, event_country,
			_pending["outcome_type"], _pending["outcome_value"],
			_pending["outcome_amount"], next_id)
	queue_free()


func _check_prerequisite(prereq: String) -> bool:
	if player_country == null:
		return true
	if prereq.begins_with("!"):
		return not player_country.CountryFlags.has(prereq.substr(1))
	return player_country.CountryFlags.has(prereq)


# Shrink the headline so long titles fit on one line within the label instead of
# spilling across the panel and over the short-description text.
func _apply_headline(title: String) -> void:
	var lbl: Label = $EventPanel/EventNameLabel
	lbl.text = title
	lbl.clip_text = true                          # hard stop — never overflow the panel
	lbl.autowrap_mode = TextServer.AUTOWRAP_OFF   # keep it a single line; shrink instead of wrap
	var n := title.length()
	var fs := 46
	if n > 52: fs = 24
	elif n > 44: fs = 28
	elif n > 36: fs = 33
	elif n > 28: fs = 39
	lbl.add_theme_font_size_override("font_size", fs)


# Thresholds sized for the body box that ends above the button row + reward strip.
func _apply_long_desc(body: String) -> void:
	var lbl: Label = $EventPanel/EventLongDescriptionLabel
	lbl.text = body
	var n := body.length()
	var fs := 31
	if n > 1580: fs = 12
	elif n > 1140: fs = 15
	elif n > 790: fs = 19
	elif n > 440: fs = 24
	lbl.add_theme_font_size_override("font_size", fs)
	if n > 440:
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	else:
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER


func _substitute(text: String) -> String:
	text = text.replace("[P]", "\n\n")
	if target_tile != null:
		var tile_name: String = target_tile.tileName if target_tile.tileName else "the Fort"
		text = text.replace("[TILE_NAME]", tile_name)
		var cmd_name: String = "the Commander"
		if target_tile.tileGovernor != null:
			cmd_name = target_tile.tileGovernor.governorType
		text = text.replace("[COMMANDER_NAME]", cmd_name)
		# [GOVERNOR_TITLE]: General at lvl 3; Governor if courthouse present; else Commander
		var gov_title: String = "Commander"
		if target_tile.tileGovernor != null:
			if target_tile.tileGovernor.governorLevel >= 3:
				gov_title = "General"
			else:
				for b in target_tile.tileBuildingsList:
					if b.buildingType == "Courthouse" and b.enabled:
						gov_title = "Governor"
						break
		text = text.replace("[GOVERNOR_TITLE]", gov_title)
		# Pronoun tokens — fall back to they/them/their/themselves if no pronouns set
		var p: Dictionary = {}
		if target_tile.tileGovernor != null:
			p = target_tile.tileGovernor.pronouns
		text = text.replace("[CMD_SUBJECT]",    p.get("subject",    "they"))
		text = text.replace("[CMD_OBJECT]",     p.get("object",     "them"))
		text = text.replace("[CMD_POSSESSIVE]", p.get("possessive", "their"))
		text = text.replace("[CMD_REFLEXIVE]",  p.get("reflexive",  "themselves"))
	# Safety sweep: replace any tokens that survived (tile was null, governor missing, etc.)
	text = text.replace("[TILE_NAME]",      "the front")
	text = text.replace("[COMMANDER_NAME]", "the Commander")
	text = text.replace("[GOVERNOR_TITLE]", "Commander")
	text = text.replace("[CMD_SUBJECT]",    "they")
	text = text.replace("[CMD_OBJECT]",     "them")
	text = text.replace("[CMD_POSSESSIVE]", "their")
	text = text.replace("[CMD_REFLEXIVE]",  "themselves")
	return text


# ── LEGACY WRAPPERS ──────────────────────────────────────────────────────────
# Keep old-style callers working during transition

func buildSelf(eventType: String, eventID: String,
		eventCountry: String, _language: String) -> void:
	build_from_csv(eventID)

func buildTileEventSelf(eventType: String, eventID: String,
		eventCountry: String, tile: Tile, _language: String) -> void:
	build_from_csv(eventID, tile)
