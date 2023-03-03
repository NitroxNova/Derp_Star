extends Node2D

#press enter to generate a different colony
#colony must be loaded on ready or add_child does not work

var colony_scene = preload("res://Bumper_Ships/Bio_Dome/Colony.tscn")

func _ready():
	var colony = colony_scene.instantiate()
	colony.connect("spawn_bumper",Callable(self,"spawn_bumper"))
	add_child(colony)	
	
func _init():
	randomize()
#
func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
#
func spawn_bumper(bumper):
	add_child(bumper)
	
