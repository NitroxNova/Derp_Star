extends TextureRect

@export_multiline var messages : PackedStringArray

func _on_visibility_changed():
	$VBoxContainer/Label.text = RNG.array_rand(messages)
