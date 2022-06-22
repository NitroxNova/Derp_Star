extends Wyrm_Segment

func set_polygon_x(pos = 0):
	next_segment.set_polygon_x(160)

func take_damage(amount):
	next_segment.take_damage(amount)
