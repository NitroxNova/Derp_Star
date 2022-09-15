extends Node

var rng = RandomNumberGenerator.new()

func _init():
	randomize()
	rng.randomize()

func randi_range(from,to):
	rng.randi_range(from,to)

func randf_range(from,to):
	rng.randf_range(from,to)

func array_rand(arr):
	var index = rng.randi_range(0,arr.size()-1)
	return arr[index]
