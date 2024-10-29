extends Node2D
class_name DialogManager

@onready var dialog_box : MarginContainer = $DialogBox
@onready var bubble_box : MarginContainer = $BubbleBox
@onready var label : RichTextLabel = $DialogBox/DialogLabel

var dialog_active : bool = false
var msg_updating : bool = false

var letter_time : float = 0.03
var space_time : float = 0.04
var punc_time : float = 0.15
var end_punc_time : float = 0.3

@export var max_width : int = 860
var current_tween : Tween

var bubble_box_moving : bool = false

@export var interactable : bool = true
var start_scale : Vector2

signal advanced_line
signal bubble_box_reached_size
signal text_started
signal text_ended



func _process(delta : float) -> void:
	bubble_box.set_size(bubble_box.get_size().lerp(dialog_box.get_size(), 0.1))
	bubble_box.set_position(-bubble_box.get_size() / 2.0)
	
	if (bubble_box_moving and bubble_box.get_size().x / dialog_box.get_size().x >= 0.97):
		bubble_box_moving = false
		emit_signal("bubble_box_reached_size")


func _ready() -> void:
	start_scale = scale
	bubble_box.set_visible(false)
	set_visible(true)


func set_dialog_box_visible(visible : bool) -> void:
	if (visible):
		label.set_text("")
		bubble_box.set_visible(true)
		set_scale(Vector2.ZERO)
		_new_tween().tween_property(self, "scale", start_scale, 0.2)
		await current_tween.finished
		
		dialog_active = true
	else:
		dialog_active = false
		
		_new_tween().tween_property(self, "scale", Vector2.ZERO, 0.2)
		await current_tween.finished
		bubble_box.set_visible(false)



func update_dialog_box(msg : String, tts : bool = true, tts_voice : int = 38) -> void:
	if (tts):
		var voice : String = DisplayServer.tts_get_voices_for_language("en")[tts_voice]
		DisplayServer.tts_stop()
		DisplayServer.tts_speak(msg, voice)
	
	msg_updating = true
	bubble_box_moving = true
	emit_signal("text_started")
	
	dialog_box.set_custom_minimum_size(Vector2(256, 256))
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	
	label.set_text("!@#$%^&*())(*&^%$#@)") # sets it to random text so it will resize properly
	await dialog_box.resized
	
	label.set_text(msg)
	label.set_visible_characters(0)
	await dialog_box.resized
	
	
	if (dialog_box.size.x > max_width):
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		dialog_box.custom_minimum_size.x = max_width
	
	await bubble_box_reached_size
	
	for i in range(label.get_text().length()):
		if (not msg_updating):
			return
		
		label.visible_characters += 1
		
		if (i < label.get_text().length() - 1):
			var wait_time : float
			match label.get_text()[i]:
				',', ':', ';':
					wait_time = punc_time
				'.', '!', '?':
					wait_time = end_punc_time
				' ':
					wait_time = space_time
				_:
					wait_time = letter_time
			await get_tree().create_timer(wait_time).timeout
	
	label.set_visible_characters(-1)
	msg_updating = false
	emit_signal("text_ended")


func skip_line():
	msg_updating = false
	label.set_visible_characters(-1)
	emit_signal("text_ended")


func _new_tween() -> Tween:
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	current_tween = tween
	return tween
