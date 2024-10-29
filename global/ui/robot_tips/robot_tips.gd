extends Control

@export var tips : Array[Conversation] = []
@onready var conversing_manager = $ConversingManager
@onready var overlay = $Overlay
@onready var robot_anim = $Robot/AnimationPlayer

signal tips_finished


func _ready() -> void:
	conversing_manager.conversations = tips


func start_tips(idx : int) -> void:
	if (idx >= tips.size()):
		idx = tips.size() - 1
	
	await conversing_manager.start_conversation(idx)
	var tween = get_tree().create_tween()
	tween.tween_property(overlay, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "position:y", 800, 1.0)
	await tween.finished
	emit_signal("tips_finished")
	set_visible(false)


func _on_dialog_manager_text_started() -> void:
	robot_anim.play("talking")


func _on_dialog_manager_text_ended() -> void:
	robot_anim.play("idle")
