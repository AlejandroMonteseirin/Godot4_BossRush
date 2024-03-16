extends HSlider


var timer =false
func _ready():
	timer=true
	value= Global.effectVolume
	timer=false




func _on_value_changed(value):
	if !timer:
		Audio.play_sound(preload("res://audio/interface/scroll_003.ogg"))
		$"../TimerEffect".start()
		timer=true


func _on_timer_effect_timeout():
	timer=false
	Global.set_setting("effectVolume", value)

