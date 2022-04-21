extends Enemy_Projectile

func _ready():
	linear_velocity = Vector2(700,0).rotated(rotation)

func _on_Despawn_Timer_timeout():
	queue_free()

func _on_Laser_body_entered(body):
	if body.is_in_group("player"):
		body.minus_health(5)
		queue_free()
	$Sprite.look_at(linear_velocity+position)
