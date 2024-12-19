extends System
class_name Render_System

# "rendering" is just adding an instance of the scene to the tree
static func run():
	for entity_id in ECS.c_get("Needs_Render"):
		print("rendering " + str(entity_id))
		var entity :Entity = ECS.get_entity(entity_id)
		var c_needs_render :Needs_Render_Component = entity.c_get("Needs_Render")
		var node:Node2D = load(c_needs_render.path).instantiate()
		node.set_meta("entity_id",entity_id)
		Connector.get_current_dimension().spawn_entity(node,entity.c_has("Bumper"))
		if entity.c_has("Collision_Damage"):
			node.body_entered.connect(Collision_System.on_body_entered.bind(entity_id))
			node.body_shape_entered.connect(Collision_System.on_shape_entered.bind(entity_id))
		if entity.c_has("Floating_Health"):
			var c_floating_health :Floating_Health_Component = entity.c_get("Floating_Health")
			var c_health:Health_Component = entity.c_get("Health")
			var health_node:Node = load("res://Bumper_Ships/Health_Node.tscn").instantiate()
			var health_bar:ProgressBar = health_node.find_child("ProgressBar")
			health_bar.value = c_health.current
			health_bar.max_value = c_health.maximum
			c_health.current_changed.connect(health_bar.set_value)
			c_health.maximum_changed.connect(health_bar.set_max)
			node.add_child(health_node)
			var xform_node = RemoteTransform2D.new()
			xform_node.use_global_coordinates = true
			xform_node.update_position = true
			xform_node.update_rotation = false
			xform_node.update_scale = false
			node.add_child(xform_node)
			xform_node.remote_path = "../Health_Node/Node2D"
			xform_node.position = c_floating_health.offset
			entity.c_remove("Floating_Health")
		entity.c_remove("Needs_Render")
		entity.c_add(Node_Component.new(node))
		
