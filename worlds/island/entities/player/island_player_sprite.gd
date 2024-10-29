extends AnimatedSprite2D

@onready var player = get_parent()

var time : float = 0.0
var rotate_time : float = 0.25
var right : int = 1
var target_rot_degrees : float

signal stepped


func _process(delta: float) -> void:
	if (player.input != Vector2.ZERO):
		if (player.input.y > 0):
			if (player.input.x > 0):
				play("walk_downright")
				set_flip_h(false)
			elif (player.input.x < 0):
				play("walk_downright")
				set_flip_h(true)
			else:
				play("walk_down")
		elif (player.input.y < 0):
			if (player.input.x > 0):
				play("walk_upright")
				set_flip_h(false)
			elif (player.input.x < 0):
				play("walk_upright")
				set_flip_h(true)
			else:
				play("walk_up")
		else:
			play("walk_right")
			if (player.input.x > 0):
				set_flip_h(false)
			elif (player.input.x < 0):
				set_flip_h(true)
	
	
	# TEMP ANIMATION
	if (player.input != Vector2.ZERO):
		time += delta
	else:
		set_rotation(0)
	
	if (time > rotate_time):
		rotate_sprite()
	
	#rotation_degrees = lerp(rotation_degrees, target_rot_degrees, 0.5)


func rotate_sprite() -> void:
	time = 0.0
	#target_rot_degrees = randi_range(5, 10) * right
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "rotation_degrees", randi_range(5, 10) * right, 0.1)
	right *= -1
	emit_signal("stepped")
