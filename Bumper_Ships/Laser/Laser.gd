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
	elif source == "player" and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
	$Sprite.look_at(linear_velocity+position)
	
func _on_Laser_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var shape = body.shape_owner_get_owner(body_shape_index)
	if is_instance_valid(shape) and shape.has_method("take_damage") and source == "player" and not body.is_in_group("player"):
		shape.take_damage(damage)
		queue_free()
