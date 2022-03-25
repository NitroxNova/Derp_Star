extends CollisionPolygon2D


func _physics_process(delta):
	rotation += delta * 2

func _on_Timer_timeout():
	$Laser_01.shoot()
	$Laser_02.shoot()
	$Laser_03.shoot()
	$Laser_04.shoot()
	$Laser_05.shoot()
