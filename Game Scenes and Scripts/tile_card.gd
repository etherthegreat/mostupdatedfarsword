extends Panel
# ═════════════════════════════════════════════════════════════════════════════
# TILE CARD — GUI pass 2026-10-26
# The click-a-tile readout, rebuilt to read in one glance:
#   • a terrain painting banner with the tile name and owner stripe
#   • strategic pills (FRONT LINE, UNDEFENDED, TECH SITE …)
#   • one big "headline" row: what you WIN by liberating it, or what it MAKES you
#   • the tile's buildings as sketches with level pips and their yield
#   • hover a building for its detail card (the building info panel)
# Built entirely in code from placeholder art, so swapping a texture path below is
# all it takes to drop in finished art. world.gd creates one via _show_tile_info().
# ═════════════════════════════════════════════════════════════════════════════

const W := 360.0
const ART := "res://art assets/"
const TERRAIN := ART + "Placeholder Art/UI Art/terrain/"
const SKETCH := ART + "finishedAssets/buildingsketches/"
const ICON := ART + "finishedAssets/manaicons/"
const ORES := ART + "finishedAssets/ores/"
const ECO := ART + "ModifierIcons/TileEcoModifiers/"

const BG := Color(0.07, 0.09, 0.16, 0.95)
const BORDER := Color(0.85, 0.62, 0.18, 1.0)
const GOLD := Color(1.0, 0.82, 0.32)
const DIM := Color(0.72, 0.80, 0.95)
const GOOD := Color(0.55, 0.92, 0.55)
const BAD := Color(1.0, 0.45, 0.42)

const OWNER_COLORS := {"USA": Color(0.27, 0.43, 0.78), "UK": Color(0.62, 0.12, 0.16), "CA": Color(0.85, 0.70, 0.30)}
const OWNER_NAMES := {"USA": "United States", "UK": "British Empire", "CA": "Canada"}

# Pax terrain → painting. Winter swaps in the snowy version where there is one.
const TERRAIN_ART := {
	"Farmlands": "IMG_1434.PNG", "Woods": "IMG_1437.PNG", "Suburbs": "IMG_1436.PNG",
	"Wetlands": "IMG_1424.PNG", "Foothills": "IMG_1438.PNG", "Metro": "IMG_1427.PNG",
	"Fort": "IMG_1438.PNG", "Fortress": "IMG_1438.PNG",
}
const TERRAIN_WINTER := {"Woods": "IMG_1442.PNG", "Foothills": "IMG_1439.PNG", "Fort": "IMG_1439.PNG", "Fortress": "IMG_1439.PNG"}
# One-line read of what the ground means for a general.
const TERRAIN_NOTE := {
	"Farmlands": "Open fields — feeds armies, hard to hold",
	"Woods": "Forest — cover for defenders",
	"Suburbs": "Settled country — rich and exposed",
	"Wetlands": "Bog and marsh — slow going for everyone",
	"Foothills": "High ground — defenders dig in",
	"Metro": "City — money, people, and street fighting",
	"Fort": "Fortified ground", "Fortress": "Fortified ground",
}

# building key (as in tile.buildings) → [sketch, display name, short purpose]
const BUILDINGS := {
	"farm": ["farm.png", "Farm", "Feeds the region"],
	"granary": ["granary.png", "Granary", "Stores food against winter"],
	"mine": ["mine.png", "Mine", "Ore for the war industry"],
	"camp": ["camp.png", "Camp", "Timber and frontier hands"],
	"market": ["faire.png", "Market", "Coin — and loot when it falls"],
	"forge": ["forge.png", "Forge", "Arms the army"],
	"barracks": ["barracks.png", "Barracks", "Raises fighting men"],
	"fortress": ["fortress.png", "Fortress", "Walls — slows any siege"],
	"courthouse": ["courthouse.png", "Courthouse", "Law, order, spell tokens"],
	"library": ["library.png", "Library", "Knowledge — tech"],
	"monument": ["tower.png", "Monument", "Culture and pride"],
	"resort": ["bath.png", "Resort", "Keeps people content"],
	"dock": ["dock.png", "Dock", "Ships and trade"],
	"temple": ["temple.png", "Temple", "Faith"],
	"workshop": ["workshop.png", "Workshop", "Craft and tools"],
}
const CROP_ART := {
	"corn": "Wheat.PNG", "hay": "Wheat.PNG", "apples": "Razorberry.PNG", "peaches": "Razorberry.PNG",
	"oranges": "Bananas.PNG", "peanuts": "Bananas.PNG", "soybeans": "Bamboo.PNG",
	"mushrooms": "Wereroot.PNG", "cannabis": "Cannabis.PNG",
}
const ORE_ART := {"Iron": "Iron.PNG", "Copper": "Copper.PNG", "Gold": "Gold.PNG", "Marble": "Marble.PNG"}

# resource key → [icon, colour] (keys match building.totalBuilding* fields)
const RES := {
	"Dollars": ["currency.png", Color(1.0, 0.85, 0.35)],
	"Weapons": ["Weapons.png", Color(0.85, 0.85, 0.9)],
	"Manpower": ["manpower.png", Color(0.95, 0.65, 0.55)],
	"Science": ["science2.png", Color(0.6, 0.85, 1.0)],
	"Culture": ["Culture.png", Color(0.9, 0.7, 1.0)],
	"Food": ["fooda.png", Color(0.6, 0.95, 0.5)],
	"Magic": ["Magic.png", Color(0.75, 0.6, 1.0)],
}

var _tile = null
var _world = null
var _detail: PanelContainer = null
var _tex_cache := {}


# ═════════════════════════════════════════════════════════════════════════════
func build(tile, world) -> void:
	_tile = tile
	_world = world
	mouse_filter = Control.MOUSE_FILTER_STOP
	var sb := StyleBoxFlat.new()
	sb.bg_color = BG
	sb.border_color = BORDER
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(8)
	add_theme_stylebox_override("panel", sb)
	clip_contents = true

	var col := VBoxContainer.new()
	col.name = "Col"
	col.add_theme_constant_override("separation", 6)
	col.position = Vector2(0, 0)
	col.custom_minimum_size = Vector2(W, 0)
	add_child(col)

	_banner(col)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 8)
	var pad := MarginContainer.new()
	for side in ["left", "right"]:
		pad.add_theme_constant_override("margin_" + side, 12)
	pad.add_theme_constant_override("margin_bottom", 12)
	pad.add_child(body)
	col.add_child(pad)

	_pills(body)
	_headline(body)
	_buildings(body)
	_footer(body)

	size = Vector2(W, col.get_combined_minimum_size().y)
	# a quick "pop" so opening a tile feels like picking up a card
	pivot_offset = Vector2(0, 0)
	scale = Vector2(0.94, 0.94)
	modulate.a = 0.0
	var tw := create_tween().set_parallel(true)
	tw.tween_property(self, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "modulate:a", 1.0, 0.10)
	call_deferred("_fit")


func _fit() -> void:
	var col = get_node_or_null("Col")
	if col != null:
		size = Vector2(W, col.get_combined_minimum_size().y)


func _exit_tree() -> void:
	if _detail != null and is_instance_valid(_detail):
		_detail.queue_free()


# ═════════════════════════════════════════════════════════════════════════════
# Sections
# ═════════════════════════════════════════════════════════════════════════════
func _banner(parent: Control) -> void:
	var holder := Control.new()
	holder.custom_minimum_size = Vector2(W, 118)
	holder.clip_contents = true
	parent.add_child(holder)

	var art := TextureRect.new()
	art.texture = _tex(TERRAIN + _terrain_file())
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.size = Vector2(W, 118)
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(art)

	# darken the bottom so the name always reads over any painting
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.45)
	shade.position = Vector2(0, 62)
	shade.size = Vector2(W, 56)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(shade)

	var owner := str(_tile.tileOwner)
	var stripe := ColorRect.new()
	stripe.color = OWNER_COLORS.get(owner, Color(0.5, 0.5, 0.5))
	stripe.position = Vector2(0, 112)
	stripe.size = Vector2(W, 6)
	holder.add_child(stripe)

	var name_l := _label(str(_tile.tileName), 22, Color.WHITE)
	name_l.position = Vector2(12, 64)
	name_l.add_theme_constant_override("outline_size", 6)
	name_l.add_theme_color_override("font_outline_color", Color.BLACK)
	holder.add_child(name_l)

	var sub := _label("%s  •  %s  •  %s" % [str(_tile.tileContinent), str(_tile.terrain), OWNER_NAMES.get(owner, owner)], 13, Color(0.92, 0.94, 1.0))
	sub.position = Vector2(13, 92)
	sub.add_theme_constant_override("outline_size", 4)
	sub.add_theme_color_override("font_outline_color", Color.BLACK)
	holder.add_child(sub)

	# crop / ore medallions in the top-right corner of the painting
	var x := W - 44.0
	var ore = _tile.get("geologicResource")
	if ore != null and ORE_ART.has(str(ore)):
		holder.add_child(_medallion(_tex(ORES + ORE_ART[str(ore)]), Vector2(x, 8), str(ore) + " deposit"))
		x -= 40.0
	var crop := str(_tile.get("tileCrop") if _tile.get("tileCrop") != null else "")
	if CROP_ART.has(crop):
		holder.add_child(_medallion(_tex(ORES + CROP_ART[crop]), Vector2(x, 8), crop.capitalize() + " country"))


func _pills(parent: Control) -> void:
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 6)
	row.add_theme_constant_override("v_separation", 4)
	var owner := str(_tile.tileOwner)
	var mine := owner == "USA"
	var army = _tile.get("stationedArmy")
	var garrisoned: bool = army != null and is_instance_valid(army)
	var front := false
	for n in _tile.TileNeighbors:
		if n != null and is_instance_valid(n) and str(n.tileOwner) != owner and not (owner in ["USA", "CA"] and str(n.tileOwner) in ["USA", "CA"]):
			front = true
			break
	if _world != null and _world.has_method("_is_tech_tile") and _world._is_tech_tile(_tile):
		row.add_child(_pill("TECH SITE", Color(0.25, 0.55, 0.85)))
	if front:
		row.add_child(_pill("FRONT LINE", Color(0.75, 0.25, 0.2)))
	if garrisoned:
		row.add_child(_pill("GARRISONED" if not mine else "YOUR ARMY HERE", Color(0.35, 0.35, 0.45)))
	elif not mine:
		row.add_child(_pill("UNDEFENDED", Color(0.2, 0.6, 0.3)))
	elif front:
		row.add_child(_pill("NO GARRISON", Color(0.75, 0.45, 0.1)))
	if _tile.has_method("recently_conquered") and _tile.recently_conquered():
		row.add_child(_pill("JUST TAKEN", Color(0.55, 0.3, 0.6)))
	if _tile.has_method("is_fortified") and _tile.is_fortified():
		row.add_child(_pill("FORTIFIED", Color(0.4, 0.4, 0.4)))
	if row.get_child_count() > 0:
		parent.add_child(row)
	var note := _label(str(TERRAIN_NOTE.get(str(_tile.terrain), "")), 12, DIM)
	if note.text != "":
		parent.add_child(note)


func _headline(parent: Control) -> void:
	var owner := str(_tile.tileOwner)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	var chips := HFlowContainer.new()
	chips.add_theme_constant_override("h_separation", 10)
	chips.add_theme_constant_override("v_separation", 6)
	if owner == "USA":
		box.add_child(_label("THIS TILE MAKES  / turn", 13, GOLD))
		var totals := _tile_totals()
		for k in ["Dollars", "Weapons", "Manpower", "Science", "Culture", "Food"]:
			if absf(float(totals.get(k, 0.0))) >= 0.5:
				chips.add_child(_chip(k, float(totals[k]), 26))
		if int(totals.get("Defense", 0)) > 0:
			chips.add_child(_text_chip("DEF +%d" % int(totals["Defense"]), Color(0.8, 0.8, 0.85), 18))
		if chips.get_child_count() == 0:
			chips.add_child(_label("Nothing yet — build here", 14, DIM))
	else:
		box.add_child(_label("LIBERATE FOR", 13, GOLD))
		for sp in _spoils():
			if sp[0] == "Dollars" or sp[0] == "Weapons" or sp[0] == "Manpower":
				chips.add_child(_chip(sp[0], float(sp[1]), 26, true))
			else:
				chips.add_child(_chip(sp[0], float(sp[1]), 26, true, sp[2]))
		if chips.get_child_count() == 0:
			chips.add_child(_label("Open ground — no spoils, just the map", 14, DIM))
	box.add_child(chips)
	var frame := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 1, 0.05)
	sb.border_color = Color(GOLD.r, GOLD.g, GOLD.b, 0.35)
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(6)
	sb.content_margin_left = 10
	sb.content_margin_right = 10
	sb.content_margin_top = 6
	sb.content_margin_bottom = 8
	frame.add_theme_stylebox_override("panel", sb)
	frame.add_child(box)
	parent.add_child(frame)


func _buildings(parent: Control) -> void:
	var bdict: Dictionary = _tile.get("buildings") if _tile.get("buildings") != null else {}
	if bdict.is_empty():
		return
	parent.add_child(_label("BUILDINGS", 13, GOLD))
	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	var keys: Array = bdict.keys()
	keys.sort_custom(func(a, b): return int(bdict[a]) > int(bdict[b]))
	for key in keys:
		grid.add_child(_building_cell(str(key), int(bdict[key])))
	parent.add_child(grid)


func _footer(parent: Control) -> void:
	var feats = _tile.get("tileSpecialFeatures")
	if feats != null and not (feats as Array).is_empty():
		var f := _label("★ " + ", ".join(PackedStringArray((feats as Array).map(func(x): return str(x)))), 13, Color(1.0, 0.92, 0.7))
		f.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		f.custom_minimum_size = Vector2(W - 24, 0)
		parent.add_child(f)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var corr := int(_tile.get("corruption") if _tile.get("corruption") != null else 0)
	var ico := _icon(_tex(ECO + _corruption_file(corr)), 26)
	ico.tooltip_text = "Corruption %d%%" % corr
	row.add_child(ico)
	row.add_child(_label("Corruption %d%%" % corr, 13, BAD if corr > 40 else DIM))
	if _tile.has_method("has_special_feature") and (_tile.has_special_feature("Major River") or _tile.has_special_feature("Major Lake")):
		var w := _icon(_tex(ECO + "FreshWater.png"), 26)
		w.tooltip_text = "Fresh water"
		row.add_child(w)
	var gov = _tile.get("tileGovernor")
	if gov != null:
		var gn = gov.get("governorName")
		row.add_child(_label("  Gov. " + str(gn if gn != null else gov.get("governorType")), 13, Color.WHITE))
	parent.add_child(row)


# ═════════════════════════════════════════════════════════════════════════════
# Buildings + the hover detail card
# ═════════════════════════════════════════════════════════════════════════════
func _building_cell(key: String, level: int) -> Control:
	var info: Array = BUILDINGS.get(key, ["workshop.png", key.capitalize(), ""])
	var cell := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 1, 0.06)
	sb.set_corner_radius_all(6)
	sb.content_margin_left = 3
	sb.content_margin_right = 3
	sb.content_margin_top = 3
	sb.content_margin_bottom = 3
	cell.add_theme_stylebox_override("panel", sb)
	cell.custom_minimum_size = Vector2(78, 0)
	cell.mouse_filter = Control.MOUSE_FILTER_STOP
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 1)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pic := _icon(_tex(SKETCH + str(info[0])), 56)
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var disabled := int((_tile.get("disabled_buildings") as Dictionary).get(key.capitalize(), 0)) if _tile.get("disabled_buildings") != null else 0
	if disabled > 0:
		pic.modulate = Color(0.45, 0.45, 0.45)
	v.add_child(pic)
	var nm := _label(str(info[1]), 11, Color.WHITE)
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(nm)
	var pips := _label(_pips(level), 12, GOLD)
	pips.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(pips)
	if disabled > 0:
		var d := _label("OFFLINE %dt" % disabled, 10, BAD)
		d.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(d)
	cell.add_child(v)
	cell.mouse_entered.connect(func(): _show_detail(key, level, cell))
	cell.mouse_exited.connect(_hide_detail)
	return cell


func _show_detail(key: String, level: int, cell: Control) -> void:
	_hide_detail()
	var info: Array = BUILDINGS.get(key, ["workshop.png", key.capitalize(), ""])
	var card := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = BG
	sb.border_color = BORDER
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(8)
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	sb.content_margin_top = 10
	sb.content_margin_bottom = 12
	card.add_theme_stylebox_override("panel", sb)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	v.custom_minimum_size = Vector2(250, 0)
	card.add_child(v)

	var pic := _icon(_tex(SKETCH + str(info[0])), 150)
	pic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(pic)
	v.add_child(_label(str(info[1]).to_upper() + "   " + _pips(level), 20, Color.WHITE))
	v.add_child(_label("Level %d  —  %s" % [level, _kind(key, level)], 13, DIM))
	if str(info[2]) != "":
		v.add_child(_label(str(info[2]), 14, Color(0.95, 0.95, 0.85)))

	var b = _building_node(key)
	var yields := HFlowContainer.new()
	yields.add_theme_constant_override("h_separation", 10)
	if b != null and str(_tile.tileOwner) == "USA":
		for k in ["Dollars", "Weapons", "Manpower", "Science", "Culture", "Food"]:
			var amt := float(b.get("totalBuilding" + k) if b.get("totalBuilding" + k) != null else 0)
			if absf(amt) >= 0.5:
				yields.add_child(_chip(k, amt, 22))
		var dfn := int(b.get("totalBuildingDefensiveness") if b.get("totalBuildingDefensiveness") != null else 0)
		if dfn > 0:
			yields.add_child(_text_chip("DEF +%d" % dfn, Color(0.8, 0.8, 0.85), 16))
		if yields.get_child_count() > 0:
			v.add_child(_label("PER TURN", 12, GOLD))
			v.add_child(yields)
	var spoil := _spoil_for(key)
	if str(_tile.tileOwner) != "USA" and not spoil.is_empty():
		v.add_child(_label("ON CAPTURE", 12, GOLD))
		var h := HFlowContainer.new()
		h.add_child(_chip(spoil[0], float(spoil[1]), 22, true, spoil[2] if spoil.size() > 2 else ""))
		v.add_child(h)
	if level < 3:
		v.add_child(_label("Upgrade to level %d for more." % (level + 1), 12, DIM))

	var host: Node = get_parent() if get_parent() != null else self
	host.add_child(card)
	_detail = card
	card.reset_size()
	var vp := get_viewport_rect().size
	var x := global_position.x + size.x + 10.0
	var y := clampf(cell.global_position.y - 40.0, 100.0, vp.y - card.size.y - 10.0)
	card.global_position = Vector2(minf(x, vp.x - card.size.x - 10.0), y)
	card.modulate.a = 0.0
	card.create_tween().tween_property(card, "modulate:a", 1.0, 0.08)


func _hide_detail() -> void:
	if _detail != null and is_instance_valid(_detail):
		_detail.queue_free()
	_detail = null


func _building_node(key: String):
	var list = _tile.get("tileBuildingsList")
	if list == null:
		return null
	for b in list:
		if is_instance_valid(b) and str(b.get("buildingType")).to_lower() == key.to_lower():
			return b
	return null


func _kind(key: String, level: int) -> String:
	# Tiers named the way the design doc describes building growth.
	var tiers := {
		"farm": ["Fields", "Farms", "Plantations"], "mine": ["Pit", "Mine", "Excavation"],
		"camp": ["Camp", "Logging Camp", "Timber Works"], "market": ["Stalls", "Market", "Exchange"],
		"forge": ["Smithy", "Forge", "Armory"], "barracks": ["Muster Yard", "Barracks", "Garrison"],
		"fortress": ["Stockade", "Fort", "Fortress"], "library": ["Reading Room", "Library", "Academy"],
		"courthouse": ["Magistrate", "Courthouse", "High Court"], "dock": ["Landing", "Dock", "Shipyard"],
		"granary": ["Silo", "Granary", "Depot"], "monument": ["Marker", "Monument", "Memorial"],
		"resort": ["Inn", "Resort", "Spa Town"],
	}
	var t: Array = tiers.get(key, [])
	if t.is_empty():
		return key.capitalize()
	return str(t[clampi(level - 1, 0, t.size() - 1)])


# ═════════════════════════════════════════════════════════════════════════════
# Economy reads
# ═════════════════════════════════════════════════════════════════════════════
func _tile_totals() -> Dictionary:
	var out := {"Dollars": 0.0, "Weapons": 0.0, "Manpower": 0.0, "Science": 0.0, "Culture": 0.0, "Food": 0.0, "Defense": 0}
	var list = _tile.get("tileBuildingsList")
	if list == null:
		return out
	for b in list:
		if not is_instance_valid(b):
			continue
		for k in ["Dollars", "Weapons", "Manpower", "Science", "Culture", "Food"]:
			var v = b.get("totalBuilding" + k)
			if v != null:
				out[k] += float(v)
		var d = b.get("totalBuildingDefensiveness")
		if d != null:
			out["Defense"] += int(d)
	return out


func _spoils() -> Array:
	# Same rules as world._on_tile_liberated, read off the world's constants.
	var out: Array = []
	if _world != null and _world.has_method("_is_tech_tile") and _world._is_tech_tile(_tile):
		out.append(["Science", 1, "Tech token"])
	for key in ["monument", "courthouse", "market", "forge", "barracks"]:
		var sp := _spoil_for(key)
		if not sp.is_empty() and int((_tile.buildings as Dictionary).get(key, 0)) > 0:
			out.append(sp)
	return out


func _spoil_for(key: String) -> Array:
	var cash := 300
	var weapons := 200
	var manpower := 1000
	if _world != null and _world.has_method("_is_tech_tile"):
		# world.gd's liberation cache constants (Object.get() can't see script consts)
		cash = int(_world.CACHE_CASH)
		weapons = int(_world.CACHE_WEAPONS)
		manpower = int(_world.CACHE_MANPOWER)
	match key:
		"monument": return ["Culture", 1, "Culture token"]
		"courthouse": return ["Magic", 3, "Spell tokens"]
		"market": return ["Dollars", cash, ""]
		"forge": return ["Weapons", weapons, ""]
		"barracks": return ["Manpower", manpower, ""]
	return []


# ═════════════════════════════════════════════════════════════════════════════
# Small widgets
# ═════════════════════════════════════════════════════════════════════════════
func _chip(res: String, amount: float, icon_px: int, plus_always: bool = false, caption: String = "") -> Control:
	var info: Array = RES.get(res, ["currency.png", Color.WHITE])
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 3)
	h.add_child(_icon(_tex(ICON + str(info[0])), icon_px))
	var sgn := "+" if amount > 0 or plus_always else ""
	var num := ("%d" % int(round(amount))) if absf(amount - round(amount)) < 0.05 else ("%.1f" % amount)
	if res == "Dollars":
		num = "$" + num.trim_prefix("-")
		if amount < 0:
			sgn = "-"
	var l := _label(sgn + num, int(icon_px * 0.72), info[1] if amount >= 0 else BAD)
	l.add_theme_constant_override("outline_size", 4)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	h.add_child(l)
	if caption != "":
		h.add_child(_label(caption, 12, DIM))
	return h


func _text_chip(txt: String, col: Color, px: int) -> Control:
	var l := _label(txt, px, col)
	l.add_theme_constant_override("outline_size", 4)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	return l


func _pill(txt: String, col: Color) -> Control:
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = col
	sb.set_corner_radius_all(9)
	sb.content_margin_left = 8
	sb.content_margin_right = 8
	sb.content_margin_top = 1
	sb.content_margin_bottom = 1
	p.add_theme_stylebox_override("panel", sb)
	p.add_child(_label(txt, 11, Color.WHITE))
	return p


func _medallion(tex: Texture2D, pos: Vector2, tip: String) -> Control:
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, 0.55)
	sb.border_color = BORDER
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(18)
	p.add_theme_stylebox_override("panel", sb)
	p.position = pos
	p.tooltip_text = tip
	var i := _icon(tex, 34)
	i.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(i)
	return p


func _icon(tex: Texture2D, px: int) -> TextureRect:
	var r := TextureRect.new()
	r.texture = tex
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.custom_minimum_size = Vector2(px, px)
	return r


func _label(txt: String, px: int, col: Color) -> Label:
	var l := Label.new()
	l.text = txt
	l.add_theme_font_size_override("font_size", px)
	l.add_theme_color_override("font_color", col)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


func _pips(level: int) -> String:
	var n := maxi(3, level)
	var s := ""
	for i in n:
		s += "●" if i < level else "○"
	return s


func _tex(path: String) -> Texture2D:
	if _tex_cache.has(path):
		return _tex_cache[path]
	var t: Texture2D = null
	if ResourceLoader.exists(path):
		t = load(path)
	_tex_cache[path] = t
	return t


func _terrain_file() -> String:
	var terr := str(_tile.terrain)
	var m := 7
	if _world != null and _world.get("month") != null:
		m = int(_world.month)
	var winter: bool = (m == 12 or m == 1 or m == 2) and int(_tile.get("winterScore") if _tile.get("winterScore") != null else 0) >= 40
	if winter and TERRAIN_WINTER.has(terr):
		return TERRAIN_WINTER[terr]
	return TERRAIN_ART.get(terr, "IMG_1422.PNG")


func _corruption_file(c: int) -> String:
	if c <= 25:
		return "CorruptionNo.png"
	if c <= 40:
		return "CorruptionLight.png"
	if c <= 60:
		return "CorruptionModerate.png"
	if c < 80:
		return "CorruptionHeavy.png"
	return "CorruptionTotal.png"
