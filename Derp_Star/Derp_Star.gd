extends RigidBody2D

onready var thrusters = [$Thruster1,$Thruster2,$Thruster3,$Thruster4,$Thruster5]
var hotkeys = ["thruster_1","thruster_2","thruster_3","thruster_4","thruster_5"]

export (Resource) var health

signal update_health
signal update_max_health
signal player_died

func _ready():
	health.connect("current_changed",self,"update_health")
	health.connect("maximum_changed",self,"update_max_health")
	health.connect("current_zero",self,"player_died")

func _process(delta):
	for i in 5:
		if Input.is_action_just_pressed(hotkeys[i]):
			thrusters[i].activate()
		if Input.is_action_just_released(hotkeys[i]):
			thrusters[i].deactivate()	

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			$Muh_Lazer.activate()
		else:
			$Muh_Lazer.deactivate()
			
func _on_Derp_Star_body_entered(body):
	if body.is_in_group("bumper"):
		body.take_damage(linear_velocity.length()/10)
				
func take_damage(amount):
	health.decrease_current(amount)

func update_health(amount):
	emit_signal("update_health", amount)
	
func update_max_health(amount):
	emit_signal("update_max_health", amount)

func player_died():
	emit_signal("player_died")
