extends RigidBody2D

var body_bone = preload("res://Boss/Space_Wyrm/Body/Bone.tscn")
var head_bone = preload("res://Boss/Space_Wyrm/Head/Bone.tscn")
var body_shape = preload("res://Boss/Space_Wyrm/Body/Shape.tscn")
var head_shape = preload("res://Boss/Space_Wyrm/Head/Shape.tscn")
var body_polygon = preload("res://Boss/Space_Wyrm/Body/Polygon.tscn")
var space_wyrm = load("res://Boss/Space_Wyrm/Space_Wyrm.tscn")
var wyrmhole = preload("res://Boss/Space_Wyrm/Wyrmhole/Wyrmhole.tscn")

signal close_wyrmhole

func spawn_wyrmhole():
	var port_1 = wyrmhole.instance()
	var port_2 = wyrmhole.instance()
	port_1.position = $Head.global_position
	port_2.position = Connector.derp_star.global_position
	port_2.connect("opened",self,"teleport")
	connect("close_wyrmhole",port_1,"close")
	connect("close_wyrmhole",port_2,"close")
	Connector.draw_explosion(port_1)
	Connector.draw_explosion(port_2)
	
func teleport(wyrmhole):
	global_position = wyrmhole.position + ($Tail.global_position - $Head.global_position)
	emit_signal("close_wyrmhole")

func destroy_segment(segment):
	var top_half = space_wyrm.instance()
	top_half.transform = segment.global_transform
	var tail = top_half.get_node("Tail")
	tail.bone = top_half.get_node("Skeleton2D/Tail")
	tail.polygon = top_half.get_node("Polygons/Tail")
	var next_segment = segment.next_segment
	next_segment.bone.get_parent().remove_child(next_segment.bone)
	tail.bone.add_child(next_segment.bone)
	tail.set_next(next_segment)
	top_half.get_node("AnimationPlayer").setup()
	
	while next_segment != null:
		remove_child(next_segment)
		top_half.add_child(next_segment)
		if next_segment.polygon != null:
			$Polygons.remove_child(next_segment.polygon)
			top_half.get_node("Polygons").add_child(next_segment.polygon)
		next_segment = next_segment.next_segment
		
	get_parent().add_child(top_half)
	tail.setup()
	
	var head = head_shape.instance()
	head.bone = head_bone.instance()
	segment.prev_segment.bone.add_child(head.bone)
	head.set_prev(segment.prev_segment)
	add_child(head)
	$Tail.setup()
	$AnimationPlayer.setup()
	
func build(body_count):
	var idle_animation = $AnimationPlayer.get_animation("Idle")
	$Tail.bone = $Skeleton2D/Tail
	$Tail.polygon = $Polygons/Tail
	var prev_segment = $Tail
	for i in body_count:
		var segment = body_shape.instance()
		segment.bone = body_bone.instance()
		segment.polygon = body_polygon.instance()
		$Polygons.add_child(segment.polygon)
		segment.set_prev(prev_segment)
		prev_segment.bone.add_child(segment.bone)
		add_child(segment)
		prev_segment = segment		
	var head = head_shape.instance()
	head.bone = head_bone.instance()
	prev_segment.bone.add_child(head.bone)
	head.set_prev(prev_segment)
	add_child(head)
	$Tail.setup()
	$AnimationPlayer.setup()
	
