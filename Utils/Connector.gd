extends Node

var main
var derp_star
var explosions
var pick_ups
var overlay
var hud
var dimension_list

func reset():
	derp_star = get_node("/root/Main/Derp_Star")
	explosions = get_node("/root/Main/Dimension/Explosions")
	pick_ups = get_node("/root/Main/Dimension/Pick_Ups")
	overlay = get_node("/root/Main/Overlay")
	hud = get_node("/root/Main/Overlay/HUD")
	main = get_node("/root/Main")
	dimension_list = []
	dimension_list.append(get_node("/root/Main/Dimension"))
	dimension_list.append(load("res://Dimension/Olympus/Dimension.tscn").instance())

func load_dimension(id):
	var cur_dim = get_node("/root/Main/Dimension")
	main.remove_child(cur_dim)
	main.add_child(dimension_list[id])

func derp_star_position(node):
	derp_star.connect("position_changed",node,"derp_star_position_changed")

func draw_explosion(node):
	explosions.add_child(node)

func show_boss_flash():
	overlay.get_node("Boss_Flash").show()
	
func hide_boss_flash():
	overlay.get_node("Boss_Flash").hide()

func add_points(amount):
	main.add_points(amount)

func drop_item(i):
	pick_ups.add_child(i)
