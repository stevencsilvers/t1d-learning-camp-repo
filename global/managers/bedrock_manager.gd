extends Node
class_name BedrockManager


@onready var http_request = $HTTPRequest
const url : String = "https://vt3fkivoma.execute-api.us-east-1.amazonaws.com/dev"
const headers : Array[String] = ["Content-Type: application/json"]
signal content_recieved(data)

var output : String = "[output]"

signal response_received(text : String)


func bedrock_request(model : String, prompt : String, length : int = 100, temp : float = 0.0, top_p : float = 0.1) -> String:
	var body : String = '{"model": "' + model + '", "prompt": "' + prompt + '", "length": "' + str(length) + '", "temp": "' + str(temp) + '", "top_p": "' + str(top_p) + '"}'
	
	http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	
	await content_recieved
	
	emit_signal("response_received", output)
	return output


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var dict : Dictionary
	
	if (result == 0 and response_code == 200):
		dict = JSON.parse_string(body.get_string_from_utf8())
		output = parse_dict_for_output(dict)
		#print(dict) # TEMP
	else:
		output = "Error! (result: " + str(result) + ", response_code: " + str(response_code) + ")"
	
	content_recieved.emit(output)


func parse_dict_for_output(dict : Dictionary) -> String:
	var sd = str(dict) # String Dictionary
	var start : int = sd.find("\"outputText\": \"") + 15
	var substring : String = sd.substr(start, sd.find("completionReason") - start - 4)
	substring = substring.replace("\\", "")
	return substring
