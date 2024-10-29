extends Resource
class_name BedrockCall


@export var model : String = "base"
@export_multiline var prompt : String = "Hello!"
@export var length : int = 100
@export_range(0.0, 1.0, 0.1) var temp : float = 0.3
@export_range(0.1, 1.0, 0.1) var top_p : float = 0.5

var response : String = ""
