extends Node2D

var bumper_texture : Texture2D
var shard_velocity_map = {}
var shard_count = 50
var height : float
var width : float
var shader_material

func _ready():
	$Boom.play()
	make_debris()

func _process(delta):
	for child in shard_velocity_map.keys():
		child.position -= shard_velocity_map[child] * delta * 400
		child.color.a -= delta 

func _on_Boom_animation_finished():
#	print("explosion finished")
	queue_free()

func make_debris():
	var points = PackedVector2Array()
	
	$Boom.scale.x = (float(width)/256) * 1.2
	$Boom.scale.y = (float(height)/256) * 1.2
	
	$Debris.position.x -= width/2
	$Debris.position.y -= height/2
	points.append(Vector2(0,0))
	points.append(Vector2(0,height))
	points.append(Vector2(width,height))
	points.append(Vector2(width,0))
		
	for i in range(shard_count):
		points.append(Vector2(randf()*width,randf()*height))
	
	var delaunay_points = Geometry2D.triangulate_delaunay(points)
	
	for index in len(delaunay_points) / 3:
		var shard_pool = PackedVector2Array()
		var center = Vector2.ZERO
		
		for n in range(3):
			shard_pool.append(points[delaunay_points[(index * 3) + n]])
			center += points[delaunay_points[(index * 3) + n]]
		center /= 3
			
		var shard = Polygon2D.new()
		shard.polygon = shard_pool
		shard.texture = bumper_texture
		shard.material = shader_material
		var shard_velocity = (Vector2(width/2,height/2) - center) / Vector2(width/2,height/2)
		shard_velocity_map[shard] = shard_velocity
		$Debris.add_child(shard)
