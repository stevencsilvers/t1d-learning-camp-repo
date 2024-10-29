extends Node2D


@onready var parent : CharacterBody2D = get_parent()

@export var gravity : float = 12
@export var terminal_velocity : float = 800.0
@export var bounce_strength : float = -1000.0
@export var horizontal_move_speed : float = 100.0

@export var default_rotate_speed : float = 2.0
@export var bounce_rotate_speed_mult : float = 2.0
var rotate_speed : float

const rotate : bool = false


func _ready() -> void:
	parent.velocity.x = -horizontal_move_speed
	rotate_speed = default_rotate_speed
	
	
	if (rotate):
		parent.get_node("Sprite2D").rotation_degrees = randi_range(0, 360)


func _process(delta : float) -> void:
	parent.velocity.y = move_toward(parent.velocity.y, terminal_velocity, gravity * delta * 60)
	
	if (parent.position.y > 1080):
		_bounce()
	
	if (parent.position.x < 0):
		parent.velocity.x = horizontal_move_speed
	elif(parent.position.x > 1920):
		parent.velocity.x = -horizontal_move_speed
	
	if (rotate):
		parent.get_node("Sprite2D").rotation += delta * rotate_speed * sign(parent.velocity.x)


func _bounce() -> void:
	parent.velocity.y = bounce_strength
	rotate_speed = default_rotate_speed * bounce_rotate_speed_mult
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "rotate_speed", default_rotate_speed, 2.0)
