extends Node2D

var dps = 5

func _ready():
	deactivate()

func _process(delta):
	for body in $Beam.get_overlapping_bodies():
		body.take_damage(dps*delta)

func activate():
	$Beam.show()
	$Beam/CollisionShape2D.disabled = false
	set_process(true)
	
func deactivate():
	$Beam.hide()
	$Beam/CollisionShape2D.disabled = true
	set_process(false)
