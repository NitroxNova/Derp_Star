extends Bumper_Ship

const MAX_SPEED = 600
const MAX_ROTATE = 8
var laser = preload("res://Bumper_Ships/Laser/Laser.tscn")

func build():
	.build()
	var x_velocity = randf() * 2 - 1
	var y_velocity = randf() * 2 - 1
	linear_velocity = Vector2(x_velocity,y_velocity).normalized() * MAX_SPEED
	angular_velocity = MAX_ROTATE
	
func shoot():
	var b = laser.instance()
	b.transform = $Laser_Pointer.global_transform
	emit_signal("spawn_projectile",b)


func _on_Bumper_body_entered(body):
	var multiplier = MAX_SPEED/linear_velocity.length()
	linear_velocity *= multiplier
	multiplier = MAX_ROTATE/abs(angular_velocity)
	angular_velocity *= multiplier
