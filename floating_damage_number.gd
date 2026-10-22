extends Node2D

func setup(amount: int, color: Color) -> void:
	$Label.text = "-" + str(amount)
	$Label.add_theme_color_override("font_color", color)
	$Label.add_theme_font_size_override("font_size", 28)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 90.0, 1.4)
	tween.tween_property(self, "modulate:a", 0.0, 1.4).set_delay(0.4)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
