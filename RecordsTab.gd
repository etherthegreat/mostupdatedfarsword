extends Control
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# RecordsTab (Control)
# └── HSplitContainer (split ~25% / 75%)
#     ├── CategoryScroll (ScrollContainer, left panel)
#     │   └── CategoryList (VBoxContainer)
#     │       # category buttons injected here at runtime
#     └── EntryPanel (VBoxContainer, right panel, inside ScrollContainer)
#         ├── EntryHeader (HBoxContainer)
#         │   ├── EntryIcon  (TextureRect, 64x64)
#         │   └── EntryMeta  (VBoxContainer)
#         │       ├── EntryName     (Label, bold, large)
#         │       └── EntryCategory (Label, italic, smaller)
#         ├── Divider    (HSeparator)
#         ├── EntryBody  (RichTextLabel, bbcode on, scroll_active=false,
#         │               fit_content=true, autowrap=true)
#         └── SeeAlsoBox (HBoxContainer, hidden when empty)
#             ├── SeeAlsoLabel (Label, "See also:")
#             └── SeeAlsoLinks (HBoxContainer)
#                 # link buttons injected at runtime
# ============================================================

var _current_category: String = ""

func _ready() -> void:
	buildSelf()

func buildSelf() -> void:
	_build_category_list()
	# Show first non-empty category by default
	if not RecordsDatabase.CATEGORIES.is_empty():
		_select_category(RecordsDatabase.CATEGORIES[0])

func _build_category_list() -> void:
	var list = get_node_or_null("HSplitContainer/CategoryScroll/CategoryList")
	if not list:
		return
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()

	for cat in RecordsDatabase.CATEGORIES:
		var btn := Button.new()
		btn.text = cat
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.pressed.connect(_select_category.bind(cat))
		list.add_child(btn)

func _select_category(category: String) -> void:
	_current_category = category
	var entries := RecordsDatabase.get_category_entries(category)
	# For now show first entry of the category; later could show a sub-list
	if not entries.is_empty():
		_show_entry(entries[0])

func _show_entry(entry: Dictionary) -> void:
	var is_mystery: bool  = entry.get("is_mystery", false)
	var is_unlocked: bool = not is_mystery or LibraryData.is_discovered(entry.get("unlock_flag", ""))

	var name_lbl  = get_node_or_null("HSplitContainer/EntryScroll/EntryPanel/EntryHeader/EntryMeta/EntryName")
	var cat_lbl   = get_node_or_null("HSplitContainer/EntryScroll/EntryPanel/EntryHeader/EntryMeta/EntryCategory")
	var icon_rect = get_node_or_null("HSplitContainer/EntryScroll/EntryPanel/EntryHeader/EntryIcon")
	var body_lbl  = get_node_or_null("HSplitContainer/EntryScroll/EntryPanel/EntryBody")
	var see_box   = get_node_or_null("HSplitContainer/EntryScroll/EntryPanel/SeeAlsoBox")
	var see_links = get_node_or_null("HSplitContainer/EntryScroll/EntryPanel/SeeAlsoBox/SeeAlsoLinks")

	if name_lbl:
		name_lbl.text = "???" if (is_mystery and not is_unlocked) else entry.get("name", "")
	if cat_lbl:
		cat_lbl.text = entry.get("category", "")
	if icon_rect:
		var ipath: String = entry.get("icon_path", "")
		if ipath != "" and ResourceLoader.exists(ipath):
			icon_rect.texture = load(ipath)
		else:
			icon_rect.texture = null
	if body_lbl:
		if is_mystery and not is_unlocked:
			body_lbl.clear()
			body_lbl.append_text("[i]" + entry.get("description", "") + "[/i]")
		else:
			body_lbl.clear()
			body_lbl.append_text(entry.get("description", ""))

	# See also links
	if see_links:
		for child in see_links.get_children():
			see_links.remove_child(child)
			child.queue_free()
		var see_also: Array = entry.get("see_also", [])
		if see_box:
			see_box.visible = not see_also.is_empty()
		for related_id in see_also:
			var related := RecordsDatabase.get_entry(related_id)
			if related.is_empty():
				continue
			var link_btn := Button.new()
			link_btn.text = related.get("name", related_id)
			link_btn.flat = true
			link_btn.pressed.connect(_show_entry.bind(related))
			see_links.add_child(link_btn)

# ── wikilink processing ──────────────────────────────────────────────────────

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
			var label  = linked.get("name", entry_id) if not linked.is_empty() else entry_id
			result += "[url=" + entry_id + "]" + label + "[/url]"
			i = close + 2
		else:
			result += text[i]
			i += 1
	return result

func _on_body_link_clicked(meta) -> void:
	select_entry(str(meta))

# ── external navigation ───────────────────────────────────────────────────────

func select_entry(entry_id: String) -> void:
	var entry := RecordsDatabase.get_entry(entry_id)
	if entry.is_empty():
		return
	var category: String = entry.get("category", "")
	if category != _current_category:
		_select_category_button(category)
		_current_category = category
	_show_entry(entry)

func _select_category_button(category: String) -> void:
	var list = get_node_or_null("HSplitContainer/CategoryScroll/CategoryList")
	if not list:
		return
	for btn in list.get_children():
		if btn is Button and btn.text == category:
			btn.emit_signal("pressed")
			return
