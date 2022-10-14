extends Area2D

export var faction = "enemy"
var dps = 10
var length = 500
var max_length = 500

func _physics_process(delta):
	for body in get_overlapping_bodies():
		Connector.deal_damage(self,body,dps*delta)

func set_length(l):
	if l > max_length:
		l = max_length
	length = l
	$CollisionShape2D.shape.extents.x = length/2
	$CollisionShape2D.position.x = length/2
	
func set_max_length(m):
	max_length = m
	$Max_Length.position.x = max_length
	if length > max_length:
		set_length(max_length)

func activate():
	$CollisionShape2D.disabled = false
	set_physics_process(true)

func deactivate():
	$CollisionShape2D.disabled = true
	set_physics_process(false)
