extends Area2D

func _ready():
	deactivate()

func activate():
	show()
	set_process(true)
	
func deactivate():
	hide()
	set_process(false)
	
func _process(delta):
	look_at(get_global_mouse_position())
	for body in get_overlapping_bodies():
		if not body.is_in_group("player"):
			body.take_damage(100*delta)
