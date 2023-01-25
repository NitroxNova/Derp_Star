extends Area2D

var length : float
var height : float
var max_length : float
onready var direct_space = get_world_2d().direct_space_state
var area_scene = load("res://Weapon/Laser_Beam/Beam_Area.tscn")
var faction
var dps

func _physics_process(delta):
	for body in get_overlapping_bodies():
		Connector.deal_damage(self,body,dps*delta)

func set_height(h:float):
	height = h
	$CollisionShape2D.shape.extents.y = height/2
	
func set_length(l:float):
	length = l
	$CollisionShape2D.shape.extents.x = length/2
	$CollisionShape2D.position.x = length/2

func set_maximum_length(m):
	max_length = m
	$Max_Length.position.x = max_length

func get_raycast_start():
	return global_position

func get_raycast_end():
	return $Max_Length.global_position

func cast_beam():
	var start = get_raycast_start()
	var end = get_raycast_end()
	var result = direct_space.intersect_ray(start,end,[],4)
	if result:
		set_length(start.distance_to(result.position))
		if not $Beam_Area:
			var new_area = area_scene.instance()
			new_area.set_height(height)
			new_area.dps = dps
			add_child(new_area)
		$Beam_Area.set_maximum_length(max_length-length)
		$Beam_Area.global_position = result.position
		var incoming_direction = result.position - start
		$Beam_Area.global_rotation = incoming_direction.bounce(result.normal).angle()
		$Beam_Area.faction = result.collider.faction
		$Beam_Area.cast_beam()
	else:
		set_length(max_length)
		remove_child($Beam_Area)
