extends CharacterBody2D
class_name IslandPlayer

@export var move_speed : float = 250.0
@export var move_acceleration : float = 30.0
@export var move_friction : float = 50.0

var input : Vector2 = Vector2.ZERO
var input_mult : float = 1.0

@onready var sprite = $IslandPlayerSprite
@onready var camera = $Camera2D




func _process(delta: float) -> void:
	input = input_mult * Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
	
	if (input == Vector2.ZERO):
		_apply_friction(delta)
	else:
		_apply_acceleration(delta)


func _apply_acceleration(delta : float):
	velocity.x = move_toward(velocity.x, input.x * move_speed, move_acceleration * delta * 60)
	velocity.y = move_toward(velocity.y, input.y * move_speed, move_acceleration * delta * 60)


func _apply_friction(delta : float):
	velocity.x = move_toward(velocity.x, 0.0, move_friction * delta * 60)
	velocity.y = move_toward(velocity.y, 0.0, move_friction * delta * 60)


func _physics_process(delta: float) -> void:
	move_and_slide()


func set_input_mult(mult : float) -> float:
	var prev_mult = input_mult
	input_mult = mult
	return prev_mult


func set_camera_zoom(zoom, time) -> float:
	var prev_zoom : float = camera.zoom.x
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "zoom", Vector2(1.0, 1.0) * zoom, time)
	
	return prev_zoom
