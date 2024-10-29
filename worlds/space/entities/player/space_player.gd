extends CharacterBody2D
class_name SpacePlayer

@export var move_speed : float = 500.0
@export var move_acceleration : float = 40.0
@export var move_friction : float = 60.0
var input_control : float = 1.0

var input : Vector2 = Vector2.ZERO

@onready var sprite_handler = $SpriteHandler
@onready var weapon = $Weapon

var data : int = 0

@export var max_health : int = 3
var health : int
var invincible : bool = false
@export var invincible_time : float = 3.0
var hit_knockback_strength : float = 1200
var hit_friction_mult : float = 0.5

@onready var swap_cooldown_timer = $SwapCooldownTimer
var can_swap : bool = false


func _ready() -> void:
	health = max_health


func _process(delta: float) -> void:
	input = input_control * Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	
	if (input == Vector2.ZERO):
		_apply_friction(delta)
	else:
		_apply_acceleration(delta)
	
	sprite_handler.set_sprite_rotation(30 * input.y)


func _apply_acceleration(delta : float):
	velocity.x = move_toward(velocity.x, input.x * move_speed, move_acceleration * delta * 60)
	velocity.y = move_toward(velocity.y, input.y * move_speed, move_acceleration * delta * 60)


func _apply_friction(delta : float):
	velocity.x = move_toward(velocity.x, 0.0, move_friction * delta * 60)
	velocity.y = move_toward(velocity.y, 0.0, move_friction * delta * 60)


func _physics_process(delta: float) -> void:
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("action") and can_swap):
		swap()


func swap() -> void:
	data = sprite_handler.swap_sprites()
	swap_cooldown_timer.start()
	can_swap = false
	WMM.play_sound("Swap")


func hit(source : Node2D) -> void:
	if (not invincible):
		health -= 1
		WMM.play_sound("PlayerHit")
	
		if (health <= 0):
			die()
		else:
			invincible = true
			sprite_handler.set_alpha(0.5)
			input_control = 0.0
			
			if (source != null):
				velocity = (position - source.position).normalized() * hit_knockback_strength
			
			var tween : Tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(self, "input_control", 1.0, 1.0)
			tween.tween_property(self, "friction", move_friction, 1.0)
			
			await get_tree().create_timer(invincible_time).timeout
			
			invincible = false
			sprite_handler.set_alpha(1.0)


func die() -> void:
	WMM.load_world("island", [3])
	queue_free()


func _on_swap_cooldown_timer_timeout() -> void:
	can_swap = true


func _on_robot_tips_tips_finished() -> void:
	can_swap = true
	weapon.can_shoot = true
