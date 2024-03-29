extends Resource
class_name Capped_Value

@export var current : float
@export var maximum : float

signal current_changed
signal current_zero
signal maximum_changed

func _init(c=current,m=maximum):
	set_maximum(m)
	set_current(c)

func set_current(amount):
	var prev = current
	current = min(amount,maximum)
	if prev > 0 and current <= 0:
		emit_signal("current_zero")
	update_current()
	
func update_current():
	emit_signal("current_changed",current)

func increase_current(amount):
	set_current(current + amount)

func decrease_current(amount):
	set_current(current - amount)

func set_maximum(amount):
	maximum = amount
	update_maximum()

func update_maximum():
	emit_signal("maximum_changed", maximum)

func increase_maximum(amount):
	set_maximum(maximum + amount)

func get_percent():
	return float(current)/maximum
