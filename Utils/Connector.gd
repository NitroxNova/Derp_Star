extends Node

var derp_star
var explosions

func reset():
	derp_star = get_node("/root/Main/Derp_Star")
	explosions = get_node("/root/Main/Explosions")

func derp_star_position(node):
	derp_star.connect("position_changed",node,"derp_star_position_changed")

func draw_explosion(node):
	explosions.add_child(node)
