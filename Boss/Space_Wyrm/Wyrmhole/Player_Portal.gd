extends Sprite

signal opened

var dimension_id
var linked_portal
var disabled = true

func close():
	$Resize_Player.play("Close")

func _on_Resize_Player_animation_finished(anim_name):
	if anim_name == "Open":
		emit_signal("opened",self)
		disabled = false
	elif anim_name == "Close":
		queue_free()

func teleport_player():
	Connector.load_dimension(linked_portal.dimension_id)
	Connector.derp_star.position = linked_portal.position

func _on_Area2D_body_entered(body):
	if not disabled:
		$Timer.start()
		disabled = true
		teleport_player()
	
func _on_Timer_timeout():
	disabled = false
