extends Node


@export var score_label : RichTextLabel
@onready var add_to_score_label = preload("res://global/ui/score/add_to_score_label.tscn")

@export_color_no_alpha var positive_color : Color
@export_color_no_alpha var negative_color : Color


var score : int = 0
var display_score : int = 0
var score_changing : bool = false

var prev_color_tween : Tween
var prev_number_tween : Tween

signal score_changed(score)


func _ready():
	_set_score_label(0)


func add_to_score(amount : int, pos : Vector2 = Vector2(-1, -1), color_change : bool = true) -> void:
	if (prev_number_tween != null):
		prev_number_tween.kill()
		_set_score_label(score)
	
	score += amount
	emit_signal("score_changed", score)
	
	if (amount < -10 or amount > 10):
		score_changing = true
		var tween : Tween = get_tree().create_tween()
		prev_number_tween = tween
		tween.tween_property(self, "display_score", score, 0.5)
		tween.tween_callback(_score_done_changing)
	else:
		_set_score_label(score)
	
	if (pos != Vector2(-1, -1)):
		var label_inst = add_to_score_label.instantiate()
		label_inst.position = pos
		label_inst.set_value(amount)
		if (WMM.get_global_ui() != null):
			WMM.get_global_ui().add_child(label_inst)
	
	if (color_change and score_label != null):
		if (amount > 0):
			score_label.set_modulate(positive_color)
		else:
			score_label.set_modulate(negative_color)
		
		if (prev_color_tween != null):
			prev_color_tween.kill()
		var tween = create_tween()
		prev_color_tween = tween
		tween.tween_property(score_label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)


func _score_done_changing() -> void:
	score_changing = false
	_set_score_label(score)


func _process(_delta : float) -> void:
	if (score_changing):
		_set_score_label(display_score)


func _set_score_label(num : int):
	score_label.set_text(" " + str(num))
