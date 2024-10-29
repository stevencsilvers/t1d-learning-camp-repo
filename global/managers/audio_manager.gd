extends Node
class_name AudioManager


func play(name : String) -> void:
	var target_stream : AudioStreamPlayer = get_node(name)
	
	if (target_stream == null):
		printerr("<AudioManager> Cannot find sfx named: ", name)
		return
	
	if (target_stream is AudioStreamPlayerPlus):
		target_stream.play_plus()
	else:
		target_stream.play()
