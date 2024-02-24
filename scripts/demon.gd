extends Node2D






# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func dispara():
	if not $mareado.visible:
		$demonio.play("fire180")
		$disparador/Timer.wait_time=1.5
		$disparador/Timer.start()



func _on_timer_timeout():
	if(not atacando):
		dispara() # Replace with function body.


func _on_demonio_animation_finished():
	if($demonio.animation=="hit180"):
		$mareado.visible=false
	$demonio.play("idle180")
	$Timer.start()

func _on_area_ataque_body_entered(body):
	if "jugador" in body:
		ataque() 
		
func _on_area_ataque_body_exited(body):
	atacando=false
	$atackcontroller.dejaAtacar() 
	
var atacando=false
func ataque():
	if(not atacando):
		atacando=true
		$atackcontroller.ataca()
		$demonio.play("attack180")
	

func _on_hitbox_demonio_body_entered(body):
	if "danaEnemigo" in body and body.danaEnemigo:
		body.call_deferred("destruir")
		$demonio.play("hit180") # Replace with function body.
		$mareado.visible=true
		print("Da al demonio")
