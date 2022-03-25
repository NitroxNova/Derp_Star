extends KinematicBody2D

var speed = 750
var velocity = Vector2()

func _ready():
	velocity = Vector2(speed,0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		if collision.collider.name == "Derp_Star":
			Player_Stats.increment_health(-1)
			queue_free()
		else:
			velocity = velocity.bounce(collision.normal)
			rotation = velocity.angle()

func _on_Timer_timeout():
	queue_free()
