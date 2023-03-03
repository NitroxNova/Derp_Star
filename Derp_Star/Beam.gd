extends Node2D

class_name Player_Beam

@export var energy_cost : int

signal decrease_energy

func _ready():
	deactivate()

func _process(delta):
	look_at(get_global_mouse_position())
	emit_signal("decrease_energy",energy_cost * delta)
	
func activate():
	$Beam.show()
	$Beam/CollisionShape2D.disabled = false
	set_process(true)
	
func deactivate():
	$Beam.hide()
	$Beam/CollisionShape2D.disabled = true
	set_process(false)
