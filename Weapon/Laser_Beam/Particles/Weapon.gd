extends Laser_Beam
class_name Particle_Laser_Beam

func _ready():
	$Particles_Line2D.width = $Particles_Viewport.size.y

func draw_beam():
	super.draw_beam()
	$Particles_Line2D.points = $Line2D.points

func deactivate():
	super.deactivate()
	$Particles_Line2D.points = []
