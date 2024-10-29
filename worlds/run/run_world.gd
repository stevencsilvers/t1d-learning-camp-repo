extends Node2D


var data : Array[int] = [0]: 
	set(_data): data = _data



# TEMP
func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel")):
		WMM.load_world("island", [0])
