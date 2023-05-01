extends Bone2D

func set_laser_color(gradient:Gradient):
	var laser = $Lazer/Reset_XForm/Line2D
	var inner_color = gradient.sample(1.0)
	var outer_color = gradient.sample(0.75)
	laser.texture.gradient.colors[0] = outer_color
	laser.texture.gradient.colors[1] = inner_color
	laser.texture.gradient.colors[2] = inner_color
	laser.texture.gradient.colors[3] = outer_color
	
	$Lazer/Particles_Viewport/GPUParticles2D.process_material.color = gradient.sample(0)
	$Lazer/Particles_Viewport/GPUParticles2D.process_material.color.a = .5
	$Lazer/Particles_Viewport/GPUParticles2D2.process_material.color = gradient.sample(0.25)
	$Lazer/Particles_Viewport/GPUParticles2D2.process_material.color.a = .5
	
	$Head.material.get("shader_parameter/gradient").gradient = gradient
	$Jaw/Jaw.material.get("shader_parameter/gradient").gradient = gradient
	
	
