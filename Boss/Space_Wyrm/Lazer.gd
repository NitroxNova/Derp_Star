extends Node2D

onready var space_state = get_world_2d().direct_space_state

func _ready():
	deactivate()

func activate():
	$Beam.activate()
	set_physics_process(true)

func deactivate():
	$Beam.deactivate()
	$Deflect.deactivate()
	set_physics_process(false)

func _physics_process(delta):
	var result = space_state.intersect_ray(global_position, $Beam/Endpoint.global_position, [], 4)
	if result:
		var length = global_position.distance_to(result.position)
		$Beam.set_length(length)
		$Deflect.position.x = length
		$Deflect.set_length(1000-length)
		$Deflect.set_particles_offset(length)
		var incoming_direction = result.position - global_position
		$Deflect.global_rotation = incoming_direction.bounce(result.normal).angle()
		$Deflect.activate()
	else:
		$Beam.set_length(1000)
		$Deflect.deactivate()
