extends Node2D


@export var follow_speed : float = 100.0

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var parent : CharacterBody2D = get_parent()


func _process(_delta : float):
	if (player != null):
		parent.velocity = (player.position - global_position).normalized() * follow_speed
