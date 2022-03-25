extends Path2D

var stripy_bumper = preload("res://Bumper_Ships/Stripy_Triangle/Bumper.tscn")
var bio_ship = preload("res://Bumper_Ships/Bio_Ship/Bio_Ship.tscn")
var x_thing = preload("res://Bumper_Ships/X-Thing/x-thing.tscn")
var shooting_star = preload("res://Bumper_Ships/Shooting_Star/Shooting_Star.tscn")
var bumper_array = [stripy_bumper,bio_ship,x_thing,shooting_star]
#var bumper_array = [x_thing]

func _init():
	Utils.bumper_count = 0

func _on_Timer_timeout():
	if Utils.bumper_count < 50:
		Utils.bumper_count += 1
		var bumper = Utils.array_rand(bumper_array).instance()
		var spawn_location = $PathFollow2D
		spawn_location.unit_offset = randf()
		bumper.transform = spawn_location.global_transform
		Utils.spawn_bumper(bumper)
	
