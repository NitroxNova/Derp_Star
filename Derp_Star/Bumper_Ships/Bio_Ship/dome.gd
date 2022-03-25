extends CollisionShape2D

func on_player_hit():
	Player_Stats.add_points(100)
	queue_free()
