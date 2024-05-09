extends RigidBody2D

var danaEnemigo=false
var speed = 900
var atacable=true
var player 
var destruyendo=false
var variacionVidas=-0.5
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	if player:
		# Calcula la dirección hacia el jugador
		var target_direction = (player.global_position - global_position).normalized()
		self.apply_impulse(target_direction*speed)
		$Timer2.wait_time=3
		$Timer2.start()

	
#unc _process(delta):

	


func _on_timer_timeout():
	queue_free()



func destruir():
	if not destruyendo:
		Audio.play_sound(preload("res://audio/otros/472688__silverillusionist__fire-burst.wav"))
		$CollisionShape2D.disabled=true
		destruyendo=true
		var tween = create_tween()
		tween.tween_property($PointLight2D, "energy", 0,0.5)
		tween.play()
		$explota.emitting=true
		$Timer.wait_time=0.5
		$Timer.start()



func _on_visible_on_screen_notifier_2d_screen_exited():
	destruir()

func atacado(_damage):
	if not destruyendo:
		Audio.play_sound(preload("res://audio/impacts/impactGlass_medium_004.ogg"))
		$Timer.stop()
		danaEnemigo=true
		var vectorNormal:Vector2= (self.global_position-player.global_position).normalized()
		self.apply_force(vectorNormal * 10000)
		$bolaRoja.modulate = Color(1,1,1)


func _on_timer_2_timeout():
	destruir()
