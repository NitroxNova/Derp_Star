class_name Bumper_Ship
extends RigidBody2D

export (Resource) var health
export (Resource) var drop_item
export (int) var points
var explosion = preload("res://Bumper_Ships/Explosion/Explosion.tscn")

signal add_points
signal draw_explosion
signal drop_item

func get_collision_shape():
	return $Collision_Shape.duplicate()

func get_collision_shapes():
	return [get_collision_shape()]

func _ready():
	connect("ready",self,"on_ready")
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
	emit_signal("add_points",points)
	explode()
	drop_item()
	queue_free()

func drop_item():
	if drop_item:
		var i = drop_item.instance()
		i.transform = global_transform
		emit_signal("drop_item",i)

func explode():
	var e = explosion.instance()
	e.transform = global_transform
	e.bumper_texture = $Base_Sprite.texture
	emit_signal("draw_explosion",e)
	
func static_on():
	$Static.emitting = true
	
func static_off():
	$Static.emitting = false
