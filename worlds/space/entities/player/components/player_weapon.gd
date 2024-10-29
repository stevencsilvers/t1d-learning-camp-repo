extends Node2D


@onready var player : CharacterBody2D = get_parent()
@onready var world : Node = get_tree().get_first_node_in_group("world").get_node("Projectiles")

@onready var bullet = preload("res://worlds/space/entities/player/components/player_bullet.tscn")
@export var bullet_speed : float = 1000.0
@export var spread : float = 3

var can_shoot : bool = false


func _unhandled_input(event: InputEvent) -> void:
	if (can_shoot and event.is_action_pressed("enter")):
		shoot()


func shoot() -> void:
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = global_position
	bullet_instance.set_velocity(bullet_speed, deg_to_rad(randf_range(-spread, spread)))
	bullet_instance.set_data(player.data)
	world.add_child(bullet_instance)
	WMM.play_sound("Shoot")
