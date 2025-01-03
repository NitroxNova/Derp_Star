extends RigidBody2D

var entity_id : int

@onready var thrusters = [$Thruster1,$Thruster2,$Thruster3,$Thruster4,$Thruster5]
var hotkeys = ["thruster_1","thruster_2","thruster_3","thruster_4","thruster_5"]
var is_energy_locked = false
#onready var beams = [$Muh_Lazer,$Gravity_Beam]
var beams = []
var beam_index = 0
var faction = "player"

@export var health : Capped_Value
@export var energy : Capped_Value

signal health_changed
signal max_health_changed
signal player_died
signal energy_changed
signal max_energy_changed
signal energy_locked
signal energy_unlocked

func _ready():
	health.connect("current_changed",Callable(self,"update_health"))
	health.connect("maximum_changed",Callable(self,"update_max_health"))
	health.connect("current_zero",Callable(self,"died"))
	energy.connect("current_zero",Callable(self,"lock_energy"))
	energy.connect("current_changed",Callable(self,"update_energy"))
	energy.connect("maximum_changed",Callable(self,"update_max_energy"))
	
	Player_Stats.talent["max_health"].connect("upgrade_changed",Callable(self,"max_health_talent_changed"))
	Player_Stats.talent["max_energy"].connect("upgrade_changed",Callable(self,"max_energy_talent_changed"))
	Player_Stats.talent["laser_beam"].connect("upgrade_changed",Callable(self,"laser_beam_talent_changed"))
	Player_Stats.talent["gravity_beam"].connect("upgrade_changed",Callable(self,"gravity_beam_talent_changed"))
	
func laser_beam_talent_changed(value,increment):
	beams.append($Muh_Lazer)
	if beams.size() == 1:
		$Muh_Lazer.show()
	
func gravity_beam_talent_changed(value,increment):
	beams.append($Gravity_Beam)
	if beams.size() == 1:
		$Gravity_Beam.show()
	
func max_health_talent_changed(value,increment):
	var increase = increment * 100
	health.increase_maximum(increase)

func max_energy_talent_changed(value,increment):
	var increase = increment * 100
	energy.increase_maximum(increase)

func _process(delta):
	if (energy.current < energy.maximum):
		energy.increase_current(5*delta)
	if (energy_locked and energy.get_percent() > .25):
		unlock_energy()
	if Input.is_action_pressed("accelerate"):
		accelerate()
	if Input.is_action_pressed("brake"):
		brake()

func brake():
	for t in thrusters:
		var angle = t.global_rotation
		var direction = Vector2(cos(angle), sin(angle))
		var angle_to = linear_velocity.angle_to(direction)
		if (angle_to > .5 * PI or angle_to < -.5 * PI) and linear_velocity.length() > 10:
			t.activate()
		else:
			t.deactivate()
	
func accelerate():
	for t in thrusters:
		var angle = t.global_rotation
		var direction = Vector2(cos(angle), sin(angle))
		var angle_to = linear_velocity.angle_to(direction)
		if angle_to < .5 * PI and angle_to > -.5 * PI:
			t.activate()
		else:
			t.deactivate()
		
func _input(event):
	if event.is_action_pressed("change_beam_up"):
		change_beam(1)
	elif event.is_action_pressed("change_beam_down"):
		change_beam(-1)
	elif event.is_action_pressed("energy_shield") and not is_energy_locked and Player_Stats.talent["energy_shield"].upgrade > 0:
		$Energy_Shield.enable()
	elif event.is_action_released("energy_shield"):
		$Energy_Shield.disable()
	elif event.is_action_released("accelerate") or event.is_action_released("brake"):
		for t in thrusters:
			t.deactivate()
	elif event is InputEventMouseButton and not is_energy_locked and beams.size() > 0:
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
			
func change_beam(amount):
	if beams.size() > 0:
		beams[beam_index].deactivate()
		beams[beam_index].hide()
		beam_index = (beam_index + amount) % beams.size()
		beams[beam_index].show()
						
func take_damage(amount):
	health.decrease_current(amount)

func add_health(amount):
	health.increase_current(amount)
	
func update_health(amount):
	emit_signal("health_changed", amount)
	
func update_max_health(amount):
	emit_signal("max_health_changed", amount)

func died():
	emit_signal("player_died")
	
func update_energy(amount):
	emit_signal("energy_changed", amount)
	
func update_max_energy(amount):
	emit_signal("max_energy_changed", amount)

func decrease_energy(amount):
	energy.decrease_current(amount)
	
func add_energy(amount):
	energy.increase_current(amount)

func lock_energy():
	is_energy_locked = true
	beams[beam_index].deactivate()
	$Energy_Shield.disable()
	emit_signal("energy_locked")

func unlock_energy():
	is_energy_locked = false
	emit_signal("energy_unlocked")
