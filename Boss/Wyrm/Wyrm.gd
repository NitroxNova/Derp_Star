@tool
extends Node2D

@export var points = 100

var attack_phase = ""
var faction = "enemy"
var gradient : Gradient
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
	if attack_phase == "Laser":
		laser()
	elif attack_phase == "Charge":
		charge()
		
		
func _process(delta):
	if attack_phase == "Laser":
		SmoothLookAtRigid(segment_list[-1],Connector.derp_star.get_node().global_position,5.0)
		
static func SmoothLookAtRigid( nodeToTurn, targetPosition, turnSpeed ):
	#https://github.com/LillyByte/godot-smoothlookat2d/blob/master/smoothlookat2d.gd
	var target = targetPosition.angle_to_point(nodeToTurn.position)
	nodeToTurn.angular_velocity = (fposmod(target - nodeToTurn.rotation , TAU ) -PI ) * turnSpeed

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
		var wyrm_builder = Wyrm_Builder.new(id-1,gradient,texture)
		var wyrm = wyrm_builder.build()
		wyrm.position = segment_list[0].global_position
		Wyrm_Builder.transfer_health_and_position(wyrm,segment_list.slice(0,id+1))
		wyrm.attack_phase = attack_phase
		spawn_boss.emit(wyrm)
		wyrm_builder = Wyrm_Builder.new(segment_list.size()-id-2,gradient,texture)
		wyrm = wyrm_builder.build()
		wyrm.position = segment_list[id].global_position
		Wyrm_Builder.transfer_health_and_position(wyrm,segment_list.slice(id))
		wyrm.attack_phase = attack_phase
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
	port_1.position = segment_list[-1].global_position
	port_2.position = Connector.derp_star.get_node().global_position
	port_2.connect("opened",Callable(self,"teleport").bind(port_2))
	connect("close_wyrmhole",Callable(port_1,"close"))
	connect("close_wyrmhole",Callable(port_2,"close"))
	emit_signal("wyrmhole_spawned",port_1)
	emit_signal("wyrmhole_spawned",port_2)
	
func teleport(wyrmhole):
	global_position = wyrmhole.global_position
	global_position -= segment_list[segment_list.size()/2].position
	emit_signal("close_wyrmhole")

func charge():
	$Attack_Timer.wait_time = 3
	$Attack_Timer.start()
	attack_phase = "Charge"
	for segment in segment_list:
		segment.get_node("Charge_Aura").show()

	#$Head.bone.get_node("Lazer").deactivate()
	#$Tail.aura_on()
	#if attack_phase != "Charge":
		#$AnimationPlayer.play("Charge")
		#$Charge_Timer.start()
		#attack_phase = "Charge"
		#rotation = Connector.derp_star.global_position.angle_to_point(global_position)
		#linear_velocity = Vector2(-500,0).rotated(rotation)

func charge_ended():
	attack_phase = ""
	for segment in segment_list:
		segment.get_node("Charge_Aura").hide()

func laser():
	$Attack_Timer.wait_time = 4
	$Attack_Timer.start()
	segment_list[-1].get_node("Laser/Laser_Beam").activate()
	attack_phase = "Laser"
	spawn_wyrmhole()


func laser_ended():
	attack_phase = ""
	segment_list[-1].get_node("Laser/Laser_Beam").deactivate()

	
#func _on_Space_Wyrm_body_entered(body):
	#var damage = linear_velocity.length()/20
	#Connector.deal_damage(self,body,damage)


func attack_timer_timeout():
	if attack_phase=="Laser":
		laser_ended()
		charge()
	elif attack_phase == "Charge":
		charge_ended()
		laser()
