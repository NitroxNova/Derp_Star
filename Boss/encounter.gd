extends Node2D
class_name Boss_Encounter

@export_multiline var splash_text
@export var splash_gradient : Gradient

signal spawn_boss
signal spawn_boss_core
signal spawn_item
signal spawn_explosion
signal boss_defeated
