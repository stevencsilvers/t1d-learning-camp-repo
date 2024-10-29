extends Node2D
class_name DragAndDrop

# logic
var in_area : bool = false
var held : bool = false:
	set = set_held, get = get_held
@export var interactable : bool = true

# info
var data : int = 0

# animation
var time : float = 0.0
const tween_time : float = 0.25

@onready var sprite : Sprite2D = $Sprite2D
var obj_name : String = ""
var def_scale : Vector2 = Vector2(1.0, 1.0)

signal highlighted(obj : Node2D)
signal grabbed(obj : Node2D)
signal dropped(obj : Node2D)

@onready var sorting_world : Node2D = get_tree().get_first_node_in_group("sorting_world")

@onready var tts_voice : String = DisplayServer.tts_get_voices_for_language("en")[38]


func _ready() -> void:
	connect("highlighted", sorting_world.object_highlighted)
	connect("grabbed", sorting_world.object_grabbed)
	connect("dropped", sorting_world.object_dropped)
	
	sprite.set_material(sprite.get_material().duplicate())


func _process(delta: float) -> void:
	if (held):
		position = lerp(position, get_global_mouse_position(), 0.5)
		
		time += delta
		sprite.rotation_degrees = sin(time * 5) * 10
		if (time > 6.28):
			time = 0


func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("click") and in_area and interactable):
		set_held(true)
		
	
	if (event.is_action_released("click") and held):
		set_held(false)


func _on_area_2d_mouse_entered() -> void:
	if (interactable):
		in_area = true
		_set_outline(true)
		emit_signal("highlighted", self)
		
		if (not held):
			_set_outline_white(false)


func _on_area_2d_mouse_exited() -> void:
	in_area = false
	if (not held):
		_set_outline(false)


func set_held(_held : bool) -> void:
	held = _held
	
	if (held):
		emit_signal("grabbed", self)
		
		_set_outline_white(true)
		var tween : Tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "scale", def_scale * 1.15, tween_time)
		time = 0.0
		
		DisplayServer.tts_stop()
		DisplayServer.tts_speak(obj_name, tts_voice)
		WMM.play_sound("PickUp")
	else:
		emit_signal("dropped", self)
		
		_set_outline_white(false)
		var tween : Tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.set_ease(Tween.EASE_IN_OUT)
		if (interactable):
			tween.tween_property(sprite, "scale", def_scale, tween_time)
		tween.tween_property(sprite, "rotation_degrees", 0.0, tween_time)
		WMM.play_sound("Drop")


func get_held() -> bool:
	return held


func _set_outline(show : bool) -> void:
	if (show):
		sprite.get_material().set_shader_parameter("show", true)
	else:
		sprite.get_material().set_shader_parameter("show", false)

func _set_outline_white(white : bool) -> void:
	if (white):
		sprite.get_material().set_shader_parameter("line_color", Color(1.0, 1.0, 1.0, 1.0))
	else:
		sprite.get_material().set_shader_parameter("line_color", Color(0.0, 0.0, 0.0, 1.0))


func freeze() -> void:
	interactable = false
	_set_outline(false)
	
	var tween : Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "scale", def_scale * 0.9, tween_time)
	tween.tween_property(sprite, "position", Vector2(0, 32), tween_time)


func set_sprite(new_sprite : Texture2D) -> void:
	$Sprite2D.set_texture(new_sprite)
