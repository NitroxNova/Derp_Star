extends Node2D

func spawn_bumper(bumper):
	add_child(bumper)

func spawn_projectile(projectile):
	add_child(projectile)

func _on_Try_Again_pressed():
	get_tree().reload_current_scene()

func _on_Quit_pressed():
	get_tree().quit()
