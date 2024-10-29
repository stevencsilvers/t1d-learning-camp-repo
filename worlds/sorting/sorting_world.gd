extends Node2D

var data : Array[int] = [0]: 
	set(_data): data = _data

@export var containers : Array[Control]

@onready var score_manager = $ScoreManager

@export var text : TextEdit

var score : int = 0
var display_score : int = 0

var score_changing : bool = false

var highlighted_container : int = -1

@export var food : Array[Food] = []
@export var symptoms : Array[Symptom] = []
var use_symptoms : bool = false
@export var use_symptom_indexes : Array[int]

@onready var objects = $Objects
@onready var cl : Vector2 = $Objects/SpawnCornerL.position # Corner Left
@onready var cr : Vector2 = $Objects/SpawnCornerR.position # Corner Right
@onready var drag_object = preload("res://worlds/sorting/objects/drag_and_drop/drag_and_drop.tscn")

var object_amount : int = 12
var objects_correct : int = 0

@onready var robot_tips = $CanvasLayer3/RobotTips
@onready var icon_r = $CanvasLayer/IconR
@onready var icon_l = $CanvasLayer/IconL
@export var icon_high : Texture2D
@export var icon_low : Texture2D


func _ready() -> void:
	for cont in containers:
		cont.connect("custom_mouse_entered", _container_entered)
		cont.connect("mouse_exited", _container_exited)
	
	if (WMM.progress != null):
		WMM.progress.world_nums["sorting"] += 1
		
		for i in range(use_symptom_indexes.size()):
			if (WMM.progress.world_nums["sorting"] == use_symptom_indexes[i]):
				use_symptoms = true
		
		if (not use_symptoms):
			WMM.progress.food_unlocked += 4
			object_amount = WMM.progress.food_unlocked
	
	if (WMM.progress != null):
		robot_tips.start_tips(WMM.progress.world_nums["sorting"])
	else:
		robot_tips.start_tips(0)
	
	if (use_symptoms):
		icon_r.set_texture(icon_high)
		icon_l.set_texture(icon_low)
	
	spawn_objects()


func spawn_objects() -> void:
	if (not use_symptoms):
		for i in range(object_amount):
			var obj_inst = drag_object.instantiate()
			obj_inst.set_sprite(food[i].sprite)
			obj_inst.obj_name = food[i].name
			obj_inst.position = Vector2(cl.x + ((cr.x - cl.x) / object_amount) * i, randi_range(cl.y, cr.y))
			obj_inst.data = int(food[i].rocket)
			objects.add_child(obj_inst)
	else:
		for i in range(symptoms.size()):
			var obj_inst = drag_object.instantiate()
			obj_inst.set_sprite(symptoms[i].sprite)
			obj_inst.obj_name = symptoms[i].name
			obj_inst.get_node("Sprite2D").set_scale(Vector2(0.6, 0.6))
			obj_inst.def_scale = Vector2(0.6, 0.6)
			obj_inst.position = Vector2(cl.x + ((cr.x - cl.x) / symptoms.size()) * i, randi_range(cl.y, cr.y))
			obj_inst.data = int(symptoms[i].high)
			objects.add_child(obj_inst)



func object_highlighted(obj : Node2D) -> void:
	pass


func object_grabbed(obj : Node2D) -> void:
	pass


func object_dropped(obj : Node2D) -> void:
	if (obj.data == highlighted_container): # correct box
		obj.freeze()
		score_manager.add_to_score(1000, get_global_mouse_position())
		objects_correct += 1
		WMM.play_sound("CorrectSort")
		if (not use_symptoms and objects_correct == object_amount):
			finish()
		elif (use_symptoms and objects_correct == symptoms.size()):
			finish()
	elif (highlighted_container != -1):
		score_manager.add_to_score(-100, get_global_mouse_position())
		WMM.play_sound("IncorrectSort")



func _container_entered(emitting_cont : Control) -> void:
	var cont_index : int
	var i : int = -1
	for cont in containers:
		i += 1
		if (cont == emitting_cont):
			cont_index = i
	
	highlighted_container = cont_index


func _container_exited() -> void:
	highlighted_container = -1


func _unhandled_input(event: InputEvent) -> void: #temp
	if (event.is_action_pressed("ui_cancel")):
		finish()


func finish() -> void:
	await get_tree().create_timer(1.0).timeout
	WMM.load_world("island", [0])
