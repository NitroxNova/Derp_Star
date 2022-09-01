extends Node

var main
var derp_star
var explosions
var pick_ups
var projectiles
var bumper_list
var overlay
var hud
var talent_overlay
var dimension_list

func reset():
	derp_star = get_node("/root/Main/Derp_Star")
	overlay = get_node("/root/Main/Overlay")
	talent_overlay = get_node("/root/Main/Overlay/Talents")
	hud = get_node("/root/Main/Overlay/HUD")
	main = get_node("/root/Main")
	setup_dimension()
	dimension_list = []
	dimension_list.append(get_node("/root/Main/Dimension"))
	dimension_list.append(load("res://Dimension/Olympus/Dimension.tscn").instance())
	Player_Stats.reset()

func setup_dimension():
	explosions = get_node("/root/Main/Dimension/Explosions")
	pick_ups = get_node("/root/Main/Dimension/Pick_Ups")
	projectiles = get_node("/root/Main/Dimension/Projectiles")
	bumper_list = get_node("/root/Main/Dimension/Bumper_List")
	
func load_dimension(id):
	var cur_dim = get_node("/root/Main/Dimension")
	main.remove_child(cur_dim)
	main.add_child(dimension_list[id])
	setup_dimension()

func draw_explosion(node):
	explosions.add_child(node)

func show_boss_flash():
	overlay.get_node("Boss_Flash").show()
	
func hide_boss_flash():
	overlay.get_node("Boss_Flash").hide()

func drop_item(i):
	pick_ups.add_child(i)

func spawn_projectile(p):
	projectiles.add_child(p)
	
func spawn_bumper(b):
	bumper_list.add_child(b)

func deal_damage(source, target, amount):
	if is_instance_valid(target) and target.has_method("take_damage") and source.faction != target.faction:
		target.take_damage(amount)
		return amount
	else:
		return false
