extends Area2D

export var faction : String
var dps = 5
var damage_shapes = []
var length

func _ready():
	deactivate()
	set_length(1000)

func set_length(l):
	if length != l:
		length = l
		if length > 1000:
			length = 1000
		$Gradient.rect_size.y = length
		
		$CollisionShape2D.shape.extents.x = length/2
		$CollisionShape2D.position.x = length/2
		
		$Lightning_Texture.texture.region.size.x = length
		
func set_particles_offset(xo:int):
	$Lightning_Texture.texture.region.position.x = xo

func _process(delta):
	var damage = dps*delta
	for body in get_overlapping_bodies():
		Connector.deal_damage(self,body,damage)
	for shape in damage_shapes:
		if !Connector.deal_damage(self,shape,damage):
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
	if is_instance_valid(shape):
		damage_shapes.append(shape)

func _on_Beam_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if is_instance_valid(body):
		var shape = body.shape_owner_get_owner(body_shape_index)
		damage_shapes.erase(shape)
