extends Resource
class_name Conversation

@export var background : Texture2D
@export var dialog : Array[String] = []
@export var bedrock_calls : Array[BedrockCall] = []
var user_responses : Array[String]
