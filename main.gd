extends Node2D

var player_points = 0

signal update_points

func _init():
	randomize()
	
func _ready():
	Connector.reset()
	$Derp_Star.health.update_maximum()
	$Derp_Star.health.update_current()
	$Derp_Star.energy.update_maximum()
	$Derp_Star.energy.update_current()
	$Space_Wyrm.build(12)

func add_points(amount):
	player_points += amount
	emit_signal("update_points",player_points)

func spawn_bumper_area(area):
	area.connect("spawn_bumper",self,"spawn_bumper")
	$Bumper_List.add_child(area)
	$Bumper_List.update_bumper_count()

func spawn_bumper(bumper):
	bumper.connect("add_points",self,"add_points")
	bumper.connect("draw_explosion",self,"draw_explosion")
	bumper.connect("drop_item",self,"drop_item")
	bumper.connect("spawn_bumper",self,"spawn_bumper")
	$Bumper_List.add_child(bumper)
	$Bumper_List.update_bumper_count()

func drop_item(i):
	$Pick_Ups.add_child(i)

func draw_explosion(e):
	$Explosions.add_child(e)
	$Bumper_List.update_bumper_count()
