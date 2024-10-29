extends Node2D
class_name ResponseManager

@onready var text_edit = $Control/DialogBox/MarginContainer/TextEdit
@onready var shake_timer = $ShakeTimer
@onready var control = $Control

@export var shake_curve : Curve
@export var shake_magnitude : float = 48

@onready var done_button : TextureButton = $Control/DoneButton
@onready var mic_button : TextureButton = $Control/MicButton

signal text_requested
signal text_submitted(text : String)


func _ready() -> void:
	control.set_visible(false)


func request_response() -> void:
	control.set_visible(true)
	done_button.set_disabled(false)
	mic_button.set_disabled(false)
	text_edit.set_text("")
	set_scale(Vector2.ZERO)
	_new_tween().tween_property(self, "scale", Vector2(1.0, 1.0), 0.25)
	emit_signal("text_requested")


func _on_done_button_pressed() -> void:
	try_submit_text()

func _process(delta : float) -> void:
	if (not shake_timer.is_stopped()):
		control.position.x = sin(shake_timer.get_time_left() / shake_timer.get_wait_time() * 4 * PI) * \
				shake_curve.sample(1 - shake_timer.get_time_left() / shake_timer.get_wait_time()) * shake_magnitude


func try_submit_text() -> void:
	if (text_edit.get_text() != ""):
		submit_text()
	else: # Can't submit if text edit is empty
		shake_timer.start()


func submit_text() -> void:
	done_button.set_disabled(true)
	mic_button.set_disabled(true)
	
	emit_signal("text_submitted", text_edit.get_text())
	
	WMM.play_sound("SubmitText")
	
	var tween = _new_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.25)
	await tween.finished
	
	control.set_visible(false)


func _on_mic_button_pressed() -> void:
	print("Mic Input")


func _new_tween() -> Tween:
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	return tween


func _input(event: InputEvent) -> void:
	if (control.visible and event.is_action_pressed("enter")):
		try_submit_text()
