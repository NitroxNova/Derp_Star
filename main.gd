extends Node2D

func _init():
	randomize()
	
func _ready():
	Save.load_file()
	Connector.reset()
#	Player_Stats.increase_points(10000)
#	Player_Stats.increase_boss_cores(20)
	Player_Stats.talent["laser_beam"].increase_upgrade()
	Player_Stats.talent["energy_shield"].increase_upgrade()
	Player_Stats.talent["gravity_beam"].increase_upgrade()

	$Derp_Star.health.update_maximum()
	$Derp_Star.health.update_current()
	$Derp_Star.energy.update_maximum()
	$Derp_Star.energy.update_current()
	
#	Connector.load_dimension(1)
