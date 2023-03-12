extends Node2D

class_name Player_Beam

@export var energy_cost : int
var gravity_toggle : bool = true
@onready var initial_collision_mask = $Beam.collision_mask

signal decrease_energy

func _ready():
	deactivate()

func _process(delta):
	look_at(get_global_mouse_position())
	emit_signal("decrease_energy",energy_cost * delta)
	if gravity_toggle:
		$Beam.collision_mask = 0
	else:
		$Beam.collision_mask = initial_collision_mask
	gravity_toggle = not gravity_toggle
	
func activate():
	$Beam.show()
	$Beam/CollisionShape2D.disabled = false
	process_mode = Node.PROCESS_MODE_INHERIT
	$Beam.collision_mask = initial_collision_mask
	
func deactivate():
	$Beam.hide()
	$Beam/CollisionShape2D.disabled = true
	process_mode = Node.PROCESS_MODE_DISABLED
	$Beam.collision_mask = 0
