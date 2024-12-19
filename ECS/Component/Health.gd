extends Component
class_name Health_Component

signal current_changed(value:float)
signal maximum_changed(value:float)

var current:float:
	set(value):
		current=value
		current_changed.emit(value)
		
var maximum:float:
	set(value):
		maximum=value
		maximum_changed.emit(value)

func _init(_current:float,_maximum:float=0):
	current = _current
	if _maximum == 0:
		maximum = current
	else:
		maximum = _maximum
		
