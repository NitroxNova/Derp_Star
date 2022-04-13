extends Node2D

var player_points = 0
var max_health = 100
var health = max_health

signal update_points
signal update_health
signal update_max_health
signal player_died

func _process(delta):
	minus_health(delta*10)

func _init():
	randomize()

func _ready():
	emit_signal("update_max_health",max_health)
	emit_signal("update_health",health)

func add_points(amount):
	player_points += amount
	emit_signal("update_points",player_points)

func minus_health(amount):
	health -= amount
	emit_signal("update_health",health)
	if health <= 0:
		emit_signal("player_died")

func _on_Derp_Star_body_entered(body):
	if body.is_in_group("bumper"):
		add_points(50)
		body.queue_free()
		update_bumper_count()

func spawn_bumper(bumper):
	$Bumper_List.add_child(bumper)
	update_bumper_count()

func update_bumper_count():
	$Derp_Star_Remote/Bumper_Spawner.count = $Bumper_List.get_child_count()
