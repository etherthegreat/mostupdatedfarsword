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

func _ready() -> void:
	buildSelf()

func buildSelf() -> void:
	_build_entry_list()
	# Show the most recent entry (index 0) by default if any exist
	if not LibraryData.journal_entries.is_empty():
		_show_entry(LibraryData.journal_entries[0])
	else:
		_show_empty_state()

func _build_entry_list() -> void:
	var list = get_node_or_null("HSplitContainer/EntryListScroll/EntryList")
	if not list:
		return
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()

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
		btn.pressed.connect(_show_entry.bind(entry))
		list.add_child(btn)

func _show_entry(entry: Dictionary) -> void:
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

func _turn_to_date_string(turn: int) -> String:
	# Each turn is a season; 4 turns = 1 year starting 1782
	var seasons := ["Spring", "Summer", "Autumn", "Winter"]
	var year    := 1782 + (turn / 4)
	var season  := seasons[turn % 4]
	var ordinal := _year_ordinal(year - 1781)   # year of administration
	return "%s %d  ·  Year %s of the Carlisle Administration" % [season, year, ordinal]

func _year_ordinal(n: int) -> String:
	match n:
		1: return "One"
		2: return "Two"
		3: return "Three"
		4: return "Four"
		5: return "Five"
		_: return str(n)
