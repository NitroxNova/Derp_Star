extends Node2D

export var flash_config : Resource

func spawn_wyrm(wyrmhole):
	var wyrm = load("res://Boss/Space_Wyrm/Space_Wyrm.tscn").instance()
	wyrm.position = wyrmhole.global_position
	get_parent().add_child(wyrm)
	wyrm.build(3)
	wyrmhole.close()

func wyrmhole_closed():
	queue_free()
