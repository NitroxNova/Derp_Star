extends Resource
class_name Biome

var bumper_list = []
var current_bumper

func reset_bumper():
	current_bumper = RNG.array_rand(bumper_list).instance()
	current_bumper.build()
	
func is_valid_location(coords : Vector2):
	return true
