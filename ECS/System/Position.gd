extends System
class_name Position_System

static func run():
	for entity_id in ECS.c_get("Position"):
		var entity :Entity = ECS.get_entity(entity_id)
		var c_position : Position_Component = entity.c_get("Position")
		var node = entity.get_node()
		node.position.x = c_position.x
		node.position.y = c_position.y
		entity.c_remove("Position") #will be keptqweqwqe by the node
		
		
	
