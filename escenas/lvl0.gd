extends Node

var infoNivel = {"camara":"jugador",
	"posicion": [0,200]}

var efecto = preload("res://escenas/efectoEnergiaOneShot.tscn")
@export var nivel1:PackedScene


func _ready():
	Global.tempValue=0
	$map/inicio.add_child(efecto.instantiate())


func _on_timer_timeout():
	if Global.tempValue >= 1:
		if $map/brights1.emitting==false:
			$map/brights1.emitting=true
	if Global.tempValue >= 3:
		if $map/brights2.emitting==false:
			$map/brights2.emitting=true
	if Global.tempValue >= 5:
		if $map/brights3.emitting==false:
			$map/brights3.emitting=true
	if Global.tempValue >= 6:
		if $map/brights4.emitting==false:
			$map/brights4.emitting=true
	
	if Global.tempValue >= 7:
		$map/PointLight2D.enabled=true
		$map/PointLight2D.show()
		endlvl()
		
func endlvl():
	$endlevel.monitoring=true

	

	
func _on_endlevel_body_entered(body):
	$endlevel.add_child(efecto.instantiate())
	await get_tree().create_timer(1).timeout
	get_node("/root/odin").inicializarNivel(nivel1)
