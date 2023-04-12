extends Laser_Beam
class_name Particle_Laser_Beam

func _ready():
	$Reset_XForm/Particles_Line2D.width = $Particles_Viewport.size.y

func draw_beam():
	super.draw_beam()
	$Reset_XForm/Particles_Line2D.points = $Reset_XForm/Line2D.points

func deactivate():
	super.deactivate()
	$Reset_XForm/Particles_Line2D.points = []
