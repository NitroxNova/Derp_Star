extends Bumper_Ship

const MAX_SPEED = 600
const MAX_ROTATE = 8
var laser = preload("res://Bumper_Ships/laser/Laser.tscn")

func on_ready():
	linear_velocity = Vector2(randf(),randf()).normalized() * MAX_SPEED
	angular_velocity = MAX_ROTATE
	
func shoot():
	var b = laser.instance()
	b.transform = $Laser_Pointer.global_transform
	get_tree().get_root().add_child(b)

func change_color():
	var offsets = $Rainbow.process_material.color_ramp.gradient.offsets
	for offset in offsets.size():
		offsets[offset] = fmod(offsets[offset] + 1.05, float(offsets.size())) - 1
	$Rainbow.process_material.color_ramp.gradient.offsets = offsets

func _on_Shooting_Star_body_entered(body):
	var multiplier = MAX_SPEED/linear_velocity.length()
	linear_velocity *= multiplier
	multiplier = MAX_ROTATE/abs(angular_velocity)
	angular_velocity *= multiplier
