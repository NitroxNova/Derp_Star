class_name Bumper_Ship
extends RigidBody2D

export (Resource) var health
export (Resource) var drop_item
export (int) var points
var explosion = preload("res://Bumper_Ships/Explosion/Explosion.tscn")
var faction = "enemy"

func build():
	rotation = randf() * 2 * PI

func get_collision_shape():
	var shape = $Collision_Shape.duplicate()
	shape.rotation = rotation
	shape.position += position
	return shape

func get_collision_shapes():
	return [get_collision_shape()]

func _ready():
	health.connect("current_zero",self,"died")
	$Health_Node/Node2D/ProgressBar.value = health.current
	$Health_Node/Node2D/ProgressBar.max_value = health.maximum
	add_to_group("bumper")
	static_off()
	$Health_Node/Node2D/ProgressBar.hide()

func take_damage(amount):
	health.decrease_current(amount)
	$Health_Node/Node2D/ProgressBar.value = health.current
	$Health_Node/Node2D/ProgressBar.show()
	
func died():
	Player_Stats.increase_points(points)
	explode()
	drop_item()
	queue_free()

func drop_item():
	if drop_item:
		var i = drop_item.instance()
		i.transform = global_transform
		Connector.drop_item(i)

func get_base_sprite():
	return $Base_Sprite

func explode():
	var e = explosion.instance()
	e.transform = global_transform
	var bs = get_base_sprite()
	e.bumper_texture = bs.texture
	e.height = bs.texture.get_height()
	e.width = bs.texture.get_width()
	e.scale = bs.global_scale
	Connector.draw_explosion(e)
	
func static_on():
	$Static.emitting = true
	
func static_off():
	$Static.emitting = false
