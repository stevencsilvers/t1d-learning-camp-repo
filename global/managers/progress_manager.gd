extends Node
class_name ProgressManager


@export var day : int = 0
@export var progress : int = -1:
	get = get_progress

var food_unlocked = 0
var world_nums : Dictionary = {"conversing": -1, "sorting": -1, "space": -1}

var last_island_pos : Vector2 = Vector2.ZERO:
	set = set_last_island_pos


func next_day() -> void:
	day += 1


func next_progress() -> void:
	progress += 1


func get_progress() -> int:
	return progress


func set_last_island_pos(pos : Vector2):
	last_island_pos = pos
