extends KinematicBody2D

var speed = 500
var velocity = Vector2()
var is_valid = true

func _ready():
	rotation_degrees = rand_range(0,360)

func _physics_process(delta):
	position += transform.x * speed * delta

func on_player_hit():
	if is_valid:
		Player_Stats.add_points(500)
		Utils.despawn(self)
