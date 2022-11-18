extends CanvasLayer

var pause = false

func pause():
	pause = true
	get_tree().paused = true
	$Pause_Menu.show()
	
func unpause():
	pause = false
	$Pause_Menu.hide()
	get_tree().paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
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
	pass # Replace with function body.
