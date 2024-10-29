extends Node2D


@onready var stars_front : Node2D = $StarsFront
@onready var stars_mid : Node2D = $StarsMiddle
@onready var stars_back : Node2D = $StarsBack

@export var star_speed : float = 300
@export var star_mid_mult : float = 0.5
@export var star_back_mult : float = 0.2


func _process(delta : float) -> void:
	stars_front.position.x -= delta * star_speed
	stars_back.position.x -= delta * star_speed * star_back_mult
	stars_mid.position.x -= delta * star_speed * star_mid_mult
	
	if (stars_front.position.x <= 0):
		stars_front.position.x = 5760
	if (stars_mid.position.x <= 1152):
		stars_mid.position.x = 5760
	if (stars_back.position.x <= 0):
		stars_back.position.x = 5760
