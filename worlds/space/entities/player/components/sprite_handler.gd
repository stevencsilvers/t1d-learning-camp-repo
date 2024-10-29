extends Node2D

@onready var player : CharacterBody2D = get_parent()

var primary_sprite : Node2D:
	set = set_primary
var secondary_sprite : Node2D:
	set = set_secondary

@onready var train : Node2D = $Train/TrainGraphics
@onready var rocket : Node2D = $Rocket/RocketGraphics

var primary_follow_speed : float = 1.0
var secondary_follow_speed : float = 0.1



func _ready() -> void:
	primary_sprite = train
	secondary_sprite = rocket


func _process(delta: float) -> void:
	primary_sprite.global_position = lerp(primary_sprite.global_position, player.position, primary_follow_speed)
	secondary_sprite.global_position = lerp(secondary_sprite.global_position, global_position, secondary_follow_speed)


func swap_sprites() -> int:
	var return_val : int
	
	if (primary_sprite == train):
		set_primary(rocket)
		set_secondary(train)
		return_val = 1
	else:
		set_primary(train)
		set_secondary(rocket)
		return_val = 0
	
	primary_follow_speed = 0.1
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "primary_follow_speed", 1.0, 0.5)
	
	return return_val


func set_primary(sprite : Node2D) -> void:
	primary_sprite = sprite
	sprite.set_z_index(1)
	tween_sprite(sprite, 1.0, 0.1, 1.0)
	sprite.get_node("BoostParticlesPrimary").set_emitting(true)
	sprite.get_node("BoostParticlesSecondary").set_emitting(false)


func set_secondary(sprite : Node2D) -> void:
	secondary_sprite = sprite
	sprite.set_z_index(-6)
	tween_sprite(sprite, 0.75, 0.1, 0.6)
	sprite.get_node("BoostParticlesPrimary").set_emitting(false)
	sprite.get_node("BoostParticlesSecondary").set_emitting(true)


func tween_sprite(sprite : Node2D, size : float, duration : float, dim : float) -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(size, size), duration)
	tween.tween_property(sprite, "modulate", Color(dim, dim, dim, 1.0), duration)


func set_alpha(alpha : float) -> void:
	train.modulate.a = alpha
	rocket.modulate.a = alpha


func set_sprite_rotation(degrees : float) -> void:
	primary_sprite.rotation_degrees = lerp(primary_sprite.rotation_degrees, degrees, 0.1)
	secondary_sprite.rotation_degrees = lerp(secondary_sprite.rotation_degrees, degrees * 0.5, 0.05)
