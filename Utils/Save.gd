extends Node

var file_name = "user://derp.save"

func save_file():
	var file = File.new()
	file.open(file_name, File.WRITE)
	file.store_var(Player_Stats.boss_cores)
	file.store_var(Player_Stats.save_talents())
	file.close()

func load_file():
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		Player_Stats.boss_cores = file.get_var()
		Player_Stats.load_talents(file.get_var())
		file.close()
	else:
		Player_Stats.boss_cores = 0
		Player_Stats.load_talents([])
