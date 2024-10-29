extends Node

@onready var world_manager = get_tree().get_first_node_in_group("world_manager")
@onready var bedrock : BedrockManager = null
@onready var audio : AudioManager = null
@onready var progress : ProgressManager = null


func _ready() -> void:
	if (world_manager != null):
		bedrock = world_manager.get_node("BedrockManager")
		audio = world_manager.get_node("AudioManager")
		progress = world_manager.get_node("ProgressManager")
	else:
		printerr("<WMM> World Manager not in scene tree. Cannot get bedrock, audio, or progress manager.")


func load_world(world_name : String, world_data : Array[int]) -> bool:
	if (world_manager != null):
		world_manager.load_world(world_name, world_data)
		return true
	else:
		printerr("<WMM>: World Manager not in tree. Unable to load ", world_name, " world.")
		return false


func play_sound(name : String) -> void:
	if (audio != null):
		audio.play(name)


func get_global_ui() -> CanvasLayer:
	if (world_manager != null):
		return world_manager.get_node("GlobalUI")
	else:
		return null
