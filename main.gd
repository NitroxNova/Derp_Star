extends Node2D

var player_points = 0
signal update_points

func _init():
	randomize()

func add_points(amount):
	player_points += amount
	emit_signal("update_points",player_points)

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
