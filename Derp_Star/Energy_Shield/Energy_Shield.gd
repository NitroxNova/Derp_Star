extends CharacterBody2D

var energy_cost = 5
var faction

signal decrease_energy

func _ready():
	faction = get_parent().faction
	disable()
	
	
func _process(delta):
	emit_signal("decrease_energy",energy_cost*delta)

func enable():
	show()
	$CollisionShape2D.disabled = false
	set_process(true)

func disable():
	hide()
	$CollisionShape2D.disabled = true
	set_process(false)

func take_damage(amount):
	emit_signal("decrease_energy",amount)
