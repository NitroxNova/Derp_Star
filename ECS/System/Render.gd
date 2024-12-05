extends System
class_name Render_System

# "rendering" is just adding an instance of the scene to the tree
static func run():
	for entity_id in ECS.c_get("Needs_Render"):
		print("rendering " + str(entity_id))
		var entity :Entity = ECS.get_entity(entity_id)
		var c_needs_render :Needs_Render_Component = entity.c_get("Needs_Render")
		var node = load(c_needs_render.path).instantiate()
		node.position = c_needs_render.position
		node.entity_id = entity_id
		Connector.get_current_dimension().spawn_entity(node,entity.c_has("Bumper"))
		if entity.c_has("Collision_Damage"):
			node.body_entered.connect(Collision_System.on_body_entered.bind(entity_id))
			node.body_shape_entered.connect(Collision_System.on_shape_entered.bind(entity_id))
		entity.c_remove("Needs_Render")
		entity.c_add(Node_Component.new(node))
		
