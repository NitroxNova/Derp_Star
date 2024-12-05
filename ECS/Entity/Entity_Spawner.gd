extends Resource
class_name Entity_Spawner


static func derp_star(position:Vector2):
	var entity :Entity = ECS.new_entity()
	entity.c_add(Needs_Render_Component.new("res://Derp_Star/Derp_Star.tscn",position))
	entity.c_add(Player_Component.new())
	entity.c_add(Faction_Component.new("player"))
	entity.c_add(Collision_Damage_Component.new(.05))
	return entity
	
