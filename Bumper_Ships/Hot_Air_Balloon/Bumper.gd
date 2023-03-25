extends Bumper_Ship

var flame_on = false
var speed_min = 100
var speed_max = 500

func _ready():
	super()
	activate_flame()

func build():
	var pattern_id = RNG.randi_range(1,8)
	var pattern_texture = load("res://Bumper_Ships/Hot_Air_Balloon/Pattern/color_mask_" + str(pattern_id)+ ".png")
	$Base_Sprite.material.set_shader_parameter("Pattern",pattern_texture)
	
	var color_list = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.PURPLE, Color.WHITE, Color.TEAL, Color.PINK]
	color_list = RNG.array_rand_multi(color_list,3)
	$Base_Sprite.material.set_shader_parameter("Color_1",color_list[0])
	$Base_Sprite.material.set_shader_parameter("Color_2",color_list[1])
	$Base_Sprite.material.set_shader_parameter("Color_3",color_list[2])
	
func _physics_process(delta):
	set_constant_torque(rotation / PI * -100000)
	var speed = linear_velocity.y * -1
	if speed > speed_max and flame_on:
		deactivate_flame()
	elif speed < speed_min and not flame_on:
		activate_flame()
	
func activate_flame():
	$Flame.show()
	flame_on = true
	set_constant_force(Vector2.UP * 100)

func deactivate_flame():
	$Flame.hide()
	flame_on = false
	set_constant_force(Vector2.ZERO)
