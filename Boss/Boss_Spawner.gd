extends Node2D
export var boss_list = []

func spawn_boss():
	var boss = RNG.array_rand(boss_list).instance()
	boss.position = Connector.derp_star.global_position
	add_child(boss)
	Connector.overlay.play_boss_flash(boss.flash_config)

func boss_defeated():
	$Spawn_Timer.start()
