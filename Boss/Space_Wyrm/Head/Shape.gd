extends Wyrm_Segment
var invulnerable = true

func _ready():
	connect_health()
	Connector.derp_star_position(self)

func derp_star_position_changed(pos):
	bone.look_at(pos)
	
func take_damage(amount):
	if invulnerable:
		prev_segment.take_damage(amount)
	else:
		.take_damage(amount)

func died():
	get_parent().queue_free()

func update_remote_transform():
	var bone_remote = bone.get_node("RemoteTransform2D")
	bone_remote.remote_path = bone_remote.get_path_to(self)

func set_polygon_x(pos = 0):
	pass
	
func set_prev(ps, set_next = true):
	if ps.get_name() == "Tail":
		invulnerable = false
	.set_prev(ps,set_next)
	
func map_bones():
	pass
