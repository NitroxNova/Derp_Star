extends Node2D

signal add_points
signal draw_explosion

func _ready():
	for child in get_children():
		child.connect("add_points",self,"add_points")
		child.connect("draw_explosion",self,"draw_explosion")
		child.connect("tree_exited",self,"dome_destroyed")

func add_points(amount):
	emit_signal("add_points",amount)

func draw_explosion(explosion):
	emit_signal("draw_explosion",explosion)

func dome_destroyed():
	if get_child_count() == 0:
		queue_free()
