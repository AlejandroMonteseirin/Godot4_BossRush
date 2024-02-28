extends HSlider


func _ready():
	value= Global.effectVolume


func _on_drag_ended(value_changed):
	Global.set_setting("effectVolume", value)


func _on_drag_started():
	Audio.play_sound(preload("res://audio/interface/scroll_003.ogg"))
