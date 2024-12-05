extends Component
class_name Node_Component

var node : Node # instance of node

var scene_path :
	get:
		return node.scene_file_path
		
var position :
	get:
		return node.position

func _init(_node:Node):
	node = _node
	#node is set from needs_render.path in the render system
