extends WorldTarget
class_name WorldPortal


var player_in_area : bool = false
@export var destination_world : String = ""
@export var destination_data : Array[int] = [0]

@export var dialog_text : String = "Enter!"

@onready var dialog_manager = $DialogManager
@onready var sprite = $Sprite

@onready var ui = get_tree().get_first_node_in_group("island_ui")
@onready var player = get_tree().get_first_node_in_group("island_player")
@onready var player_compass = get_tree().get_first_node_in_group("island_player").get_node("Compass")

var used : bool = false

signal portal_area_entered
signal portal_area_exited
signal portal_used

@export var active : bool = true:
	set = set_active


func _ready() -> void:
	sprite.set_material(sprite.get_material().duplicate())


func _unhandled_input(event: InputEvent) -> void:
	if (active and not used and player_in_area and event.is_action_pressed("advance_dialog")):
		use_portal()


func set_active(_active : bool):
	active = _active


func use_portal() -> void:
	used = true
	emit_signal("portal_used")
	WMM.play_sound("Enter")
	player.set_input_mult(0.0)
	player.set_camera_zoom(2.5, 2.0)
	await dialog_manager.set_dialog_box_visible(false)
	dialog_manager.queue_free()
	await get_tree().create_timer(1.0).timeout
	
	if (WMM.load_world(destination_world, destination_data) == true):
		return
	
	player.set_input_mult(1.0)
	player.set_camera_zoom(1.0, 2.0)



func _on_portal_area_body_entered(body: Node2D) -> void:
	if (active and body is IslandPlayer):
		player_in_area = true
		emit_signal("portal_area_entered")
		set_player_compass_visible(false)
		sprite.get_material().set_shader_parameter("show", true)
		ui.set_input_prompt_visible(true)
		WMM.play_sound("Appear")
		
		if (dialog_manager != null):
			dialog_manager.set_dialog_box_visible(true)
			dialog_manager.update_dialog_box(dialog_text, false)


func _on_portal_area_body_exited(body: Node2D) -> void:
	if (active and not used and body is IslandPlayer):
		player_in_area = false
		emit_signal("portal_area_exited")
		set_player_compass_visible(true)
		sprite.get_material().set_shader_parameter("show", false)
		ui.set_input_prompt_visible(false)
		WMM.play_sound("Disappear")
		
		if (dialog_manager != null):
			dialog_manager.set_dialog_box_visible(false)


func set_player_compass_visible(vis : bool) -> void:
	player_compass.set_compass_visible(is_current_target, vis)
