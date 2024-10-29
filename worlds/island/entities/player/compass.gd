extends Node2D

@onready var island = get_tree().get_first_node_in_group("island_world")
@onready var sprite = $CompassSprite
var compass_visible : bool = true


func _process(_delta : float) -> void:
	if (island.current_target != null):
		var dir : Vector2 = global_position - island.current_target.position
		rotation = atan2(dir.y, dir.x) - deg_to_rad(90)


func set_compass_visible(current_target : bool, vis : bool):
	if (get_tree() != null and current_target):
		if (vis):
			var tween = get_tree().create_tween()
			tween.set_trans(Tween.TRANS_ELASTIC)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.5)
			compass_visible = true
		else:
			var tween = get_tree().create_tween()
			tween.set_trans(Tween.TRANS_ELASTIC)
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(sprite, "scale", Vector2(0.0, 0.0), 0.5)
			compass_visible = false
