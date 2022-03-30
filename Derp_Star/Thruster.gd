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
	get_parent().apply_impulse(position,thrust_rot*delta*40)
