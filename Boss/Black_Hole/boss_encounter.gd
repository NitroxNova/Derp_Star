extends Boss_Encounter

var faction = "environment"
var dps : float = 30
enum {FADE_IN, GROW, COLLAPSE, FINISH_BEAMS}
var state = FADE_IN
var size : float = 1.0
var max_size : float = 5.0
var item_list = [load("res://Pick_Ups/Ore_Chunk/Uranium.tscn"),load("res://Pick_Ups/Ore_Chunk/Gold.tscn"),load("res://Pick_Ups/Ore_Chunk/Cobalt.tscn"),
load("res://Pick_Ups/Health/Health_Pack.tscn"),load("res://Pick_Ups/Energy/Energy_Pack.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == GROW:
#		increase_size(delta)
		for body in $Area2D.get_overlapping_bodies():
			var dist = global_position.distance_to(body.global_position)
			var radius = $Area2D/CollisionShape2D.shape.radius
			var dist_ratio = max(0,1 - (dist/radius))
			var damage = dps * delta * dist_ratio * size
			if body is Dropped_Item and body.global_position.distance_to(global_position) < radius /2 :
				var points = 10
				if "points" in body:
					points = body.points
				increase_size(points * .01)
				body.queue_free()
			elif body.is_in_group("bumper") and body.health.current <= damage:
				increase_size(body.points * .01)
				body.explode()
				body.queue_free()
			else:
				Connector.deal_damage(self,body,damage)


func _on_animation_player_animation_finished(anim_name):
	state = GROW
	$Area2D/CollisionShape2D.disabled = false

func set_size(s:float):
	if state == GROW:
		size = s
		if size >= max_size:
			explode()
			size = max_size
		var l_scale = sqrt(size)
		$Visuals.scale = Vector2(l_scale,l_scale)
		$Area2D.scale = Vector2(l_scale,l_scale)
	
func increase_size(amount:float):
	set_size(size + amount)

func explode():
	if state == GROW:
		state = COLLAPSE
		$Area2D.gravity = -200
		var tween = get_tree().create_tween()
		tween.tween_property($Visuals, "scale", Vector2.ZERO, 5).from_current()
		tween.connect("finished",Callable(self, "collapse_complete"))
		var item_tween = get_tree().create_tween().set_loops()
		item_tween.tween_callback(generate_item).set_delay(0.1)
		tween.connect("finished",Callable(item_tween, "kill"))
		
		$Light_Beams.emitting = true

func collapse_complete():
	print("collapse complete")
	if state == COLLAPSE:
		state = FINISH_BEAMS
		var tween = get_tree().create_tween()
		tween.tween_interval(5)
		tween.connect("finished",Callable(self, "light_beams_finished"))
		$Light_Beams.emitting = false
#		$Item_Timer.stop()
		emit_signal("spawn_boss_core",global_position)
		$Area2D/CollisionShape2D.disabled = true

func light_beams_finished():
	queue_free()
	emit_signal("boss_defeated")
	
func generate_item():
	if state == COLLAPSE:
		var item : Dropped_Item = RNG.array_rand(item_list).instantiate()
		if item is Ore_Chunk:
			item.set_size(randf_range(.1,.4))
		item.position = global_position + Vector2(randf_range(-500,500),randf_range(-500,500))
		emit_signal("spawn_item",item)
		item.apply_central_impulse(Vector2(randf_range(-500,500),randf_range(-500,500)))
