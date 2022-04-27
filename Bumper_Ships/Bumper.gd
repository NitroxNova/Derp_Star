class_name Bumper_Ship
extends RigidBody2D

export (Resource) var health
export (int) var points

signal add_points

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
