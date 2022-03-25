extends Node

var points = 0
var max_health:int = 100
var health:int = max_health

signal update_points
signal update_health
signal died
	
func add_points(amount):
	points += amount
	emit_signal("update_points",points)

func increment_health(amount):
	health += amount
	if (health < 0):
		health = 0
		emit_signal("died")
	if (health > max_health):
		health = max_health
	emit_signal("update_health",health)
