extends Area2D

var faction = "environment"
var dps : float = 30
var size : float = 1

func _process(delta):
	for body in get_overlapping_bodies():
		var dist = global_position.distance_to(body.global_position)
		var dist_ratio = 1 - (dist/$CollisionShape2D.shape.radius)
		var damage = dps * delta * dist_ratio * size
		if body.is_in_group("bumper") and body.health.current <= damage:
			increase_size(body.points * .01)
			body.explode()
			body.queue_free()
		else:
			Connector.deal_damage(self,body,damage)

func set_size(s:float):
	size = s
	var l_scale = sqrt(size)
	scale = Vector2(l_scale,l_scale)
	
func increase_size(amount:float):
	set_size(size + amount)
