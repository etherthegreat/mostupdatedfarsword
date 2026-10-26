extends Control

# GUI pass 2026-10-25 — legibility camera.
#  • Pans the Camera2D directly and clamps it to the map art, so the view never
#    drifts into the grey void past the map edge.
#  • Zoom is multiplicative, tweened, and anchored on the mouse cursor.
#  • Deeper close-up zoom (MAX_ZOOM) so individual tiles can carry text.
#  • Clamping leaves room for the HUD bars so the map edge isn't hidden under them.

const PAN_SPEED: float = 4.0        # screen px per physics tick at zoom 1 (scaled by 1/zoom)
const ZOOM_STEP: float = 1.15       # each wheel notch multiplies/divides zoom by this
const MAX_ZOOM: float = 3.0         # close-up (bigger = closer)
const MIN_ZOOM_FLOOR: float = 0.35  # never zoom out further than this, even on a huge map
const ZOOM_TWEEN_TIME: float = 0.12

# Screen-space HUD thickness (px) — the map may slide under these, but its edge stays reachable.
const HUD_TOP: float = 100.0
const HUD_BOTTOM: float = 110.0
const HUD_LEFT: float = 0.0
const HUD_RIGHT: float = 90.0

var map_rect: Rect2 = Rect2()       # world-space bounds of the map art; empty = no clamping
var min_zoom: float = 0.5
var _target_zoom: float = 1.0
var _zoom_tween: Tween = null

@onready var cam: Camera2D = $Camera2D


func _ready() -> void:
	_target_zoom = cam.zoom.x


# Called by world.gd once the map is built.
func set_map_rect(r: Rect2) -> void:
	map_rect = r
	if r.size.x <= 0.0 or r.size.y <= 0.0:
		return
	var vp: Vector2 = get_viewport_rect().size
	var usable := Vector2(vp.x - HUD_LEFT - HUD_RIGHT, vp.y - HUD_TOP - HUD_BOTTOM)
	# Furthest-out zoom = the whole map just fits the usable screen area.
	min_zoom = clampf(min(usable.x / r.size.x, usable.y / r.size.y), MIN_ZOOM_FLOOR, 1.0)
	_target_zoom = clampf(cam.zoom.x, min_zoom, MAX_ZOOM)
	cam.zoom = Vector2(_target_zoom, _target_zoom)
	clamp_camera()


func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	if Input.is_action_pressed("Up"):
		dir.y -= 1
	if Input.is_action_pressed("Down"):
		dir.y += 1
	if Input.is_action_pressed("Right"):
		dir.x += 1
	if Input.is_action_pressed("Left"):
		dir.x -= 1
	if dir != Vector2.ZERO:
		# Constant on-screen pan speed regardless of zoom.
		cam.global_position += dir * PAN_SPEED / cam.zoom.x
	# Always clamp — other code (focus_camera_on tweens) also moves the camera.
	# Skip while our own zoom tween runs: its target is already clamped for the final zoom.
	if _zoom_tween == null or not _zoom_tween.is_running():
		clamp_camera()


func _input(event: InputEvent) -> void:
	# Zoom is bound to the mouse wheel (momentary), so it must be event-driven.
	if event.is_action_pressed("Zoom In"):
		_zoom_at_cursor(ZOOM_STEP)
	elif event.is_action_pressed("Zoom Out"):
		_zoom_at_cursor(1.0 / ZOOM_STEP)


func _zoom_at_cursor(factor: float) -> void:
	var old_z: float = _target_zoom
	var new_z: float = clampf(old_z * factor, min_zoom, MAX_ZOOM)
	if is_equal_approx(new_z, old_z):
		return
	_target_zoom = new_z
	# Keep the world point under the mouse fixed while zooming.
	var vp_size: Vector2 = get_viewport_rect().size
	var mouse_screen: Vector2 = get_viewport().get_mouse_position()
	var off: Vector2 = mouse_screen - vp_size * 0.5
	var world_under_mouse: Vector2 = cam.global_position + off / old_z
	var new_center: Vector2 = world_under_mouse - off / new_z
	new_center = _clamped_center(new_center, new_z)
	if _zoom_tween != null and _zoom_tween.is_valid():
		_zoom_tween.kill()
	_zoom_tween = create_tween().set_parallel(true)
	_zoom_tween.tween_property(cam, "zoom", Vector2(new_z, new_z), ZOOM_TWEEN_TIME) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_zoom_tween.tween_property(cam, "global_position", new_center, ZOOM_TWEEN_TIME) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


# Legacy entry point (kept in case anything else calls it).
func _apply_zoom(delta: float) -> void:
	_zoom_at_cursor(ZOOM_STEP if delta > 0.0 else 1.0 / ZOOM_STEP)


func clamp_camera() -> void:
	if map_rect.size.x <= 0.0:
		return
	cam.global_position = _clamped_center(cam.global_position, cam.zoom.x)


func _clamped_center(center: Vector2, z: float) -> Vector2:
	if map_rect.size.x <= 0.0 or z <= 0.0:
		return center
	var vp: Vector2 = get_viewport_rect().size
	var half: Vector2 = vp * 0.5 / z
	# Allowed range for the screen centre so the map edge can reach (not pass) the HUD edge.
	var min_x: float = map_rect.position.x + half.x - HUD_LEFT / z
	var max_x: float = map_rect.end.x - half.x + HUD_RIGHT / z
	var min_y: float = map_rect.position.y + half.y - HUD_TOP / z
	var max_y: float = map_rect.end.y - half.y + HUD_BOTTOM / z
	var out := center
	out.x = map_rect.get_center().x if min_x > max_x else clampf(center.x, min_x, max_x)
	out.y = map_rect.get_center().y if min_y > max_y else clampf(center.y, min_y, max_y)
	return out
