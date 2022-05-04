class_name Bumper_Ship
extends RigidBody2D

export (Resource) var health
export (int) var points
var explosion = preload("res://Bumper_Ships/Explosion/Explosion.tscn")

signal add_points
signal draw_explosion

func setup():
	health.connect("current_zero",self,"died")
	$Health_Node/Node2D/ProgressBar.value = health.current
	$Health_Node/Node2D/ProgressBar.max_value = health.maximum

func take_damage(amount):
	health.decrease_current(amount)
	$Health_Node/Node2D/ProgressBar.value = health.current
	$Health_Node/Node2D/ProgressBar.show()
	
func died():
	emit_signal("add_points",points)
	queue_free()
	explode()

func explode():
	var e = explosion.instance()
	e.transform = global_transform
	e.bumper_texture = $Base_Sprite.texture
	emit_signal("draw_explosion",e)
	
func static_on():
	$Static.emitting = true
	
func static_off():
	$Static.emitting = false
