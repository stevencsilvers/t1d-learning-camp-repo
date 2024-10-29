extends CharacterBody2D
class_name SpaceEnemy


@export var max_health : int = 1
var health : int
@export var data : int = 0

signal died


func _ready() -> void:
	health = max_health
	connect("died", get_tree().get_first_node_in_group("enemy_manager").enemy_died)


func hit(damage : int) -> void:
	health -= damage
	modulate = Color(10.0, 10.0, 10.0, 1.0)
	
	if (health <= 0):
		die()
	
	await get_tree().create_timer(0.025).timeout
	modulate = Color(1.0, 1.0, 1.0, 1.0)


func die() -> void:
	emit_signal("died")
	queue_free()


func _physics_process(_delta : float) -> void:
	if (velocity != Vector2.ZERO):
		move_and_slide()


func _on_area_2d_body_entered(body : Node2D) -> void:
	if (body is SpacePlayer):
		body.hit(self)
