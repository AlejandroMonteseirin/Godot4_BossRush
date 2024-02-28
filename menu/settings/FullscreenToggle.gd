extends CheckButton

func _ready():
	set_pressed_no_signal(Global.fullscreen)
	
	if !OS.has_feature("pc"):
		hide()

func _on_toggled(bpressed):
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	Global.set_setting("fullscreen", bpressed)
