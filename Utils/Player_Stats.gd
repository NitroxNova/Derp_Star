extends Node

var boss_cores = 20
var points = 10000
var talent = preload("res://Talent/Talent_List.tres")

func get_talent(t_name):
	return talent.list[t_name].upgrade

func add_boss_core():
	boss_cores += 1
	print(boss_cores)
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
