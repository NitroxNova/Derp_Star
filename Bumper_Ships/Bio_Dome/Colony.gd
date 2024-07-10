extends Node2D

const size = 500
const min_distance = 200
var dome_count = randi() % 4 + 4
var dome_list = []
var tube_list = []
var housing = preload("res://Bumper_Ships/Bio_Dome/Housing/Dome.tscn")
var reactor = preload("res://Bumper_Ships/Bio_Dome/Reactor/Dome.tscn")
var hospital = preload("res://Bumper_Ships/Bio_Dome/Hospital/Dome.tscn")
var bigtree = preload("res://Bumper_Ships/Bio_Dome/Tree/Dome.tscn")
var dome_scenes = [reactor,hospital,housing,bigtree,housing,bigtree,housing]	

signal spawn_bumper

func _on_Colony_tree_entered():
	draw()

func reset():
	dome_list = []
	tube_list = []
	build()

func get_collision_shapes():
	var shapes = []
	for tube in tube_list:
		var tube_shape = tube.get_collision_shape()
		tube_shape.position += position
		shapes.append(tube_shape)
	for dome in dome_list:
		var dome_shape = dome.get_collision_shape()
		dome_shape.position += position
		shapes.append(dome_shape)
	return shapes
	
func build():
	if not make_domes():
		reset()

func draw():
	for tube in tube_list:
		tube.position += position
		emit_signal("spawn_bumper",tube)
	for dome in dome_list:
		dome.position += position
		emit_signal("spawn_bumper",dome)
	queue_free()
	
func make_domes():
	var dome_coords = PackedVector2Array()
	for i in dome_count:
		var dome = dome_scenes[i].instantiate()
		var pos = rand_coords(20)
		if not pos is Vector2:
			return false
		dome.position = pos
		dome_list.append(dome)
		dome_coords.append(dome.position)
	return make_triangles(dome_coords)
	
func make_triangles(dome_coords):
	var delaunay_points = Geometry2D.triangulate_delaunay(dome_coords)
	for triangle_index in int(len(delaunay_points) / 3.0):
		var triangle_domes = []
		var triangle_coords = PackedVector2Array()
		for n in 3:
			var i = delaunay_points[(triangle_index * 3) + n]
			triangle_domes.append(i)	
			triangle_coords.append(dome_list[i].position)
		if is_valid_triangle(triangle_coords):
			connect_domes(triangle_domes)
		else:
			return false
	return true

func is_valid_triangle(coords):
	for i in 3:
		var c0 = coords[i]
		var c1 = coords[(i+1) % 3]
		var c2 = coords[(i-1) % 3]
		if not is_valid_angle(c0,c1,c2):
			return false
	return true

func is_valid_angle(c0,c1,c2):
	var angle = abs(rad_to_deg((c2-c0).angle_to(c1-c0)))
	if angle < 25:
		return false
	return true
	
func connect_domes(triangle):
	for i in 3:
		var dome_1 = dome_list[triangle[i]]
		var dome_2 = dome_list[triangle[(i+1)%3]]
		var tube = dome_1.connect_dome(dome_2)
		if tube:
			tube_list.append(tube)
			
func rand_coords(attempts):
	var x = randf() * size - size/2
	var y = randf() * size - size/2
	var pos = Vector2(x,y)
	if is_valid_coords(pos):
		return pos
	if attempts > 0:
		return rand_coords(attempts-1)
	return false
	
func is_valid_coords(pos):
	for dome in dome_list:
		if dome.position.distance_to(pos) < min_distance:
			return false
	return true


