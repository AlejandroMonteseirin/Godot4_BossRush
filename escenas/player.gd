extends CharacterBody2D

@onready var rayoPlayer = preload("res://escenas/rayoPlayer.tscn")
@onready var global = get_node(".")
var jugador = true


var contadorRodar=0
var cooldownRodar=0.5

const COOLDOWN_ATAQUE=0.5
var contadorAtaque=0
var cooldownAtaque=COOLDOWN_ATAQUE
var hitboxAtaque=false



var contadorRayo=0



var direccion=0
var ultimoAngulo=0
var ultimoAnguloConDecimal=0

var hit=false
var cooldownHit=0.6

enum State
{
  STATE_WALKING,
  STATE_DASH,
  STATE_ATTACK,
  STATE_HIT,
  STATE_RAYO,
  STATE_DEATH
};
var ESTADO=State.STATE_WALKING

var unlockeables = 0

func cambiarEstado(nuevoEstado):
	match ESTADO:
		State.STATE_ATTACK:
			$ataqueHitbox/Area2D.hide()
			$ataqueHitbox/Area2D.monitoring=false
			$ataqueHitbox.emitting=false
			hitboxAtaque=false
		State.STATE_DASH:
			cooldownRodar=1
			$GPUParticles2D2.emitting=false
		State.STATE_RAYO:
			contadorRayo=0
			$rayo.emitting=false
			$rayo/PointLight2D.visible=false
			
	match nuevoEstado:
		State.STATE_HIT:
			Audio.play_sound(preload("res://audio/impacts/impactPlate_heavy_003.ogg"))
			cooldownHit=0.6
			Input.start_joy_vibration(0,0.4,0.1,0.6)
			$AnimationPlayer.play("hit")
			Global.shake_camera(0.3,35)
			cambiarAnimacion(ultimoAngulo,Vector2(0,0),"hit")
		State.STATE_ATTACK:
			Input.start_joy_vibration(0,0.1,0.1,0.3)
			cambiarAnimacion(ultimoAngulo,Vector2(0,0),"attack")
			contadorAtaque=0
		State.STATE_DASH:
			$GPUParticles2D2.emitting=true
			self.velocity=self.velocity*3
			contadorRodar=0
		State.STATE_RAYO:
			$rayo.emitting=true
			$rayo.position=Vector2(100,0).rotated(deg_to_rad(ultimoAnguloConDecimal))
			self.velocity=Vector2(0,0)
		State.STATE_DEATH:
			cambiarAnimacion(ultimoAngulo,Vector2(0,0),"death")
			muerte()
	ESTADO=nuevoEstado

func _physics_process(delta):
	procesarCooldowns(delta)
	match ESTADO:
		State.STATE_WALKING:
			var direction:Vector2 = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
			self.velocity=direction*1000
			
			if unlockeables>=1 and cooldownRodar<=0 and Input.is_action_just_pressed("rodar") and direction!=Vector2(0,0):
				cambiarEstado(State.STATE_DASH)
				return
				
			if Input.is_action_just_pressed("ataque") and cooldownAtaque<=0:
				cambiarEstado(State.STATE_ATTACK)
				return
			
			if unlockeables>=2 and Input.is_action_just_pressed("rayo"):
				cambiarEstado(State.STATE_RAYO)
				return
			moverse(direction)
		State.STATE_DASH:
			contadorRodar=contadorRodar+1*delta
			moverse(Vector2(0,0))
			if contadorRodar>0.15:
				cambiarEstado(State.STATE_WALKING)
				return
		State.STATE_ATTACK:
			contadorAtaque=contadorAtaque+1*delta
			if(contadorAtaque>0.35 and hitboxAtaque==false ):
				sonidoAtaque()
				$ataqueHitbox.position=Vector2(100,0).rotated(deg_to_rad(diccionarioAngulos[ultimoAngulo]))
				$ataqueHitbox.rotation=deg_to_rad(ultimoAngulo+225)
				$ataqueHitbox/Area2D.show()
				$ataqueHitbox/Area2D.monitoring=true
				$ataqueHitbox.emitting=true
				hitboxAtaque=true
			if(contadorAtaque>0.5 and hitboxAtaque==true):
				cambiarEstado(State.STATE_WALKING)

		State.STATE_HIT:
			if(cooldownHit>0):		
				cooldownHit=cooldownHit-1*delta
			else:
				cambiarEstado(State.STATE_WALKING)
				
		State.STATE_RAYO:
			if Input.is_action_pressed("rayo"):

				$rayo.process_material.scale_min=0.1+contadorRayo*0.1
				$rayo.process_material.scale_max=0.1+contadorRayo*0.2
				if contadorRayo<=2:
					contadorRayo=contadorRayo+1*delta
				else:
					contadorRayo=2
					if $rayo/PointLight2D.visible==false:
						$rayo/PointLight2D.visible=true
			else:
				$rayo/PointLight2D.visible=false
				var relampago=rayoPlayer.instantiate()
				if(contadorRayo>=2):
					relampago.speedMultiplier=1
					relampago.global_position=self.global_position+Vector2(100,0).rotated(deg_to_rad(ultimoAnguloConDecimal))
					self.get_parent().add_child(relampago)
				elif contadorRayo<2 and contadorRayo>1:
					relampago.speedMultiplier=contadorRayo/3
					relampago.get_node("Timer2").autostart=true
					relampago.global_position=self.global_position+Vector2(100,0).rotated(deg_to_rad(ultimoAnguloConDecimal))
					self.get_parent().add_child(relampago)
				contadorRayo=0
				$rayo.emitting=false
				cambiarEstado(State.STATE_WALKING)
			moverse(Vector2(0,0))
			
	

func procesarCooldowns(delta):
	if cooldownRodar>0:
		cooldownRodar=cooldownRodar-1*delta
	if cooldownAtaque>0:
		cooldownAtaque=cooldownAtaque-1*delta
		

func moverse(direction:Vector2):

	var direccionAnimada=calcular_direccion(direction)
	ultimoAngulo=direccionAnimada
	if ESTADO==State.STATE_WALKING or ESTADO==State.STATE_DASH or ESTADO==State.STATE_RAYO:
		cambiarAnimacion(direccionAnimada,direction)

	if move_and_slide(): # true if collided
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			if col.get_collider() is RigidBody2D:
				#col.get_collider().apply_force(col.get_normal() * -force)
				if col.get_collider().is_in_group("proyectil"):
					self.tocado(col.get_collider().variacionVidas)
					col.get_collider().destruir()
func tocado(variacionVidas):
	if ESTADO != State.STATE_HIT:
		Global.freeze_engine()
		Global.modificarVidas(variacionVidas)
		if Global.vidas<=0:
			cambiarEstado(State.STATE_DEATH)
		else:
			cambiarEstado(State.STATE_HIT)
	
func vector_a_grados(vector):
	
	var angulo_radianes = atan2(vector.y, vector.x)
	var angulo_grados = rad_to_deg(angulo_radianes)

	return angulo_grados
	
func calcular_direccion(input_vector):

	if input_vector==Vector2(0,0):
		return ultimoAngulo
	var angulo = vector_a_grados(input_vector) 
	ultimoAnguloConDecimal=angulo
	if angulo <=22.5 and angulo >= -22.5:
		return 90
	elif angulo < -22.5 and angulo >= -67.5:
		return 45
	elif angulo < -67.5 and angulo >= -112.5:
		return 0
	elif angulo < -112.5 and angulo >= -157.5:
		return 320
	elif angulo < -157.5 or angulo > 157.5:
		return 270
	elif angulo <= 157.5 and angulo > 112.5:
		return 225
	elif angulo <= 112.5 and angulo > 67.5:
		return 180
	elif angulo <= 67.5 and angulo > 22.5:
		return 135
		
func cambiarAnimacion(direccionAnimada,direction:Vector2,animation="default"):
	var animacion="idle"
	$GPUParticles2D.emitting=false
	if animation=='hit':
		animacion="hit"
		$AnimatedSprite2D.speed_scale=3.8
	elif animation=="death":
		animacion="death"
		$AnimatedSprite2D.speed_scale=3
	elif animation=="attack":
		animacion="attack"
		$AnimatedSprite2D.speed_scale=8.4
	elif direction.length_squared()>0:
		animacion= "run"
		$GPUParticles2D.emitting=true

	$AnimatedSprite2D.set_animation(animacion+str(direccionAnimada))
	$AnimatedSprite2D.play()
	if animacion == "idle":
		$AnimatedSprite2D.speed_scale=3
	elif animacion == "run":
		$AnimatedSprite2D.speed_scale=12*(direction.length_squared()+0.2)


	
var diccionarioAngulos = {
	0:270,
	45:320,
	90:0,
	135:45,
	180:90,
	225:135,
	270:180,
	320:225
}
	



func _on_area_2d_body_entered(node):
	if "atacable" in node:
		node.atacado(1) # Replace with function body.

func muerte():
	self.set_physics_process(false)
	$CollisionShape2D.disabled=true
	$LightOccluder2D2.visible=false
	self.z_index=-1
	await get_tree().create_timer(3).timeout
	Global.mostrarReiniciarPopUp()
	
func reiniciar():
	cambiarAnimacion(ultimoAngulo,Vector2(0,0),"idle")
	self.cambiarEstado(State.STATE_WALKING)
	self.set_physics_process(true)
	$CollisionShape2D.disabled=false
	$LightOccluder2D2.visible=true
	self.z_index=0
	Global.vidas=3
	Global.modificarVidas(0)
	
var audioAtaques = [preload("res://audio/impacts/impactMining_000.ogg"),
preload("res://audio/impacts/impactMining_001.ogg"),
preload("res://audio/impacts/impactMining_002.ogg"),
preload("res://audio/impacts/impactMining_003.ogg"),
preload("res://audio/impacts/impactMining_004.ogg")]

func sonidoAtaque():
	var indice_aleatorio = randi() % audioAtaques.size()
	Audio.play_sound(audioAtaques[indice_aleatorio])
	
