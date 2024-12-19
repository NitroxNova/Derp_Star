extends System
class_name Change_Dimension_System

static func run():
	for entity_id in ECS.c_get("Change_Dimension"):
		var entity :Entity = ECS.get_entity(entity_id)
		var c_dimension : Change_Dimension_Component = entity.c_get("Change_Dimension")
		var node = entity.get_node()
		node.get_parent().remove_child(node)
		Connector.dimension_list[c_dimension.id].add_child(node)
		entity.c_remove("Change_Dimension") #will be keptqweqwqe by the node
		
		
		
	
