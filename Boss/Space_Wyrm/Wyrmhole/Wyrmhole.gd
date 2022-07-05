extends Sprite

signal opened

func close():
	$Resize_Player.play("Close")

func _on_Resize_Player_animation_finished(anim_name):
	if anim_name == "Open":
		emit_signal("opened",self)
	elif anim_name == "Close":
		queue_free()
