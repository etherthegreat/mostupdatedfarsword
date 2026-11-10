extends PanelContainer
# ═════════════════════════════════════════════════════════════════════════════
# ARMY CARD — GUI pass 2026-10-26
# The click-an-army readout, built on the same language as the map badge:
#   • header: commander portrait, army name + tier, general's rank, where it stands
#   • STR (the badge number) with COVERED / EXPOSED, moves, manpower + shield
#   • one row per unit: weapon, state pip, action points, health, and the exact
#     sum behind its share of STR (weapon × level × health + mods × beliefs)
#   • per-unit order buttons, with spare slots for actions still to come
#   • every mil mod the army carries, grouped by where it comes from; hover = detail
# Your armies get order buttons; enemy armies open read-only, so you can study them.
# world.gd creates one in _show_army_info(). Rebuilds itself when the army changes.
# ═════════════════════════════════════════════════════════════════════════════

const BADGE := preload("res://Game Scenes and Scripts/army_badge.gd")

const W := 420.0
const PORTRAIT_SIZE := Vector2(84, 168)   # commander art is full-body 1:2
const BG := Color(0.07, 0.09, 0.16, 0.95)
const BORDER := Color(0.85, 0.62, 0.18, 1.0)
const GOLD := Color(1.0, 0.82, 0.32)
const DIM := Color(0.72, 0.80, 0.95)
const FAINT := Color(0.55, 0.60, 0.72)
const GOOD := Color(0.55, 0.92, 0.55)
const BAD := Color(1.0, 0.45, 0.42)
const OWNER_COLORS := {"USA": Color(0.27, 0.43, 0.78), "UK": Color(0.62, 0.12, 0.16), "CA": Color(0.85, 0.70, 0.30)}
const TITLES := {1: "Captain", 2: "Colonel", 3: "General"}

# Per-unit order slots, left to right. "locked" slots are reserved for actions the
# combat rules don't support yet — they show, but can't be pressed.
const ORDERS := [
	{"key": "fire", "label": "Fire", "tip": "Fire a volley. Muskets must reload afterwards."},
	{"key": "charge", "label": "Charge", "tip": "Bayonet / saber charge. Hits hard, costs you men, pierces shields."},
	{"key": "hold", "label": "Hold", "tip": "Stay loaded and braced. Counts as COVERED for the army."},
	{"key": "flank", "label": "Flank", "tip": "Cavalry encirclement charge (tier II+ sabers)."},
	{"key": "fortify", "label": "Fortify", "tip": "Dig in for melee defence — coming with the combat rework.", "locked": true},
	{"key": "", "label": "·", "tip": "Free slot for a future action (logistics, entrench …).", "locked": true},
]
# Where a mil mod comes from, in display order.
const SOURCE_ORDER := ["Commander", "Beliefs & Nation", "Weapon", "Ore", "Armor", "Other"]

signal stance_changed(army)

var army = null
var read_only := false
var _font: Font
var _bold: FontVariation
var _sig := ""
var _t := 0.0


# Small control that draws one badge pip (same art as the map).
class PipIcon extends Control:
	var pip: Dictionary = {}
	func _init(p: Dictionary) -> void:
		pip = p
		custom_minimum_size = Vector2(16, 16)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		BADGE.draw_pip_on(self, size * 0.5, pip)


# Thin manpower + shield bar.
class HealthBar extends Control:
	var hp := 1.0
	var sh := 0.0
	func _init(h: float, s: float, height: float = 6.0) -> void:
		hp = clampf(h, 0.0, 1.0)
		sh = clampf(s, 0.0, 1.0)
		custom_minimum_size = Vector2(0, height)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0, 0, 0, 0.7))
		var c := BADGE.MANPOWER if hp > 0.34 else BADGE.MANPOWER.lerp(BADGE.EXPOSED, 0.6)
		draw_rect(Rect2(Vector2.ZERO, Vector2(size.x * hp, size.y)), c)
		if sh > 0.0:
			draw_rect(Rect2(Vector2.ZERO, Vector2(size.x * sh, maxf(2.0, size.y * 0.45))), BADGE.SHIELD)


func _init() -> void:
	custom_minimum_size = Vector2(W, 0)
	mouse_filter = Control.MOUSE_FILTER_STOP


func show_army(a, view_only: bool) -> void:
	army = a
	read_only = view_only
	var base := ThemeDB.fallback_font
	var th := ThemeDB.get_project_theme()
	if th != null and th.default_font != null:
		base = th.default_font
	_font = base
	_bold = FontVariation.new()
	_bold.base_font = base
	_bold.variation_embolden = 0.8
	var sb := StyleBoxFlat.new()
	sb.bg_color = BG
	sb.border_color = BORDER
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(8)
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	sb.content_margin_top = 10
	sb.content_margin_bottom = 10
	add_theme_stylebox_override("panel", sb)
	_rebuild()


# ── live refresh ────────────────────────────────────────────────────────────
func _signature() -> String:
	if army == null or not is_instance_valid(army):
		return ""
	var parts := PackedStringArray([str(army.manpowerInArmy), str(army.armyShield), str(army.currentMovementPoints), str(army.unitsList.size())])
	for u in army.unitsList:
		if u == null:
			continue
		parts.append("%s/%d/%d/%d/%d" % [u.unitStance, u.unitCurrentAP, u.reloadCounter, u.unitCurrentManpower, u.militaryModifierList.size()])
	return "|".join(parts)


func _process(delta: float) -> void:
	_t += delta
	if _t < 0.4:
		return
	_t = 0.0
	if army == null or not is_instance_valid(army):
		queue_free()
		return
	if _signature() != _sig:
		_rebuild()


func _rebuild() -> void:
	for c in get_children():
		c.queue_free()
	_sig = _signature()
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	add_child(v)
	_build_header(v)
	_build_strength(v)
	v.add_child(_rule())
	_build_units(v)
	v.add_child(_rule())
	_build_mods(v)
	# stay pinned bottom-left as the height changes
	reset_size()
	_place.call_deferred()


func _place() -> void:
	if not is_inside_tree():
		return
	# wrapped labels settle a frame late; shrink to the real content, then pin
	await get_tree().process_frame
	if not is_inside_tree():
		return
	reset_size()
	var vp := get_viewport_rect().size
	position = Vector2(12, vp.y - size.y - 12)


# ── header ──────────────────────────────────────────────────────────────────
func _build_header(v: VBoxContainer) -> void:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 12)
	v.add_child(h)
	var cid: String = army.parentCountry.CID if army.parentCountry != null else "USA"
	var frame := PanelContainer.new()
	var fsb := StyleBoxFlat.new()
	fsb.bg_color = Color(0.03, 0.04, 0.08)
	fsb.border_color = OWNER_COLORS.get(cid, BORDER)
	fsb.set_border_width_all(3)
	fsb.set_corner_radius_all(6)
	frame.add_theme_stylebox_override("panel", fsb)
	h.add_child(frame)
	var tr := TextureRect.new()
	tr.custom_minimum_size = PORTRAIT_SIZE
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED   # whole figure, never cropped
	var cmd = army.commander
	tr.texture = _portrait(cmd)
	frame.add_child(tr)
	if tr.texture == null:
		var q := _label("NO\nCOMMANDER", 13, FAINT, true)
		q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		q.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		frame.add_child(q)

	var info := VBoxContainer.new()
	info.add_theme_constant_override("separation", 1)
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(info)
	var name_row := HBoxContainer.new()
	info.add_child(name_row)
	var nm := _label(str(army.ArmyName), 18, Color.WHITE, true)
	nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_row.add_child(nm)
	if str(army.armyTier) != "":
		name_row.add_child(_label("TIER " + str(army.armyTier), 14, GOLD, true))
	if cmd != null:
		var lvl: int = int(cmd.governorLevel)
		var rank: String = TITLES.get(lvl, "Commander")
		info.add_child(_label("%s %s" % [rank, str(cmd.governorType)], 16, GOLD, true))
		info.add_child(_label("Level %d · morale %d" % [lvl, int(cmd.morale)], 14, DIM))
	else:
		info.add_child(_label("No commander", 16, FAINT, true))
		if not read_only:
			info.add_child(_label("Assign one to unlock commander mods", 13, FAINT))
	var where := "—"
	if army.inTile != null:
		where = "%s · %s" % [str(army.inTile.tileName), str(army.inTile.terrain)]
	info.add_child(_label(where, 14, DIM))
	if read_only:
		info.add_child(_label("ENEMY — read only", 13, BAD, true))
	if cmd != null and str(cmd.governorDescription) != "":
		# the full-body portrait leaves room for the commander's line
		var d := _label(str(cmd.governorDescription), 13, FAINT)
		d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		info.add_child(d)


func _portrait(cmd) -> Texture2D:
	# Named portrait first (governor.gd GOVERNOR_PORTRAITS), then the procedural one
	# (Vermont green-coat variant included), then whatever the governor carries.
	if cmd == null:
		return null
	var t = cmd._get_portrait(str(cmd.governorType)) if cmd.has_method("_get_portrait") else null
	if t == null and cmd.has_method("get_portrait_for_region") and army.inTile != null:
		t = cmd.get_portrait_for_region(str(army.inTile.tileContinent))
	if t == null:
		var pe: Dictionary = cmd.get("portrait_entry") if cmd.get("portrait_entry") != null else {}
		if pe.has("path") and ResourceLoader.exists(str(pe.path)):
			t = load(str(pe.path))
	if t == null:
		t = cmd.governorTexture
	return t


# ── strength line ───────────────────────────────────────────────────────────
func _build_strength(v: VBoxContainer) -> void:
	var covered: bool = bool(army.get("isHolding"))
	for u in army.unitsList:
		if BADGE.unit_state(u) in ["hold", "fortify"]:
			covered = true
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	v.add_child(row)
	row.add_child(_label("STR", 15, FAINT, true))
	var s := _label(str(BADGE.army_strength(army)), 34, Color.WHITE, true)
	s.tooltip_text = "Best hit of every unit combined — the number on the map badge.\nThe breakdown under each unit shows exactly where it comes from."
	s.mouse_filter = Control.MOUSE_FILTER_PASS
	row.add_child(s)
	var chip := _chip("COVERED" if covered else "EXPOSED", BADGE.COVERED if covered else BADGE.EXPOSED)
	chip.tooltip_text = "Someone is holding loaded or fortified — a charge gets answered." if covered \
		else "Nobody is holding or fortified — an enemy charge goes unanswered."
	row.add_child(chip)
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(sp)
	var moves := _label("MOVES %d/%d" % [int(army.currentMovementPoints), int(army.maxMovementPoints)], 15, GOLD if army.currentMovementPoints > 0 else FAINT, true)
	row.add_child(moves)

	var hp: float = float(army.manpowerInArmy) / maxf(1.0, float(army.maxManpower))
	var sh: float = float(army.armyShield) / float(army.armyMaxShield) if army.armyMaxShield > 0 else 0.0
	v.add_child(HealthBar.new(hp, sh, 8.0))
	var nums := "MANPOWER %d / %d" % [army.manpowerInArmy, army.maxManpower]
	if army.armyMaxShield > 0:
		nums += "      SHIELD %d / %d" % [army.armyShield, army.armyMaxShield]
	v.add_child(_label(nums, 13, DIM))


# ── units ───────────────────────────────────────────────────────────────────
func _build_units(v: VBoxContainer) -> void:
	var head := HBoxContainer.new()
	v.add_child(head)
	head.add_child(_label("UNITS", 15, GOLD, true))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(sp)
	if not read_only:
		head.add_child(_label("all:", 13, FAINT))
		for o in ORDERS.slice(0, 3):
			var b := _order_button(o, null, false)
			b.custom_minimum_size = Vector2(52, 22)
			head.add_child(b)
	var idx := 1
	for u in army.unitsList:
		if u == null:
			continue
		_build_unit(v, u, idx)
		idx += 1


func _build_unit(v: VBoxContainer, u, idx: int) -> void:
	var box := PanelContainer.new()
	var bsb := StyleBoxFlat.new()
	bsb.bg_color = Color(0.11, 0.13, 0.22, 0.9)
	bsb.set_corner_radius_all(6)
	bsb.content_margin_left = 8
	bsb.content_margin_right = 8
	bsb.content_margin_top = 6
	bsb.content_margin_bottom = 6
	box.add_theme_stylebox_override("panel", bsb)
	v.add_child(box)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 3)
	box.add_child(col)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	col.add_child(top)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(38, 38)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if u.unitWeapon != null:
		icon.texture = u.unitWeapon.weaponImage
	top.add_child(icon)
	var mid := VBoxContainer.new()
	mid.add_theme_constant_override("separation", 0)
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(mid)
	var wt: String = u.unitWeapon.weaponType if u.unitWeapon != null else "—"
	mid.add_child(_label("%d. %s — %s   Lv%d" % [idx, str(u.unitType), wt, int(u.unitLevel)], 15, Color.WHITE, true))
	var st_row := HBoxContainer.new()
	st_row.add_theme_constant_override("separation", 5)
	mid.add_child(st_row)
	var state := BADGE.unit_state(u)
	st_row.add_child(PipIcon.new({"kind": state, "spent": u.unitCurrentAP <= 0}))
	var st_txt: String = str(BADGE.PIP_STYLES.get(state, {}).get("tip", state))
	if state in ["reload", "hold_empty"]:
		st_txt += " (%d)" % int(u.reloadCounter)
	st_row.add_child(_label(st_txt, 13, DIM))
	st_row.add_child(_label("   AP %d/%d" % [u.unitCurrentAP, u.get_max_ap()], 13, GOLD if u.unitCurrentAP > 0 else FAINT))
	var mpv := VBoxContainer.new()
	mpv.custom_minimum_size = Vector2(86, 0)
	top.add_child(mpv)
	mpv.add_child(_label("%d / %d" % [u.unitCurrentManpower, u.unitMaxManpower], 13, DIM))
	var shf: float = float(u.unitShield) / float(u.unitMaxShield) if u.unitMaxShield > 0 else 0.0
	mpv.add_child(HealthBar.new(float(u.unitCurrentManpower) / maxf(1.0, float(u.unitMaxManpower)), shf, 5.0))

	var bd := _breakdown(u)
	var bl := _label(bd.text, 12, FAINT)
	bl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	bl.tooltip_text = bd.tip
	bl.mouse_filter = Control.MOUSE_FILTER_PASS
	col.add_child(bl)

	if not read_only:
		var orders := HBoxContainer.new()
		orders.add_theme_constant_override("separation", 4)
		col.add_child(orders)
		for o in ORDERS:
			orders.add_child(_order_button(o, u, _order_allowed(o, u)))


func _breakdown(u) -> Dictionary:
	# Rebuild the sum the game uses so the player can see where STR comes from.
	var mp: float = float(u.unitCurrentManpower) / maxf(1.0, float(u.unitMaxManpower))
	var wp: float = float(u.unitCurrentWeapons) / maxf(1.0, float(u.unitMaxWeapons))
	var arty: bool = u.unitWeapon != null and u.unitWeapon.is_artillery()
	var eff: float = wp if arty else (mp + wp) * 0.5
	var lvl: int = int(u.unitLevel)
	var base_r: float = lvl * float(u.weaponRangedOffence) * eff
	var pen: float = u.unitWeapon.get_melee_penalty() if u.unitWeapon != null else 1.0
	var base_m: float = lvl * float(u.weaponOffence) * pen * eff
	var fin_r: float = float(u.unitRangedOffence)
	var fin_m: float = float(u.unitOffensiveScore)
	var bel: float = army._belief_atk_mult(u)
	var volley: float = fin_r * bel
	var bayonet: float = fin_m * 1.8 * bel if u.can_charge_melee() else 0.0
	var share: float = maxf(volley, bayonet)
	var health := "health %d%%" % roundi(eff * 100)
	var parts := PackedStringArray()
	if fin_r > 0.0:
		parts.append("Volley %d = %d × Lv%d × %s%s" % [roundi(volley), int(u.weaponRangedOffence), lvl, health, _mods_txt(fin_r - base_r)])
	if bayonet > 0.0:
		parts.append("Bayonet %d = %d × Lv%d × %s%s ×1.8 charge" % [roundi(bayonet), int(u.weaponOffence), lvl, health, _mods_txt(fin_m - base_m)])
	var txt := "  ·  ".join(parts)
	if absf(bel - 1.0) > 0.001:
		txt += "  ·  beliefs ×%.2f" % bel
	txt += "   → STR %d" % roundi(share)
	var tip := "How this unit's share of STR is built:\n" \
		+ "weapon value × unit level × health (avg of manpower & weapons; artillery: weapons only)\n" \
		+ "+ mil mods, × beliefs. Charges hit ×1.8. Muskets fight at half strength in melee.\n" \
		+ "STR uses whichever is bigger, volley or bayonet."
	return {"text": txt, "tip": tip}


func _mods_txt(d: float) -> String:
	if absf(d) < 0.5:
		return ""
	return " %+d mods" % roundi(d)


func _order_allowed(o: Dictionary, u) -> bool:
	if o.get("locked", false) or u == null or u.unitCurrentManpower <= 0:
		return false
	var w = u.unitWeapon
	match str(o.key):
		"fire":
			return w != null and not w.is_saber()
		"charge":
			return u.can_charge_melee()
		"flank":
			return w != null and w.is_saber() and str(army.armyTier) not in ["", "I"]
	return true


func _order_button(o: Dictionary, u, allowed: bool) -> Button:
	var b := Button.new()
	b.text = str(o.label)
	b.tooltip_text = str(o.tip)
	b.custom_minimum_size = Vector2(60, 26)
	b.add_theme_font_override("font", _bold)
	b.add_theme_font_size_override("font_size", 13)
	var active: bool = u != null and str(u.unitStance) == str(o.key)
	var locked: bool = o.get("locked", false)
	for st in ["normal", "hover", "pressed", "disabled", "focus"]:
		var s := StyleBoxFlat.new()
		s.set_corner_radius_all(5)
		s.set_border_width_all(1)
		s.border_color = Color(BORDER, 0.6)
		s.bg_color = Color(0.14, 0.17, 0.28)
		if active:
			s.bg_color = GOLD.darkened(0.15)
			s.border_color = GOLD
		elif st == "hover":
			s.bg_color = Color(0.2, 0.25, 0.4)
		if st == "disabled":
			s.bg_color = Color(0.09, 0.10, 0.15)
			s.border_color = Color(0.3, 0.32, 0.4, 0.6) if not locked else Color(0.3, 0.32, 0.4, 0.35)
		if st == "focus":
			s.draw_center = false
		b.add_theme_stylebox_override(st, s)
	b.add_theme_color_override("font_color", Color(0.08, 0.06, 0.02) if active else Color.WHITE)
	b.add_theme_color_override("font_hover_color", Color(0.08, 0.06, 0.02) if active else Color.WHITE)
	b.add_theme_color_override("font_disabled_color", Color(1, 1, 1, 0.28))
	if u == null:
		# "all units" shortcut
		b.pressed.connect(_set_all.bind(str(o.key)))
	else:
		b.disabled = not allowed
		b.pressed.connect(_set_stance.bind(u, str(o.key)))
	return b


func _set_stance(u, key: String) -> void:
	if u == null or key == "":
		return
	u.unitStance = key
	stance_changed.emit(army)
	_rebuild()


func _set_all(key: String) -> void:
	for u in army.unitsList:
		if u != null and _order_allowed({"key": key}, u):
			u.unitStance = key
	stance_changed.emit(army)
	_rebuild()


# ── mil mods ────────────────────────────────────────────────────────────────
func _mod_source(mm, u) -> String:
	var t: String = str(mm.milModType)
	var cmd_types := {}
	for lst in [army.commanderModifiers1, army.commanderModifiers2, army.commanderModifiers3]:
		for m in lst:
			if m != null:
				cmd_types[str(m.milModType)] = true
	if army.commander != null:
		for lst in [army.commander.govMilModsLvl1, army.commander.govMilModsLvl2, army.commander.govMilModsLvl3]:
			for m in lst:
				if m != null:
					cmd_types[str(m.milModType)] = true
	if cmd_types.has(t):
		return "Commander"
	for m in army.beliefMilMods + army.parentMilModifiers:
		var mt: String = str(m) if m is String else (str(m.get("milModType")) if m is Object else "")
		if mt == t:
			return "Beliefs & Nation"
	if u.unitWeapon != null:
		for m in u.unitWeapon.weaponMilMods:
			if str(m.milModType) == t:
				return "Weapon"
	if u.unitOre != null:
		for m in u.unitOre.oreMilMods:
			if str(m.milModType) == t:
				return "Ore"
	if u.unitArmor != null:
		for m in u.unitArmor.armorMilMods:
			if str(m.milModType) == t:
				return "Armor"
	return "Other"


func _build_mods(v: VBoxContainer) -> void:
	v.add_child(_label("MIL MODS", 15, GOLD, true))
	# type -> {mod, units:[idx], source, disabled}
	var by_type := {}
	var order: Array = []
	var idx := 1
	for u in army.unitsList:
		if u == null:
			continue
		for mm in u.militaryModifierList:
			if mm == null or not is_instance_valid(mm):
				continue
			var t: String = str(mm.milModType)
			if not by_type.has(t):
				by_type[t] = {"mod": mm, "units": [], "count": 0, "source": _mod_source(mm, u), "disabled": true}
				order.append(t)
			var e: Dictionary = by_type[t]
			e.count += 1
			if not (idx in e.units):
				e.units.append(idx)
			if not mm.disabled:
				e.disabled = false
		idx += 1
	if order.is_empty():
		v.add_child(_label("None yet — commanders, beliefs and kit add them.", 13, FAINT))
		return
	var n_units: int = army.unitsList.size()
	for src in SOURCE_ORDER:
		var mine: Array = []
		for t in order:
			if by_type[t].source == src:
				mine.append(t)
		if mine.is_empty():
			continue
		v.add_child(_label(src.to_upper(), 12, FAINT, true))
		var flow := HFlowContainer.new()
		flow.add_theme_constant_override("h_separation", 5)
		flow.add_theme_constant_override("v_separation", 5)
		v.add_child(flow)
		for t in mine:
			flow.add_child(_mod_chip(by_type[t], n_units))


func _mod_chip(e: Dictionary, n_units: int) -> Control:
	var mm = e.mod
	var chip := PanelContainer.new()
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.13, 0.16, 0.27) if not e.disabled else Color(0.09, 0.10, 0.15)
	s.border_color = Color(BAD, 0.8) if mm.isNegative else Color(BORDER, 0.55)
	s.set_border_width_all(1)
	s.set_corner_radius_all(10)
	s.content_margin_left = 5
	s.content_margin_right = 8
	s.content_margin_top = 2
	s.content_margin_bottom = 2
	chip.add_theme_stylebox_override("panel", s)
	chip.mouse_filter = Control.MOUSE_FILTER_PASS
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 4)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chip.add_child(h)
	if mm.milModTexture != null:
		var ic := TextureRect.new()
		ic.texture = mm.milModTexture
		ic.custom_minimum_size = Vector2(18, 18)
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(ic)
	var name_txt: String = str(mm.milModType)
	if e.units.size() < n_units and n_units > 1:
		name_txt += "  (unit %s)" % ",".join(PackedStringArray(e.units.map(func(x): return str(x))))
	if e.count > e.units.size():
		name_txt += "  ×%d" % (e.count / maxi(1, e.units.size()))   # stacked duplicates — worth knowing
	var l := _label(name_txt, 12, (BAD if mm.isNegative else Color.WHITE) if not e.disabled else FAINT, true)
	h.add_child(l)
	var tip := _strip_bbcode(str(mm.milModDescription))
	if tip == "":
		tip = "(no description yet)"
	if e.disabled:
		tip += "\nINACTIVE — the resource it needs has run out (or no manpower)."
	if int(mm.turnsRemaining) > 0:
		tip += "\n%d turns left" % int(mm.turnsRemaining)
	chip.tooltip_text = "%s — %s\n%s" % [str(mm.milModType), str(e.source), tip]
	return chip


static func _strip_bbcode(s: String) -> String:
	var re := RegEx.new()
	re.compile("\\[[^\\]]*\\]")
	return re.sub(s, "", true).strip_edges()


# ── helpers ─────────────────────────────────────────────────────────────────
func _label(txt: String, fs: int, col: Color, bold: bool = false) -> Label:
	var l := Label.new()
	l.text = txt
	l.add_theme_font_override("font", _bold if bold else _font)
	l.add_theme_font_size_override("font_size", fs)
	l.add_theme_color_override("font_color", col)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


func _chip(txt: String, col: Color) -> PanelContainer:
	var p := PanelContainer.new()
	var s := StyleBoxFlat.new()
	s.bg_color = Color(col, 0.18)
	s.border_color = col
	s.set_border_width_all(2)
	s.set_corner_radius_all(10)
	s.content_margin_left = 8
	s.content_margin_right = 8
	s.content_margin_top = 1
	s.content_margin_bottom = 1
	p.add_theme_stylebox_override("panel", s)
	p.mouse_filter = Control.MOUSE_FILTER_PASS
	p.add_child(_label(txt, 13, col, true))
	return p


func _rule() -> ColorRect:
	var r := ColorRect.new()
	r.color = Color(BORDER, 0.3)
	r.custom_minimum_size = Vector2(0, 1)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r
