extends Node2D


@onready var world : Node = get_tree().get_first_node_in_group("world").get_node("Projectiles")
@onready var parent : Node2D = get_parent()

@onready var bullet = preload("res://worlds/space/entities/enemy/enemy_components/enemy_bullet.tscn")
@export var bullet_speed : float = 500.0

var at_target_x : bool = false
var target_x : int
var move_speed : float = 200.0


func _ready() -> void:
	target_x = randi_range(1350, 1750)


func _process(delta : float) -> void:
	if (not at_target_x):
		parent.position.x -= move_speed * delta
	
	if (parent.position.x <= target_x):
		_start_shooting()


func _start_shooting() -> void:
	if (not at_target_x):
		$ShootTimer.start()
	at_target_x = true


func _on_shoot_timer_timeout() -> void:
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = global_position
	bullet_instance.set_speed(bullet_speed)
	world.add_child(bullet_instance)
