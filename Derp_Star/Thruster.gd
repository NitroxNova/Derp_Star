extends Sprite

var is_active = true
var dps = 50
var damage_shapes = []

func _ready():
	deactivate()

func activate():
	$Flame.show()
	$Flame/CollisionPolygon2D.disabled = false
	set_process(true)
	is_active = true
	
func deactivate():
	$Flame.hide()
	$Flame/CollisionPolygon2D.disabled = true
	set_process(false)
	is_active = false
	
func _process(delta):
	var thrust_rot = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
	var thrust_offset = global_position - get_parent().global_position
	get_parent().apply_impulse(thrust_offset,thrust_rot*delta*40)
	var damage = dps * delta
	for body in $Flame.get_overlapping_bodies():
		var is_player = get_owner().is_in_group("player")
		var body_is_player = body.is_in_group("player")
		if body.has_method("take_damage") and (not is_player == body_is_player):
			body.take_damage(damage)
	for shape in damage_shapes:
		if is_instance_valid(shape):
			shape.take_damage(damage)
		else:
			damage_shapes.erase(shape)
		
func toggle():
	if is_active:
		deactivate()
	else:
		activate()

func _on_Flame_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var shape = body.shape_owner_get_owner(body_shape_index)
	if is_instance_valid(shape) and shape.has_method("take_damage") and get_owner().is_in_group("player") and not body.is_in_group("player"):
		damage_shapes.append(shape)
