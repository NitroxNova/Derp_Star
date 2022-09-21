extends Biome

var builder = Asteroid_Builder.new()

func _init():
	bumper_list.append(load("res://Bumper_Ships/Asteroid/Bumper.tscn"))

func is_valid_location(coords:Vector2):
	var target_y = coords.x/2
	var diff = abs(coords.y-target_y)
	diff = int(diff) % 10000
	if diff < 1000:
		return true
	return false
	
func reset_bumper():
	current_bumper = builder.build()
