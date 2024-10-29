extends CanvasLayer

@onready var input_prompt = $NinePatchRect
@export var tween_duration : float = 1.0


func set_input_prompt_visible(show : bool) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	if (show):
		tween.tween_property(input_prompt, "position:y", 804, 1.0)
		tween.tween_property(input_prompt, "scale", Vector2(1.0, 1.0), tween_duration)
	else:
		tween.tween_property(input_prompt, "position:y", 1204, 1.0)
		tween.tween_property(input_prompt, "scale", Vector2(0.5, 0.5), tween_duration)
