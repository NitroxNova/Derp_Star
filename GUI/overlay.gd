extends CanvasLayer

var is_paused = false
var dead = false

func pause():
	is_paused = true
	get_tree().paused = true
	$Talents.hide()
	$Pause_Menu.show()
	$HUD/Energy_Bar.show()
	$HUD/Life_Bar.show()
	
func unpause():
	is_paused = false
	$Pause_Menu.hide()
	$Talents.hide()
	get_tree().paused = false

func pause_pressed():
	if not dead:
		if is_paused:
			unpause()
		else:
			pause()

func play_boss_flash(boss:Boss_Encounter):
	$Boss/Flash.material.get("shader_parameter/gradient").gradient = boss.splash_gradient
	$Boss/Label.text = boss.splash_text
	$Boss/AnimationPlayer.play("Flash")

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
