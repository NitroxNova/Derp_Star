extends Area2D

func _on_despawn_radius_body_exited(body):
	Utils.despawn(body)
