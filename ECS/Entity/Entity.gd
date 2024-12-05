extends Resource
class_name Entity

var id : int

func _init(_id):
	id = _id
	
func c_add(component:Component):
	ECS.component_list[component.type][id] = component

func c_remove(component_type:String):
	ECS.component_list[component_type].erase(id)

func c_has(component_type:String)->bool:
	return id in ECS.component_list[component_type]
	
func c_get(component_type:String)->Component:
	#assuming already checked if it has it.. dont need to check twice
	return ECS.component_list[component_type][id]
