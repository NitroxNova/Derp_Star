extends Bumper_Ship

func _init():
	rotation = randf() * 2 * PI

func _ready():
	._ready()
	$Thruster.activate()

func _on_Timer_timeout():
	$Thruster.toggle()
	$Thruster2.toggle()
