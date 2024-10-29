extends RichTextLabel


func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.75)
	tween.tween_callback(queue_free)


func set_value(value : int) -> void:
	if (value > 0):
		set_modulate(Color.LIGHT_GREEN)
		set_text("+" + str(value))
	else:
		set_modulate(Color.DARK_RED)
		set_text(str(value))
