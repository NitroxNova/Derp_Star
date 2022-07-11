extends RigidBody2D

func _on_Area2D_body_entered(body):
	Player_Stats.add_boss_core()
	queue_free()

func _process(delta):
	var angle = Connector.derp_star.global_position.angle_to_point(global_position)
	linear_velocity = Vector2(500,0).rotated(angle)
