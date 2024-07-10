class_name Enemy_Projectile
extends RigidBody2D

@export var speed : float
var faction = "enemy"
@export var damage : float

func _ready():
	linear_velocity = Vector2(speed,0).rotated(rotation)
	$Sprite2D.look_at(linear_velocity+position)
	connect("body_entered",Callable(self,"body_entered"))
	connect("body_shape_entered",Callable(self,"body_shape_entered"))
	$Despawn_Timer.connect("timeout",Callable(self,"despawn"))

func despawn():
	queue_free()

func body_entered(body):
	if Connector.deal_damage(self,body,damage):
		if body.is_in_group("Player_Shield"):
			faction = "player"
		else:
			queue_free()
	$Sprite2D.look_at(linear_velocity+position)
	
func body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var shape = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	if Connector.deal_damage(self,shape,damage):
		queue_free()
