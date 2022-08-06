extends Node2D

func _init():
	randomize()
	
func _ready():
	Save.load_file()
	Connector.reset()
#	Player_Stats.increase_points(10000)
#	Player_Stats.increase_boss_cores(20)
	$Derp_Star.health.update_maximum()
	$Derp_Star.health.update_current()
	$Derp_Star.energy.update_maximum()
	$Derp_Star.energy.update_current()

func spawn_bumper_area(area):
	area.connect("spawn_bumper",self,"spawn_bumper")
	$Dimension/Bumper_List.add_child(area)
	$Dimension/Bumper_List.update_bumper_count()

func spawn_bumper(bumper):
	bumper.connect("draw_explosion",self,"draw_explosion")
	bumper.connect("drop_item",self,"drop_item")
	bumper.connect("spawn_bumper",self,"spawn_bumper")
	$Dimension/Bumper_List.add_child(bumper)
	$Dimension/Bumper_List.update_bumper_count()

func drop_item(i):
	$Dimension/Pick_Ups.add_child(i)

func draw_explosion(e):
	$Dimension/Explosions.add_child(e)
	$Dimension/Bumper_List.update_bumper_count()
