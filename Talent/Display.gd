extends VBoxContainer

signal talent_pressed

var talent : Resource

var mode = "upgrade"

func set_talent(t):
	talent = t
	$Button.icon = talent.texture
	$Name.text = talent.display_name
	update_display()
	
func _on_Button_pressed():
	if mode == "upgrade":
		upgrade()
	elif mode == "unlock":
		unlock()
	emit_signal("talent_pressed",self)

func upgrade():
	Player_Stats.decrease_points(upgrade_cost())
	talent.increase_upgrade()
	update_display()

func unlock():
	Player_Stats.decrease_boss_cores(unlock_cost())
	talent.increase_unlock()
	update_display()

func update_display():
	var counter_text = str(talent.upgrade) + " / " + str(talent.unlock)
	$Counter.text = counter_text
	if mode == "upgrade":
		if talent.upgrade >= talent.unlock:
			turn_white_and_disable()
		elif Player_Stats.points < upgrade_cost():
			turn_red_and_disable()
		else:
			turn_white_and_enable()
	elif mode == "unlock":
		if (not talent.maximum == 0) and talent.maximum <= talent.unlock:
			turn_white_and_disable()
		elif Player_Stats.boss_cores < unlock_cost():
			turn_red_and_disable()
		else:
			turn_white_and_enable()

func turn_red_and_disable():	
	$Button.modulate = Color(1,0,0)
	$Button.disabled = true

func turn_white_and_disable():
	$Button.disabled = true
	$Button.modulate = Color(1,1,1)
	
func turn_white_and_enable():
	$Button.disabled = false
	$Button.modulate = Color(1,1,1)
	

func _on_Talents_mode_changed(m):
	mode = m
	update_display()

func upgrade_cost():
	return (talent.upgrade + 1) * 1000
	
func unlock_cost():
	return (talent.unlock + 1)
