extends Node

var boss_cores = 0

func add_boss_core():
	boss_cores += 1
	print(boss_cores)
	Connector.hud.update_boss_cores(boss_cores)
