extends Bumper_Ship

var flame_on = true
var speed_min = 200
var speed_max = 600

func build():
	var pattern_id = RNG.randi_range(1,8)
	var pattern_texture = load("res://Bumper_Ships/Hot_Air_Balloon/Pattern/color_mask_" + str(pattern_id)+ ".svg")
	$Base_Sprite.material.set_shader_param("Pattern",pattern_texture)
	
	var color_list = [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.white, Color.teal, Color.pink]
	color_list = RNG.array_rand_multi(color_list,3)
	$Base_Sprite.material.set_shader_param("Color_1",color_list[0])
	$Base_Sprite.material.set_shader_param("Color_2",color_list[1])
	$Base_Sprite.material.set_shader_param("Color_3",color_list[2])
	
func _integrate_forces(state):
	applied_torque = rotation / PI * -100000
	var speed = linear_velocity.y * -1
	if speed > speed_max and flame_on:
		deactivate_flame()
	elif speed < speed_min and not flame_on:
		activate_flame()
	if flame_on:
		apply_central_impulse(Vector2.UP * 4)
	
func activate_flame():
	$Flame.show()
	flame_on = true

func deactivate_flame():
	$Flame.hide()
	flame_on = false
