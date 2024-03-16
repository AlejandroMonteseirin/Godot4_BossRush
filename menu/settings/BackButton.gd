extends Button
var scene
func _ready():
	ResourceLoader.load_threaded_request("res://menu/main_menu/main_menu.tscn")
func _on_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	Global.save_settings()
	var scene = ResourceLoader.load_threaded_get("res://menu/main_menu/main_menu.tscn")
	get_tree().change_scene_to_packed(scene)
