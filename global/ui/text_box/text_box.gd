extends MarginContainer

@onready var label : = $MarginContainer/Label
@onready var timer = $LetterTimer

const MAX_WIDTH = 1280

var text : String = ""
var letter_index : int = 0

var letter_time : float = 0.03
var space_time : float = 0.04
var punc_time : float = 0.15
var end_punc_time : float = 0.3

var target_size : Vector2

signal finished_displaying

var skipping : bool = false



func display_text(msg : String, prev_size : Vector2) -> void:
	text = msg
	label.set_text(msg)
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	target_size.x = min(size.x, MAX_WIDTH)
	
	if (size.x > MAX_WIDTH):
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x resize
		await resized # wait for y resize
		custom_minimum_size.y = size.y
		target_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y
	
	label.set_visible_characters(0)
	
	# lerp size
	
	custom_minimum_size = Vector2.ZERO
	
	# lerp size
	
	_display_letter()


func _display_letter() -> void:
	label.visible_characters += 1
	letter_index += 1
	if letter_index >= text.length():
		skipping = false
		finished_displaying.emit()
		return
	
	if (not skipping):
		match text[letter_index - 1]:
			',', ':', ';':
				timer.start(punc_time)
			'.', '!', '?':
				timer.start(end_punc_time)
			' ':
				timer.start(space_time)
			_:
				timer.start(letter_time)
	else:
		_display_letter()


func skip() -> void:
	skipping = true


func _on_letter_timer_timeout() -> void:
	_display_letter()
