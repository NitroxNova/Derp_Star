extends Node2D

var dps = 5

func _process(delta):
	for body in $Beam.get_overlapping_bodies():
		body.take_damage(dps*delta)


