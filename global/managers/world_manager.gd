extends Node


var current_world : Node
var current_world_name : String
@export var default_world : String = "island"
@export var default_world_data : Array[int] = [0]

@onready var world_dict : Dictionary = {
	"conversing": preload("res://worlds/conversing/conversing_world.tscn"),
	"island": preload("res://worlds/island/island_world.tscn"),
	"sorting": preload("res://worlds/sorting/sorting_world.tscn"),
	"run": preload("res://worlds/run/run_world.tscn"),
	"space": preload("res://worlds/space/space_world.tscn"),
	"main_menu": preload("res://worlds/main_menu/main_menu.tscn"),
	"cabin": preload("res://worlds/cabin/cabin_world.tscn")
}

@onready var fade = $GlobalUI/Fade
@export var fade_time : float = 1.0


func _ready() -> void:
	print("World Manager")
	load_world(default_world, default_world_data, false)


func load_world(world_name : String, data : Array[int], use_transition : bool = true) -> String: # Returns last world
	var last_world : String = current_world_name
	
	if (last_world == "island"):
		WMM.progress.set_last_island_pos(get_tree().get_first_node_in_group("island_player").get_position())
	
	if (not world_dict.has(world_name)):
		printerr("<WorldManager>: " + world_name + " world not found!")
		return last_world
	
	if (use_transition):
		_set_fade(true)
		await get_tree().create_timer(fade_time).timeout
	
	var world_instance = world_dict[world_name].instantiate()
	if (current_world != null):
		current_world.queue_free()
	current_world = world_instance
	current_world_name = world_name
	
	world_instance.data = data
	
	
	add_child(world_instance)
	
	if (use_transition):
		_set_fade(false)
	
	return last_world


func _set_fade(visible : bool):
	var tween : Tween = get_tree().create_tween()
	if (visible):
		tween.tween_property(fade, "modulate", Color(1.0, 1.0, 1.0, 1.0), fade_time)
	else:
		tween.tween_property(fade, "modulate", Color(1.0, 1.0, 1.0, 0.0), fade_time)
