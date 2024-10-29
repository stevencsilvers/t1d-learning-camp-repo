extends Node2D

@onready var time_manager = $TimeManager
@onready var player = $IslandPlayer

@onready var portals = $Portals
@onready var npcs = $NPCs
@export var target_order : Array[WorldTarget] = []
var current_target : WorldTarget = null

@export var demo_target_order : Array[WorldTarget] = []
@export var use_demo : bool = false

var data : Array[int] = [0]: 
	set(_data): data = _data


func _ready():
	set_player_pos()
	
	for portal in portals.get_children():
		portal.set_active(false)
	for npc in npcs.get_children():
		npc.set_active(false)
	
	if (WMM.progress != null):
		if (not use_demo and WMM.progress.get_progress() < target_order.size() - 1):
			next()
		elif (use_demo and WMM.progress.get_progress() < target_order.size() - 1):
			next()
		else:
			pass # End of game (make boat spawn)


func next() -> void:
	WMM.progress.next_progress()
	if (not use_demo):
		current_target = target_order[WMM.progress.get_progress()]
	else:
		current_target = demo_target_order[WMM.progress.get_progress()]
	current_target.set_active(true)
	
	if (current_target.concurrent):
		next()
	else:
		current_target.is_current_target = true
	
	#if (current_target != null):
		#if (current_target is WorldPortal and current_target.destination_world == "cabin"):
			#time_manager.set_time("night")
		#elif (WMM.progress.get_progress() < target_order.size() - 1 and target_order[WMM.progress.get_progress() + 1] is WorldPortal and target_order[WMM.progress.get_progress() + 1].destination_world == "cabin"):
			#time_manager.set_time("sunset")
		#elif (WMM.progress.get_progress() < target_order.size() - 2 and target_order[WMM.progress.get_progress() + 1] is NPC and target_order[WMM.progress.get_progress() + 2] is WorldPortal and target_order[WMM.progress.get_progress() + 2].destination_world == "cabin"):
			#time_manager.set_time("sunset")


func set_player_pos() -> void:
	if (WMM.progress != null):
		if (WMM.progress.last_island_pos == Vector2.ZERO):
			WMM.progress.set_last_island_pos(player.get_position())
		else:
			player.set_position(WMM.progress.last_island_pos)
