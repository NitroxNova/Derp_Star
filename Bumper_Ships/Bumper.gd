class_name Bumper_Ship
extends RigidBody2D

var health = 75
var points = 50

signal add_points

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()
		emit_signal("add_points",points)
