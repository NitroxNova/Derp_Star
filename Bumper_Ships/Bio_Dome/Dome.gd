extends Bumper_Ship

var tube_scene = preload("res://Bumper_Ships/Bio_Dome/Tube/Bumper.tscn")
var connected_tubes = []

func _ready():
	._ready()
	make_joints()
	
func connect_dome(dome):
	if not is_dome_connected(dome):
		var tube = tube_scene.instance()
		tube.set_domes(self,dome)
		return tube
	return false

func is_dome_connected(dome):
	for tube in connected_tubes:
		if dome in tube.connected_domes:
			return true
	return false
	
func make_joints():
	for tube in connected_tubes:
		var joint = PinJoint2D.new()
		joint.node_a = ".."
		joint.node_b = "../../" + tube.name
		tube.connect("tree_exited",joint,"queue_free")
		add_child(joint)
