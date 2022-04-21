extends ProgressBar

var half_life
var styleBox = get("custom_styles/fg")
var colors = [Color(1,0,0),Color(1,1,0),Color(0,1,0)]

func set_max_value(max_health):
	max_value = max_health
	half_life = max_health/2

func set_value(v):
	var start = colors[floor(float(v)/half_life)]
	var end = colors[ceil(float(v)/half_life)]
	var percent = fmod(v,half_life)/half_life
	var color = lerp(start,end,percent)
	styleBox.bg_color = color
	value = v

