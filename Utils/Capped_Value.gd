extends Resource
class_name Capped_Value

export (int) var current
export (int) var maximum

signal current_changed
signal current_zero
signal maximum_changed

func _init(c=current,m=maximum):
	set_maximum(m)
	set_current(c)

func set_current(amount):
	if current > 0 and amount <= 0:
		emit_signal("current_zero")
	current = min(amount,maximum)
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
