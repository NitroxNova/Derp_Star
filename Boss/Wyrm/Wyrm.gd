extends Boss

@export var points = 0

var attack_phase = ""
var faction = "enemy"

var body_bone = preload("res://Boss/Wyrm/Body/Bone.tscn")
var head_bone = preload("res://Boss/Wyrm/Head/Bone.tscn")
var body_shape = preload("res://Boss/Wyrm/Body/Shape.tscn")
var head_shape = preload("res://Boss/Wyrm/Head/Shape.tscn")
var body_polygon = preload("res://Boss/Wyrm/Body/Polygon.tscn")
var wyrm = load("res://Boss/Wyrm/Wyrm.tscn")
var wyrmhole = preload("res://Boss/Wyrm/Wyrmhole/Wyrmhole.tscn")
var player_portal = preload("res://Boss/Wyrm/Wyrmhole/Player_Portal.tscn")

signal close_wyrmhole
signal wyrmhole_spawned

func _ready():
	laser()

func died():
	emit_signal("close_wyrmhole")
	emit_signal("boss_defeated")
	Player_Stats.increase_points(points)
	queue_free()

	

func spawn_wyrmhole():
	var port_1 = wyrmhole.instantiate()
	var port_2 = wyrmhole.instantiate()
	port_1.position = $Head.global_position
	port_2.position = Connector.derp_star.global_position
	port_2.connect("opened",Callable(self,"teleport").bind(port_2))
	connect("close_wyrmhole",Callable(port_1,"close"))
	connect("close_wyrmhole",Callable(port_2,"close"))
	emit_signal("wyrmhole_spawned",port_1)
	emit_signal("wyrmhole_spawned",port_2)
	
func teleport(wyrmhole):
	global_position = wyrmhole.position + ($Tail.global_position - $Head.global_position)
	emit_signal("close_wyrmhole")
	laser()

func charge():
	$Head.bone.get_node("Lazer").deactivate()
	$Tail.aura_on()
	if attack_phase != "Charge":
		$AnimationPlayer.play("Charge")
		$Charge_Timer.start()
		attack_phase = "Charge"
		rotation = Connector.derp_star.global_position.angle_to_point(global_position)
		linear_velocity = Vector2(-500,0).rotated(rotation)

func laser():
	$Head.bone.get_node("Lazer").activate()
	$Tail.aura_off()
	if attack_phase != "Laser":
		$Laser_Timer.start()
		attack_phase = "Laser"
		$AnimationPlayer.play("Idle")

func destroy_segment(segment):
	var top_half = wyrm.instantiate()
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
	
	emit_signal("spawn_boss",top_half)	
	tail.setup()
	top_half.laser()
	
	var head = head_shape.instantiate()
	head.bone = head_bone.instantiate()
	segment.prev_segment.bone.add_child(head.bone)
	head.set_prev(segment.prev_segment)
	add_child(head)
	$Tail.setup()
	$AnimationPlayer.setup()
	if attack_phase == "Laser":
		laser()
	else:
		charge()
	
func build(body_count):
	var idle_animation = $AnimationPlayer.get_animation("Idle")
	$Tail.bone = $Skeleton2D/Tail
	$Tail.polygon = $Polygons/Tail
	var prev_segment = $Tail
	for i in body_count:
		var segment = body_shape.instantiate()
		segment.bone = body_bone.instantiate()
		segment.polygon = body_polygon.instantiate()
		$Polygons.add_child(segment.polygon)
		segment.set_prev(prev_segment)
		prev_segment.bone.add_child(segment.bone)
		add_child(segment)
		prev_segment = segment		
	var head = head_shape.instantiate()
	head.bone = head_bone.instantiate()
	prev_segment.bone.add_child(head.bone)
	head.set_prev(prev_segment)
	add_child(head)
	$Tail.setup()
	$AnimationPlayer.setup()
	
func _on_Space_Wyrm_body_entered(body):
	var damage = linear_velocity.length()/20
	Connector.deal_damage(self,body,damage)
