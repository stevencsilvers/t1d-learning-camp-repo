extends Node2D


var on_path : bool = false
var on_grass : bool = false
var on_sand : bool = false
var on_bridge : bool = false

@onready var path : Area2D = $Path
@onready var grass : Area2D = $Grass
@onready var sand : Area2D = $Sand
@onready var bridge : Area2D = $Bridge


func _process(_delta : float) -> void:
	on_path = path.has_overlapping_areas()
	on_grass = grass.has_overlapping_areas()
	on_sand = !sand.has_overlapping_areas()
	on_bridge = bridge.has_overlapping_areas()
