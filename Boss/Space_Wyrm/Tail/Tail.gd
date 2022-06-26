extends Wyrm_Segment

func set_polygon_x():
	next_segment.set_polygon_x(160)

func take_damage(amount):
	next_segment.take_damage(amount)
	
func map_bones():
	polygon.skeleton = "../../Skeleton2D"
	polygon.clear_bones()
	polygon.add_bone(uv_bone_path(), [1, 1, 1, 1, 1, 1, 1])
	polygon.add_bone(next_segment.uv_bone_path(), [0, 1, 1, 1, 1, 1, 0])
	next_segment.map_bones()
	
func setup():
	update_remote_transform()
	set_polygon_x()
	map_bones()
