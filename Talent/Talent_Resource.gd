extends Resource
class_name Talent

export var display_name : String
export var texture : Texture
export var maximum : int

var upgrade = 0
var unlock = 0

signal upgrade_changed
signal unlock_changed

func increase_upgrade(amount = 1):
	upgrade += amount
	emit_signal("upgrade_changed",upgrade,amount)

func increase_unlock(amount = 1):
	unlock += amount
	emit_signal("unlock_changed",unlock,amount)
	Save.save_file()

	
