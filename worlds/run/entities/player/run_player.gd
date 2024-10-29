extends Node2D


var dir : Vector2 = Vector2.ZERO
var speed : float = 200

var can_turn : bool

@onready var sprite : Node2D = $SpriteHolder/Sprite2D


func _ready() -> void:
	dir = Vector2(0, -1)


func _unhandled_input(event) -> void:
	if (not can_turn):
		if (event.is_action_pressed("ui_left")):
			_move(-1)
		if (event.is_action_pressed("ui_right")):
			_move(1)
	else:
		if (event.is_action_pressed("ui_left")):
			_rotate(-1)
		if (event.is_action_pressed("ui_right")):
			_rotate(1)


func _move(value : int) -> void:
	position.x += value * 128


func _rotate(value : int) -> void:
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	
	if (value == -1):
		dir = Vector2(dir.y, -dir.x)
	elif (value == 1):
		dir = Vector2(-dir.y, dir.x)


func _process(delta: float) -> void:
	sprite.position = lerp(sprite.position, position, 0.25)
	sprite.rotation = lerp_angle(sprite.rotation, atan2(dir.y, dir.x) + deg_to_rad(90), 0.05)
