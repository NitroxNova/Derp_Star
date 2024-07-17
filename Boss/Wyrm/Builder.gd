@tool
extends Resource
class_name Wyrm_Builder

var body_count : int = 0 #number of body segments, not including head and tail
var bones = []
var gradient:Gradient
var texture:ImageTexture

func _init(_count:int, _gradient:Gradient, _texture=null):
	body_count = _count
	gradient = _gradient
	if texture == null:
		texture = Wyrm_Builder.prepare_texture(_gradient)
	else:
		texture = _texture

static func prepare_texture(_gradient:Gradient):
	var image = load("res://Boss/Wyrm/base_texture.png").get_image()
	var overlay = load("res://Boss/Wyrm/overlay_texture.png").get_image()
	for x in image.get_width():
		for y in image.get_height():
			var bg_mask = image.get_pixel(x,y)
			var bg_color = _gradient.sample(bg_mask.r)
			var overlay_color = overlay.get_pixel(x,y)
			var blended_color = bg_color
			blended_color = color_burn(blended_color,overlay_color)
			blended_color = color_dodge(blended_color,overlay_color)
			blended_color.a = bg_mask.a
			image.set_pixel(x,y,blended_color)
			
	return ImageTexture.create_from_image(image)

static func color_burn(base:Color,blend:Color):
	var burn : Color = Color.WHITE - (Color.WHITE - base) / blend
	burn = burn.clamp()
	burn = mix_colors(base,burn,blend.a)
	return burn
	
static func color_dodge(base:Color, blend:Color):
	var dodge : Color = base / (Color.WHITE - blend)
	dodge = dodge.clamp()
	dodge = mix_colors(base,dodge,blend.a)
	return dodge

static func mix_colors(base:Color,mix:Color,amount:float): #using alpha channel
	var color = base.lerp(mix,amount)
	#color.a = 1
	return color	
	
func build():
	var segment_length : int = 160 #segment length
	var total_length = (body_count + 2) * segment_length
	var wyrm := Node2D.new()
	wyrm.set_script(load("res://Boss/Wyrm/Wyrm.gd"))
	wyrm.texture = texture
	wyrm.attack_phase = "Charge"
	wyrm.gradient = gradient
	
	var attack_timer = Timer.new()
	attack_timer.one_shot = true
	attack_timer.name = "Attack_Timer"
	wyrm.add_child(attack_timer)
	attack_timer.timeout.connect(wyrm.attack_timer_timeout)
	
	var skeleton := Skeleton2D.new()
	skeleton.name = "Skeleton"
		
	var tail_bone = Bone2D.new()
	tail_bone.name = "Tail"
	tail_bone.position.x = (total_length/2.0) * -1
	tail_bone.set_rest(tail_bone.transform)
	skeleton.add_child(tail_bone)
	bones.append(tail_bone)
	
	for i in body_count:
		var curr_bone = Bone2D.new()
		curr_bone.name = "Body " + str(i+1)
		curr_bone.position.x = (total_length/2.0) * -1 + segment_length * (i+1)
		curr_bone.set_rest(curr_bone.transform)
		skeleton.add_child(curr_bone)
		bones.append(curr_bone)
		
	var head_bone = Bone2D.new()
	head_bone.name = "Head"
	head_bone.position.x = (total_length/2.0) * -1 + segment_length * (body_count+1)
	skeleton.add_child(head_bone)
	bones.append(head_bone)
	head_bone.set_rest(head_bone.transform)
	
	var jaw_bone = Bone2D.new()
	jaw_bone.name = "Jaw"
	jaw_bone.position.x = 60
	jaw_bone.position.y = 40
	jaw_bone.rotation_degrees = 15
	head_bone.add_child(jaw_bone)
	bones.append(jaw_bone)
	jaw_bone.set_rest(jaw_bone.transform)
	wyrm.add_child(skeleton)	
	
	var prev_body = null
	
	for bone_id in range(0,bones.size()):
		var rigid_body = RigidBody2D.new()
		var curr_bone:Bone2D = bones[bone_id]
		if bone_id < bones.size()-1: #dont make rigidbody for jaw
			rigid_body.position = curr_bone.global_position
			rigid_body.position.x += segment_length/2.0
			rigid_body.collision_layer = 2
			rigid_body.collision_mask = 3
			rigid_body.set_script(load("res://Boss/Wyrm/Segment.gd"))
			rigid_body.id = bone_id
			wyrm.add_child(rigid_body)
			var collider = CollisionShape2D.new()
			rigid_body.add_child(collider)
			var shape = RectangleShape2D.new()
			shape.size  = Vector2(160,100)
			collider.shape = shape
			var remote_xform = RemoteTransform2D.new()
			rigid_body.add_child(remote_xform)
			remote_xform.position.x = -80
			remote_xform.remote_path = remote_xform.get_path_to(curr_bone)
			if not prev_body == null:
				var joint = HingeJoint2D.new()
				rigid_body.add_child(joint)
				joint.node_a = joint.get_path_to(rigid_body)
				joint.node_b = joint.get_path_to(prev_body)
			rigid_body.damage_taken.connect(wyrm.segment_damage_taken)
			rigid_body.destroyed.connect(wyrm.segment_destroyed)
			
			var health_node = load("res://Bumper_Ships/Health_Node.tscn").instantiate()
			rigid_body.add_child(health_node)
			var health_xform = RemoteTransform2D.new()
			rigid_body.add_child(health_xform)
			health_xform.remote_path = health_xform.get_path_to(health_node.get_node("Node2D"))
			
			var charge_aura = load("res://Boss/Wyrm/charge_aura.tscn").instantiate()
			rigid_body.add_child(charge_aura)
			charge_aura.hide()
			charge_aura.z_index = 3
			charge_aura.modulate = gradient.get_color(0)
				
			if bone_id == body_count +1: #head
				var laser = load("res://Boss/Wyrm/laser_beam.tscn").instantiate()
				laser.dps = 35
				var laser_attach = Node2D.new()
				laser_attach.name = "Laser"
				laser_attach.position = Vector2(-3,34)
				laser_attach.add_child(laser)
				rigid_body.add_child(laser_attach)
				
				var laser_line = laser.get_node("Reset_XForm/Line2D")
				var inner_color = gradient.sample(1.0)
				var outer_color = gradient.sample(0.75)
				laser_line.texture.gradient.colors[0] = outer_color
				laser_line.texture.gradient.colors[1] = inner_color
				laser_line.texture.gradient.colors[2] = inner_color
				laser_line.texture.gradient.colors[3] = outer_color
				
				laser.get_node("Particles_Viewport/GPUParticles2D").process_material.color = gradient.sample(0)
				laser.get_node("Particles_Viewport/GPUParticles2D").process_material.color.a = .5
				laser.get_node("Particles_Viewport/GPUParticles2D2").process_material.color = gradient.sample(0.25)
				laser.get_node("Particles_Viewport/GPUParticles2D2").process_material.color.a = .5
			
			wyrm.segment_list.append(rigid_body)
			prev_body = rigid_body
		else:
			rigid_body = prev_body
		
		var body_offset = Vector2(222,40)
		var body_size = Vector2(160,100)
		if bone_id == 0:
			body_offset = Vector2(0,0)
			body_size = Vector2(222,180)
		elif bone_id == bones.size()-2:
			body_offset = Vector2(390,0)
			body_size = Vector2(240,180)
		elif bone_id == bones.size()-1:
			body_offset = Vector2(630,0)
			body_size = Vector2(200,150)
			
		var poly2D = init_segment_polygon(bone_id,body_size)
		poly2D.polygon = calc_polygon_vertex(body_size,1)
		if bone_id==0:
			poly2D.position.x -= 62
		elif bone_id == bones.size()-2:
			poly2D.position.x -= 50
			poly2D.z_index = 2
		elif bone_id == bones.size()-1:
			poly2D.position.y += 50
			poly2D.position.x -= 30
			poly2D.z_index = 1
		#else:
			#poly2D.position.x = -80
			
		poly2D.uv = calc_polygon_uvs(body_size,body_offset,1)
		#poly2D.position = Vector2.ZERO
		wyrm.add_child(poly2D)
		#print(poly2D.get_path_to(curr_bone))
		poly2D.add_bone(skeleton.get_path_to(curr_bone),PackedFloat32Array([1,1,1,1,1,1]))	
		if bone_id < bones.size()-2:
			poly2D.add_bone(skeleton.get_path_to(bones[bone_id+1]),PackedFloat32Array([0,0,1,1,0,0]))
		if bone_id > 0 and bone_id < bones.size()-1:
			poly2D.add_bone(skeleton.get_path_to(bones[bone_id-1]),PackedFloat32Array([1,0,0,0,0,1]))
	
		
	return wyrm
	
func init_segment_polygon(bone_id,size):
	var curr_bone = bones[bone_id]
	var poly2D = Polygon2D.new()
	poly2D.skeleton = "../Skeleton"
	poly2D.texture = texture		
	poly2D.position = curr_bone.global_position 
	poly2D.position.y -= size.y /2
	return poly2D

func calc_polygon_vertex(size,h_slices:int=0):
	var vertex = PackedVector2Array()
	vertex.append(Vector2(0,0))
	for slice in h_slices:
		vertex.append(Vector2(size.x * (slice+1)/(h_slices+1),0))
	vertex.append(Vector2(size.x,0))
	vertex.append(Vector2(size.x,size.y))
	for slice in h_slices:
		vertex.append(Vector2(size.x * (slice+1)/(h_slices+1),size.y))
	vertex.append(Vector2(0,size.y))
	return vertex
	
func calc_polygon_uvs(size,offset,h_slices:int=0):
	var uvs = PackedVector2Array()
	uvs.append(Vector2(offset.x,offset.y))
	for slice in h_slices:
		uvs.append(Vector2(offset.x+(size.x * (slice+1)/(h_slices+1)),offset.y))
	uvs.append(Vector2(offset.x+size.x,offset.y))
	uvs.append(Vector2(offset.x+size.x,offset.y + size.y))
	for slice in h_slices:
		uvs.append(Vector2(offset.x+(size.x * (slice+1)/(h_slices+1)),offset.y + size.y))
	uvs.append(Vector2(offset.x,offset.y + size.y))
	
	return uvs

static func transfer_health_and_position(wyrm,copy_from):
	for id in wyrm.segment_list.size():
		if id > 0 and id < copy_from.size()-1:
			var c_health = copy_from[id].health.current
			var m_health = copy_from[id].health.maximum
			if c_health < 1:
				c_health = 1
			var health = Capped_Value.new(c_health,m_health)
			wyrm.segment_list[id].health = health
		wyrm.segment_list[id].global_transform = copy_from[id].global_transform

