extends CanvasLayer


var playerNode

func assignPlayerNode(playerCountryNode):
	playerNode = playerCountryNode

func closeAllPanels() -> void:
	$TileInfoPanel.visible = false
	$BuildingInfoPanel.visible = false
	$BeliefControl.visible = false
	$TechTree.visible = false
	$SpellSchoolsControl.visible = false
	$Spellbook.visible = false
	$MilitaryPanelControl.visible = false
	$FactionControl.visible = false
	$GovernmentControl.visible = false
	$TraditionsControl.visible = false
	$WarRoomPanel.visible = false
	$ResourceInfoControl.visible = false
	$ArmyPanel.visible = false
	$CivilianControl.visible = false
	$CivilianUnitControl.visible = false
	# One panel at a time: the code-built cards and screens (army card, tile card,
	# contracts, workers, sites ...) close with everything else.
	var w = get_parent()
	if w != null and w.has_method("_close_code_panels"):
		w._close_code_panels(keep_code_panel)


# ── CLICK SHIELDS ────────────────────────────────────────────────────────────
# Most of these panels are a 40x40 root with sprites laid over the map, so nothing
# stopped a click from reaching the tiles and tokens underneath. Each one now gets an
# invisible shield, sized to whatever the panel is showing, that swallows the mouse.
# A panel that covers most of the screen shields all of it.
const SHIELDED_PANELS := ["TileInfoPanel", "BuildingInfoPanel", "BeliefControl", "TechTree",
	"SpellSchoolsControl", "Spellbook", "MilitaryPanelControl", "FactionControl",
	"GovernmentControl", "TraditionsControl", "WarRoomPanel", "ResourceInfoControl",
	"ArmyPanel", "CivilianControl", "CivilianUnitControl", "EventControl",
	"EndingSceneControl", "GameOverPanel"]
const SHIELD_FULLSCREEN_SHARE := 0.55
var keep_code_panel: String = ""   # set by world._close_all_panels while one code panel is opening
var _shields: Dictionary = {}
var _shield_t: float = 0.0


func _install_click_shields() -> void:
	for nm in SHIELDED_PANELS:
		var pn = get_node_or_null(nm)
		if pn == null or not (pn is Control) or _shields.has(nm):
			continue
		var sh := Control.new()
		sh.name = "ClickShield"
		sh.mouse_filter = Control.MOUSE_FILTER_STOP
		sh.visible = false
		pn.add_child(sh)
		pn.move_child(sh, 0)   # first child: under the panel's own buttons, over the map
		_shields[nm] = sh
		pn.visibility_changed.connect(_fit_shield.bind(nm), CONNECT_DEFERRED)   # fit at once when it opens


func _fit_shield(nm: String) -> void:
	var pn = get_node_or_null(nm)
	var sh = _shields.get(nm)
	if pn == null or sh == null or not is_instance_valid(sh):
		return
	if not pn.is_visible_in_tree():
		sh.visible = false
		return
	var vp := Rect2(Vector2.ZERO, get_viewport().get_visible_rect().size)
	var r := Rect2()
	var any := false
	var stack: Array = pn.get_children()
	while not stack.is_empty():
		var c = stack.pop_back()
		if c == sh or not (c is CanvasItem) or not c.visible:
			continue
		var cr := Rect2()
		if c is Control:
			cr = c.get_global_rect()
		elif c is Sprite2D and c.texture != null:
			cr = c.get_global_transform() * c.get_rect()
		if cr.size.x > 4.0 and cr.size.y > 4.0:
			cr = cr.intersection(vp)
			if cr.has_area():
				r = r.merge(cr) if any else cr
				any = true
		if not (c is ScrollContainer):   # a scroll list is clipped to its own rect
			stack.append_array(c.get_children())
	if not any:
		sh.visible = false
		return
	r = vp if r.get_area() >= vp.get_area() * SHIELD_FULLSCREEN_SHARE else r.grow(6.0).intersection(vp)
	var inv: Transform2D = pn.get_global_transform().affine_inverse()
	sh.position = inv * r.position
	sh.size = r.size * inv.get_scale()
	sh.visible = true


func _process(delta: float) -> void:
	_shield_t += delta
	if _shield_t < 0.15:
		return
	_shield_t = 0.0
	if _shields.is_empty():
		_install_click_shields()
	for nm in _shields:
		_fit_shield(nm)

func _on_tech_tree_button_pressed() -> void:
	if $TechTree.visible:
		$TechTree.visible = false
	else:
		closeAllPanels()
		$TechTree.visible = true


func _on_close_button_pressed() -> void:
	$TechTree.visible = false


func _on_spell_book_button_pressed() -> void:
	$Spellbook.displaySpells(playerNode)
	if $Spellbook.visible:
		$Spellbook.visible = false
	else:
		closeAllPanels()
		$Spellbook.visible = true


func _on_close_spellbook_pressed() -> void:
	$Spellbook.visible = false

signal beliefUpdate
func _on_belief_panel_button_pressed() -> void:
	$BeliefControl.buildSelf(playerNode)
	$BeliefControl.updateSelf()
	if $BeliefControl.visible:
		$BeliefControl.visible = false
	else:
		closeAllPanels()
		$BeliefControl.visible = true


func _on_factions_button_pressed() -> void:
	if $FactionControl.visible:
		$FactionControl.visible = false
	else:
		closeAllPanels()
		$FactionControl.visible = true


func _on_laws_button_pressed() -> void:
	$GovernmentControl.buildSelf(playerNode)
	$GovernmentControl.updateGovernmentPanel()
	if $GovernmentControl.visible:
		$GovernmentControl.visible = false
	else:
		closeAllPanels()
		$GovernmentControl.visible = true


func _on_open_buildings_button_pressed() -> void:
	if $BuildingInfoPanel.visible:
		$BuildingInfoPanel.visible = false
	else:
		closeAllPanels()
		$BuildingInfoPanel.visible = true


func _on_wizard_button_pressed() -> void:
	var wtc = $TileInfoPanel.get_node_or_null("WizardTileControl")
	if wtc:
		wtc.visible = not wtc.visible

func _on_magic_button_pressed() -> void:
	$SpellSchoolsControl.updateMagicAmounts(playerNode)
	if $SpellSchoolsControl.visible:
		$SpellSchoolsControl.visible = false
	else:
		closeAllPanels()
		$SpellSchoolsControl.visible = true

func _on_pick_tech_pressed() -> void:
	_on_tech_tree_button_pressed()


func _on_war_room_button_pressed() -> void:
	if $WarRoomPanel.visible:
		$WarRoomPanel.visible = false
	else:
		closeAllPanels()
		$WarRoomPanel.visible = true


func _ready() -> void:
	_build_pause_system()


func _build_pause_system() -> void:
	var menu_btn := Button.new()
	menu_btn.name = "PauseMenuButton"
	menu_btn.text = "Menu"
	menu_btn.anchor_left = 1.0
	menu_btn.anchor_right = 1.0
	menu_btn.offset_left = -122.0
	menu_btn.offset_right = -12.0
	menu_btn.offset_top = 12.0
	menu_btn.offset_bottom = 50.0

	var settings_panel = preload("res://Game Scenes and Scripts/audio_settings_panel.gd").new()
	settings_panel.name = "SettingsPanel"
	settings_panel.visible = false

	var pause_menu = preload("res://Game Scenes and Scripts/pause_menu.gd").new()
	pause_menu.name = "PauseMenu"

	add_child(menu_btn)
	add_child(pause_menu)
	add_child(settings_panel)

	pause_menu.setup(get_parent(), settings_panel)
	menu_btn.pressed.connect(pause_menu.toggle)
