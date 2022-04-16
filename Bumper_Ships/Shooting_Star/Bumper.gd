extends RigidBody2D

const MAX_SPEED = 350
const MAX_ROTATE = 4

func _ready():
	randomize()
	var start = Vector2(randf() * 2 - 1,randf() * 2 - 1).normalized() * 100
	apply_central_impulse(start)
	
func _physics_process(delta):
	if linear_velocity.length() < MAX_SPEED:
		var pulse = linear_velocity.normalized() * delta * 100
		apply_central_impulse(pulse)
	if angular_velocity >= 0 and angular_velocity < MAX_ROTATE:
		apply_torque_impulse(100)
	elif angular_velocity < 0 and angular_velocity > MAX_ROTATE * -1:
		apply_torque_impulse(-100)

func change_color():
	var offsets = $Rainbow.process_material.color_ramp.gradient.offsets
	for offset in offsets.size():
		offsets[offset] = fmod(offsets[offset] + 1.05, float(offsets.size())) - 1
	$Rainbow.process_material.color_ramp.gradient.offsets = offsets
