extends Dropped_Item
class_name Ore_Chunk

@export var points : int

func on_pickup(body):
	if body==Connector.derp_star:
		Player_Stats.increase_points(points)

func set_size(s:float):
	points *= s
	var scale_vec = Vector2(sqrt(s),sqrt(s))
	$Sprite2D.scale = scale_vec
	$CollisionShape2D.scale = scale_vec
	$Area2D.scale = scale_vec
	
