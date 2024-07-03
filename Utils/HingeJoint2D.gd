#https://www.reddit.com/r/godot/comments/y0hma9/stickman_shows_you_a_hingejoint2d/
extends PinJoint2D
class_name HingeJoint2D

const impulse_size := 200000.0

@export_range(0.0, 180.0) var Limit_left = 45.0
@export_range(0.0, 180.0) var Limit_right = 45.0

var rest_angle: float
var limit_left: float
var limit_right: float

var body_a: RigidBody2D
var body_b: RigidBody2D


func _ready():
	limit_left = deg_to_rad(Limit_left)
	limit_right = deg_to_rad(Limit_right)
	body_a = get_node(node_a)
	body_b = get_node(node_b)
	rest_angle = body_b.rotation - body_a.rotation


func _physics_process(delta):
	var cur_angle := wrapf(body_b.rotation - body_a.rotation, -PI, PI)
	var diff_angle := wrapf(cur_angle - rest_angle, -PI, PI)
	var hinge_angle : float = clamp(diff_angle, -limit_left, limit_right)
	var excede_angle : float = diff_angle - hinge_angle
	var torque: float = excede_angle * impulse_size * delta
	body_a.apply_torque_impulse(torque)
	body_b.apply_torque_impulse(-torque)
