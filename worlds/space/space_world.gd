extends Node2D

@onready var robot_tips = $UI/RobotTips

var data : Array[int] = [0]: 
	set(_data): data = _data


func _ready() -> void:
	WMM.progress.world_nums["space"] += 1
	robot_tips.start_tips(WMM.progress.world_nums["space"])


# TEMP
func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel")):
		WMM.load_world("island", [0])


func _on_score_manager_score_changed(score: Variant) -> void:
	if (score > 20000):
		WMM.load_world("island", [0])
