extends Bumper_Ship

func _ready():
	._ready()
	$Thruster.activate()

func _on_Timer_timeout():
	$Thruster.toggle()
	$Thruster2.toggle()
