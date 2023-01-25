extends Sprite

func _ready():
	$Laser_Beam.faction = get_parent().faction

func activate():
	$Laser_Beam.activate()

func deactivate():
	$Laser_Beam.deactivate()
