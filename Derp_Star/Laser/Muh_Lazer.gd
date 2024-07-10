extends Player_Beam
	
var damage_shapes = []
var faction = "player"
	
func _process(delta):
	super._process(delta)
	var damage = 100 * delta
	for body in $Beam.get_overlapping_bodies():
		Connector.deal_damage(self,body,damage)
	for shape in damage_shapes:
		if !Connector.deal_damage(self,shape,damage):
			damage_shapes.erase(shape)

func _on_Beam_body_entered(body):
	if body.is_in_group("bumper"):
		body.static_on()

func _on_Beam_body_exited(body):
	if body.is_in_group("bumper"):
		body.static_off()

func _on_Beam_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var shape = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	if is_instance_valid(shape):
		damage_shapes.append(shape)

func _on_Beam_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if is_instance_valid(body):
		var shape = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
		damage_shapes.erase(shape)
