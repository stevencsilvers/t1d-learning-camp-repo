extends NinePatchRect


signal custom_mouse_entered(cont : Control)


func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)


func _on_mouse_entered() -> void:
	emit_signal("custom_mouse_entered", self)
