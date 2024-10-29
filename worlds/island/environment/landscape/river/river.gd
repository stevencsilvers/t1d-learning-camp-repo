extends Line2D

@onready var river_particles = preload("res://worlds/island/environment/landscape/river/river_particles.tscn")
@onready var river_foam = preload("res://worlds/island/environment/landscape/river/river_foam.tscn")
@export var particles_spacing = 200
@export var emitting : bool = true
@export var foam : bool = false



func _ready() -> void:
	spawn_particles()


func spawn_particles():
	var vertex_count : int = get_point_count()
	
	if (emitting):
		for i in range(vertex_count - 1):
			var pos : Vector2 = get_point_position(i)
			var next_pos : Vector2 = get_point_position(i + 1)
			var direction : Vector2 = (next_pos - pos).normalized()
			var angle : float = atan2(direction.y, direction.x)
			
			var distance : float = pos.distance_to(next_pos)
			var count : int = int(distance / particles_spacing)
			
			for j in range(count):
				var particles_inst
				if (not foam):
					particles_inst = river_particles.instantiate()
					particles_inst.rotation = angle
				else:
					particles_inst = river_foam.instantiate()
				particles_inst.position = pos.lerp(next_pos, j * 1.0 / count)
				
				add_child(particles_inst)
