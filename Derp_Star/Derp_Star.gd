extends RigidBody2D

onready var thrusters = [$Thruster1,$Thruster2,$Thruster3,$Thruster4,$Thruster5]
var hotkeys = ["thruster_1","thruster_2","thruster_3","thruster_4","thruster_5"]
var energy_locked = false
onready var beams = [$Muh_Lazer,$Gravity_Beam]
var beam_index = 0

export (Resource) var health
export (Resource) var energy

signal update_health
signal update_max_health
signal player_died
signal update_energy
signal update_max_energy
signal lock_energy
signal unlock_energy
signal position_changed

func _ready():
	health.connect("current_changed",self,"update_health")
	health.connect("maximum_changed",self,"update_max_health")
	health.connect("current_zero",self,"player_died")
	energy.connect("current_zero",self,"lock_energy")
	energy.connect("current_changed",self,"update_energy")
	energy.connect("maximum_changed",self,"update_max_energy")

func _process(delta):
	if (energy.current < energy.maximum):
		energy.increase_current(5*delta)
	if (energy_locked and energy.get_percent() > .25):
		unlock_energy()
	emit_signal("position_changed",global_position)

func _input(event):
	if event.is_action_pressed("change_beam_up"):
		change_beam(1)
	elif event.is_action_pressed("change_beam_down"):
		change_beam(-1)
	elif event is InputEventMouseButton and not energy_locked:
		if event.pressed:
			beams[beam_index].activate()
		else:
			beams[beam_index].deactivate()
	else:
		for i in 5:
			if event.is_action_pressed(hotkeys[i]):
				thrusters[i].activate()
			if event.is_action_released(hotkeys[i]):
				thrusters[i].deactivate()	
			
func _on_Derp_Star_body_entered(body):
	if body.is_in_group("bumper"):
		body.take_damage(linear_velocity.length()/10)
		
func change_beam(amount):
		beams[beam_index].deactivate()
		beams[beam_index].hide()
		beam_index = (beam_index + amount) % beams.size()
		beams[beam_index].show()
						
func take_damage(amount):
	health.decrease_current(amount)

func add_health(amount):
	health.increase_current(amount)
	
func update_health(amount):
	emit_signal("update_health", amount)
	
func update_max_health(amount):
	emit_signal("update_max_health", amount)

func player_died():
	emit_signal("player_died")
	
func update_energy(amount):
	emit_signal("update_energy", amount)
	
func update_max_energy(amount):
	emit_signal("update_max_energy", amount)

func decrease_energy(amount):
	energy.decrease_current(amount)
	
func add_energy(amount):
	energy.increase_current(amount)

func lock_energy():
	energy_locked = true
	beams[beam_index].deactivate()
	emit_signal("lock_energy")

func unlock_energy():
	energy_locked = false
	emit_signal("unlock_energy")
