extends Control
# ============================================================
# RecordsTab — Civilopedia / how-to-play guide.
# Three panes: Categories | Entries in category | Entry detail.
# Ungated: every entry is always visible (no mystery/lock checks).
# ============================================================

const _P_CATLIST   := "Main/CategoryScroll/CategoryList"
const _P_ENTRYLIST := "Main/EntryScroll/EntryList"
const _P_ICON      := "Main/DetailPanel/DetailMargin/DetailVBox/DetailHeader/EntryIcon"
const _P_NAME      := "Main/DetailPanel/DetailMargin/DetailVBox/DetailHeader/HeaderText/EntryName"
const _P_CAT       := "Main/DetailPanel/DetailMargin/DetailVBox/DetailHeader/HeaderText/EntryCategory"
const _P_BODY      := "Main/DetailPanel/DetailMargin/DetailVBox/EntryBody"
const _P_SEEBOX    := "Main/DetailPanel/DetailMargin/DetailVBox/SeeAlsoBox"
const _P_SEELINKS  := "Main/DetailPanel/DetailMargin/DetailVBox/SeeAlsoBox/SeeAlsoLinks"

const _SEL := Color(0.85, 0.65, 0.15)

var _current_category: String = ""
var _selected_cat_btn: Button = null
var _selected_entry_btn: Button = null

func _ready() -> void:
	var body = get_node_or_null(_P_BODY)
	if body:
		body.meta_clicked.connect(_on_meta_clicked)
	buildSelf()

func buildSelf() -> void:
	_build_category_list()
	if not RecordsDatabase.CATEGORIES.is_empty():
		_select_category(RecordsDatabase.CATEGORIES[0])

func _build_category_list() -> void:
	var list = get_node_or_null(_P_CATLIST)
	if not list:
		return
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()
	_selected_cat_btn = null
	for cat in RecordsDatabase.CATEGORIES:
		var count: int = RecordsDatabase.get_category_entries(cat).size()
		var btn := Button.new()
		btn.text = "%s  (%d)" % [cat, count]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.custom_minimum_size = Vector2(0, 34)
		btn.set_meta("cat", cat)
		var c = cat
		btn.pressed.connect(func(): _select_category(c))
		list.add_child(btn)

func _select_category(category: String) -> void:
	_current_category = category
	if _selected_cat_btn:
		_selected_cat_btn.remove_theme_color_override("font_color")
		_selected_cat_btn = null
	var cbtn := _find_meta_button(get_node_or_null(_P_CATLIST), "cat", category)
	if cbtn:
		_selected_cat_btn = cbtn
		cbtn.add_theme_color_override("font_color", _SEL)
	_build_entry_list(category)

func _build_entry_list(category: String) -> void:
	var list = get_node_or_null(_P_ENTRYLIST)
	if not list:
		return
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()
	_selected_entry_btn = null
	var entries := RecordsDatabase.get_category_entries(category)
	if entries.is_empty():
		var lbl := Label.new()
		lbl.text = "(No entries written yet)"
		lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		list.add_child(lbl)
		_clear_detail()
		return
	for entry in entries:
		var btn := Button.new()
		btn.text = str(entry.get("name", "???"))
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.custom_minimum_size = Vector2(0, 30)
		btn.set_meta("eid", str(entry.get("id", "")))
		var e = entry
		btn.pressed.connect(func(): _select_entry(e))
		list.add_child(btn)
	_select_entry(entries[0])

func _select_entry(entry: Dictionary) -> void:
	if _selected_entry_btn:
		_selected_entry_btn.remove_theme_color_override("font_color")
		_selected_entry_btn = null
	var ebtn := _find_meta_button(get_node_or_null(_P_ENTRYLIST), "eid", str(entry.get("id", "")))
	if ebtn:
		_selected_entry_btn = ebtn
		ebtn.add_theme_color_override("font_color", _SEL)
	_show_entry(entry)

func _show_entry(entry: Dictionary) -> void:
	var name_lbl = get_node_or_null(_P_NAME)
	var cat_lbl  = get_node_or_null(_P_CAT)
	var icon     = get_node_or_null(_P_ICON)
	var body     = get_node_or_null(_P_BODY)
	var seebox   = get_node_or_null(_P_SEEBOX)
	var seelinks = get_node_or_null(_P_SEELINKS)
	if name_lbl:
		name_lbl.text = str(entry.get("name", ""))
	if cat_lbl:
		cat_lbl.text = str(entry.get("category", ""))
	if icon:
		var ip: String = str(entry.get("icon_path", ""))
		if ip != "" and ResourceLoader.exists(ip):
			icon.texture = load(ip)
			icon.visible = true
		else:
			icon.texture = null
			icon.visible = false
	if body:
		body.clear()
		body.append_text(_process_wikilinks(str(entry.get("description", ""))))
	if seelinks:
		for child in seelinks.get_children():
			seelinks.remove_child(child)
			child.queue_free()
		var see_also: Array = entry.get("see_also", [])
		if seebox:
			seebox.visible = not see_also.is_empty()
		for rid in see_also:
			var rel := RecordsDatabase.get_entry(rid)
			if rel.is_empty():
				continue
			var link := Button.new()
			link.text = str(rel.get("name", rid))
			link.flat = true
			link.add_theme_color_override("font_color", Color(0.44, 0.66, 0.86))
			var rid2 = rid
			link.pressed.connect(func(): select_entry(rid2))
			seelinks.add_child(link)

func _clear_detail() -> void:
	var name_lbl = get_node_or_null(_P_NAME)
	var cat_lbl  = get_node_or_null(_P_CAT)
	var icon     = get_node_or_null(_P_ICON)
	var body     = get_node_or_null(_P_BODY)
	var seebox   = get_node_or_null(_P_SEEBOX)
	if name_lbl:
		name_lbl.text = ""
	if cat_lbl:
		cat_lbl.text = ""
	if icon:
		icon.texture = null
		icon.visible = false
	if body:
		body.clear()
	if seebox:
		seebox.visible = false

func select_entry(entry_id: String) -> void:
	var entry := RecordsDatabase.get_entry(entry_id)
	if entry.is_empty():
		return
	var category: String = str(entry.get("category", ""))
	if category != _current_category:
		_select_category(category)
	_select_entry(entry)

func _on_meta_clicked(meta: Variant) -> void:
	select_entry(str(meta))

func _process_wikilinks(text: String) -> String:
	var result := ""
	var i := 0
	while i < text.length():
		if i + 1 < text.length() and text.substr(i, 2) == "[[":
			var close := text.find("]]", i + 2)
			if close == -1:
				result += text.substr(i)
				break
			var entry_id := text.substr(i + 2, close - i - 2)
			var linked := RecordsDatabase.get_entry(entry_id)
			var label := str(linked.get("name", entry_id)) if not linked.is_empty() else entry_id
			result += "[url=" + entry_id + "][color=6fa8dc]" + label + "[/color][/url]"
			i = close + 2
		else:
			result += text[i]
			i += 1
	return result

func _find_meta_button(list, key: String, value: String) -> Button:
	if not list:
		return null
	for c in list.get_children():
		if c is Button and c.has_meta(key) and str(c.get_meta(key)) == value:
			return c
	return null
