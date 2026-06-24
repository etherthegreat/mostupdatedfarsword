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
	if Input.is_action_pressed("Zoom In"):
		if $Camera2D.zoom >=2:
			$Camera2D.zoom = 2
		else:
			$Camera2D.zoom += .2
	if Input.is_action_pressed("Zoom Out"):
		if $Camera2D.zoom <=1:
			$Camera2D.zoom = 1
		else:
			$Camera2D.zoom -= .2
