extends Dropped_Item

func on_pickup(body):
	Player_Stats.add_boss_core()

func _process(delta):
	var angle = Connector.derp_star.global_position.angle_to_point(global_position)
	linear_velocity = Vector2(500,0).rotated(angle)
