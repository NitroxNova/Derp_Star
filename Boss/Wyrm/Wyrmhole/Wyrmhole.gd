extends Sprite2D

signal opened
signal closed

func close():
	$Resize_Player.play("Close")

func _on_Resize_Player_animation_finished(anim_name):
	if anim_name == "Open":
		emit_signal("opened")
	elif anim_name == "Close":
		emit_signal("closed")
		queue_free()
