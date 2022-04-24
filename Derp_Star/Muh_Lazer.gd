extends Area2D
export (Resource) var energy
var active = false
var locked = false

signal lock
signal unlock
signal energy_changed

func _ready():
	deactivate()
	energy.connect("current_zero",self,"lock")
	energy.connect("current_changed",self,"energy_changed")

func energy_changed(amount):
	emit_signal("energy_changed",amount)

func lock():
	locked = true
	deactivate()
	emit_signal("lock")

func unlock():
	locked = false
	emit_signal("unlock")
	
func activate():
	if energy.current > 0 and not locked:
		show()
		active = true
	
func deactivate():
	hide()
	active = false
	
func _process(delta):
	if (energy.current < energy.maximum):
		energy.increase_current(5*delta)
	if (locked and energy.get_percent() > .25):
		unlock()
	if active and energy.current > 0:
		energy.decrease_current(25*delta)
		look_at(get_global_mouse_position())
		for body in get_overlapping_bodies():
			if not body.is_in_group("player"):
				body.take_damage(100*delta)
