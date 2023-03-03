extends Node

var file_name = "user://derp.save"

func save_file():
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_var(Player_Stats.boss_cores)
	file.store_var(Player_Stats.save_talents())
	file.close()

func load_file():
#	var file = File.new()
	if not FileAccess.file_exists(file_name):
		var file = FileAccess.open(file_name, FileAccess.READ)
		Player_Stats.boss_cores = file.get_var()
		Player_Stats.load_talents(file.get_var())
		file.close()
	else:
		Player_Stats.boss_cores = 0
		Player_Stats.load_talents([])
