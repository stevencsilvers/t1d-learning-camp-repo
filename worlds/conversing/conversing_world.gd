extends Node2D

var data : Array[int] = [0]: 
	set(_data): data = _data

@onready var robot_anim : AnimationPlayer = $CanvasLayer/RobotControl/Robot/AnimationPlayer
@onready var dog : TextureRect = $CanvasLayer/DogControl/Dog
@onready var dog_anim : AnimationPlayer = $CanvasLayer/DogControl/Dog/AnimationPlayer
@onready var dog_talking_timer : Timer = $CanvasLayer/DogControl/Dog/TalkingTimer

@onready var background : TextureRect = $CanvasLayer/Background

@onready var response_manager = $DialogLayer/ResponseManager
@onready var conversing_manager = $ConversingManager

const override : int = -1 # DEBUG


func _ready() -> void:
	response_manager.text_edit.connect("text_changed", _start_talking_timer)
	
	if (override >= 0):
		await conversing_manager.start_conversation(override)
	elif (WMM.progress != null):
		WMM.progress.world_nums["conversing"] += 1
		await conversing_manager.start_conversation(WMM.progress.world_nums["conversing"])
	else:
		await conversing_manager.start_conversation(data[0])
	
	await get_tree().create_timer(1.0).timeout
	WMM.load_world("island", [0])


func _on_dialog_manager_text_started() -> void:
	robot_anim.play("talking")


func _on_dialog_manager_text_ended() -> void:
	robot_anim.play("idle")


func _start_talking_timer() -> void:
	if (dog.visible):
		dog_anim.play("talking")
		dog_talking_timer.start(0.6)


func _on_talking_timer_timeout() -> void:
	if (dog.visible):
		dog_anim.play("idle")


func _on_conversing_manager_conversation_started() -> void:
	var idx : int = conversing_manager.current_conversation
	
	background.set_texture(conversing_manager.conversations[idx].background)


func _unhandled_input(event: InputEvent) -> void: #temp
	if (event.is_action_pressed("ui_cancel")):
		WMM.load_world("island", [0])
