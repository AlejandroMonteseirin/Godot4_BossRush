extends Area2D

@onready var suelo = $"../Suelo3(movil)"
var moverSuelo=false
var sonidoTemblor
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moverSuelo:
		suelo.position=suelo.position+(Vector2(0,130)*delta)



func _on_timer_timeout():
	Audio.stop_sound(sonidoTemblor)
	self.queue_free()


func _on_body_entered(body):
	sonidoTemblor = Audio.play_sound(preload("res://audio/otros/524307__bertsz__earthquake-in-cave.wav"))
	Global.shake_camera(3,80)
	Input.start_joy_vibration(0,0.2,0.0,3)
	moverSuelo=true
	call_deferred('cerrarPuerta')
	$Timer.start()

func cerrarPuerta():
	$"../colisiones/puerta".disabled=false
