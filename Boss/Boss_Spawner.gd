extends Node2D
@export var boss_list = []

signal spawn_boss

func spawn_boss():
	if not boss_list.is_empty():
		var boss = RNG.array_rand(boss_list).instantiate()
		boss.position = Connector.derp_star.global_position
		emit_signal("spawn_boss",boss)
		Connector.overlay.play_boss_flash(boss.flash_config)

func boss_defeated():
	$Spawn_Timer.start()
