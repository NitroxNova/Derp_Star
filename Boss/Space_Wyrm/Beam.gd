extends Area2D

export var source : String
var dps = 5
var damage_shapes = []

func _ready():
	deactivate()
	set_length(500)

func set_length(length):
	if length > 1000:
		length = 1000
	$Gradient.rect_size.y = length
	
	$CollisionShape2D.shape.extents.x = length/2
	$CollisionShape2D.position.x = length/2
	
	var ratio = (length/1000.0)
	var amount = 25 * ratio
	var lifetime = 8.2 * ratio
	$Particles2D.amount = amount
	$Particles2D.lifetime = lifetime
	$Particles2D2.amount = amount
	$Particles2D2.lifetime = lifetime

func _process(delta):
	var damage = dps*delta
	for body in get_overlapping_bodies():
		if source == "player" and not body.is_in_group("player") and body.has_method("take_damage"):
			body.take_damage(damage)
		elif source == "boss" and (body.is_in_group("player") or body.is_in_group("Player_Shield")) :
			body.take_damage(damage)
	for shape in damage_shapes:
		if is_instance_valid(shape):
			shape.take_damage(damage)
		else:
			damage_shapes.erase(shape)

func activate():
	show()
	$CollisionShape2D.disabled = false
	set_process(true)
	
func deactivate():
	hide()
	$CollisionShape2D.disabled = true
	set_process(false)


func _on_Beam_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var shape = body.shape_owner_get_owner(body_shape_index)
	if is_instance_valid(shape) and shape.has_method("take_damage") and source == "player" and not body.is_in_group("player"):
			damage_shapes.append(shape)

func _on_Beam_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if is_instance_valid(body):
		var shape = body.shape_owner_get_owner(body_shape_index)
		damage_shapes.erase(shape)
