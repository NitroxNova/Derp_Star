extends CollisionShape2D

func on_player_hit():
	Player_Stats.increment_health(10)
	queue_free()
