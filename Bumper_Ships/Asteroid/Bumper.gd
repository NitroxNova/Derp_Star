extends Bumper_Ship

var asteroid = load("res://Bumper_Ships/Asteroid/Bumper.tscn")
@export var ore_list = []
var size = 1.0

func build():
	super.build()

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
	super.died()

func spawn_ore(s):
	var ore = ore_list[randi() % ore_list.size()].instantiate()
	ore.position = global_position
	ore.set_size(s)
	emit_signal("spawn_item",ore)

func get_base_sprite():
	return $Scalar/Base_Sprite

func set_size(s):
	size = s
	var scale_vec = Vector2(sqrt(s),sqrt(s))
	$Collision_Shape.scale = scale_vec
	$Scalar.scale = scale_vec
	$Health_Node/Node2D/ProgressBar.position.y *= sqrt(s)
	$Static.scale = scale_vec
	$Static.position *= scale_vec
	starting_health *= s
	points = ceil(points*s)

func spawn_chunk(loc,s):
	var builder = Asteroid_Builder.new()
	var a = builder.build(s,$Scalar/Base_Sprite.material.get("shader_parameter/gradient").gradient)
	a.position = loc.global_position
	a.set_size(s)
	var vel = (a.position - global_position) * 5
	a.linear_velocity = vel
	emit_signal("spawn_bumper",a)


func _on_Bumper_body_entered(body):
	var damage = linear_velocity.length() * size * .2
	Connector.deal_damage(self,body,damage)
