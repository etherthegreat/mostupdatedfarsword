extends Button
# ═════════════════════════════════════════════════════════════════════════════
# RUN CLOCK — 2026-10-26
# The big turn countdown on the bottom flag band: turns left until the election
# (turn 100), wearing your live grade. Click → Standing panel (run_progress.gd).
# world.gd creates it in _setup_run_clock() and feeds it via show_state().
# ═════════════════════════════════════════════════════════════════════════════

const SS := preload("res://Game Scenes and Scripts/score_screen.gd")
const SIZE := Vector2(300, 100)
const CENTER_X := 960.0          # sits on the red centre stripe of the bottom flag band
const TOP_Y := 974.0
const BG := Color(0.07, 0.09, 0.16, 0.94)
const BORDER := Color(0.85, 0.62, 0.18, 1.0)
const GOLD := Color(1.0, 0.82, 0.32)
const PALE := Color(0.72, 0.78, 0.90)
const HOT := Color(1.0, 0.42, 0.36)
const FINAL_STRETCH := 10        # last N turns: the number burns red and pulses

var turns_left := 100
var last_turn := 100
var grade := "F"
var score := 0
var _font: Font
var _bold: FontVariation
var _t := 0.0
var _pop := 0.0                  # grade-change flash


func _ready() -> void:
	custom_minimum_size = SIZE
	size = SIZE
	position = Vector2(CENTER_X - SIZE.x * 0.5, TOP_Y)
	flat = true
	focus_mode = Control.FOCUS_NONE
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	tooltip_text = "Turns left until the election.\nClick to see where your run stands."
	var th := ThemeDB.get_project_theme()
	_font = th.default_font if th != null and th.default_font != null else ThemeDB.fallback_font
	_bold = FontVariation.new()
	_bold.base_font = _font
	_bold.variation_embolden = 0.9
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)


func show_state(left: int, g: String, s: int, last: int = 100) -> void:
	if g != grade:
		_pop = 1.0
	turns_left = left
	grade = g
	score = s
	last_turn = last
	queue_redraw()


func _process(delta: float) -> void:
	_t += delta
	if _pop > 0.0:
		_pop = maxf(0.0, _pop - delta * 1.6)
		queue_redraw()
	elif turns_left <= FINAL_STRETCH:
		queue_redraw()


func _draw() -> void:
	var r := Rect2(Vector2.ZERO, size)
	var hov := is_hovered()
	var sb := StyleBoxFlat.new()
	sb.bg_color = BG.lightened(0.08) if hov else BG
	sb.border_color = GOLD if hov else BORDER
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(12)
	sb.shadow_color = Color(0, 0, 0, 0.5)
	sb.shadow_size = 10
	draw_style_box(sb, r)

	# grade medallion
	var gc: Color = SS.GRADE_COLORS.get(grade, PALE)
	var c := Vector2(52, size.y * 0.5)
	var rad := 36.0 + 6.0 * _pop
	draw_circle(c, rad + 3.0, Color(0, 0, 0, 0.45))
	draw_circle(c, rad, gc.darkened(0.55))
	draw_arc(c, rad, 0, TAU, 48, gc, 3.0, true)
	if _pop > 0.0:
		draw_arc(c, rad + 8.0 * (1.0 - _pop) + 4.0, 0, TAU, 48, Color(gc, _pop), 2.0, true)
	var gfs := 46
	var gw := _bold.get_string_size(grade, HORIZONTAL_ALIGNMENT_LEFT, -1, gfs).x
	draw_string(_bold, c + Vector2(-gw * 0.5, gfs * 0.36), grade, HORIZONTAL_ALIGNMENT_LEFT, -1, gfs, gc)

	# countdown number
	var hot := turns_left <= FINAL_STRETCH
	var pulse := 0.5 + 0.5 * sin(_t * 6.0) if hot else 0.0
	var ncol: Color = HOT.lerp(Color.WHITE, pulse * 0.35) if hot else Color.WHITE
	var num := str(turns_left)
	var nfs := 58
	draw_string(_bold, Vector2(104, 62), num, HORIZONTAL_ALIGNMENT_LEFT, -1, nfs, ncol)
	var nw := _bold.get_string_size(num, HORIZONTAL_ALIGNMENT_LEFT, -1, nfs).x
	var cap := "LAST TURN" if turns_left == 1 else "TURNS LEFT"
	if turns_left <= 0:
		cap = "ELECTION"
	draw_string(_bold, Vector2(112 + nw, 38), cap, HORIZONTAL_ALIGNMENT_LEFT, -1, 15, HOT if hot else PALE)
	draw_string(_font, Vector2(112 + nw, 60), "score %d" % score, HORIZONTAL_ALIGNMENT_LEFT, -1, 15, gc)

	# elapsed bar: fills toward the election
	var bar := Rect2(104, 76, size.x - 122, 8)
	draw_rect(bar, Color(1, 1, 1, 0.12))
	var k := clampf(1.0 - float(turns_left) / maxf(1.0, float(last_turn)), 0.0, 1.0)
	draw_rect(Rect2(bar.position, Vector2(bar.size.x * k, bar.size.y)), HOT if hot else BORDER)
