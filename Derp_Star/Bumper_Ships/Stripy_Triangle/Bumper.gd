extends StaticBody2D

var is_valid = true

func on_player_hit():
	if is_valid:
		Player_Stats.add_points(100)
		Utils.despawn(self)
