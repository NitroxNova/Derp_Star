extends CanvasLayer

func _ready():
	Player_Stats.connect("update_points",self,"update_points")
	$Health_Bar.max_value = Player_Stats.max_health
	$Health_Bar.value = Player_Stats.health
	Player_Stats.connect("update_health",self,"update_health")
	Player_Stats.connect("died",self,"died")

func update_points(amount):
	$Points.text = str(amount)

func update_health(amount):
	$Health_Bar.value = amount

func died():
	get_tree().paused = true
	$Health_Bar.hide()
	$Died.show()
