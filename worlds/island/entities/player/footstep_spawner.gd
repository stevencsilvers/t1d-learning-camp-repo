extends Node2D

@onready var player = get_parent()
@onready var effects_parent = get_tree().get_first_node_in_group("effects")
@onready var footstep = preload("res://worlds/island/entities/player/footsteps/footstep.tscn")

@export var sfx_manager : Node2D

@export var footstep_dist : int = 16
@export var linger_time : float = 1.0
@export var fade_time : float = 1.0

var right : int = 1



func _on_island_player_sprite_stepped() -> void:
	if (sfx_manager.current_surface == sfx_manager.Surface.PATH or sfx_manager.current_surface == sfx_manager.Surface.SAND):
		var footstep_inst = footstep.instantiate()
		var dir : float = atan2(player.input.y, player.input.x) + deg_to_rad(90)
		footstep_inst.set_rotation(dir)
		footstep_inst.position = global_position + Vector2(cos(dir), sin(dir)) * footstep_dist * right
		effects_parent.add_child(footstep_inst)
		footstep_inst.fade(linger_time, fade_time)
	
	right *= -1
