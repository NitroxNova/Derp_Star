@tool
extends Node2D

@export var points = 100

var attack_phase = ""
var faction = "enemy"
var color_gradient : Gradient
var texture : ImageTexture

var wyrm = load("res://Boss/Wyrm/Wyrm.tscn")
var wyrmhole = preload("res://Boss/Wyrm/Wyrmhole/Wyrmhole.tscn")
var player_portal = preload("res://Boss/Wyrm/Wyrmhole/Player_Portal.tscn")

var segment_list := []

signal close_wyrmhole
signal wyrmhole_spawned
signal spawn_boss
signal spawn_boss_core
signal spawn_item
signal spawn_explosion
signal boss_defeated

func _ready():
	laser()

func segment_damage_taken(amount,id):
	#print(str(amount) + " damage to " + str(id))
	if id == 0: #tail
		if segment_list.size() == 2: #deal damamge to head
			segment_list[1].reduce_health(amount)
		else:
			pass
	elif id == segment_list.size()-1: #head
		if segment_list.size() == 2: #deal damamge to head
			segment_list[id].reduce_health(amount)
		else:
			#evenly split damamge among other segments
			amount/=float(segment_list.size()-2)
			for i in segment_list.size()-2:
				segment_list[i+1].reduce_health(amount)
	else: #body
		segment_list[id].reduce_health(amount)

func segment_destroyed(id):
	#print(str(id) + " was destroyed")
	if id == segment_list.size()-1: #head was destroyed
		died()
	else: #body segment, since tail should never take damage
		var wyrm_builder = Wyrm_Builder.new(id-1,texture)
		var wyrm = wyrm_builder.build()
		wyrm.position = segment_list[0].global_position
		Wyrm_Builder.transfer_health_and_position(wyrm,segment_list.slice(0,id+1))
		spawn_boss.emit(wyrm)
		wyrm_builder = Wyrm_Builder.new(segment_list.size()-id-2,texture)
		wyrm = wyrm_builder.build()
		wyrm.position = segment_list[id].global_position
		Wyrm_Builder.transfer_health_and_position(wyrm,segment_list.slice(id))
		spawn_boss.emit(wyrm)
		queue_free()
		

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
	pass
	#$Head.bone.get_node("Lazer").deactivate()
	#$Tail.aura_on()
	#if attack_phase != "Charge":
		#$AnimationPlayer.play("Charge")
		#$Charge_Timer.start()
		#attack_phase = "Charge"
		#rotation = Connector.derp_star.global_position.angle_to_point(global_position)
		#linear_velocity = Vector2(-500,0).rotated(rotation)

func laser():
	pass
	#$Head.bone.get_node("Lazer").activate()
	#$Tail.aura_off()
	#if attack_phase != "Laser":
		#$Laser_Timer.start()
		#attack_phase = "Laser"
		#$AnimationPlayer.play("Idle")

#func destroy_segment(segment):
	#var top_half = wyrm.instantiate()
	#top_half.color_gradient = color_gradient
	#top_half.transform = segment.global_transform
	#var tail = top_half.get_node("Tail")
	#tail.bone = top_half.get_node("Skeleton2D/Tail")
	#tail.polygon = top_half.get_node("Polygons/Tail")
	#var next_segment = segment.next_segment
	#next_segment.bone.get_parent().remove_child(next_segment.bone)
	#tail.bone.add_child(next_segment.bone)
	#tail.set_next(next_segment)
	#top_half.get_node("AnimationPlayer").setup()
	#
	#while next_segment != null:
		#remove_child(next_segment)
		#top_half.add_child(next_segment)
		#if next_segment.polygon != null:
			#$Polygons.remove_child(next_segment.polygon)
			#top_half.get_node("Polygons").add_child(next_segment.polygon)
		#next_segment = next_segment.next_segment
	#
	#emit_signal("spawn_boss",top_half)	
	#tail.setup()
	#top_half.laser()
	#
	#var head = head_shape.instantiate()
	#head.bone = head_bone.instantiate()
	#segment.prev_segment.bone.add_child(head.bone)
	#head.set_prev(segment.prev_segment)
	#add_child(head)
	#$Tail.setup()
	#$Tail.set_color_gradient(color_gradient)
	#$AnimationPlayer.setup()
	#if attack_phase == "Laser":
		#laser()
	#else:
		#charge()
	
#func build(body_count):
	#var idle_animation = $AnimationPlayer.get_animation("Idle")
	#$Tail.bone = $Skeleton2D/Tail
	#$Tail.polygon = $Polygons/Tail
	#var prev_segment = $Tail
	#for i in body_count:
		#var segment = body_shape.instantiate()
		#segment.bone = body_bone.instantiate()
		#segment.polygon = body_polygon.instantiate()
		#$Polygons.add_child(segment.polygon)
		#segment.set_prev(prev_segment)
		#prev_segment.bone.add_child(segment.bone)
		#add_child(segment)
		#prev_segment = segment		
	#var head = head_shape.instantiate()
	#head.bone = head_bone.instantiate()
	#prev_segment.bone.add_child(head.bone)
	#head.set_prev(prev_segment)
	#add_child(head)
	#$Tail.setup()
	#$Tail.set_color_gradient(color_gradient)
	#$AnimationPlayer.setup()
	
#func _on_Space_Wyrm_body_entered(body):
	#var damage = linear_velocity.length()/20
	#Connector.deal_damage(self,body,damage)
