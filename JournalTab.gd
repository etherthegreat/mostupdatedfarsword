extends Control
# ============================================================
# JournalTab — President Ualani Carlisle's classified memo log.
# Container-based layout (JournalTab.tscn) with parchment styling,
# an eagle-seal letterhead, dark ink, and a CLASSIFIED stamp that
# appears on secret-tier entries.
# ============================================================

const _CLASSIFICATION_COLORS := {
	"EYES ONLY":    Color(0.72, 0.10, 0.10),
	"TOP SECRET":   Color(0.72, 0.10, 0.10),
	"SECRET":       Color(0.78, 0.36, 0.0),
	"CONFIDENTIAL": Color(0.18, 0.34, 0.70),
	"DECLASSIFIED": Color(0.16, 0.45, 0.18),
}
const _STAMP_CLASSIFICATIONS := ["EYES ONLY", "TOP SECRET", "SECRET"]

const _LIB_SCHEME := "lib://"

const _PARCHMENT := Color(0.898, 0.847, 0.635)
const _INK       := Color(0.18, 0.14, 0.08)
const _INK_BOLD  := Color(0.11, 0.08, 0.04)

const _SEAL_TEX  := "res://art assets/PresidentialLibrary/eagle_seal_transparent.png"
const _STAMP_TEX := "res://art assets/PresidentialLibrary/classified_stamp.png"

const _P_LIST       := "HSplitContainer/EntryListScroll/EntryList"
const _P_LISTSCROLL := "HSplitContainer/EntryListScroll"
const _P_PANEL      := "HSplitContainer/MemoPanel"
const _P_CLASS      := "HSplitContainer/MemoPanel/MemoMargin/MemoVBox/LetterheadRow/HeaderTextVBox/ClassificationLabel"
const _P_DATE       := "HSplitContainer/MemoPanel/MemoMargin/MemoVBox/LetterheadRow/HeaderTextVBox/DateLabel"
const _P_SEAL       := "HSplitContainer/MemoPanel/MemoMargin/MemoVBox/LetterheadRow/SealMini"
const _P_SUBJECT    := "HSplitContainer/MemoPanel/MemoMargin/MemoVBox/SubjectLabel"
const _P_BODY       := "HSplitContainer/MemoPanel/MemoMargin/MemoVBox/MemoBody"
const _P_STAMP      := "HSplitContainer/MemoPanel/ClassifiedStamp"

var _selected_button: Button = null
var _current_entry_id: String = ""

func _ready() -> void:
	var body = get_node_or_null(_P_BODY)
	if body:
		body.meta_clicked.connect(_on_link_clicked)
		body.meta_hover_started.connect(_on_link_hover_start)
		body.meta_hover_ended.connect(_on_link_hover_end)
	_apply_parchment_style()
	_wire_art()
	buildSelf()

func _apply_parchment_style() -> void:
	var panel = get_node_or_null(_P_PANEL)
	if panel:
		var style := StyleBoxFlat.new()
		style.bg_color = _PARCHMENT
		style.border_width_left = 2
		style.border_width_top = 2
		style.border_width_right = 2
		style.border_width_bottom = 2
		style.border_color = Color(0.62, 0.50, 0.30)
		style.corner_radius_top_left = 4
		style.corner_radius_top_right = 4
		style.corner_radius_bottom_left = 4
		style.corner_radius_bottom_right = 4
		style.shadow_color = Color(0, 0, 0, 0.25)
		style.shadow_size = 6
		panel.add_theme_stylebox_override("panel", style)
	var date_lbl = get_node_or_null(_P_DATE)
	if date_lbl:
		date_lbl.add_theme_color_override("font_color", _INK)
	var subj_lbl = get_node_or_null(_P_SUBJECT)
	if subj_lbl:
		subj_lbl.add_theme_color_override("font_color", _INK_BOLD)
	var body_lbl = get_node_or_null(_P_BODY)
	if body_lbl:
		body_lbl.add_theme_color_override("default_color", _INK)

func _wire_art() -> void:
	var seal = get_node_or_null(_P_SEAL)
	if seal and ResourceLoader.exists(_SEAL_TEX):
		seal.texture = load(_SEAL_TEX)
	var stamp = get_node_or_null(_P_STAMP)
	if stamp:
		if ResourceLoader.exists(_STAMP_TEX):
			stamp.texture = load(_STAMP_TEX)
		stamp.visible = false

func buildSelf() -> void:
	_build_entry_list()
	if not LibraryData.journal_entries.is_empty():
		_show_entry(LibraryData.journal_entries[0])
	else:
		_show_empty_state()

func _build_entry_list() -> void:
	var list = get_node_or_null(_P_LIST)
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
		var e = entry
		btn.pressed.connect(func():
			_select_button(btn)
			_show_entry(e))
		list.add_child(btn)

func _select_button(btn: Button) -> void:
	if _selected_button:
		_selected_button.remove_theme_color_override("font_color")
		_selected_button.modulate = Color(1, 1, 1, 1)
	_selected_button = btn
	btn.add_theme_color_override("font_color", Color(0.85, 0.65, 0.15))
	btn.modulate = Color(1.0, 1.0, 0.9, 1.0)

func _show_entry(entry: Dictionary) -> void:
	_current_entry_id = entry.get("id", "")
	var class_lbl   = get_node_or_null(_P_CLASS)
	var date_lbl    = get_node_or_null(_P_DATE)
	var subject_lbl = get_node_or_null(_P_SUBJECT)
	var body_lbl    = get_node_or_null(_P_BODY)
	var stamp       = get_node_or_null(_P_STAMP)
	var classification: String = entry.get("classification", "DECLASSIFIED")
	var turn: int = entry.get("turn", 0)
	if class_lbl:
		class_lbl.text = classification
		var col: Color = _CLASSIFICATION_COLORS.get(classification, _INK)
		class_lbl.add_theme_color_override("font_color", col)
	if date_lbl:
		date_lbl.text = _turn_to_date_string(turn)
	if subject_lbl:
		subject_lbl.text = "RE: " + entry.get("title", "")
	if body_lbl:
		body_lbl.clear()
		body_lbl.append_text(entry.get("body", ""))
	if stamp:
		stamp.visible = classification in _STAMP_CLASSIFICATIONS

func _show_empty_state() -> void:
	var class_lbl   = get_node_or_null(_P_CLASS)
	var date_lbl    = get_node_or_null(_P_DATE)
	var subject_lbl = get_node_or_null(_P_SUBJECT)
	var body_lbl    = get_node_or_null(_P_BODY)
	var stamp       = get_node_or_null(_P_STAMP)
	if class_lbl:
		class_lbl.text = ""
	if date_lbl:
		date_lbl.text = ""
	if subject_lbl:
		subject_lbl.text = ""
	if body_lbl:
		body_lbl.clear()
		body_lbl.append_text("[i]No entries have been recorded yet.[/i]")
	if stamp:
		stamp.visible = false

func select_entry(entry_id: String) -> void:
	for entry in LibraryData.journal_entries:
		if entry.get("id", "") == entry_id:
			_show_entry(entry)
			_highlight_button_for(entry_id)
			return

func _highlight_button_for(entry_id: String) -> void:
	var list   = get_node_or_null(_P_LIST)
	var scroll = get_node_or_null(_P_LISTSCROLL)
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

func _on_link_clicked(meta: Variant) -> void:
	var uri := str(meta)
	if not uri.begins_with(_LIB_SCHEME):
		return
	var path := uri.substr(_LIB_SCHEME.length())
	var slash := path.find("/")
	var tab := path.substr(0, slash).to_upper() if slash >= 0 else path.to_upper()
	var entry_id := path.substr(slash + 1) if slash >= 0 else ""
	var panel := _get_library_panel()
	if panel:
		panel.navigate_to(tab, entry_id)

func _on_link_hover_start(meta: Variant) -> void:
	var body = get_node_or_null(_P_BODY)
	if body:
		var uri := str(meta)
		if uri.begins_with(_LIB_SCHEME):
			var label := uri.substr(_LIB_SCHEME.length()).replace("/", " > ")
			body.tooltip_text = "Open: " + label
		else:
			body.tooltip_text = uri

func _on_link_hover_end(_meta: Variant) -> void:
	var body = get_node_or_null(_P_BODY)
	if body:
		body.tooltip_text = ""

func _get_library_panel() -> Node:
	var n := get_parent()
	while n:
		if n.has_method("navigate_to"):
			return n
		n = n.get_parent()
	return null

func _turn_to_date_string(turn: int) -> String:
	var seasons := ["Spring", "Summer", "Autumn", "Winter"]
	var year := 1782 + (turn / 4)
	var season = seasons[turn % 4]
	var ordinal := _year_ordinal(year - 1781)
	return "%s %d  -  Year %s of the Carlisle Administration" % [season, year, ordinal]

func _year_ordinal(n: int) -> String:
	match n:
		1: return "One"
		2: return "Two"
		3: return "Three"
		4: return "Four"
		5: return "Five"
		_: return str(n)
