extends Node2D
class_name WorldTarget

var is_current_target : bool = false:
	set(yes):
		is_current_target = yes
		emit_signal("current_target_changed", yes)
@export var concurrent : bool = false

signal current_target_changed(is_current : bool)
