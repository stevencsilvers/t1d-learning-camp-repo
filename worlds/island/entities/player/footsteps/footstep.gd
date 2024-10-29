extends Sprite2D


func fade(linger_time : float, fade_time : float) -> void:
	await get_tree().create_timer(linger_time).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), fade_time)
	tween.tween_callback(queue_free)
