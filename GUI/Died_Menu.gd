extends TextureRect

@export (Array, String, MULTILINE) var messages

func show():
	$VBoxContainer/Label.text = RNG.array_rand(messages)
	super.show()
