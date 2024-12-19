extends Resource
class_name Entity_Spawner


static func derp_star()->Entity:
	var entity :Entity = ECS.new_entity()
	entity.c_add(Needs_Render_Component.new("res://Derp_Star/Derp_Star.tscn"))
	entity.c_add(Player_Component.new())
	entity.c_add(Faction_Component.new("player"))
	entity.c_add(Collision_Damage_Component.new(.05))
	entity.c_add(Health_Component.new(1000))
	return entity
	
static func blockade()->Entity:
	var entity :Entity = ECS.new_entity()
	entity.c_add(Needs_Render_Component.new("res://Bumper_Ships/Blockade/Blockade.tscn"))
	entity.c_add(Health_Component.new(50))
	entity.c_add(Floating_Health_Component.new(Vector2(-50,0)))
	entity.c_add(Faction_Component.new("enemy"))
	return entity
