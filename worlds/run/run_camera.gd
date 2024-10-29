extends Camera2D

@export var player : Node2D

@export var lookahead : int = 300


func _process(_delta: float) -> void:
	position = lerp(position, Vector2(960, 540) + player.dir * lookahead, 0.1)
	rotation = lerp_angle(rotation, atan2(player.dir.y, player.dir.x) + deg_to_rad(90), 0.05)
