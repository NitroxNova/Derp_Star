extends PathFollow2D

var speed = 150

func _physics_process(delta):
	set_offset(get_offset() + speed * delta)
