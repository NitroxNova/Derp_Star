extends Node

var bumper_count = 0

func _init():
	randomize()

func array_rand(array):
	var index = randi() % array.size()
	return array[index]

func spawn_projectile(projectile):
	get_node("/root/Play").spawn_projectile(projectile)
	
func spawn_bumper(bumper):
	get_node("/root/Play").spawn_bumper(bumper)

func despawn(object):
	if object.is_in_group("projectile"):
		object.queue_free()
	elif object.is_valid:
		object.is_valid = false
		object.queue_free()
		Utils.bumper_count -= 1
		
