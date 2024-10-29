extends Node


@export var time_mult = 2.0
@export var amplitude_mult = 0.2
var time : float = 0.0
@onready var parent = get_parent()


func _ready():
	time += randf_range(0, 6)


func _process(delta: float) -> void:
	time += delta
	parent.rotation = sin(time * time_mult) * amplitude_mult
	
	if (time > PI * 2):
		time = 0.0
