extends CollisionShape2D
class_name Wyrm_Segment

var bone
var polygon
var prev_segment
var next_segment
	
func set_next(ns, set_prev = true):
	next_segment = ns
	if set_prev:
		ns.set_prev(self,false)

func set_prev(ps, set_next = true):
	prev_segment = ps
	if set_next:
		ps.set_next(self,false)

func update_remote_transform():
	var bone_remote = bone.get_node("RemoteTransform2D")
	bone_remote.remote_path = bone_remote.get_path_to(self)
	next_segment.update_remote_transform()

func set_polygon_x(pos = 0):
	polygon.position.x = pos
	next_segment.set_polygon_x(pos + 160)
