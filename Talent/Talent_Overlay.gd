extends ColorRect

var mode = "upgrade"
var talent_display = preload("res://Talent/Display.tscn")

signal mode_changed
signal talents_changed

func _ready():
	for t in Player_Stats.talent.values():
		var d = talent_display.instantiate()
		d.set_talent(t)
		$Talents.add_child(d)
		connect("mode_changed",Callable(d,"_on_Talents_mode_changed"))
		d.connect("talent_pressed",Callable(self,"_on_Talent_talent_pressed"))
		connect("talents_changed",Callable(d,"update_display"))
	upgrade_mode()

func upgrade_mode():
	mode = "upgrade"
	emit_signal("mode_changed",mode)
	$Buttons/Upgrade.disabled = true
	$Buttons/Unlock.disabled = false
	color = Color(0,.5,0,1)

func unlock_mode():
	mode = "unlock"
	emit_signal("mode_changed",mode)
	$Buttons/Unlock.disabled = true
	$Buttons/Upgrade.disabled = false
	color = Color(1,.5,0,1)

func _on_Talent_talent_pressed(talent):
	emit_signal("talents_changed")
