extends Control

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Up"):
		position.y -= 10
	if Input.is_action_pressed("Down"):
		position.y += 10
	if Input.is_action_pressed("Right"):
		position.x += 10
	if Input.is_action_pressed("Left"):
		position.x -= 10


func _input(event: InputEvent) -> void:
	# Zoom is bound to the mouse wheel (momentary), so it must be event-driven,
	# not polled with is_action_pressed. Camera2D.zoom is a Vector2 -> operate on .x.
	if event.is_action_pressed("Zoom In"):
		_apply_zoom(0.2)
	elif event.is_action_pressed("Zoom Out"):
		_apply_zoom(-0.2)


func _apply_zoom(delta: float) -> void:
	var z: float = clampf($Camera2D.zoom.x + delta, 1.0, 2.0)
	$Camera2D.zoom = Vector2(z, z)
