extends Control

var target_pos : Vector2
@export var speed : float = 2
@export var magnitude : float = 12

var time : float = 0
@onready var start_pos = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	position.y = start_pos + sin(time * speed) * magnitude
