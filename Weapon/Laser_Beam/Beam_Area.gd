extends Area2D
class_name Laser_Beam_Area

var length : float
var height : float
var max_length : float
@onready var direct_space = get_world_2d().direct_space_state
var area_scene = load("res://Weapon/Laser_Beam/Beam_Area.tscn")
var faction
var dps
var damage_shapes = []

func _physics_process(delta):
	for body in get_overlapping_bodies():
		Connector.deal_damage(self,body,dps*delta)
	for shape in damage_shapes:
		if !Connector.deal_damage(self,shape,dps*delta):
			damage_shapes.erase(shape)

func set_height(h:float):
	height = h
	$CollisionShape2D.shape.size.y = height
	
func set_length(l:float):
	length = l
	$CollisionShape2D.shape.size.x = length
	$CollisionShape2D.position.x = length/2

func set_maximum_length(m):
	max_length = m
	$Max_Length.position.x = max_length
	$RayCast2D.target_position.x = max_length

func get_raycast_start():
	return global_position

func get_raycast_end():
	return $Max_Length.global_position

func cast_beam():
	var start = get_raycast_start()
	var end = get_raycast_end()
	if $RayCast2D.is_colliding():
		var collision_point = $RayCast2D.get_collision_point()
		set_length(start.distance_to(collision_point))
		if not $Beam_Area:
			var new_area = area_scene.instantiate()
			new_area.set_height(height)
			new_area.dps = dps
			add_child(new_area)
		$Beam_Area.set_maximum_length(max_length-length)
		$Beam_Area.global_position = collision_point
#		var incoming_direction = collision_point - start
#		$Beam_Area.global_rotation = incoming_direction.bounce(result.normal).angle()
		$Beam_Area.global_rotation = $RayCast2D.get_collision_normal().angle()
		$Beam_Area.faction = $RayCast2D.get_collider().faction
		$Beam_Area.cast_beam()
	else:
		set_length(max_length)
		if has_node("Beam_Area"):
			remove_child($Beam_Area)

func body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if not body is TileMapLayer:
		var shape = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
		if is_instance_valid(shape):
			damage_shapes.append(shape)

func body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if not body is TileMapLayer:
		if is_instance_valid(body):
			var shape = body.shape_owner_get_owner(body_shape_index)
			damage_shapes.erase(shape)
