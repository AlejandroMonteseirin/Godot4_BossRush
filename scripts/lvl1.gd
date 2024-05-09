extends Node

var infoNivel = {"camara":"jugador",
	"posicion": [-500,6000]}
@export var nivel2:PackedScene
var efecto = preload("res://escenas/efectoEnergiaOneShot.tscn")
# Called when the node enters the scene tree for the first time.


func _ready():
	Global.tempValue=0
	$inicio.add_child(efecto.instantiate())


func _on_timer_timeout():
	if Global.tempValue >= 1:
		if $brights1.emitting==false:
			$brights1.emitting=true
	if Global.tempValue >= 3:
		if $brights2.emitting==false:
			$brights2.emitting=true
	if Global.tempValue >= 5:
		if $brights3.emitting==false:
			$brights3.emitting=true
	if Global.tempValue >= 6:
		if $brights4.emitting==false:
			$brights4.emitting=true
	
	if Global.tempValue >= 7:
		$map/PointLight2D.enabled=true
		$map/PointLight2D.show()
		endlvl()
		
func endlvl():
	$endlevel.monitoring=true

	

	
func _on_endlevel_body_entered(body):
	$endlevel.add_child(efecto.instantiate())
	await get_tree().create_timer(1).timeout
	get_node("/root/odin").inicializarNivel(nivel2)
