extends Node

var main
var derp_star:
	get:
		for e_id in ECS.c_get("Player"):
			var entity = ECS.get_entity(e_id)
			return entity.c_get("Node").node
var overlay
var hud
var talent_overlay
var dimension_list
var current_dimension = 0
var difficulty = 0

func get_current_dimension():
	return dimension_list[current_dimension]

func reset():
	#derp_star = get_node("/root/Main/Derp_Star")
	overlay = get_node("/root/Main/Overlay")
	talent_overlay = get_node("/root/Main/Overlay/Talents")
	hud = get_node("/root/Main/Overlay/HUD")
	main = get_node("/root/Main")
	dimension_list = []
	dimension_list.append(load("res://Dimension/Tutorial/Dimension.tscn").instantiate())
	dimension_list.append(load("res://Dimension/Derp_Space/Dimension.tscn").instantiate())
	dimension_list.append(load("res://Dimension/Olympus/Dimension.tscn").instantiate())
	dimension_list.append(load("res://Dimension/Oceanus/Dimension.tscn").instantiate())
	Player_Stats.reset()
	
func load_dimension(id):
	var cur_dim = get_node("/root/Main/Dimension")
	main.remove_child(cur_dim)
	main.add_child(dimension_list[id])
	current_dimension = id

func show_boss_flash():
	overlay.get_node("Boss_Flash").show()
	
func hide_boss_flash():
	overlay.get_node("Boss_Flash").hide()


func deal_damage(source, target, amount):
	if is_instance_valid(target) and target.has_method("take_damage") and source.faction != target.faction:
		target.take_damage(amount)
		return amount
	else:
		return false
