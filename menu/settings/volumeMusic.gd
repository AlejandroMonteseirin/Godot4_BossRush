extends HSlider


func _ready():
	value= Global.musicVolume


func _on_drag_ended(value_changed):
	Global.set_setting("musicVolume", value)


func _on_drag_started():
	Audio.play_sound(preload("res://audio/interface/scroll_003.ogg"))
