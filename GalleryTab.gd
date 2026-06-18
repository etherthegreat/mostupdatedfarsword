extends Control
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# GalleryTab (Control)
# ├── ScrollContainer
# │   └── GalleryGrid (GridContainer, columns=4,
# │                    theme_override_constants/h_separation=8,
# │                    theme_override_constants/v_separation=8)
# └── Lightbox (Control, full-screen overlay, hidden by default)
#     ├── DarkBG          (ColorRect, full screen, rgba 0,0,0,0.9)
#     ├── FullArtRect     (TextureRect, large centered, expand_mode=fit)
#     ├── LightboxTitle   (Label, bold, bottom center)
#     ├── LightboxFlavor  (Label, italic, smaller, below title)
#     ├── PrevButton      (Button, "<", left side)
#     ├── NextButton      (Button, ">", right side)
#     └── CloseButton     (Button, "✕", top-right)
# ============================================================

const GALLERY_CATALOG := [
	# ── WHITE HOUSE SECRETS (sensual / explicit) ───────────────────────────
	{
		"event_id": "WH_SECRET_01",
		"title":    "The New Year, Privately",
		"hint":     "Ualani must be in Washington DC when the new year turns",
		"art_path": "",   # TODO: set art path when asset is ready
		"flavor":   "No ceremony. No camera. No country to perform for.",
	},
	{
		"event_id": "WH_SECRET_07",
		"title":    "Independence Day — Hers",
		"hint":     "Ualani must be in Washington DC on the Fourth of July",
		"art_path": "",
		"flavor":   "The founding documents were written by people who did not mean her. She means them anyway.",
	},
	{
		"event_id": "WH_SECRET_10",
		"title":    "A Letter from Jessica",
		"hint":     "Reach the Alliance stage with Canada (Ualani in Washington DC)",
		"art_path": "",
		"flavor":   "Not a diplomatic dispatch. A personal one.",
	},
	{
		"event_id": "WH_SECRET_12",
		"title":    "Christmas in Washington",
		"hint":     "Ualani must be in Washington DC in winter",
		"art_path": "",
		"flavor":   "She is from Hawaii. This is not Christmas as she knows it.",
	},
	# ── UALANI PERSONAL EVENTS (sensual — Full option) ─────────────────────
	{
		"event_id": "UALANI_AMBUSH_01",
		"title":    "The Counteroffensive Briefing",
		"hint":     "Hold a tile against a Crown ambush with Ualani present",
		"art_path": "",
		"flavor":   "Ualani was already there. The Crown did not know that.",
	},
	{
		"event_id": "UALANI_DIGNITARY_01",
		"title":    "The Full Presidential Reception",
		"hint":     "Host a diplomatic reception at a liberated courthouse tile",
		"art_path": "",
		"flavor":   "The courthouse has never looked this good.",
	},
	{
		"event_id": "UALANI_MEMORIAL_01",
		"title":    "The Presidential Address",
		"hint":     "Visit a memorial tile with Ualani",
		"art_path": "",
		"flavor":   "The ground has history. The President has remarks.",
	},
	{
		"event_id": "UALANI_WOUNDED_01",
		"title":    "The Field Hospital Visit",
		"hint":     "Ualani visits a field hospital after a battle",
		"art_path": "",
		"flavor":   "She knew their names. That is not an expression.",
	},
	{
		"event_id": "UALANI_WINTER_01",
		"title":    "The Winter March",
		"hint":     "March an army through a cold terrain tile in winter",
		"art_path": "",
		"flavor":   "Washington did it once. The precedent is established.",
	},
	{
		"event_id": "UALANI_FORGE_01",
		"title":    "The Surprise Inspection",
		"hint":     "Own a Level 2+ Forge with a garrison present",
		"art_path": "",
		"flavor":   "Production numbers were good. The President made them better.",
	},
	{
		"event_id": "UALANI_CULPER_01",
		"title":    "The Culper Meeting",
		"hint":     "Activate the Culper Ring intelligence network",
		"art_path": "",
		"flavor":   "The message arrived with no signature. She knew who sent it.",
	},
	{
		"event_id": "UALANI_CULPER_BRIEF_01",
		"title":    "Intelligence Confirmed",
		"hint":     "Receive a confirmed intelligence brief from the Culper Ring",
		"art_path": "",
		"flavor":   "The asset delivered. The map is different now.",
	},
	{
		"event_id": "UALANI_ALLIANCE_01",
		"title":    "The Alliance Council",
		"hint":     "Meet with a Commander who holds two or more objectives",
		"art_path": "",
		"flavor":   "An alliance was discussed. The discussion went well.",
	},
	{
		"event_id": "UALANI_FRONTIER_01",
		"title":    "The Frontier Walk",
		"hint":     "Establish presence at a border tile adjacent to Canada",
		"art_path": "",
		"flavor":   "The northern edge of the Republic. She walked it.",
	},
	# ── COMMANDER THANKS (explicit) ────────────────────────────────────────
	{
		"event_id": "CMD_THANKS",
		"title":    "A Personal Presidential Visit",
		"hint":     "A Commander completes their full arc at maximum loyalty",
		"art_path": "",
		"flavor":   "The President doesn't visit everyone. She visited them.",
	},
	# ── PROTECTOR ARCS (kinky) ─────────────────────────────────────────────
	{
		"event_id": "PROT_01_SUMMON",
		"title":    "Mothman Approaches",
		"hint":     "Begin the Mothman protector arc (Harper's Ferry region)",
		"art_path": "",
		"flavor":   "A presence in the dark.",
	},
	{
		"event_id": "PROT_01_AGREE",
		"title":    "The Harper's Ferry Accord",
		"hint":     "Complete the Mothman protector arc and accept the alliance",
		"art_path": "",
		"flavor":   "The agreement required no words. The words came anyway.",
	},

]

var _tile_scene = preload("res://GalleryTile.tscn")
var _unlocked_list: Array = []   # filtered to only unlocked entries, for lightbox cycling
var _lightbox_index: int  = 0

func _ready() -> void:
	buildSelf()

func buildSelf() -> void:
	var grid = get_node_or_null("ScrollContainer/GalleryGrid")
	if not grid:
		return

	# clear old tiles
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	_unlocked_list.clear()

	for entry in GALLERY_CATALOG:
		var eid      := entry.get("event_id", "")
		var unlocked := LibraryData.is_gallery_unlocked(eid)

		var art: Texture2D = null
		if unlocked:
			var art_path := entry.get("art_path", "")
			if art_path != "" and ResourceLoader.exists(art_path):
				art = load(art_path)
			_unlocked_list.append(entry)

		var tile = _tile_scene.instantiate()
		tile.buildSelf(eid, entry.get("title", "???"), entry.get("hint", ""),
				art, unlocked)
		tile.tile_clicked.connect(_on_tile_clicked)
		grid.add_child(tile)

func _on_tile_clicked(event_id: String) -> void:
	for i in range(_unlocked_list.size()):
		if _unlocked_list[i]["event_id"] == event_id:
			_lightbox_index = i
			break
	_show_lightbox()

func _show_lightbox() -> void:
	var lb = get_node_or_null("Lightbox")
	if not lb:
		return
	lb.visible = true
	_update_lightbox()

func _update_lightbox() -> void:
	if _unlocked_list.is_empty():
		return
	var entry     := _unlocked_list[_lightbox_index]
	var art_rect   = get_node_or_null("Lightbox/FullArtRect")
	var title_lbl  = get_node_or_null("Lightbox/LightboxTitle")
	var flavor_lbl = get_node_or_null("Lightbox/LightboxFlavor")
	var prev_btn   = get_node_or_null("Lightbox/PrevButton")
	var next_btn   = get_node_or_null("Lightbox/NextButton")

	if art_rect:
		var art_path := entry.get("art_path", "")
		if art_path != "" and ResourceLoader.exists(art_path):
			art_rect.texture = load(art_path)
	if title_lbl:
		title_lbl.text = entry.get("title", "")
	if flavor_lbl:
		flavor_lbl.text = entry.get("flavor", "")
	if prev_btn:
		prev_btn.visible = _unlocked_list.size() > 1
	if next_btn:
		next_btn.visible = _unlocked_list.size() > 1

func _on_prev_button_pressed() -> void:
	_lightbox_index = (_lightbox_index - 1 + _unlocked_list.size()) % _unlocked_list.size()
	_update_lightbox()

func _on_next_button_pressed() -> void:
	_lightbox_index = (_lightbox_index + 1) % _unlocked_list.size()
	_update_lightbox()

func _on_close_button_pressed() -> void:
	var lb = get_node_or_null("Lightbox")
	if lb:
		lb.visible = false
