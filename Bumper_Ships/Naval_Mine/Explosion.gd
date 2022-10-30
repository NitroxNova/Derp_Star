extends Area2D

var damage = 100
var faction = "environment"
var dealt_damage = false

func _ready():
	$Particle.emitting = true
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape($CollisionShape2D.shape)
	query.transform = global_transform
	var result = get_world_2d().direct_space_state.intersect_shape(query)
	for r in result:
		Connector.deal_damage(self,r.collider,damage)

		
func _on_Timer_timeout():
	queue_free()
