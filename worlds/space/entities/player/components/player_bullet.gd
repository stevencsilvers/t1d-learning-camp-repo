extends Node2D
class_name PlayerBullet


var velocity : Vector2 = Vector2.ZERO
var data : int = -1:
	set = set_data, get = get_data

@export var bullet_damage : int = 10



func set_velocity(speed : float, angle : float) -> void:
	velocity = Vector2(cos(angle), sin(angle)) * speed


func set_data(_data : int) -> void:
	data = _data
	
	if (data == 0):
		modulate = Color(0.8, 0.3, 0.3)
	else:
		modulate = Color(0.2, 0.7, 0.7)


func get_data() -> int:
	return data


func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_area_2d_area_entered(area : Area2D) -> void:
	if (area.get_parent() is SpaceEnemy):
		if (area.get_parent().data == get_data()):
			area.get_parent().hit(bullet_damage)
			WMM.play_sound("Explode")
		else:
			get_tree().get_first_node_in_group("score_manager").add_to_score(-100)
			WMM.play_sound("Wrong")
	elif (area.get_parent() is EnemyBullet):
		area.get_parent().queue_free()
	queue_free()
