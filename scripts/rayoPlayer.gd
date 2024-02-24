extends RigidBody2D

var danaEnemigo=true
var speed = 1500
var speedMultiplier=1
var player 
var destruyendo=false
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	if player:
		# Calcula la dirección hacia el jugador
		var target_direction = -(player.global_position - global_position).normalized()
		self.apply_impulse(target_direction*speed*speedMultiplier)

	


	


func _on_timer_timeout():
	queue_free()



func destruir():
	if not destruyendo:
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




func _on_timer_2_timeout():
	destruir() 
