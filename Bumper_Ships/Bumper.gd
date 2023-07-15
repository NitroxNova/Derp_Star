class_name Bumper_Ship
extends RigidBody2D

@export var starting_health : int
var health : Capped_Value
@export var loot : PackedScene
@export var points : int
var explosion = preload("res://Bumper_Ships/Explosion/Explosion.tscn")
var faction = "enemy"

signal update_current_health
signal update_maximum_health
signal spawn_bumper
signal spawn_explosion
signal spawn_item
signal spawn_projectile

func build():
	rotation = randf() * 2 * PI

func get_collision_shape():
	var shape = $Collision_Shape.duplicate()
	shape.rotation = rotation
	shape.position += position
	return shape

func get_collision_shapes():
	return [get_collision_shape()]

func _ready():
	health = Capped_Value.new(starting_health,starting_health)
	health.connect("current_zero",Callable(self,"died"))
	emit_signal("update_maximum_health",health.maximum)
	emit_signal("update_current_health",health.current)
	add_to_group("bumper")
	static_off()
	$Health_Node/Node2D/ProgressBar.hide()

func take_damage(amount):
	health.decrease_current(amount)
	emit_signal("update_current_health",health.current)
	$Health_Node/Node2D/ProgressBar.show()
	
func died():
	Player_Stats.increase_points(points)
	explode()
	drop_item()
	queue_free()

func drop_item():
	if not loot == null:
		var i = loot.instantiate()
		i.transform = global_transform
		emit_signal("spawn_item",i)

func get_base_sprite():
	return $Base_Sprite

func get_shatter_texture():
	return get_base_sprite().texture

func explode():
	var e = explosion.instantiate()
	e.transform = global_transform
	var bs = get_base_sprite()
	var bs_texture = get_shatter_texture()
	e.bumper_texture = bs_texture
	e.height = bs_texture.get_height()
	e.width = bs_texture.get_width()
	e.scale = bs.global_scale
	e.shader_material = bs.material
	emit_signal("spawn_explosion",e)
	
func static_on():
	$Static.emitting = true
	
func static_off():
	$Static.emitting = false

