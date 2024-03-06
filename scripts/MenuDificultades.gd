extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_baby_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))


func _on_hero_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))


func _on_legend_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))


func _on_back_pressed():
	Audio.play_sound(preload("res://audio/interface/select_005.ogg"))
	$"../MenuOptions".modulate = Color(1,1,1,0)
	var tween=get_tree().create_tween()
	tween.tween_property($"../MenuOptions", "modulate", Color(1,1,1,1) , 3)
	self.hide()
	$"../MenuOptions".show()
	$"../MenuOptions/Start".grab_focus()
