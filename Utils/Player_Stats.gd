extends Node

var boss_cores = 0
var points = 0
var talent = preload("res://Talent/Talent_List.tres").list

func reset():
	points = 0
	for t in talent.values():
		t.upgrade = 0
	Connector.talent_overlay.emit_signal("talents_changed")
	Connector.hud.update_boss_cores(Player_Stats.boss_cores)

func save_talents():
	var save = {}
	for t in talent:
		save[t] = talent[t].unlock
	return save

func load_talents(save):
	for s in save:
		talent[s].unlock = save[s]

func get_talent(t_name):
	return talent[t_name].upgrade

func add_boss_core():
	boss_cores += 1
	print(boss_cores)
	Connector.hud.update_boss_cores(boss_cores)

func increase_boss_cores(amount):
	boss_cores += amount
	Connector.hud.update_boss_cores(boss_cores)
	
func decrease_boss_cores(amount):
	boss_cores -= amount
	Connector.hud.update_boss_cores(boss_cores)

func increase_points(amount):
	points += amount
	Connector.hud.update_points(points)

func decrease_points(amount):
	points -= amount
	Connector.hud.update_points(points)
