extends Node2D

func _on_Wyrm_Timer_timeout():
	var wyrmhole = load("res://Boss/Space_Wyrm/Wyrmhole/Wyrmhole.tscn").instance()
	wyrmhole.position = Connector.derp_star.global_position
	Connector.draw_explosion(wyrmhole)
	wyrmhole.connect("opened",self,"spawn_wyrm")
	Connector.show_boss_flash()

func spawn_wyrm(wyrmhole):
	var wyrm = load("res://Boss/Space_Wyrm/Space_Wyrm.tscn").instance()
	wyrm.position = wyrmhole.global_position
	add_child(wyrm)
	wyrm.build(5)
	wyrmhole.close()
	Connector.hide_boss_flash()
