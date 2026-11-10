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


# ── WHAT THE OPEN PANELS COVER ───────────────────────────────────────────────
# Most of these panels are a 40x40 root with sprites laid over the map, and many of their
# buttons are Area2Ds (beliefs, laws, the resource bar). A Control that swallows the mouse
# under them would also swallow those, so nothing here touches the mouse. Instead this
# keeps the screen area each open panel is showing, and the MAP asks blocks_map_at()
# before it reacts: tiles (tile.gd), the right-click march (world.gd) and the army, worker
# and move-marker tokens (path_control.gd) all stand down under an open panel.
# A panel that covers most of the screen claims all of it.
const COVERING_PANELS := ["TileInfoPanel", "BuildingInfoPanel", "BeliefControl", "TechTree",
	"SpellSchoolsControl", "Spellbook", "MilitaryPanelControl", "FactionControl",
	"GovernmentControl", "TraditionsControl", "WarRoomPanel", "ResourceInfoControl",
	"ArmyPanel", "CivilianControl", "CivilianUnitControl", "EventControl",
	"EndingSceneControl", "GameOverPanel"]
const COVER_FULLSCREEN_SHARE := 0.55
var keep_code_panel: String = ""   # set by world._close_all_panels while one code panel is opening
var _panel_rects: Dictionary = {}  # panel name -> Rect2 on screen (only panels showing something)
var _cover_t: float = 0.0
var _cover_wired: bool = false


func blocks_map_at(screen_pos: Vector2) -> bool:
	for nm in _panel_rects:
		if _panel_rects[nm].has_point(screen_pos):
			return true
	return false


# Something the player can see: art, a backing panel, a button, text. Bare containers
# and empty holders do not count, or an idle popup holder would claim the middle of the map.
func _is_solid(c) -> bool:
	if c is Sprite2D:
		return c.texture != null
	if c is TextureRect:
		return c.texture != null
	if c is Label:
		return c.text != ""
	return c is Panel or c is PanelContainer or c is ColorRect or c is NinePatchRect \
		or c is BaseButton or c is RichTextLabel or c is LineEdit or c is TextEdit \
		or c is Range or c is TabContainer or c is ItemList


func _measure_panel(nm: String) -> void:
	var pn = get_node_or_null(nm)
	if pn == null or not (pn is CanvasItem) or not pn.is_visible_in_tree():
		_panel_rects.erase(nm)
		return
	var vp := Rect2(Vector2.ZERO, get_viewport().get_visible_rect().size)
	var r := Rect2()
	var any := false
	var stack: Array = pn.get_children()
	while not stack.is_empty():
		var c = stack.pop_back()
		if not (c is CanvasItem) or not c.visible:
			continue
		if _is_solid(c):
			var cr: Rect2 = c.get_global_rect() if c is Control else c.get_global_transform() * c.get_rect()
			cr = cr.intersection(vp)
			if cr.size.x > 4.0 and cr.size.y > 4.0:
				r = r.merge(cr) if any else cr
				any = true
		if c is ScrollContainer:
			# a list is clipped to its own box: it counts as that box once it holds anything
			var filled := false
			for inner in c.get_children():
				if inner is Control and not (inner is ScrollBar) and inner.get_child_count() > 0:
					filled = true
			if filled:
				var sr: Rect2 = c.get_global_rect().intersection(vp)
				if sr.has_area():
					r = r.merge(sr) if any else sr
					any = true
			continue
		stack.append_array(c.get_children())
	if not any:
		_panel_rects.erase(nm)
		return
	_panel_rects[nm] = vp if r.get_area() >= vp.get_area() * COVER_FULLSCREEN_SHARE else r.grow(6.0).intersection(vp)


func _measure_all_panels() -> void:
	for nm in COVERING_PANELS:
		_measure_panel(nm)


func _process(delta: float) -> void:
	if not _cover_wired:
		_cover_wired = true
		for nm in COVERING_PANELS:
			var pn = get_node_or_null(nm)
			if pn != null and pn is CanvasItem:
				pn.visibility_changed.connect(_measure_panel.bind(nm), CONNECT_DEFERRED)   # at once when it opens or closes
	_cover_t += delta
	if _cover_t < 0.15:
		return
	_cover_t = 0.0
	_measure_all_panels()


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
