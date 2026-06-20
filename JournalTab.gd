extends Control
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# JournalTab (Control)
# └── HSplitContainer (split ~30% / 70%)
#     ├── EntryListScroll (ScrollContainer, left panel)
#     │   └── EntryList (VBoxContainer)
#     │       # entry buttons injected at runtime
#     └── MemoPanel (Panel, right panel, "parchment/paper" texture recommended)
#         ├── ClassificationLabel  (Label, bold caps, color=red-ish)
#         ├── DateLabel            (Label, italic, small)
#         ├── SubjectLabel         (Label, bold, "RE: ...")
#         ├── Divider              (HSeparator)
#         └── MemoBody             (RichTextLabel, bbcode on,
#                                   scroll_active=true, fit_content=false)
# ============================================================

const _CLASSIFICATION_COLORS := {
	"EYES ONLY":    Color(0.8, 0.1, 0.1),
	"TOP SECRET":   Color(0.8, 0.1, 0.1),
	"SECRET":       Color(0.85, 0.4, 0.0),
	"CONFIDENTIAL": Color(0.2, 0.4, 0.8),
	"DECLASSIFIED": Color(0.2, 0.6, 0.2),
}

# URI scheme: lib://tab/entry_id  e.g. lib://records/FACTION_001
const _LIB_SCHEME := "lib://"

var _selected_button: Button = null
var _current_entry_id: String = ""

func _ready() -> void:
	var body = get_node_or_null("HSplitContainer/MemoPanel/MemoBody")
	if body:
		body.meta_clicked.connect(_on_link_clicked)
		body.meta_hover_started.connect(_on_link_hover_start)
		body.meta_hover_ended.connect(_on_link_hover_end)
	_apply_parchment_style()
	buildSelf()

func _apply_parchment_style() -> void:
	var panel = get_node_or_null("HSplitContainer/MemoPanel")
	if not panel:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.96, 0.92, 0.80)
	style.border_width_left   = 2
	style.border_width_top    = 2
	style.border_width_right  = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.70, 0.58, 0.38)
	style.corner_radius_top_left     = 4
	style.corner_radius_top_right    = 4
	style.corner_radius_bottom_left  = 4
	style.corner_radius_bottom_right = 4
	panel.add_theme_stylebox_override("panel", style)

func buildSelf() -> void:
	_build_entry_list()
	if not LibraryData.journal_entries.is_empty():
		_show_entry(LibraryData.journal_entries[0])
	else:
		_show_empty_state()

# ── entry list ────────────────────────────────────────────────────────────────

func _build_entry_list() -> void:
	var list = get_node_or_null("HSplitContainer/EntryListScroll/EntryList")
	if not list:
		return
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()
	_selected_button = null

	if LibraryData.journal_entries.is_empty():
		var empty_lbl := Label.new()
		empty_lbl.text = "No entries yet."
		empty_lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		list.add_child(empty_lbl)
		return

	for entry in LibraryData.journal_entries:
		var btn := Button.new()
		btn.text = "[Turn %d]  %s" % [entry.get("turn", 0), entry.get("title", "")]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.custom_minimum_size = Vector2(0, 40)
		var e := entry  # capture for closure
		btn.pressed.connect(func():
			_select_button(btn)
			_show_entry(e))
		list.add_child(btn)

func _select_button(btn: Button) -> void:
	if _selected_button:
		_selected_button.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
		_selected_button.modulate = Color(1, 1, 1, 1)
	_selected_button = btn
	btn.add_theme_color_override("font_color", Color(0.95, 0.80, 0.30))
	btn.modulate = Color(1.0, 1.0, 0.9, 1.0)

# ── memo panel ────────────────────────────────────────────────────────────────

func _show_entry(entry: Dictionary) -> void:
	_current_entry_id = entry.get("id", "")
	var class_lbl   = get_node_or_null("HSplitContainer/MemoPanel/ClassificationLabel")
	var date_lbl    = get_node_or_null("HSplitContainer/MemoPanel/DateLabel")
	var subject_lbl = get_node_or_null("HSplitContainer/MemoPanel/SubjectLabel")
	var body_lbl    = get_node_or_null("HSplitContainer/MemoPanel/MemoBody")

	var classification := entry.get("classification", "DECLASSIFIED")
	var turn           := entry.get("turn", 0)

	if class_lbl:
		class_lbl.text = classification
		var col := _CLASSIFICATION_COLORS.get(classification, Color.WHITE)
		class_lbl.add_theme_color_override("font_color", col)
	if date_lbl:
		date_lbl.text = _turn_to_date_string(turn)
	if subject_lbl:
		subject_lbl.text = "RE: " + entry.get("title", "")
	if body_lbl:
		body_lbl.clear()
		body_lbl.append_text(entry.get("body", ""))

func _show_empty_state() -> void:
	var body_lbl = get_node_or_null("HSplitContainer/MemoPanel/MemoBody")
	if body_lbl:
		body_lbl.clear()
		body_lbl.append_text("[i]No entries have been recorded yet.[/i]")

# ── external navigation ───────────────────────────────────────────────────────

func select_entry(entry_id: String) -> void:
	for entry in LibraryData.journal_entries:
		if entry.get("id", "") == entry_id:
			_show_entry(entry)
			_highlight_button_for(entry_id)
			return

func _highlight_button_for(entry_id: String) -> void:
	var list   = get_node_or_null("HSplitContainer/EntryListScroll/EntryList")
	var scroll = get_node_or_null("HSplitContainer/EntryListScroll")
	if not list:
		return
	var idx := 0
	for entry in LibraryData.journal_entries:
		if entry.get("id", "") == entry_id:
			var btn = list.get_child(idx) as Button
			if btn:
				_select_button(btn)
				if scroll:
					scroll.ensure_control_visible(btn)
			return
		idx += 1

# ── hyperlink handling ────────────────────────────────────────────────────────

func _on_link_clicked(meta: Variant) -> void:
	var uri := str(meta)
	if not uri.begins_with(_LIB_SCHEME):
		return
	var path := uri.substr(_LIB_SCHEME.length())   # e.g. "records/FACTION_001"
	var slash := path.find("/")
	var tab      := path.substr(0, slash).to_upper() if slash >= 0 else path.to_upper()
	var entry_id := path.substr(slash + 1)          if slash >= 0 else ""
	var panel := _get_library_panel()
	if panel:
		panel.navigate_to(tab, entry_id)

func _on_link_hover_start(meta: Variant) -> void:
	var body = get_node_or_null("HSplitContainer/MemoPanel/MemoBody")
	if body:
		var uri := str(meta)
		if uri.begins_with(_LIB_SCHEME):
			var label := uri.substr(_LIB_SCHEME.length()).replace("/", " → ")
			body.hint_tooltip = "Open: " + label
		else:
			body.hint_tooltip = uri

func _on_link_hover_end(_meta: Variant) -> void:
	var body = get_node_or_null("HSplitContainer/MemoPanel/MemoBody")
	if body:
		body.hint_tooltip = ""

# ── helpers ───────────────────────────────────────────────────────────────────

func _get_library_panel() -> Node:
	var n := get_parent()
	while n:
		if n.has_method("navigate_to"):
			return n
		n = n.get_parent()
	return null

func _turn_to_date_string(turn: int) -> String:
	var seasons := ["Spring", "Summer", "Autumn", "Winter"]
	var year    := 1782 + (turn / 4)
	var season  := seasons[turn % 4]
	var ordinal := _year_ordinal(year - 1781)
	return "%s %d  ·  Year %s of the Carlisle Administration" % [season, year, ordinal]

func _year_ordinal(n: int) -> String:
	match n:
		1: return "One"
		2: return "Two"
		3: return "Three"
		4: return "Four"
		5: return "Five"
		_: return str(n)
