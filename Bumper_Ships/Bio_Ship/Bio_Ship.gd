extends StaticBody2D

var is_valid = true

func on_player_hit():
	if get_child_count() == 1:
		Utils.despawn(self)
