extends Enemy_Projectile

var source = "bumper"
var damage = 3

func _ready():
	linear_velocity = Vector2(700,0).rotated(rotation)

func _on_Despawn_Timer_timeout():
	queue_free()

func _on_Laser_body_entered(body):
	if body.is_in_group("player") and source == "bumper":
		body.take_damage(damage)
		queue_free()
	elif body.is_in_group("Player_Shield"):
		source = "player"
		body.take_damage(damage)
	elif source == "player":
		body.take_damage(damage)
		queue_free()
	$Sprite.look_at(linear_velocity+position)
	
