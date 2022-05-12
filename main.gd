extends Node2D

var player_points = 0

signal update_points

func _init():
	randomize()
	
func _ready():
	$Derp_Star.health.update_maximum()
	$Derp_Star.health.update_current()
	$Derp_Star.energy.update_maximum()
	$Derp_Star.energy.update_current()

func add_points(amount):
	player_points += amount
	emit_signal("update_points",player_points)

func spawn_bumper(bumper):
	bumper.connect("add_points",self,"add_points")
	bumper.connect("draw_explosion",self,"draw_explosion")
	$Bumper_List.add_child(bumper)
	update_bumper_count()

func update_bumper_count():
	$Derp_Star_Remote/Bumper_Spawner.count = $Bumper_List.get_child_count()

func draw_explosion(e):
	$Explosions.add_child(e)
	update_bumper_count()
