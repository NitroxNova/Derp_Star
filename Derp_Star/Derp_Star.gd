extends RigidBody2D

var thrusters = []
var hotkeys = ["thruster_1","thruster_2","thruster_3","thruster_4","thruster_5"]

signal minus_health

func _ready():
	thrusters = [$Thruster1,$Thruster2,$Thruster3,$Thruster4,$Thruster5]

func _process(delta):
	for i in 5:
		if Input.is_action_just_pressed(hotkeys[i]):
			thrusters[i].activate()
		if Input.is_action_just_released(hotkeys[i]):
			thrusters[i].deactivate()

func minus_health(amount):
	emit_signal("minus_health",amount)
