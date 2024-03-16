extends VBoxContainer

@export var settings_scene:PackedScene

func _ready():
	get_children()[0].grab_focus()
	
	if !OS.has_feature("pc"):
		$Quit.hide()

func _on_quit_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	get_tree().quit()

func _on_settings_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	get_tree().change_scene_to_packed(settings_scene)

func _on_start_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	$"../MenuDificultades".modulate = Color(1,1,1,0)
	var tween=get_tree().create_tween()
	tween.tween_property($"../MenuDificultades", "modulate", Color(1,1,1,1) , 3)
	self.hide()
	$"../MenuDificultades".show()
	$"../MenuDificultades/Hbox/VBoxContainer2/Hero".grab_focus()


