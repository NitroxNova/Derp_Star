extends Bumper_Ship

var asteroid = load("res://Bumper_Ships/Asteroid/Bumper.tscn")
export var ore_list = []
var size = 1.0

func build():
	.build()
	set_size(randf() * .8 + .2)

func died():
	if size > .2:
		if (round(randf())):
			spawn_chunk($Scalar/Split_1,size/2)
			spawn_chunk($Scalar/Split_4,size/2)
			spawn_ore(size/2)
		else:
			spawn_chunk($Scalar/Split_1,size/3)
			spawn_chunk($Scalar/Split_2,size/3)
			spawn_chunk($Scalar/Split_3,size/3)
	.died()

func spawn_ore(s):
	var ore = ore_list[randi() % ore_list.size()].instance()
	ore.position = global_position
	ore.set_size(s)
	Connector.drop_item(ore)

func get_base_sprite():
	return $Scalar/Base_Sprite

func set_size(s):
	size = s
	var scale_vec = Vector2(sqrt(s),sqrt(s))
	$Collision_Shape.scale = scale_vec
	$Scalar.scale = scale_vec
	$Health_Node/Node2D/ProgressBar.rect_position.y *= sqrt(s)
	health.set_maximum(health.maximum*s)
	health.set_current(health.maximum)
	points = ceil(points*s)

func spawn_chunk(loc,s):
	var a = asteroid.instance()
	a.position = loc.global_position
	a.set_size(s)
	var vel = (a.position - global_position) * 300
	a.linear_velocity = vel
	Connector.spawn_bumper(a)

func static_on():
	$Scalar/Static.emitting = true
	
func static_off():
	$Scalar/Static.emitting = false
