extends KinematicBody2D

var velocity = Vector2()
var speed = 200
var is_valid = true

func on_player_hit():
	if is_valid:
		Player_Stats.add_points(100)
		Utils.despawn(self)

func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(rotation)
	var collision = move_and_slide(velocity)
	var loc = get_node("/root/Play/Derp_Star/Flight_Path/PathFollow2D")
	look_at(loc.global_position)

func _on_Timer_timeout():
	$laser_1.shoot()
	$laser_2.shoot()
	$laser_3.shoot()
	$laser_4.shoot()
