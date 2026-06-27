extends Control
# ============================================================
# GalleryTab - unlockable scene gallery (catalog auto-built from EventArt).
# One tile per scene, grouped. NSFW scenes are hidden when streaming_mode is ON.
# ============================================================

const PREVIEW_UNLOCK_ALL := true  # TEMP: reveal all art for review; set false to gate by real gameplay unlocks.

const _GROUP_ORDER = ["White House Secrets", "Protectors", "Canada", "Governor"]

const GALLERY_CATALOG = [
	{"event_id": "AGENT_355", "group": "Protectors", "title": "Agent 355 - Agree", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/agent_355.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "AGENT_355_INTIMATE", "group": "Protectors", "title": "Agent 355 - Agree (Intimate)", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/agent_355_intimate.png", "nsfw": true, "hint": "", "flavor": ""},
	{"event_id": "AGENT_355_SUMMON", "group": "Protectors", "title": "Agent 355 - Summon", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/agent_355_summon.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "AGENT_355_TAME", "group": "Protectors", "title": "Agent 355 - Tame", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/agent_355_tame.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "BELL_WITCH", "group": "Protectors", "title": "Bell Witch - Agree", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/bell_witch.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "BELL_WITCH_INTIMATE", "group": "Protectors", "title": "Bell Witch - Agree (Intimate)", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/bell_witch_intimate.png", "nsfw": true, "hint": "", "flavor": ""},
	{"event_id": "BELL_WITCH_SUMMON", "group": "Protectors", "title": "Bell Witch - Summon", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/bell_witch_summon.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "BELL_WITCH_TAME", "group": "Protectors", "title": "Bell Witch - Tame", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/bell_witch_tame.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "CA_PM_BATTLEFIELD_SCENE", "group": "Canada", "title": "Battlefield", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/ca_pm_battlefield_scene.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "CA_PM_LEGACY_SCENE", "group": "Canada", "title": "Legacy", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/ca_pm_legacy_scene.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "CAN_ALLIANCE_SIGNED_INTIMATE", "group": "Canada", "title": "Alliance Signed Intimate", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/can_alliance_signed_intimate.png", "nsfw": true, "hint": "", "flavor": ""},
	{"event_id": "CAN_ALLIANCE_SIGNED_SCENE", "group": "Canada", "title": "Alliance Signed", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/can_alliance_signed_scene.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "GOATMAN", "group": "Protectors", "title": "Goatman - Agree", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/goatman.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "GOATMAN_INTIMATE", "group": "Protectors", "title": "Goatman - Agree (Intimate)", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/goatman_intimate.png", "nsfw": true, "hint": "", "flavor": ""},
	{"event_id": "GOATMAN_SUMMON", "group": "Protectors", "title": "Goatman - Summon", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/goatman_summon.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "GOATMAN_TAME", "group": "Protectors", "title": "Goatman - Tame", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/goatman_tame.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "GOV_LVL3_CEREMONY_SCENE", "group": "Governor", "title": "Lvl3 Ceremony", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/gov_lvl3_ceremony_scene.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "GOV_REWARD_SCENE", "group": "Governor", "title": "Reward", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/gov_reward_scene.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "JERSEY_DEVIL_AGREE_NSFW", "group": "Protectors", "title": "Jersey Devil - Agree (Intimate)", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/jersey devil agree nsfw.png", "nsfw": true, "hint": "", "flavor": ""},
	{"event_id": "JERSEY_DEVIL_AGREE_SFW", "group": "Protectors", "title": "Jersey Devil - Agree", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/jersey devil agree sfw.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "JERSEY_DEVIL_TAME", "group": "Protectors", "title": "Jersey Devil - Tame", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/jersey devil tame.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "JERSEY_DEVIL_SUMMON", "group": "Protectors", "title": "Jersey Devil - Summon", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/jersey_devil_summon.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "LINCOLN_GHOST_AGREE_NSFW", "group": "Protectors", "title": "Lincoln's Ghost - Agree (Intimate)", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/lincoln ghost agree nsfw.png", "nsfw": true, "hint": "", "flavor": ""},
	{"event_id": "LINCOLN_GHOST_AGREE_SFW", "group": "Protectors", "title": "Lincoln's Ghost - Agree", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/lincoln ghost agree sfw.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "LINCOLN_GHOST_TAME", "group": "Protectors", "title": "Lincoln's Ghost - Tame", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/lincoln ghost tame.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "LINCOLNS_GHOSTSUMMON", "group": "Protectors", "title": "Lincoln's Ghost - Summon", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/lincolns_ghostSummon.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "MOTHMAN_AGREE_SFW", "group": "Protectors", "title": "Mothman - Agree", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/mothman agree sfw.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "MOTHMAN_SUMMON", "group": "Protectors", "title": "Mothman - Summon", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/mothman_summon.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "MOTHMANTAME_SCENE", "group": "Protectors", "title": "Mothman - Tame", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/mothmantame_scene.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "OLD_IRONSIDES_AGREE_NSFW", "group": "Protectors", "title": "Old Ironsides - Agree (Intimate)", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/old ironsides agree nsfw.png", "nsfw": true, "hint": "", "flavor": ""},
	{"event_id": "OLD_IRONSIDES_AGREE_SFW", "group": "Protectors", "title": "Old Ironsides - Agree", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/old ironsides agree sfw.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "OLD_IRONSIDES_TAME", "group": "Protectors", "title": "Old Ironsides - Tame", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/old ironsides tame.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "OLD_IRONSIDESSUMMON", "group": "Protectors", "title": "Old Ironsides - Summon", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/old_ironsidesSummon.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "PENOIT_SOLIDARITY", "group": "Protectors", "title": "Penoit - Agree", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/penoit_solidarity.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "WH_SECRET_JUNETEENTH", "group": "White House Secrets", "title": "Juneteenth", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/wh_secret_Juneteenth.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "WH_SECRET_CHERRY_BLOSSOMS", "group": "White House Secrets", "title": "Cherry Blossoms", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/wh_secret_cherry blossoms.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "WH_SECRET_CHRISTMAS", "group": "White House Secrets", "title": "Christmas", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/wh_secret_christmas.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "WH_SECRET_HALLOWEEN", "group": "White House Secrets", "title": "Halloween", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/wh_secret_halloween.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "WH_SECRET_INDEPENDENCEDAY", "group": "White House Secrets", "title": "Independenceday", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/wh_secret_independenceday.png", "nsfw": false, "hint": "", "flavor": ""},
	{"event_id": "WH_SECRET_PRIDE", "group": "White House Secrets", "title": "Pride", "art_path": "res://art assets/AmericanRevolutionArt/EventArt/wh_secret_pride.png", "nsfw": false, "hint": "", "flavor": ""},
]

var _tile_scene = load("res://GalleryTile.tscn")
var _visible_unlocked: Array = []
var _lightbox_index: int = 0

func _ready() -> void:
	var lb = get_node_or_null("Lightbox")
	if lb:
		lb.visible = false
	var prev = get_node_or_null("Lightbox/PrevButton")
	if prev:
		prev.pressed.connect(_on_prev_button_pressed)
	var nxt = get_node_or_null("Lightbox/NextButton")
	if nxt:
		nxt.pressed.connect(_on_next_button_pressed)
	var close = get_node_or_null("Lightbox/CloseButton")
	if close:
		close.pressed.connect(_on_close_button_pressed)
	buildSelf()

func _streaming() -> bool:
	if has_node("/root/LibraryData"):
		return bool(LibraryData.get_setting("streaming_mode", false))
	return false

func buildSelf() -> void:
	var root = get_node_or_null("ScrollContainer/GalleryRoot")
	if not root:
		return
	for child in root.get_children():
		root.remove_child(child)
		child.queue_free()
	_visible_unlocked.clear()
	var streaming := _streaming()
	for group_name in _GROUP_ORDER:
		var group_entries: Array = []
		for entry in GALLERY_CATALOG:
			if str(entry.get("group", "")) != group_name:
				continue
			if streaming and bool(entry.get("nsfw", false)):
				continue
			group_entries.append(entry)
		if group_entries.is_empty():
			continue
		var header := Label.new()
		header.text = group_name
		header.add_theme_font_size_override("font_size", 18)
		header.add_theme_color_override("font_color", Color(0.85, 0.65, 0.15))
		root.add_child(header)
		var grid := GridContainer.new()
		grid.columns = 4
		grid.add_theme_constant_override("h_separation", 10)
		grid.add_theme_constant_override("v_separation", 10)
		root.add_child(grid)
		for entry in group_entries:
			var eid: String = str(entry.get("event_id", ""))
			var unlocked: bool = PREVIEW_UNLOCK_ALL or _is_unlocked(eid)
			var art: Texture2D = null
			if unlocked:
				var ap: String = str(entry.get("art_path", ""))
				if ap != "" and ResourceLoader.exists(ap):
					art = load(ap)
				_visible_unlocked.append(entry)
			var tile = _tile_scene.instantiate()
			tile.buildSelf(eid, str(entry.get("title", "???")), str(entry.get("hint", "")), art, unlocked)
			tile.tile_clicked.connect(_on_tile_clicked)
			grid.add_child(tile)

func _is_unlocked(event_id: String) -> bool:
	if has_node("/root/LibraryData"):
		return LibraryData.is_gallery_unlocked(event_id)
	return false

func _on_tile_clicked(event_id: String) -> void:
	for i in range(_visible_unlocked.size()):
		if str(_visible_unlocked[i].get("event_id", "")) == event_id:
			_lightbox_index = i
			break
	_show_lightbox()

func _show_lightbox() -> void:
	var lb = get_node_or_null("Lightbox")
	if lb:
		lb.visible = true
		_update_lightbox()

func _update_lightbox() -> void:
	if _visible_unlocked.is_empty():
		return
	_lightbox_index = clamp(_lightbox_index, 0, _visible_unlocked.size() - 1)
	var entry = _visible_unlocked[_lightbox_index]
	var art_rect   = get_node_or_null("Lightbox/FullArtRect")
	var title_lbl  = get_node_or_null("Lightbox/LightboxTitle")
	var flavor_lbl = get_node_or_null("Lightbox/LightboxFlavor")
	var prev_btn   = get_node_or_null("Lightbox/PrevButton")
	var next_btn   = get_node_or_null("Lightbox/NextButton")
	if art_rect:
		var ap: String = str(entry.get("art_path", ""))
		if ap != "" and ResourceLoader.exists(ap):
			art_rect.texture = load(ap)
		else:
			art_rect.texture = null
	if title_lbl:
		title_lbl.text = str(entry.get("title", ""))
	if flavor_lbl:
		flavor_lbl.text = str(entry.get("flavor", ""))
	var many := _visible_unlocked.size() > 1
	if prev_btn:
		prev_btn.visible = many
	if next_btn:
		next_btn.visible = many

func _on_prev_button_pressed() -> void:
	if _visible_unlocked.is_empty():
		return
	_lightbox_index = (_lightbox_index - 1 + _visible_unlocked.size()) % _visible_unlocked.size()
	_update_lightbox()

func _on_next_button_pressed() -> void:
	if _visible_unlocked.is_empty():
		return
	_lightbox_index = (_lightbox_index + 1) % _visible_unlocked.size()
	_update_lightbox()

func _on_close_button_pressed() -> void:
	var lb = get_node_or_null("Lightbox")
	if lb:
		lb.visible = false

func select_entry(event_id: String) -> void:
	for i in range(_visible_unlocked.size()):
		if str(_visible_unlocked[i].get("event_id", "")) == event_id:
			_lightbox_index = i
			_show_lightbox()
			return
