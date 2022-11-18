extends CanvasLayer

var pause = false
var dead = false

func pause():
	pause = true
	get_tree().paused = true
	$Talents.hide()
	$Pause_Menu.show()
	$HUD/Energy_Bar.show()
	$HUD/Life_Bar.show()
	
func unpause():
	pause = false
	$Pause_Menu.hide()
	$Talents.hide()
	get_tree().paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause") and not dead:
		if pause:
			unpause()
		else:
			pause()

func _on_Resume_Button_pressed():
	unpause()

func _on_Restart_Button_pressed():
	unpause()
	get_tree().reload_current_scene()

func _on_Quit_Button_pressed():
	get_tree().quit()
	
func player_died():
	dead = true
	get_tree().paused = true
	$Died_Menu.show()

func _on_Talents_Button_pressed():
	$Pause_Menu.hide()
	$Talents.show()
	$HUD/Energy_Bar.hide()
	$HUD/Life_Bar.hide()
