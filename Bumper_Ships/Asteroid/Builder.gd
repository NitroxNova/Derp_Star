extends Resource
class_name Asteroid_Builder

var asteroid_list = [
	load("res://Bumper_Ships/Asteroid/Variant/Asteroid_01.tscn"),
	load("res://Bumper_Ships/Asteroid/Variant/Asteroid_02.tscn"),
	load("res://Bumper_Ships/Asteroid/Variant/Asteroid_03.tscn"),
	load("res://Bumper_Ships/Asteroid/Variant/Asteroid_04.tscn"),
	load("res://Bumper_Ships/Asteroid/Variant/Asteroid_05.tscn"),
	load("res://Bumper_Ships/Asteroid/Variant/Asteroid_06.tscn")
]

var gradient_list = [
	load("res://Bumper_Ships/Asteroid/Gradient/brown.tres"),
	load("res://Bumper_Ships/Asteroid/Gradient/grey.tres"),
	load("res://Bumper_Ships/Asteroid/Gradient/red.tres")
]

func build(size=null, gradient = null):
	if size == null:
		size = RNG.randf_range(0.2,0.8)
	if gradient == null:
		gradient = RNG.array_rand(gradient_list)
	var bumper = RNG.array_rand(asteroid_list).instance()
	bumper.set_size(size)
	var shader_gradient = bumper.get_node("Scalar/Base_Sprite").material.get("shader_param/gradient")
	shader_gradient.gradient = gradient
	return bumper
