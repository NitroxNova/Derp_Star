extends RigidBody2D
class_name Dropped_Item

func _on_Area2D_body_entered(body):
	on_pickup(body)
	queue_free()

func on_pickup(_body):
	pass

func _on_Timer_timeout():
	queue_free()
