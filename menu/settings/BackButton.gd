extends Button

func _on_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	Global.save_settings()
	get_tree().change_scene_to_file(Global.SCENE_MAIN_MENU)
