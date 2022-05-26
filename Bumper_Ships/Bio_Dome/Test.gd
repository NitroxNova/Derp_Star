extends Node2D

func _init():
	randomize()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()


	
