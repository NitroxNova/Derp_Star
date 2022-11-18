extends Area2D

export var flash_config : Resource
var faction = "environment"
var dps : float = 30
var size : float = 1
var max_size : float = 5
enum {FADE_IN, GROW, COLLAPSE, FINISH_BEAMS}
var state = FADE_IN
var item_list = [load("res://Pick_Ups/Ore_Chunk/Uranium.tscn"),load("res://Pick_Ups/Ore_Chunk/Gold.tscn"),load("res://Pick_Ups/Ore_Chunk/Cobalt.tscn"),
load("res://Pick_Ups/Health/Health_Pack.tscn"),load("res://Pick_Ups/Energy/Energy_Pack.tscn")]

func _ready():
	$CollisionShape2D.disabled = true
	$Light_Beams.emitting = false

func _process(delta):
	if state == GROW:
#		increase_size(delta)
		for body in get_overlapping_bodies():
			var dist = global_position.distance_to(body.global_position)
			var radius = $CollisionShape2D.shape.radius
			var dist_ratio = max(0,1 - (dist/radius))
			var damage = dps * delta * dist_ratio * size
			if body is Dropped_Item and body.global_position.distance_to(global_position) < radius /2 :
				var points = 10
				if points in body:
					points = body.points
				increase_size(points * .01)
				body.queue_free()
			elif body.is_in_group("bumper") and body.health.current <= damage:
				increase_size(body.points * .01)
				body.explode()
				body.queue_free()
			else:
				Connector.deal_damage(self,body,damage)

func set_size(s:float):
	if state == GROW:
		size = s
		if size >= max_size:
			explode()
			size = max_size
		var l_scale = sqrt(size)
		scale = Vector2(l_scale,l_scale)
	
func increase_size(amount:float):
	set_size(size + amount)
	
func explode():
	if state == GROW:
		state = COLLAPSE
		gravity = -200
		$Tween.interpolate_property($Shader,"scale",$Shader.scale,Vector2.ZERO,5)
		$Tween.interpolate_property($Center,"scale",$Center.scale,Vector2.ZERO,5)
		$Tween.start()
		$Item_Timer.start()
		$Light_Beams.emitting = true

func _on_Tween_tween_all_completed():
	if state == COLLAPSE:
		state = FINISH_BEAMS
		$Light_Timer.start()
		$Light_Beams.emitting = false
		$Item_Timer.stop()
		Connector.drop_boss_core(global_position)

func spawn_item():
	if state == COLLAPSE:
		var item : Dropped_Item = RNG.array_rand(item_list).instance()
		if item is Ore_Chunk:
			item.set_size(rand_range(.1,.4))
		item.position = global_position + Vector2(rand_range(-500,500),rand_range(-500,500))
		Connector.drop_item(item)
		item.apply_central_impulse(Vector2(rand_range(-500,500),rand_range(-500,500)))


func _on_Light_Timer_timeout():
	queue_free()
	get_parent().boss_defeated()

func _on_AnimationPlayer_animation_finished(anim_name):
	state = GROW
	$CollisionShape2D.disabled = false
