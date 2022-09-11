class_name Bumper_Ship
extends RigidBody2D

export var starting_health : int
var health : Capped_Value
export (Resource) var drop_item
export (int) var points
var explosion = preload("res://Bumper_Ships/Explosion/Explosion.tscn")
var faction = "enemy"

signal update_current_health
signal update_maximum_health

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
	health.connect("current_zero",self,"died")
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
	if drop_item:
		var i = drop_item.instance()
		i.transform = global_transform
		Connector.drop_item(i)

func get_base_sprite():
	return $Base_Sprite

func explode():
	var e = explosion.instance()
	e.transform = global_transform
	var bs = get_base_sprite()
	e.bumper_texture = bs.texture
	e.height = bs.texture.get_height()
	e.width = bs.texture.get_width()
	e.scale = bs.global_scale
	Connector.draw_explosion(e)
	
func static_on():
	$Static.emitting = true
	
func static_off():
	$Static.emitting = false


func _on_Bumper_a():
	pass # Replace with function body.
