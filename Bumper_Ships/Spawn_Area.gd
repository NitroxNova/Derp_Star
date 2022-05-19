extends Area2D

var bumper
var frames = 1

signal spawn_bumper

func set_bumper(b):
	bumper = b
	bumper.transform = transform
	for shape in bumper.get_collision_shapes():
		add_child(shape)

func spawn():
	var overlaps = get_overlapping_bodies().size() + get_overlapping_areas().size()
	if overlaps == 0:
		emit_signal("spawn_bumper",bumper)
	queue_free()

func _process(delta):
	if frames <= 0:
		spawn()
	frames -= 1
