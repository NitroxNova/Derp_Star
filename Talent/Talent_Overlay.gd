extends ColorRect

var mode = "upgrade"

signal mode_changed
signal talents_changed

func _ready():
	$Talent.set_talent(Player_Stats.talent.list["max_health"])
	upgrade_mode()

func upgrade_mode():
	mode = "upgrade"
	emit_signal("mode_changed",mode)
	$HBoxContainer/Upgrade.disabled = true
	$HBoxContainer/Unlock.disabled = false
	color = Color(0,.5,0,1)

func unlock_mode():
	mode = "unlock"
	emit_signal("mode_changed",mode)
	$HBoxContainer/Unlock.disabled = true
	$HBoxContainer/Upgrade.disabled = false
	color = Color(1,.5,0,1)

func _on_Talent_talent_pressed(talent):
	if mode == "upgrade":
		talent.upgrade()
	elif mode == "unlock":
		talent.unlock()
	emit_signal("talents_changed")
