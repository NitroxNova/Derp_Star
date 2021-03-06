extends AnimationPlayer

func setup():
	setup_charge_animation()
	setup_idle_animation()

func setup_charge_animation():
	var charge = get_animation("Charge")
	var segment = get_node("../Tail")
	var index = 0
	
	while segment != null:
		var bone_path = str(get_parent().get_path_to(segment.bone))
		var pos_track = charge.add_track(Animation.TYPE_VALUE)
		charge.track_set_path(pos_track,bone_path + ":position")
		var rot_track = charge.add_track(Animation.TYPE_VALUE)
		charge.track_set_path(rot_track,bone_path + ":rotation")
		
		var frames = 60.0
		for f in frames:
			var time = (f/frames) * 6
			var curr_pos = charge_pos(index,time)
			var next_pos = charge_pos(index+1,time)
			var prev_pos = charge_pos(index-1,time)
			var curr_rot = next_pos.angle_to_point(curr_pos)
			var prev_rot = curr_pos.angle_to_point(prev_pos)
			if segment.prev_segment == null: #tail
				charge.track_insert_key(pos_track,time,curr_pos)
				charge.track_insert_key(rot_track,time,curr_rot)
			else: 
				charge.track_insert_key(rot_track,time,curr_rot - prev_rot)	
				var pos_x = curr_pos.distance_to(prev_pos)
				charge.track_insert_key(pos_track,time,Vector2(pos_x,0))
	
		segment = segment.next_segment
		index += 1
	
func charge_pos(index,time):
	var x = index*150
	var y = sin((index+time)*PI/3) * 150
	return Vector2(x,y)
	
func setup_idle_animation():
	var idle = get_animation("Idle")
	var segment = get_node("../Tail")
	var index = 0
	var rotation_start = [1,1,1,-1,-1,-1]
	var rotation_end = [1.2,1.2,1.2,-1.2,-1.2,-1.2]
	while segment.next_segment != null:
		var track_index = idle.add_track(Animation.TYPE_VALUE)
		var anim_path = str(get_parent().get_path_to(segment.bone))
		idle.track_set_path(track_index,anim_path + ":rotation")
		idle.track_insert_key(track_index,0,rotation_start[index%rotation_start.size()])
		idle.track_insert_key(track_index,2.5,rotation_end[index%rotation_end.size()])
		segment = segment.next_segment
		index += 1
