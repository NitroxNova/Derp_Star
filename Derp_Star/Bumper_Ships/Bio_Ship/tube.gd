extends CollisionShape2D

func on_player_hit():
	queue_free()
