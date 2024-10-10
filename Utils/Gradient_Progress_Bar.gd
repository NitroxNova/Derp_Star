extends ProgressBar
class_name Player_Health_Bar

@onready var styleBox = get("theme_override_styles/fill")
@export var gradient : Gradient

#ovveride setters on from ProgressBar and Ranged
func _set(prop_name,prop_value):
	match prop_name:
		"value":
			set_value_override(prop_value)

func set_value_override(v):
	value = v
	var color = gradient.sample(ratio)
	if styleBox != null:
		styleBox.bg_color = color
