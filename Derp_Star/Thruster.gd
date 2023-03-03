extends Sprite2D

var is_active = true
var dps = 50
var damage_shapes = []
@onready var faction = get_parent().faction

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
	get_parent().apply_impulse(thrust_rot*delta*40, thrust_offset)
	var damage = dps * delta
	for body in $Flame.get_overlapping_bodies():
		Connector.deal_damage(self,body,damage)
	for shape in damage_shapes:
		if !Connector.deal_damage(self,shape,damage):
			damage_shapes.erase(shape)
		
func toggle():
	if is_active:
		deactivate()
	else:
		activate()

func _on_Flame_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var shape = body.shape_owner_get_owner(body_shape_index)
	if is_instance_valid(shape):
		damage_shapes.append(shape)
