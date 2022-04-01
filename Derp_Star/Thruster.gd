extends Sprite

func _ready():
	deactivate()

func activate():
	$Flame.show()
	set_process(true)
	
func deactivate():
	$Flame.hide()
	set_process(false)
	
func _process(delta):
	var thrust_rot = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
	var thrust_offset = global_position - get_parent().global_position
	get_parent().apply_impulse(thrust_offset,thrust_rot*delta*40)
