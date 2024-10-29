extends CollisionPolygon2D


func _ready() -> void:
	$StaticBody2D/CollisionPolygon2D.set_polygon(get_polygon())
