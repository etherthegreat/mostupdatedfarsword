extends Control

var playerNode
var investmentTech: techButton
var nextTechChange: int = 0

# Row label | Col1 | Col2 | Col3 | Col4
const TECH_ROWS := [
	["SABRE",    "Swordsmanship",    "Cavalry Drills",   "Officer Training",     "Marine Discipline"],
	["RIFLES",   "Musket Drilling",  "Volley Tactics",   "Percussion Ignition",  "Repeating Mechanisms"],
	["ARTILLERY","Field Gunnery",    "Siege Works",      "Explosive Charges",    "Rocket Artillery"],
	["CIVILIAN", "Agrarian Reform",  "Trade Networks",   "Industrialization",    "Infrastructure"],
	["DEFENSE",  "Organization",     "Logistics",        "Tactics",              "Authority"],
]

const TECH_COSTS := [40, 100, 250, 500]

var _buttons: Dictionary = {}  # techName -> techButton node

signal addTechToPlayer
signal investmentChanged

func buildSelf(player) -> void:
	playerNode = player
	_build_grid()
	_connect_signals()
	_mark_purchased(player)


func _build_grid() -> void:
	_buttons.clear()
	var grid := $TechPanel/GridContainer
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	var button_scene := load("res://tech_unlock_button.tscn")

	for row_idx in range(TECH_ROWS.size()):
		var row_data: Array = TECH_ROWS[row_idx]
		var row_label_text: String = row_data[0]

		# Column 0: row label
		var lbl := Label.new()
		lbl.text = row_label_text
		lbl.add_theme_font_size_override("font_size", 14)
		lbl.add_theme_color_override("font_color", Color(0.95, 0.88, 0.62, 1))
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		lbl.custom_minimum_size = Vector2(120, 0)
		grid.add_child(lbl)

		var row_btns: Array[techButton] = []

		for col_idx in range(1, 5):
			var tech_name: String = row_data[col_idx]
			var cost: int = TECH_COSTS[col_idx - 1]

			var btn: techButton = button_scene.instantiate()
			btn.techID = tech_name
			btn.techCost = cost

			# Each tech requires only the previous one in the same row
			if col_idx > 1:
				btn.reqTechs = [row_btns[col_idx - 2]]

			grid.add_child(btn)
			row_btns.append(btn)
			_buttons[tech_name] = btn

func _mark_purchased(player) -> void:
	for tech in player.unlockedTechnologies:
		if tech.techName in _buttons:
			_buttons[tech.techName].purchased = true
	_refresh_all()

func _connect_signals() -> void:
	for btn in _buttons.values():
		btn.selectInvestment.connect(selectInvestmentFunc)
		btn.newTech.connect(unlockTech)

func _refresh_all() -> void:
	for btn in _buttons.values():
		btn.refresh_visual()

func unlockTech(techID: String, techButt: techButton, change: int) -> void:
	nextTechChange = change
	techButt.purchased = true
	emit_signal("addTechToPlayer", techID)
	investmentTech = null
	emit_signal("investmentChanged")
	_refresh_all()

func selectInvestmentFunc(techbutt: techButton) -> void:
	investmentTech = techbutt
	emit_signal("investmentChanged")
	if nextTechChange > 0:
		investInTech(nextTechChange)
		nextTechChange = 0
	self.visible = false

func investInTech(science: int) -> void:
	investmentTech.addScienceInvestment(science)

func _on_close_button_pressed() -> void:
	self.visible = false

func _on_purchase_tech_button_pressed() -> void:
	pass

func _on_close_panel_button_pressed() -> void:
	$TechInfoPanel.visible = false
