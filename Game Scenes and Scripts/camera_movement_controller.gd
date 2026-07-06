extends Control

const PAN_SPEED: float = 4.0   # was 10 — slower pan so black tile borders don't blur while moving

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Up"):
		position.y -= PAN_SPEED
	if Input.is_action_pressed("Down"):
		position.y += PAN_SPEED
	if Input.is_action_pressed("Right"):
		position.x += PAN_SPEED
	if Input.is_action_pressed("Left"):
		position.x -= PAN_SPEED


func _input(event: InputEvent) -> void:
	# Zoom is bound to the mouse wheel (momentary), so it must be event-driven,
	# not polled with is_action_pressed. Camera2D.zoom is a Vector2 -> operate on .x.
	if event.is_action_pressed("Zoom In"):
		_apply_zoom(0.2)
	elif event.is_action_pressed("Zoom Out"):
		_apply_zoom(-0.2)


func _apply_zoom(delta: float) -> void:
	var z: float = clampf($Camera2D.zoom.x + delta, 0.5, 2.0)   # min 0.5 = zoom out ~2x farther
	$Camera2D.zoom = Vector2(z, z)
