extends System
class_name Death_System

static func run():
	for entity_id in ECS.c_get("Died"):
		var entity :Entity = ECS.get_entity(entity_id)
		var c_node = entity.get_node()
		c_node.get_parent().remove_child(c_node)
		ECS.remove_entity(entity_id)
