extends Boss_Encounter

var player_portal = preload("res://Boss/Wyrm/Wyrmhole/Player_Portal.tscn")
var wyrm_scene = preload("res://Boss/Wyrm/Wyrm.tscn")
@export var final_points = 0

func _on_wyrmhole_opened():
	init_wyrm()
	$Wyrmhole.close()

func init_wyrm():
	var wyrm = wyrm_scene.instantiate()
	wyrm.build(3)
	spawn_wyrm(wyrm)
	
	
func spawn_wyrm(wyrm):
	wyrm.spawn_boss.connect(spawn_wyrm)
	wyrm.wyrmhole_spawned.connect(spawn_wyrmhole)
	wyrm.boss_defeated.connect(wyrm_defeated.bind(wyrm))
	add_child(wyrm)
#	encounter_defeated()

func spawn_wyrmhole(wh):
	add_child(wh)

func wyrm_defeated(wyrm):
	var wyrm_count = get_tree().get_nodes_in_group("Space_Wyrm").size()
	if (wyrm_count == 1):
		Player_Stats.increase_points(final_points)
		emit_signal("spawn_boss_core",wyrm.get_node("Head").global_position)
		spawn_player_portal(wyrm.get_node("Head").global_position)
		emit_signal("boss_defeated")
		queue_free()

func spawn_player_portal(pos):
	var port_1 = player_portal.instantiate()
	var port_2 = player_portal.instantiate()
	port_1.linked_portal = port_2
	port_2.linked_portal = port_1
	port_1.position = pos
	port_2.position = global_position
	port_1.dimension_id = Connector.current_dimension
	port_2.dimension_id = Connector.current_dimension
	while port_2.dimension_id == Connector.current_dimension:
		port_2.dimension_id = randi_range(0,Connector.dimension_list.size()-1)
	emit_signal("spawn_explosion",port_1)
	Connector.dimension_list[port_2.dimension_id].spawn_explosion(port_2)
