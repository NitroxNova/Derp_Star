extends KinematicBody2D

var velocity = Vector2()
var rotation_speed = 0.0
var is_valid = false

func _ready():
	get_tree().paused = false
	Player_Stats.max_health = 100
	Player_Stats.health = Player_Stats.max_health
	Player_Stats.points = 0

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		var collider = collision.collider
		if collider.is_in_group("projectile"):
			pass
		else:
			velocity = velocity.bounce(collision.normal)
			if collision.collider_shape.has_method("on_player_hit"):
				collision.collider_shape.on_player_hit()
			if collider.has_method("on_player_hit"):
				collider.on_player_hit()
			 
	rotation += rotation_speed * delta
	#slow down rotation
	if (rotation_speed > 0):
		rotation_speed -= delta
		if (rotation_speed < 0):
			rotation_speed = 0
	elif (rotation_speed < 0):
		rotation_speed += delta
		if (rotation_speed > 0):
			rotation_speed = 0
	#slow down speed
	var decelarate = velocity.normalized()
	decelarate.x *= delta*50
	decelarate.y *= delta*50
	velocity -= decelarate
	
