extends Sprite

onready var space_state = get_world_2d().direct_space_state

func _ready():
	$Deflect_Area.deactivate()

func _physics_process(delta):
	var start = $Beam_Area.global_position
	var end = $Beam_Area/Max_Length.global_position
	var result = space_state.intersect_ray(start,end,[],4)
	if result:
		var length = start.distance_to(result.position)
		$Beam_Area.set_length(length)
		$Line2D.points[1].x = length
		$Deflect_Area.position.x = length
		$Deflect_Area.set_max_length($Beam_Area.max_length-length)
		var incoming_direction = result.position - start
		$Deflect_Area.global_rotation = incoming_direction.bounce(result.normal).angle()
		$Deflect_Area.activate()
		var local_coords = $Line2D.get_global_transform().xform_inv($Deflect_Area/Max_Length.global_position)
		$Line2D.points[2] = local_coords
	elif $Beam_Area.length != $Beam_Area.max_length:
		$Beam_Area.set_length($Beam_Area.max_length)
		$Line2D.points[1] = $Beam_Area/Max_Length.position
		$Line2D.points[2] = $Beam_Area/Max_Length.position
		$Deflect_Area.deactivate()
		
