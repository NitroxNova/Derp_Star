class_name Enemy_Projectile
extends RigidBody2D

func take_damage(amount):
	queue_free()
