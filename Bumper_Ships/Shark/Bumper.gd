extends Bumper_Ship

var speed = 350
var bite_damage = 50
var aggro_range = 700
var is_aggro = false

signal aggro_on
signal aggro_off

func set_aggro_on():
	if not is_aggro:
		is_aggro = true
		emit_signal("aggro_on")

func set_aggro_off():
	if is_aggro:
		is_aggro = false
		emit_signal("aggro_off")

func _integrate_forces(state):
	var distance = global_position.distance_to(Connector.derp_star.get_node().global_position)
	if distance < aggro_range:
		set_aggro_on()
		var angle_to = get_angle_to(Connector.derp_star.get_node().global_position)
		state.angular_velocity = angle_to * 5
	else:
		set_aggro_off()
	state.linear_velocity = Vector2(speed,0).rotated(global_rotation)
	
func explode():
	var e = explosion.instantiate()
	e.transform = global_transform
	e.bumper_texture = $Polygon2D.texture
	e.width = 400
	e.height = 162
	emit_signal("spawn_explosion",e)


func _on_Bite_Area_body_entered(body):
	if body.faction != faction and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("Chomp")

func deal_bite_damage():
	for body in $Bite_Area.get_overlapping_bodies():
		Connector.deal_damage(self,body,bite_damage)


func _on_AnimationPlayer_animation_finished(anim_name):
	for body in $Bite_Area.get_overlapping_bodies():
		if body.faction != faction and not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Chomp")
