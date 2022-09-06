extends Dropped_Item

func on_pickup(body):
	body.add_energy(50)
