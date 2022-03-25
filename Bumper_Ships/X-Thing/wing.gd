extends Node2D

var laser = preload("res://Bumper_Ships/X-Thing/laser.tscn")

func shoot():
	var b = laser.instance()
	b.transform = global_transform
	Utils.spawn_projectile(b)
