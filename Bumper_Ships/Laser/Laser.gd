extends Enemy_Projectile

var damage = 3
var faction = "enemy"

func _ready():
	linear_velocity = Vector2(700,0).rotated(rotation)

func _on_Despawn_Timer_timeout():
	queue_free()

func _on_Laser_body_entered(body):
	if Connector.deal_damage(self,body,damage):
		if body.is_in_group("Player_Shield"):
			faction = "player"
		else:
			queue_free()
	$Sprite.look_at(linear_velocity+position)
	
func _on_Laser_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var shape = body.shape_owner_get_owner(body_shape_index)
	if Connector.deal_damage(self,shape,damage):
		queue_free()
