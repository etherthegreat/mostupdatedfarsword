extends Control
# ============================================================
# SCENE STRUCTURE (build in Godot editor):
#
# EconomicLedger (Control, fullscreen overlay or large panel)
# ├── DarkOverlay  (ColorRect, full screen, rgba 0,0,0,0.75)
# └── LedgerPanel  (Panel, ~900x700, centered)
#     ├── TitleBar  (HBoxContainer)
#     │   ├── TitleLabel   (Label, "ECONOMIC LEDGER", bold)
#     │   └── CloseButton  (Button, "✕")
#     └── TabContainer  (fills rest of LedgerPanel)
#         # Tabs injected at runtime by buildSelf()
# ============================================================

const RESOURCES := [
	{"key": "food",       "label": "Food",       "income": "FPM", "expense": "foodEXPM",       "tile_field": "buildingFoodOutput"},
	{"key": "wood",       "label": "Wood",       "income": "WPM", "expense": "woodEXPM",       "tile_field": "buildingWoodOutput"},
	{"key": "metal",      "label": "Metal",      "income": "MPM", "expense": "metalEXPM",      "tile_field": "buildingMetalOutput"},
	{"key": "weapons",    "label": "Weapons",    "income": "PPM", "expense": "weaponsEXPM",    "tile_field": "buildingWeaponsOutput"},
	{"key": "dollars",    "label": "Currency",   "income": "DPM", "expense": "dollarsEXPM",    "tile_field": "buildingDollarsOutput"},
	{"key": "magic",      "label": "Magic",      "income": "APM", "expense": "magicEXPM",      "tile_field": "buildingMagicOutput"},
	{"key": "culture",    "label": "Culture",    "income": "CPM", "expense": "cultureEXPM",    "tile_field": "buildingCultureOutput"},
	{"key": "manpower",   "label": "Manpower",   "income": "MAN", "expense": "manpowerEXPM",   "tile_field": "buildingManpowerOutput"},
	{"key": "happiness",  "label": "Happiness",  "income": "HPM", "expense": "happinessEXPM",  "tile_field": "buildingHappinessOutput"},
	{"key": "mandate",    "label": "Mandate",    "income": "NDT", "expense": "mandateEXPM",    "tile_field": "buildingMandateOutput"},
]

var playerNode: country = null

func buildSelf(playerCountryNode: country) -> void:
	playerNode = playerCountryNode
	var tabs := get_node_or_null("LedgerPanel/TabContainer")
	if not tabs:
		return

	# Clear existing tabs
	for child in tabs.get_children():
		tabs.remove_child(child)
		child.queue_free()

	_build_overview_tab(tabs)
	for res in RESOURCES:
		_build_resource_tab(tabs, res)

# ── Overview tab ──────────────────────────────────────────────────────────────

func _build_overview_tab(tabs: TabContainer) -> void:
	var scroll := ScrollContainer.new()
	scroll.name = "Overview"
	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vbox)
	tabs.add_child(scroll)

	# Header row
	vbox.add_child(_header_row(["Resource", "Income / turn", "Expense / turn", "Net"]))
	vbox.add_child(HSeparator.new())

	for res in RESOURCES:
		var income  : int = playerNode.get(res["income"])  if playerNode.get(res["income"])  != null else 0
		var expense : int = playerNode.get(res["expense"]) if playerNode.get(res["expense"]) != null else 0
		var net     : int = income - expense
		var color   : Color = Color.GREEN if net >= 0 else Color.RED
		vbox.add_child(_data_row([
			res["label"],
			str(income),
			str(expense),
			_colored(str(net), color),
		]))

# ── Per-resource tab ──────────────────────────────────────────────────────────

func _build_resource_tab(tabs: TabContainer, res: Dictionary) -> void:
	var scroll := ScrollContainer.new()
	scroll.name = res["label"]
	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vbox)
	tabs.add_child(scroll)

	vbox.add_child(_header_row(["Tile", "Output / turn"]))
	vbox.add_child(HSeparator.new())

	var total := 0
	for tile in playerNode.OwnedTileList:
		var output: int = int(tile.get(res["tile_field"])) if tile.get(res["tile_field"]) != null else 0
		if output == 0:
			continue
		total += output
		vbox.add_child(_data_row([tile.tileName, str(output)]))

	vbox.add_child(HSeparator.new())
	vbox.add_child(_data_row(["TOTAL", str(total)], true))

# ── UI helpers ────────────────────────────────────────────────────────────────

func _header_row(cols: Array) -> HBoxContainer:
	return _make_row(cols, Color(0.85, 0.85, 0.85, 1.0), true)

func _data_row(cols: Array, bold: bool = false) -> HBoxContainer:
	return _make_row(cols, Color.WHITE, bold)

func _make_row(cols: Array, color: Color, bold: bool) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for col in cols:
		var lbl := RichTextLabel.new()
		lbl.bbcode_enabled = true
		lbl.fit_content = true
		lbl.scroll_active = false
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.add_theme_color_override("default_color", color)
		if bold:
			lbl.append_text("[b]" + str(col) + "[/b]")
		else:
			lbl.append_text(str(col))
		row.add_child(lbl)
	return row

func _colored(text: String, color: Color) -> String:
	var hex := color.to_html(false)
	return "[color=#" + hex + "]" + text + "[/color]"

# ── close button ─────────────────────────────────────────────────────────────

func _on_close_button_pressed() -> void:
	visible = false
