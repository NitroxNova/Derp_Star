extends Node2D

const MAX_COUNT = 100
const INNER_X = 1920/2 + 100
const INNER_Y = 1080/2 + 100

const SPAWN_SIZE = 4000
const DESPAWN_RADIUS = (SPAWN_SIZE/2) * sqrt(2)

export var bumper_scenes = []

func spawn_bumper():
	var bumper = bumper_scenes[randi() % bumper_scenes.size()].instance()
	bumper.build()
	bumper.position = generate_coords()
	while not is_valid_spawn_location(bumper):
		bumper.position = generate_coords()
	Connector.spawn_bumper(bumper)

func generate_coords():
	var min_coord = Connector.derp_star.global_position - Vector2(SPAWN_SIZE/2,SPAWN_SIZE/2)
	var newx = (randf() * SPAWN_SIZE) + min_coord[0]
	var newy = (randf() * SPAWN_SIZE) + min_coord[1]
	var new_coords = Vector2(newx,newy)
	if is_off_screen(new_coords):
		return new_coords
	return generate_coords()
	
func is_valid_spawn_location(bumper):
	var space_state = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	for cs in bumper.get_collision_shapes():
		if cs is CollisionShape2D:
			query.set_shape(cs.shape)
		elif cs is CollisionPolygon2D:
			var shape = ConvexPolygonShape2D.new()
			shape.points = cs.polygon
			query.set_shape(shape)
		query.transform = cs.transform
		var result = space_state.intersect_shape(query,1)
		if result:
			return false
	return true

func is_off_screen(loc):
	if loc[0] < Connector.derp_star.global_position.x - INNER_X:
		return true
	elif loc[0] > Connector.derp_star.global_position.x + INNER_X:
		return true
	elif loc[1] < Connector.derp_star.global_position.y - INNER_Y:
		return true
	elif loc[1] > Connector.derp_star.global_position.y + INNER_Y:
		return true
	else:
		return false

func _process(delta):
	while get_child_count() < MAX_COUNT:
		spawn_bumper()
	despawn_random(20)

func despawn_random(n=1):
	if get_child_count():
		var rand_bumper = get_child(randf() * get_child_count())
		var distance = rand_bumper.global_position.distance_to(Connector.derp_star.global_position)
		if distance > DESPAWN_RADIUS:
			rand_bumper.queue_free()
			if n > 1:
				despawn_random(n-1)
