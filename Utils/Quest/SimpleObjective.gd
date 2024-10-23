extends Resource
class_name SimpleObjective

signal objective_complete
signal objective_failed

var description = ""
var complete = false
var failed = false

func _init(_desc:String=""):
	description = _desc

func set_complete(value=true):
	complete = value
	if complete == true:
		objective_complete.emit()
	
