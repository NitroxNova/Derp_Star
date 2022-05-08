extends Area2D

const MAX_COUNT = 40
const INNER_X = 1920/2 + 100
const INNER_Y = 1080/2 + 100

var count = 0
var striped_bumper = preload("res://Bumper_Ships/Stripes/Bumper.tscn")
var shooting_star = preload("res://Bumper_Ships/Shooting_Star/Bumper.tscn")
var biodome = preload("res://Bumper_Ships/Bio_Dome/Colony.tscn")
var bumper_scenes = [striped_bumper,shooting_star,biodome]

signal update_count
signal spawn_bumper

func _ready():
	while count < MAX_COUNT:
		spawn_bumper()

func spawn_bumper():
	var bumper = bumper_scenes[randi() % bumper_scenes.size()].instance()
	bumper.position = generate_coords()
	while not is_valid_spawn_location(bumper.position):
		bumper.position = generate_coords()
	bumper.rotation = randf() * 2 * PI
	emit_signal("spawn_bumper",bumper)

func generate_coords():
	var min_coord = global_position - $CollisionShape2D.shape.extents
	var newx = (randf() * $CollisionShape2D.shape.extents[0] * 2) + min_coord[0]
	var newy = (randf() * $CollisionShape2D.shape.extents[1] * 2) + min_coord[1]
	return Vector2(newx,newy)

func is_valid_spawn_location(loc):
	if loc[0] < global_position.x - INNER_X:
		return true
	elif loc[0] > global_position.x + INNER_X:
		return true
	elif loc[1] < global_position.y - INNER_Y:
		return true
	elif loc[1] > global_position.y + INNER_Y:
		return true
	else:
		return false

func _on_Bumper_Manager_body_exited(body):
	if body.is_in_group("bumper"):
		body.queue_free()
		emit_signal("update_count")

func _on_Timer_timeout():
	while count < MAX_COUNT:
		spawn_bumper()
