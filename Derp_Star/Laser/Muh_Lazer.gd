extends Player_Beam
	
var damage_shapes = []
	
func _process(delta):
	._process(delta)
	for body in $Beam.get_overlapping_bodies():
		if body.is_in_group("bumper"):
			body.take_damage(100*delta)
	for shape in damage_shapes:
		if is_instance_valid(shape):
			shape.take_damage(100*delta)
		else:
			damage_shapes.erase(shape)

func _on_Beam_body_entered(body):
	if body.is_in_group("bumper"):
		body.static_on()

func _on_Beam_body_exited(body):
	if body.is_in_group("bumper"):
		body.static_off()

func _on_Beam_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var shape = body.shape_owner_get_owner(body_shape_index)
	if is_instance_valid(shape) and shape.has_method("take_damage"):
		damage_shapes.append(shape)

func _on_Beam_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if is_instance_valid(body):
		var shape = body.shape_owner_get_owner(body_shape_index)
		damage_shapes.erase(shape)
