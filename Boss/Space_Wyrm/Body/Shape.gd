extends Wyrm_Segment

func _ready():
	connect_health()

func set_polygon_x(pos = 0):
	polygon.position.x = pos
	next_segment.set_polygon_x(pos + 160)
		
func map_bones():
	polygon.skeleton = "../../Skeleton2D"
	polygon.clear_bones()
	polygon.add_bone(uv_bone_path(),[1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
	polygon.add_bone(next_segment.uv_bone_path(), [0, 0, 0, 1, 1, 1, 0, 0, 0, 0])
	polygon.add_bone(prev_segment.uv_bone_path(), [1, 0, 0, 0, 0, 0, 0, 0, 1, 1])
	next_segment.map_bones()
