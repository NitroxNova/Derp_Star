extends Node2D

export var hotkey = ""

func flame_on():
	$Flame.show()

func flame_off():
	$Flame.hide()

func _process(delta):
	if Input.is_action_just_pressed(hotkey):
		flame_on()
	if Input.is_action_just_released(hotkey):
		flame_off()
	if Input.is_action_pressed(hotkey):
		var angle = get_global_transform().get_rotation() - 0.5 * PI
		angle = normalize_radial(angle)
		var angle_vector:Vector2 = Vector2(cos(angle),sin(angle))
		angle_vector *= 10
		get_parent().velocity += angle_vector
		var parent_angle = get_parent().velocity.angle() 
		parent_angle = normalize_radial(parent_angle)
#		print (str(parent_angle) + " " + str(angle))
		var turn = 1
		if parent_angle > PI:
			if angle < parent_angle and angle > parent_angle - PI:
				turn = -1
		else:
			turn = -1
			if angle > parent_angle and angle < parent_angle + PI:
				turn = 1
		turn /= 20.0 #must be float or rounds to 0
		get_parent().rotation_speed += turn
		
func normalize_radial(radial):
	radial += 2 * PI
	radial = fmod(radial, 2*PI)
	return radial
