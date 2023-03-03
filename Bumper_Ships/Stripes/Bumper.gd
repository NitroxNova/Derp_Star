extends Bumper_Ship

func _ready():
	super._ready()
	$Thruster.activate()

func _on_Timer_timeout():
	$Thruster.toggle()
	$Thruster2.toggle()
