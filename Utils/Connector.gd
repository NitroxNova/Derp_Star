extends Node

var derp_star

func reset():
	derp_star = get_node("/root/Main/Derp_Star")

func derp_star_position(node):
	derp_star.connect("position_changed",node,"derp_star_position_changed")
