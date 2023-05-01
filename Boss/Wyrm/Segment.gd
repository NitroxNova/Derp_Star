extends CollisionShape2D
class_name Wyrm_Segment

var bone
var polygon
var prev_segment
var next_segment
@export var health : Capped_Value
var faction = "enemy"

func set_color_gradient(gradient:Gradient):
	$Charge_Aura.process_material.color = gradient.sample(1.0)
	$Charge_Aura.process_material.color.a = 0.5		
	if not next_segment == null:
		next_segment.set_color_gradient(gradient)
	if not polygon == null:
		polygon.material.get("shader_parameter/gradient").gradient = gradient
	
func aura_on():
	$Charge_Aura.show()
	next_segment.aura_on()

func aura_off():
	$Charge_Aura.hide()
	next_segment.aura_off()

func uv_bone_path():
	var path = get_node("../Skeleton2D").get_path_to(bone)
	return path
	
func connect_health():
	health.connect("current_zero",Callable(self,"died"))
	$Health_Node/Node2D/ProgressBar.value = health.current
	$Health_Node/Node2D/ProgressBar.max_value = health.maximum
	$Health_Node/Node2D/ProgressBar.hide()
		
func take_damage(amount):
	health.decrease_current(amount)
	$Health_Node/Node2D/ProgressBar.value = health.current
	$Health_Node/Node2D/ProgressBar.show()
	
func died():
	get_parent().destroy_segment(self)
	bone.queue_free()
	polygon.queue_free()
	queue_free()
		
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
