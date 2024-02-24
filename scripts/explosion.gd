extends Node2D

func _ready():
	Global.shake_camera(0.5,100)

func _on_animated_sprite_2d_animation_finished():
	self.queue_free()
