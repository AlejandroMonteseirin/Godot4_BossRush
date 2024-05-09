extends RigidBody2D
@onready var rayo = preload("res://escenas/rayo.tscn")
@export var activado=false
@export var principal=true
var atacable=true
var disabled=false
# Called when the node enters the scene tree for the first time.
func _ready():
	if activado:
		var tween = create_tween()
		tween.tween_property($PointLight2D, "energy", 5,1)
		tween.play()
		activar()





func _on_area_2d_body_entered(body):
	if disabled:
		return
	if "danaEnemigo" in body and body.danaEnemigo:
		body.call_deferred("destruir")
		atacado(0)


func atacado(_dano):
	if disabled:
		return
	if activado:
		morir()
		if principal:
			activarResto()
	else: 
		activar()
		

func activarResto():
	get_tree().call_group("obelisk", "activar")

func morir():
	disabled=true
	$Timer.stop()
	var tween:Tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1,1),0.05)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(0,0,0),0.05)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1,1),0.05)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(0,0,0),0.05)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1,1),0.05)


	tween.tween_property($AnimatedSprite2D, "modulate", Color(0.2,0.2,0.2),2)
	tween.parallel().tween_property($PointLight2D, "energy", 0,2)
	tween.play()
	if principal:
		Global.tempValue=Global.tempValue+1


func activar():
	if activado and principal:
		return
	activado=true
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(0,0,1),0.1)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1,1),1)
	tween.play()
	var tween2 = create_tween()
	tween2.tween_property($PointLight2D, "energy", 5,1)
	tween2.play()
	Global.shake_camera(0.1,100)
	$Timer.wait_time=randf_range(0.8,1.4)
	$Timer.start()

func _on_timer_timeout():
	if disabled:
		return
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(0,0,1),0.1)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1,1),1)
	tween.play()
	var tween2 = create_tween()
	tween2.tween_property($PointLight2D, "energy", 10,0.1)
	tween2.tween_property($PointLight2D, "energy", 5,2.9)
	tween2.play()
	var tween3 = create_tween()
	tween3.tween_property($PointLight2D, "texture_scale", 5,0.1)
	tween3.tween_property($PointLight2D, "texture_scale", 2,2.9)
	tween3.play()
	$Timer.wait_time=3.0
	Audio.play_sound(preload("res://audio/otros/143611__dwoboyle__weapons-synth-blast-01.wav"))
	self.add_child(rayo.instantiate())
