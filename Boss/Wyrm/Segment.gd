@tool
extends Node

var faction = "enemy"
@export var id = 0
@export var health := Capped_Value.new(100,100)
@export var points := 5
signal damage_taken (amount,id)
signal destroyed (id)

func _ready():
	health.current_zero.connect(destroy_segment)
	$Health_Node/Node2D/ProgressBar.value = health.current
	$Health_Node/Node2D/ProgressBar.max_value = health.maximum
	if health.current < 1:
		health.set_current(1)
	if health.current < health.maximum:
		$Health_Node/Node2D/ProgressBar.show()
	else:
		$Health_Node/Node2D/ProgressBar.hide()

func take_damage(amount):
	damage_taken.emit(amount,id)

func reduce_health(amount):
	health.decrease_current(amount)
	$Health_Node/Node2D/ProgressBar.value = health.current
	$Health_Node/Node2D/ProgressBar.show()
	
func destroy_segment():
	destroyed.emit(id)
