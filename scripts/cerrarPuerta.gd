extends Area2D

@onready var suelo = $"../Suelo3(movil)"
var moverSuelo=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moverSuelo:
		suelo.position=suelo.position+(Vector2(0,110)*delta)



func _on_timer_timeout():
	self.queue_free()


func _on_body_entered(body):
	print("cerrando")
	Global.shake_camera(3,80)
	Input.start_joy_vibration(0,0.2,0.0,3)
	moverSuelo=true
	call_deferred('cerrarPuerta')
	$Timer.start()

func cerrarPuerta():
	$"../colisiones/puerta".disabled=false
