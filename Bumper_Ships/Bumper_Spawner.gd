extends Node2D

const MAX_COUNT = 100
const INNER_X = 1920/2 + 100
const INNER_Y = 1080/2 + 100

const SPAWN_SIZE = 4000
const DESPAWN_RADIUS = (SPAWN_SIZE/2) * sqrt(2)

var count = 0
var striped_bumper = preload("res://Bumper_Ships/Stripes/Bumper.tscn")
var shooting_star = preload("res://Bumper_Ships/Shooting_Star/Bumper.tscn")
var biodome = preload("res://Bumper_Ships/Bio_Dome/Colony.tscn")
var bumper_scenes = [striped_bumper,shooting_star,biodome]
var spawn_area_scene = preload("res://Bumper_Ships/Spawn_Area.tscn")

signal spawn_bumper

func update_bumper_count():
	count = get_child_count()

func spawn_bumper():
	var spawn_location = generate_coords()
	while not is_valid_spawn_location(spawn_location):
		spawn_location = generate_coords()
	var spawn_area = spawn_area_scene.instance()
	spawn_area.position = spawn_location
	var bumper = bumper_scenes[randi() % bumper_scenes.size()].instance()
	spawn_area.set_bumper(bumper)
	emit_signal("spawn_bumper",spawn_area)

func generate_coords():
	var min_coord = Connector.derp_star.global_position - Vector2(SPAWN_SIZE/2,SPAWN_SIZE/2)
	var newx = (randf() * SPAWN_SIZE) + min_coord[0]
	var newy = (randf() * SPAWN_SIZE) + min_coord[1]
	return Vector2(newx,newy)

func is_valid_spawn_location(loc):
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
	while count < MAX_COUNT:
		spawn_bumper()
	despawn_random(20)

func despawn_random(n=1):
	var rand_bumper = get_child(randi() % get_child_count())
	var distance = rand_bumper.global_position.distance_to(Connector.derp_star.global_position)
	if distance > DESPAWN_RADIUS:
		rand_bumper.queue_free()
		update_bumper_count()
		if n > 1:
			despawn_random(n-1)
