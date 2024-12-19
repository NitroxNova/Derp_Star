extends System
class_name Collision_System

static func on_body_entered(body:Node2D,source_id):
	#print("body entered")
	var source_entity = ECS.get_entity(source_id)
	var source_node = source_entity.c_get("Node").node
	var damage = source_node.linear_velocity.length() * source_entity.c_get("Collision_Damage").multiplier
	var target_id = body.get_meta("entity_id")
	if target_id != null:
		var target_entity = Entity.new(target_id)
		var target_faction = target_entity.c_get("Faction")
		var source_faction = source_entity.c_get("Faction")
		if target_faction.f_name != source_faction.f_name:
			target_entity.c_add(Take_Damage_Component.new(damage,source_id))
	#Connector.deal_damage(source_node,body,damage)

static func on_shape_entered(body_rid, body, body_shape_index, local_shape_index,source_id):
	#print("shape entered")
	if not body is TileMapLayer: #cant get shapes from tilemaps anymore
		var source_entity = ECS.get_entity(source_id)
		var source_node = source_entity.c_get("Node").node
		var shape = body.shape_owner_get_owner(body_shape_index)
		var damage = source_node.linear_velocity.length() * source_entity.c_get("Collision_Damage").multiplier
		#Connector.deal_damage(source_node,shape,damage)
