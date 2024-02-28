extends VFlowContainer

func _ready():
	focus()
	
	if !OS.has_feature("pc"):
		$Quit.hide()

func focus():
	get_children()[0].grab_focus()

func _on_quit_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	get_tree().quit()

func _on_main_menu_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	var root = get_tree().get_root().get_tree()
	root.paused = false
	root.change_scene_to_file(Global.SCENE_MAIN_MENU)


func _on_options_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	var root = get_tree().get_root().get_tree()
	root.paused = false
	root.change_scene_to_file(Global.SCENE_)
