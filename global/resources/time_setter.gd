extends WorldTarget


@export var time : String = "day"
var active : bool = false



func set_active(_active : bool) -> void:
	active = _active
	if (active):
		get_tree().get_first_node_in_group("island_world").get_node("TimeManager").set_time(time)
