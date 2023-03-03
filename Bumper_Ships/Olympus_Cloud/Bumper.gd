extends Bumper_Ship

var lightning = preload("res://Bumper_Ships/Olympus_Cloud/Bolt.tscn")
enum {HAPPY,ANGRY}
var state = HAPPY

func take_damage(amount):
	super.take_damage(amount)
	if state != ANGRY:
		$Base_Sprite.show()
		$Happy.show()
		$Lightning_Timer.start()
		state = ANGRY

func _on_Lightning_Timer_timeout():
	$Lightning_Rod.look_at(Connector.derp_star.global_position)
	var spread = .5
	var rot = (randf() * spread) - (spread/2.0)
	$Lightning_Rod.rotate(rot)
	var l = lightning.instantiate()
	l.transform = $Lightning_Rod/Spawn.global_transform
	emit_signal("spawn_projectile",l)
