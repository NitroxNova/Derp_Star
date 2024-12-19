extends System
class_name Damage_System

static func run():
	for entity_id in ECS.c_get("Take_Damage"):
		var entity :Entity = ECS.get_entity(entity_id)
		var c_health = entity.c_get("Health")
		var c_damage = entity.c_get("Take_Damage")
		c_health.current -= c_damage.amount
		entity.c_remove("Take_Damage")
		if c_health.current <= 0:
			entity.c_add(Died_Component.new())
