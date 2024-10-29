extends Node2D

@export var scale_rand = 0.1
@export var size_rand = 0.05
const rotation_rand : float = 5
@onready var sprite = $Sprite
@onready var shadow = $Shadow

@export var sprites : Array[Texture2D]

var sway_speed : float = 1.0:
	set(speed): sprite.get_material().set_shader_parameter("speed", speed)
var sway_magnitude : float = 16.0:
	set(magnitude): sprite.get_material().set_shader_parameter("magnitude", magnitude)
var sway_offset : float = 0.0:
	set(offset): sprite.get_material().set_shader_parameter("offset", offset)

const sway_rand : float = 0.05
const magnitude_rand : float = 1.0
const offset_rand : float = 1.0

@export var color_rand : Gradient


func _ready() -> void:
	if (sprites.size() > 0):
		sprite.set_texture(sprites[randi_range(0, sprites.size() - 1)])
	
	var og_size : Vector2 = sprite.get_scale()
	var new_size : Vector2 = randf_range(1 - scale_rand, 1 + scale_rand) * Vector2(randf_range(og_size.x - size_rand, og_size.x + size_rand), randf_range(og_size.y - size_rand, og_size.y + size_rand))
	sprite.set_scale(new_size)
	shadow.set_scale(new_size)
	var new_rotation = randf_range(-rotation_rand, rotation_rand)
	sprite.set_rotation_degrees(new_rotation)
	shadow.set_rotation_degrees(new_rotation)
	
	# Make sway material a copy
	var material_copy = sprite.get_material().duplicate()
	sprite.set_material(material_copy)
	if (shadow != null):
		shadow.set_material(material_copy)
	
	sway_speed += randf_range(-sway_rand, sway_rand)
	sway_magnitude += randf_range(-magnitude_rand, magnitude_rand)
	sway_offset += randf_range(0, offset_rand)
	
	if (randi_range(0, 1) == 1):
		sprite.set_flip_h(true)
	
	if (color_rand != null):
		sprite.set_modulate(color_rand.sample(randf_range(0.0, 1.0)))
