extends Node

var rng = RandomNumberGenerator.new()

func _init():
	randomize()
	rng.randomize()

func randi_range(from,to):
	return rng.randi_range(from,to)

func randf_range(from,to):
	return rng.randf_range(from,to)

func array_rand(arr):
	var index = rng.randi_range(0,arr.size()-1)
	return arr[index]

func array_rand_multi(in_array, count):
	var out_array = []
	while count > 0:
		var value = array_rand(in_array)
		out_array.append(value)
		in_array.erase(value)
		count -= 1
	return out_array
