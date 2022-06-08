extends KinematicBody2D	


func _ready():
	$AnimationPlayer.play("Idle")

func _on_Derp_Star_update_position(derp_pos):
	$Skeleton2D/Tail/Body_3/Body_2/Body_1/Head.look_at(derp_pos)
