extends Bumper_Ship

var connected_domes = []

func set_domes(d1,d2):
	connected_domes.append(d1)
	connected_domes.append(d2)
	d1.connected_tubes.append(self)
	d2.connected_tubes.append(self)
	set_endpoints(d1.position,d2.position)

func set_endpoints(c1,c2):
	var center = (c1 + c2) / 2
	position = center
	rotation = (c1.direction_to(c2)).angle()
	var length = c1.distance_to(c2) - 130
	$Polygon2D.polygon = [Vector2(0,0),Vector2(length,0),Vector2(length,30),Vector2(0,30)]
	$Polygon2D.position.x = length/2 * -1
	$Collision_Shape.shape.extents.x = length/2
	$Static.process_material.emission_box_extents.x = length/2
	$Static.amount = length * .1

func explode():
	var e = explosion.instance()
	e.transform = global_transform
	e.bumper_texture = $Polygon2D.texture
	e.width = $Polygon2D.polygon[1].x
	e.height = 30
	emit_signal("draw_explosion",e)
