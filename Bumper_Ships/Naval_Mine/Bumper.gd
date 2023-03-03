extends Bumper_Ship

func explode():
	var explode = load("res://Bumper_Ships/Naval_Mine/Explosion.tscn").instantiate()
	explode.transform = global_transform
	emit_signal("spawn_explosion",explode)

