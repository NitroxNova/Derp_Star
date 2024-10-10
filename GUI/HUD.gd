extends Control

@onready var energy_styleBox = $Energy_Bar.get("theme_override_styles/fill")
@onready var health_styleBox = $Life_Bar.get("theme_override_styles/fill")

var energy_color = Color(0,1,1)
var energy_lock_color = Color(.5,.5,.5)
var half_life

func _ready():
	update_boss_cores(Player_Stats.boss_cores)

func update_energy(amount):
	$Energy_Bar.value = amount
	
func update_max_energy(amount):
	$Energy_Bar.max_value = amount

func lock_energy():
	energy_styleBox.bg_color = energy_lock_color

func unlock_energy():
	energy_styleBox.bg_color = energy_color

func update_max_health(max_health):
	$Life_Bar.max_value = max_health
	half_life = max_health/2

func update_health(v):
	$Life_Bar.value = v

func update_points(amount):
	$Points.text = str(amount)

func update_boss_cores(amount):
	$Boss_Cores/HBoxContainer/Label.text = str(amount)
