extends Node2D
class_name EnemyBullet


var speed : float = 0.0:
	set = set_speed, get = get_speed


func set_speed(_speed : float) -> void:
	speed = _speed


func get_speed() -> float:
	return speed


func _physics_process(delta: float) -> void:
	position.x -= speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is SpacePlayer):
		body.hit(self)
		queue_free()
