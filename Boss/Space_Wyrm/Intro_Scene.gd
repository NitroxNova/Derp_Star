extends Node2D

@export var flash_config : Resource

signal spawn_boss

func spawn_wyrm(wyrmhole):
	var wyrm = load("res://Boss/Space_Wyrm/Space_Wyrm.tscn").instantiate()
	wyrm.position = wyrmhole.global_position
	emit_signal("spawn_boss",wyrm)
	wyrm.build(3)
	wyrmhole.close()

func wyrmhole_closed():
	queue_free()
