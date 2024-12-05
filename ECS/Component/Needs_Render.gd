extends Component
class_name Needs_Render_Component

var path : String #path to scene
var position : Vector2 #position in which to render, once its in scene dont need to keep track, just get it from the node component
#do we need one for dimension? or will it always add to the current one

func _init(_path:String,_position:Vector2) -> void:
	path = _path
	position = _position
