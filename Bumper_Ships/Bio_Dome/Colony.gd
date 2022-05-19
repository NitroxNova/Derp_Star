extends Node2D

signal add_points
signal draw_explosion
signal drop_item

func _ready():
	for child in get_children():
		child.connect("add_points",self,"add_points")
		child.connect("draw_explosion",self,"draw_explosion")
		child.connect("drop_item",self,"drop_item")
		child.connect("tree_exited",self,"dome_destroyed")

func get_collision_shapes():
	var shapes = []
	for child in get_children():
		var shape = child.get_collision_shape()
		shape.transform = child.transform
		shapes.append(shape)
	return shapes

func add_points(amount):
	emit_signal("add_points",amount)

func draw_explosion(explosion):
	emit_signal("draw_explosion",explosion)

func drop_item(item):
	emit_signal("drop_item",item)

func dome_destroyed():
	if get_child_count() == 0:
		queue_free()
