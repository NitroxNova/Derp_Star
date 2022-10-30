extends Bumper_Ship

func explode():
	var explode = load("res://Bumper_Ships/Naval_Mine/Explosion.tscn").instance()
	explode.transform = global_transform
	Connector.draw_explosion(explode)

