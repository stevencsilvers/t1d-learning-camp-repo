extends Control

var data : Array[int] = [0]: 
	set(_data): data = _data


func _ready() -> void:
	sleep()


func _on_sleep_button_pressed() -> void:
	sleep()


func sleep() -> void:
	WMM.progress.next_day()
	await get_tree().create_timer(1.0).timeout
	WMM.load_world("island", [0])
