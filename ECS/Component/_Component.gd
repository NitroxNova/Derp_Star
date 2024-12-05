extends Resource
class_name Component

var type :
	get:
		return get_script().get_global_name().trim_suffix("_Component")
