extends SimpleObjective
class_name MultiObjective

var objectives : Array[SimpleObjective]

func add_objective(obj:SimpleObjective):
	var obj_id = objectives.size()
	objectives.append(obj)
	obj.objective_complete.connect(sub_objective_complete)

func sub_objective_complete():
	for obj in objectives:
		if obj.complete == false:
			return
	#if none of the objectives were false (all true)
	if not failed:
		set_complete()
