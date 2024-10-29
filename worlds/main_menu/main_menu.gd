extends Control

@onready var dog_art = $Main/DogArt
@onready var robot_art = $Main/RobotArt
var art_shift : Vector2 = Vector2.ZERO

var stats_showing : bool = false


var data : Array[int] = [1]: 
	set(_data): data = _data


func _process(delta: float) -> void:
	art_shift = -(clamp(Vector2(960, 540).distance_to(get_global_mouse_position()), 0.0, 100.0) * (Vector2(960, 540) - get_global_mouse_position()).normalized()) / 2.0
	dog_art.position = dog_art.position.lerp(art_shift, 0.05)
	robot_art.position = robot_art.position.lerp(art_shift / 1.2, 0.03)


func _on_settings_pressed() -> void:
	print("settings")


func _on_play_pressed() -> void:
	WMM.play_sound("Enter")
	WMM.load_world("island", [0])


func _on_exit_pressed() -> void:
	print("quit application")


func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel")):
		stats_showing = !stats_showing
		$Stats.set_visible(stats_showing)


func _on_stats_button_pressed() -> void:
	stats_showing = true
	$Stats.set_visible(true)
