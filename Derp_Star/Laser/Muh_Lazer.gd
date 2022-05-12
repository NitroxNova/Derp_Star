extends Player_Beam
	
func _process(delta):
	._process(delta)
	for body in $Beam.get_overlapping_bodies():
		body.take_damage(100*delta)

func _on_Beam_body_entered(body):
	if body.is_in_group("bumper"):
		body.static_on()

func _on_Beam_body_exited(body):
	if body.is_in_group("bumper"):
		body.static_off()

