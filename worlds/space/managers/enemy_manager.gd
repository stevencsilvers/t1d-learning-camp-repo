extends Node2D

@onready var bounce_enemy = preload("res://worlds/space/entities/enemy/bounce_enemy.tscn")
@onready var urination = preload("res://worlds/space/entities/enemy/urination.tscn")
@onready var dizziness = preload("res://worlds/space/entities/enemy/dizziness.tscn")
@onready var nausea = preload("res://worlds/space/entities/enemy/tiredness.tscn")
@onready var sweating = preload("res://worlds/space/entities/enemy/sweating.tscn")
@onready var hunger = preload("res://worlds/space/entities/enemy/hunger.tscn")

@onready var enemies : Array = [bounce_enemy, urination, dizziness, nausea, sweating, hunger]

#@onready var enemies : Array = [follow_enemy, bounce_enemy, shoot_enemy]
@onready var enemy_parent = $Enemies

@onready var robot_tips = get_tree().get_first_node_in_group("robot_tips")


var current_enemy_count : int = 0
var enemy_amount : int = 1
var wave_num : int = 0

@export var enemy_points : int = 1000


func _ready() -> void:
	await robot_tips.tips_finished
	spawn_wave()


func enemy_died() -> void:
	current_enemy_count -= 1
	get_tree().get_first_node_in_group("score_manager").add_to_score(enemy_points)
	
	if (current_enemy_count <= 0):
		spawn_wave()


func spawn_wave() -> void:
	wave_num += 1
	
	if (wave_num % 3 == 0):
		enemy_amount += 1
	
	for i in range(enemy_amount):
		current_enemy_count += 1
		spawn_enemy(randi() % enemies.size())


func spawn_enemy(index : int) -> void:
	var enemy_instance = enemies[index].instantiate()
	enemy_instance.position = position + Vector2(randi_range(0, 200), randi_range(-450, 450))
	enemy_parent.add_child(enemy_instance)
