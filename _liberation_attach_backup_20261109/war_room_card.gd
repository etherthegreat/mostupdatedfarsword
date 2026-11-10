extends PanelContainer
# ═════════════════════════════════════════════════════════════════════════════
# WAR ROOM CARD — quest readout, 2026-11-09
# One card per spirit (Department of Mythological Affairs) or commander.
# Same visual language as the tile card: dark navy panel, gold border, pills,
# one headline per card. Built entirely in code so finished art only has to
# replace a texture path.
#
# A spirit joins in three steps, and the card always answers three questions:
#   1. Where am I?         -> the CONTACT > TRUST > ACCORD strip
#   2. What do I do next?  -> the tasks of the current step, each with live progress
#   3. What happens then?  -> the gold status line (which scene arrives, or the order button)
# ═════════════════════════════════════════════════════════════════════════════

signal order_pressed(protector_id)

const BG := Color(0.07, 0.09, 0.16, 0.96)
const BG_DONE := Color(0.06, 0.10, 0.10, 0.90)
const BORDER := Color(0.85, 0.62, 0.18, 1.0)
const BORDER_QUIET := Color(0.30, 0.36, 0.52, 1.0)
const GOLD := Color(1.0, 0.82, 0.32)
const DIM := Color(0.72, 0.80, 0.95)
const FAINT := Color(0.50, 0.57, 0.72)
const GOOD := Color(0.55, 0.92, 0.55)
const WHITE := Color(0.96, 0.97, 1.0)

const STAGE_TITLES := {"contact": "CONTACT", "trust": "TRUST", "accord": "ACCORD"}
const PORTRAIT_DIRS := [
	"res://art assets/AmericanRevolutionArt/EventArt/",
	"res://art assets/finishedAssets/governors/",
	"res://art assets/AmericanRevolutionArt/Panel/",
]
const PORTRAIT_FALLBACK := "res://art assets/PresidentialLibrary/eagle_seal_transparent.png"

var _box: VBoxContainer


func _init() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_PASS
	var pad := MarginContainer.new()
	for side in ["margin_left", "margin_right"]:
		pad.add_theme_constant_override(side, 14)
	for side in ["margin_top", "margin_bottom"]:
		pad.add_theme_constant_override(side, 12)
	add_child(pad)
	_box = VBoxContainer.new()
	_box.add_theme_constant_override("separation", 8)
	pad.add_child(_box)


# ── SPIRIT CARD ──────────────────────────────────────────────────────────────
# arc: the dictionary WarRoomPanel keeps per protector (see _build_protector_arc).
# view: what WarRoomPanel worked out for display this frame:
#   {state: "complete"|"answer"|"order"|"working"|"waiting", status: String, reward: String}
func build_protector(arc: Dictionary, view: Dictionary) -> void:
	var state: String = view.get("state", "working")
	_style(state == "order" or state == "answer", state == "complete")

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	_box.add_child(head)
	head.add_child(_portrait(_find_portrait(arc), 84))

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 4)
	head.add_child(col)
	col.add_child(_label(str(arc.get("protector_name", "Unknown")), 24, GOLD if state != "complete" else GOOD))
	col.add_child(_label(str(view.get("where", "")), 14, DIM))
	col.add_child(_stage_strip(arc))

	# The headline: what happens next.
	var status := _label(str(view.get("status", "")), 16, GOLD if state in ["order", "answer"] else WHITE)
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_box.add_child(status)

	if state == "order":
		var b := Button.new()
		b.text = "MAKE CONTACT — PRESIDENTIAL ORDER"
		b.custom_minimum_size = Vector2(0, 42)
		b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_size_override("font_size", 16)
		b.add_theme_color_override("font_color", GOLD)
		b.pressed.connect(func():
			b.disabled = true
			b.text = "ORDER SENT"
			order_pressed.emit(arc.get("protector_id", "")))
		_box.add_child(b)

	# The tasks of the step in progress.
	var si: int = int(arc.get("stage_index", 0))
	var stages: Array = arc.get("stages", [])
	if state != "complete" and si < stages.size():
		for row in view.get("tasks", []):
			_box.add_child(_task_row(str(row.get("label", "")), str(row.get("progress", "")), bool(row.get("done", false))))

	var reward: String = str(view.get("reward", ""))
	if reward != "":
		var rw := _label(reward, 13, GOOD if state == "complete" else FAINT)
		rw.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_box.add_child(rw)
	var memo: String = str(arc.get("memo_note", ""))
	if memo != "" and state != "complete":
		var m := _label("DMA note: " + memo, 13, FAINT)
		m.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_box.add_child(m)
	tooltip_text = str(arc.get("soma_memo", ""))


# ── COMMANDER CARD ───────────────────────────────────────────────────────────
func build_commander(arc: Dictionary, rows: Array) -> void:
	var all_done: bool = bool(arc.get("arc_complete", false))
	_style(all_done, false)
	var gov = arc.get("governor")

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	_box.add_child(head)
	var tex: Texture2D = gov.governorTexture if gov != null and gov.governorTexture != null else _tex(PORTRAIT_FALLBACK)
	head.add_child(_portrait(tex, 64))

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 2)
	head.add_child(col)
	col.add_child(_label(str(gov.governorType) if gov != null else "Unknown Commander", 22, GOLD))
	var home = arc.get("home_tile")
	var sub: String = str(arc.get("archetype_name", ""))
	if home != null and is_instance_valid(home):
		sub += "  •  stationed at " + str(home.tileName)
	col.add_child(_label(sub, 14, DIM))
	_add_army_lines(col, gov)
	var n_done: int = 0
	for r in rows:
		if r.get("done", false):
			n_done += 1
	col.add_child(_label("%d of %d objectives" % [n_done, rows.size()], 13, GOOD if all_done else FAINT))

	for r in rows:
		_box.add_child(_task_row(str(r.get("label", "")), str(r.get("progress", "")), bool(r.get("done", false))))
	var foot := "REUNION UNLOCKED" if all_done \
			else "Finish all three to unlock this commander's reunion scene"
	_box.add_child(_label(foot, 13, GOLD if all_done else FAINT))


# The army that came with this commander: its two units, men, strength and where it stands.
func _add_army_lines(col: Node, gov) -> void:
	if gov == null or gov.get("commanderHomeTile") == null:
		return
	var a = gov.get("commanderArmy")
	if a == null or not is_instance_valid(a) or a.deleteMode or a.manpowerInArmy <= 0:
		var left: int = int(gov.get("commanderRemusterTurns")) if gov.get("commanderRemusterTurns") != null else -1
		var home = gov.commanderHomeTile
		if left > 0 and home != null and is_instance_valid(home):
			col.add_child(_label("Army destroyed. A new one musters at %s after %d more turns of holding it." % [str(home.tileName), left], 14, Color(0.95, 0.45, 0.40)))
		else:
			col.add_child(_label("Army mustering", 14, FAINT))
		return
	var kinds: Array = []
	for u in a.unitsList:
		var wpn = u.unitWeapon
		if wpn != null and wpn.is_saber():
			kinds.append("Saber")
		elif wpn != null and wpn.is_artillery():
			kinds.append("Artillery")
		else:
			kinds.append("Musket")
	var where: String = str(a.inTile.tileName) if a.inTile != null and is_instance_valid(a.inTile) else "the field"
	col.add_child(_label("%s  •  %s  •  %d / %d men  •  attack %d  •  at %s" % [
		str(a.ArmyName), " + ".join(kinds), int(a.manpowerInArmy), int(a.maxManpower), int(round(a.armyPunch + a.armyLaunch)), where], 14, GOLD))
	if a.displaced:
		col.add_child(_label("DISPLACED: the enemy holds %s. No recruits, and the army loses men each turn until it is retaken." % str(gov.commanderHomeTile.tileName), 13, Color(0.95, 0.45, 0.40)))


# ── PIECES ───────────────────────────────────────────────────────────────────
func _style(highlight: bool, done: bool) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = BG_DONE if done else BG
	sb.border_color = BORDER if highlight else BORDER_QUIET
	sb.set_border_width_all(2 if highlight else 1)
	sb.set_corner_radius_all(6)
	add_theme_stylebox_override("panel", sb)


func _stage_strip(arc: Dictionary) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	var si: int = int(arc.get("stage_index", 0))
	var stages: Array = arc.get("stages", [])
	for i in stages.size():
		var title: String = STAGE_TITLES.get(str(stages[i].get("key", "")), "?")
		if i < si:
			row.add_child(_pill("✓ " + title, Color(0.16, 0.42, 0.22), GOOD))
		elif i == si:
			row.add_child(_pill(str(i + 1) + " " + title, Color(0.45, 0.32, 0.06), GOLD))
		else:
			row.add_child(_pill(str(i + 1) + " " + title, Color(0.14, 0.17, 0.26), FAINT))
		if i < stages.size() - 1:
			row.add_child(_label("›", 16, FAINT))
	return row


func _pill(txt: String, bg: Color, fg: Color) -> Control:
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.set_corner_radius_all(9)
	sb.content_margin_left = 9
	sb.content_margin_right = 9
	sb.content_margin_top = 2
	sb.content_margin_bottom = 2
	p.add_theme_stylebox_override("panel", sb)
	p.add_child(_label(txt, 12, fg))
	return p


func _task_row(label: String, progress: String, done: bool) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var mark := _label("✓" if done else "○", 17, GOOD if done else FAINT)
	mark.custom_minimum_size = Vector2(20, 0)
	row.add_child(mark)
	var l := _label(label, 16, GOOD if done else WHITE)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(l)
	if progress != "":
		var p := _label(progress, 15, GOOD if done else DIM)
		p.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		p.custom_minimum_size = Vector2(120, 0)
		row.add_child(p)
	return row


func _portrait(tex: Texture2D, px: int) -> Control:
	var frame := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.03, 0.04, 0.08)
	sb.border_color = BORDER_QUIET
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(4)
	frame.add_theme_stylebox_override("panel", sb)
	frame.custom_minimum_size = Vector2(px, px)
	frame.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	frame.clip_contents = true
	var t := TextureRect.new()
	t.name = "Portrait"   # art slot: swap the texture to re-skin
	t.texture = tex
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	t.custom_minimum_size = Vector2(px, px)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(t)
	return frame


func _label(txt: String, px: int, col: Color) -> Label:
	var l := Label.new()
	l.text = txt
	l.add_theme_font_size_override("font_size", px)
	l.add_theme_color_override("font_color", col)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


# Portrait: the art of this spirit's own scenes (accord first, then the summon),
# then a governor portrait of the same name, then the Republic's seal.
func _find_portrait(arc: Dictionary) -> Texture2D:
	var pid: String = str(arc.get("protector_id", ""))
	var names: Array = []
	for suffix in ["_AGREE", "_TAME", "_SUMMON"]:
		var tag: String = str(EventDatabase.get_event(pid + suffix).get("image_tag", "")).strip_edges()
		if tag != "":
			names.append(tag)
			names.append(tag.replace("_", " "))
	var plain: String = str(arc.get("protector_name", "")).to_lower()
	names.append(plain.replace(" ", "_").replace("'", ""))
	for nm in names:
		for dir in PORTRAIT_DIRS:
			for ext in [".png", ".PNG"]:
				if ResourceLoader.exists(dir + nm + ext):
					return load(dir + nm + ext)
	return _tex(PORTRAIT_FALLBACK)


func _tex(path: String) -> Texture2D:
	return load(path) if ResourceLoader.exists(path) else null
