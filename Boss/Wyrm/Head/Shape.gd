extends Wyrm_Segment
var invulnerable = true

func _ready():
	connect_health()
	bone.get_node("Lazer").faction = faction
	
func _process(delta):
	var target_angle = bone.global_position.angle_to_point(Connector.derp_star.global_position)
	bone.global_rotation = lerp_angle(bone.global_rotation,target_angle,.05)
	
func set_color_gradient(gradient):
	super(gradient)
	bone.set_laser_color(gradient)

func aura_on():
	$Charge_Aura.show()

func aura_off():
	$Charge_Aura.hide()
	
func take_damage(amount):
	if invulnerable:
		prev_segment.take_damage(amount)
	else:
		super.take_damage(amount)

func died():
	get_parent().died()

func update_remote_transform():
	var bone_remote = bone.get_node("RemoteTransform2D")
	bone_remote.remote_path = bone_remote.get_path_to(self)

func set_polygon_x(pos = 0):
	pass
	
func set_prev(ps, set_next = true):
	if ps.get_name() == "Tail":
		invulnerable = false
	super.set_prev(ps,set_next)
	
func map_bones():
	pass
