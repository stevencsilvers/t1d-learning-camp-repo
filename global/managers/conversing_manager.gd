extends Node

@export var dialog_manager : DialogManager
@export var response_manager : ResponseManager
@export var image_rect : TextureRect

@export var conversations : Array[Conversation] = []

signal advanced_dialog
signal conversation_started

var current_conversation : int
var bedrock_calls_used : int = 0
var responses_used : int = 0

var response_split : bool = false
var split_chars : String = ".!?"
var split_minimum : int = 32

@export var dialog_start_delay : float = 0.0

@export var images : Array[DisplayImage] = []


func _ready() -> void:
	if (response_manager != null):
		response_manager.connect("text_submitted", _on_response_manager_text_submitted)


func start_conversation(idx : int, tts : bool = true, voice : int = 38) -> void:
	if (idx >= conversations.size()):
		printerr("<conversing_manager> start_conversation idx is out of bounds of conversations array, index: ", idx)
		return
	
	current_conversation = idx
	responses_used = 0
	emit_signal("conversation_started")
	
	await get_tree().create_timer(dialog_start_delay).timeout
	
	await dialog_manager.set_dialog_box_visible(true)
	
	for i in range(conversations[idx].dialog.size()):
		var dialog : String = conversations[idx].dialog[i]
		response_split = false
		
		if (dialog.begins_with("~")): # Display Image
			if (image_rect != null):
				display_image(conversations[idx], dialog)
		elif (dialog == "_"): # User inputs response
			await get_response()
		else: # Continue dialog
			if (dialog.begins_with("^")): # Bedrock call
				await get_bedrock_response(idx, tts, voice)
					
			else: # Normal dialog
				dialog_manager.update_dialog_box(dialog, tts, voice)
			
			if (not response_split):
				await advanced_dialog
			
			if (dialog_manager.msg_updating): # skip line reveal animation
				dialog_manager.skip_line()
				await advanced_dialog
				WMM.play_sound("AdvancedDialog")
			else:
				WMM.play_sound("AdvancedDialog")
	
	await dialog_manager.set_dialog_box_visible(false)


func get_response() -> void:
	if (response_manager == null):
		conversations[current_conversation].user_responses.append("<ConversingManager> Error! No ResponseManager reference.")
		return
	
	response_manager.request_response()
	await response_manager.text_submitted


func get_bedrock_response(_idx : int, tts : bool, voice : int) -> void:
	var req = conversations[_idx].bedrock_calls[bedrock_calls_used]
	
	var prompt : String = req.prompt
	
	if (prompt.find("_") != -1): # If prompt has space for user response
		if (responses_used >= conversations[_idx].user_responses.size()):
			printerr("<conversing_manager> user responses out of bounds, responses_used: ", responses_used)
		else:
			prompt = prompt.replace("_", conversations[_idx].user_responses[responses_used])
			prompt = prompt.replace("\"", "\'") # quotation marks mess up call
			prompt = prompt.replace("\n", " ") # new lines mess up call
			prompt = prompt.replace("\\", " ") # \ messes up call
			responses_used += 1
	
	print(req.model, " ", prompt, " ", req.length, " ", req.temp, " ", req.top_p) # TEMP TEMP TEMP
	var response : String = await WMM.bedrock.bedrock_request(req.model, prompt, req.length, req.temp, req.top_p)
	conversations[current_conversation].bedrock_calls[bedrock_calls_used].response = response
	bedrock_calls_used += 1
	
	print(response + "\n\n") # debug
	
	# if response should be split
	if (response.length() > split_minimum):
		await split_response(response, tts, voice)
		response_split = true
	else:
		dialog_manager.update_dialog_box(response, tts, voice)
	
	# If AI asks follow-up question
	if (response.ends_with("?")):
		# Create new follow up question
		var prev_call = conversations[current_conversation].bedrock_calls[bedrock_calls_used - 1]
		var new_call : BedrockCall = BedrockCall.new()
		new_call.model = prev_call.model
		new_call.prompt = prev_call.prompt.substr(0, prev_call.prompt.find(")") + 1) + " " + prev_call.response + ", Other: _. " + "You: " # prev_call.prompt + 
		new_call.length = prev_call.length
		new_call.temp = prev_call.temp
		new_call.top_p = prev_call.top_p
		conversations[current_conversation].bedrock_calls.insert(bedrock_calls_used, new_call)
		
		await get_response()
		await get_bedrock_response(_idx, tts, voice)


# Split Bedrock response into sentences and display each
func split_response(response : String, tts : bool, voice : int) -> void:
	var split : Array[String] = []
	
	var resp : String = response
	var split_index : int = 0
	var find_index
	var continue_loop : bool = true
	
	while (continue_loop):
		split_index = resp.length()
		
		for i in (split_chars.length()):
			find_index = resp.find(split_chars[i])
			if (find_index != -1 and find_index < split_index): # and find_index >= split_minimum
				split_index = find_index
		
		if (split_index == resp.length()): # didn't split at all
			continue_loop = false
		else:
			split.append(resp.substr(0, split_index + 1))
			resp = resp.substr(split_index + 1)
	
	if (split.size() == 0):
		split.append(resp)
	
	
	for i in range (split.size()):
		dialog_manager.update_dialog_box(split[i], tts, voice)
		
		await advanced_dialog
		WMM.play_sound("AdvancedDialog")
			
		if (dialog_manager.msg_updating): # skip line reveal animation
			dialog_manager.skip_line()
			await advanced_dialog
			WMM.play_sound("AdvancedDialog")


func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("advance_dialog")):
		emit_signal("advanced_dialog")


func _on_response_manager_text_submitted(text : String) -> void:
	conversations[current_conversation].user_responses.append(text)


func display_image(conversation : Conversation, image_name : String):
	if (image_name == "~"): # Clear image
		image_rect.set_texture(null)
		WMM.play_sound("WriteChalk")
	else: # Find image in conversation's images array
		var img : DisplayImage = null
		var name2 = image_name.substr(1)
		for disp_img in images:
			if (disp_img.name == name2):
				img = disp_img
		
		if (img == null):
			printerr("<ConversingManager> Cannot find image with name \"", image_name, "\"")
		else:
			image_rect.set_texture(img.image)
			WMM.play_sound("WriteChalk")
