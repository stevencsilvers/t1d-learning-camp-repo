extends WorldTarget
class_name NPC

var player_in_area : bool = false
var dialog_active : bool = false

@onready var dialog_manager = $DialogManager
@onready var ui = get_tree().get_first_node_in_group("island_ui")
@onready var player = get_tree().get_first_node_in_group("island_player")
@onready var conversing_manager = $ConversingManager
@onready var sprite = $Sprite2D
@onready var interact_area = $InteractArea

@export var conversations : Array[Conversation] = []
@onready var island_world = get_tree().get_first_node_in_group("island_world")

var conversations_used = 0

@export var npc_sprite : Texture2D
@export var npc_sprite_talking : Texture2D
@onready var talk_anim_timer : Timer = $TalkAnimTimer
var talking_sprite_showing : bool = false

@export var tts_voice : int = 38

@export var active : bool = true:
	set = set_active


func _ready():
		if (island_world != null):
			var world_data : int = island_world.data[0]
		
		if (npc_sprite != null):
			sprite.set_texture(npc_sprite)
		
		sprite.set_material(sprite.get_material().duplicate())
		
		conversing_manager.conversations = conversations


func _unhandled_input(event: InputEvent) -> void:
	if (player_in_area and not dialog_active and event.is_action_pressed("advance_dialog")):
		start_dialog()


func set_active(_active : bool) -> void:
	active = _active
	set_visible(active)
	interact_area.set_monitoring(active)
	$StaticBody2D/CollisionShape2D.set_disabled(true)


func start_dialog() -> void:
	dialog_active = true
	player.set_camera_zoom(1.1, 1.0)
	var prev_mult : float = player.set_input_mult(0.0)
	ui.set_input_prompt_visible(false)
	sprite.get_material().set_shader_parameter("show", false)
	WMM.play_sound("Boop")
	
	await conversing_manager.start_conversation(conversations_used, true, tts_voice)
	if (conversations_used < conversations.size() - 1):
		conversations_used += 1
	
	dialog_active = false
	player.set_camera_zoom(1.0, 1.0)
	player.set_input_mult(prev_mult)
	ui.set_input_prompt_visible(true)
	sprite.get_material().set_shader_parameter("show", true)


func _on_interact_area_body_entered(body: Node2D) -> void:
	if (body is IslandPlayer):
		player_in_area = true
		ui.set_input_prompt_visible(true)
		sprite.get_material().set_shader_parameter("show", true)
		WMM.play_sound("Appear")


func _on_interact_area_body_exited(body: Node2D) -> void:
	if (body is IslandPlayer):
		player_in_area = false
		ui.set_input_prompt_visible(false)
		sprite.get_material().set_shader_parameter("show", false)
		WMM.play_sound("Disappear")


func _on_dialog_manager_text_started() -> void:
	talk_anim_timer.start()
	sprite.set_texture(npc_sprite_talking)
	talking_sprite_showing = true


func _on_dialog_manager_text_ended() -> void:
	talk_anim_timer.stop()
	sprite.set_texture(npc_sprite)
	talking_sprite_showing = false


func _on_talk_anim_timer_timeout() -> void:
	talking_sprite_showing = !talking_sprite_showing
	
	if (talking_sprite_showing):
		sprite.set_texture(npc_sprite_talking)
	else:
		sprite.set_texture(npc_sprite)
