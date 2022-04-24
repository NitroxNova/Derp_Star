extends Control

onready var energy_styleBox = $Energy_Bar.get("custom_styles/fg")

var energy_color = Color(0,1,1)
var energy_lock_color = Color(.5,.5,.5)

func update_energy(amount):
	$Energy_Bar.value = amount
	
func update_energy_maximum(amount):
	$Energy_Bar.max_value = amount

func lock_energy():
	energy_styleBox.bg_color = energy_lock_color

func unlock_energy():
	energy_styleBox.bg_color = energy_color
