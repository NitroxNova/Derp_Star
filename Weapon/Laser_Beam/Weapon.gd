extends Node2D
class_name Laser_Beam

@export var dps: float
var faction
var area_scene = preload("res://Weapon/Laser_Beam/Beam_Area.tscn")
@onready var length = $Line2D.points[1].x
@onready var height = $Line2D.width

func _ready():
	deactivate()

func _physics_process(delta):
	$Beam_Area.cast_beam()
	draw_beam()

func deactivate():
	set_physics_process(false)
	$Line2D.points = []
	remove_child($Beam_Area)
	
func activate():
	set_physics_process(true)
	var beam_area = area_scene.instantiate()
	beam_area.set_height(height)
	beam_area.set_maximum_length(length)
	beam_area.faction = faction
	beam_area.dps = dps
	add_child(beam_area)

func draw_beam():
	var points = PackedVector2Array()
	var curr_beam = $Beam_Area
	var done = false
	while not done:
		points.append(curr_beam.get_raycast_start())
		var next_beam = curr_beam.get_node("Beam_Area")
		if next_beam:
			curr_beam = next_beam
		else:
			done = true
	points.append(curr_beam.get_raycast_end())
	points = $Line2D.get_global_transform()points * 
	$Line2D.points = points
