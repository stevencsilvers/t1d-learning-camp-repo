extends Node2D

@onready var player = get_parent()
@onready var surfaces = get_tree().get_first_node_in_group("surfaces")

enum Surface {BRIDGE, GRASS, PATH, SAND}
var current_surface : int


func _process(delta: float) -> void:
	
	if (surfaces.on_bridge):
		current_surface = Surface.BRIDGE
	elif(surfaces.on_grass):
		current_surface = Surface.GRASS
	elif (surfaces.on_path):
		current_surface = Surface.PATH
	elif (surfaces.on_sand):
		current_surface = Surface.SAND
	else:
		current_surface = Surface.GRASS


func play_walk_sound() -> void:
	match (current_surface):
		Surface.BRIDGE:
			WMM.play_sound("WalkWood")
		Surface.PATH:
			WMM.play_sound("WalkPath")
		Surface.SAND:
			WMM.play_sound("WalkSand")
		_:
			WMM.play_sound("WalkGrass")
