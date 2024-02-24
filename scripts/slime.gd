extends CharacterBody2D
var atacable=true
var player
var slime 
enum State
{
  IDLE,
  DAMAGED,
  CARGANDO,
  MOVING
};
var estado=State.IDLE
var tween 

var iniciadoCombate=false
var vidas=5
var hijo:bool=false
var bebe:bool=false
var explosion : PackedScene= preload("res://escenas/explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if bebe:
		$Timer.start()
		$GPUParticles2D.hide()
	elif hijo:
		slime = load("res://escenas/slime.tscn")
		$Timer.start()
	else:
		slime = load("res://escenas/slime.tscn")

		
	player=get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(self.velocity.length_squared()<=0.1):
		$GPUParticles2D.emitting=false
	else:
		$GPUParticles2D.emitting=true
	match estado:
		State.DAMAGED:
			var collision = move_and_collide(self.velocity * delta)
			if collision:
				self.velocity=velocity.bounce(collision.get_normal())*0.4
			self.velocity=self.velocity*(1-0.98*delta)
		State.MOVING:
			var collision = move_and_collide(self.velocity * delta)
			if collision:
				if 'jugador' in collision.get_collider():
					collision.get_collider().tocado(-1)
				self.velocity=velocity.bounce(collision.get_normal())*0.8
			self.velocity=self.velocity*(1-0.7*delta)
					


func atacado(_damage):
	if estado!= State.DAMAGED and estado != State.MOVING:
		vidas = vidas-1
		Global.freeze_engine()
		if !iniciadoCombate:
			iniciadoCombate=true
			Global.musica(1)
		if (vidas<=0):
			if not hijo and not bebe:
				for i in range(2):
					var slimeInstance= slime.instantiate()
					slimeInstance.hijo=true
					slimeInstance.scale=Vector2(5,5)
					slimeInstance.vidas=3
					slimeInstance.estado=State.DAMAGED
					slimeInstance.iniciadoCombate=true
					call_deferred('crear',slimeInstance,i)
				call_deferred('destruir')
			if hijo and not bebe:
				for i in range(2):
					var slimeInstance= slime.instantiate()
					slimeInstance.bebe=true
					slimeInstance.scale=Vector2(3,3)
					slimeInstance.vidas=1
					slimeInstance.estado=State.DAMAGED
					slimeInstance.iniciadoCombate=true
					call_deferred('crear',slimeInstance,i)
				call_deferred('destruir')
			if bebe:
				call_deferred('destruir')
					
		cambiarEstado(State.DAMAGED)

func destruir():
	self.add_child(explosion.instantiate())
	$AnimatedSprite2D.hide()
	$GPUParticles2D.hide()
	$CollisionShape2D.disabled=true
	await get_tree().create_timer(2.0).timeout
	Global.tempValue=Global.tempValue+1
	self.queue_free()
	
func crear(slimeInstance,number):
	if number ==1:
		slimeInstance.global_position = self.global_position+Vector2(25,0)
		slimeInstance.velocity= Vector2(500,0)
	else:
		slimeInstance.global_position = self.global_position+Vector2(-25,0)
		slimeInstance.velocity= Vector2(-500,0)
	self.get_parent().add_child(slimeInstance)
func cambiarEstado(nuevoEstado):
	$Timer.stop()
	match estado:
		State.CARGANDO:
			pass
		State.MOVING:
			pass
	match nuevoEstado:
		State.DAMAGED:
			$AnimatedSprite2D.animation="damaged"
			$AnimatedSprite2D.play()
			$hitParticles.rotation = get_angle_to(player.position)+PI
			$hitParticles.emitting=true
			self.velocity=(self.global_position-player.global_position).normalized()*3000
			$AnimationPlayer.play("hit")
			$Timer.wait_time=randf_range(0.4,0.7)
			cambiarColor(Color.WHITE,$Timer.wait_time)
			$Timer.start()
		State.CARGANDO:
			$AnimatedSprite2D.animation="idle"
			$Timer.wait_time=randf_range(1.7,2.5)
			self.velocity=Vector2(0,0)
			cambiarColor(Color.RED,$Timer.wait_time)
			$Timer.start()
		State.MOVING:
			$AnimationPlayer.play("moving")
			$AnimatedSprite2D.animation="moving"
			$Timer.wait_time=2
			$Timer.start()
			self.velocity=(player.global_position-self.global_position).normalized()*3000
		State.IDLE:
			$AnimatedSprite2D.animation="idle"
			$Timer.wait_time=0.5
			$Timer.start()
			self.velocity=Vector2(0,0)
			cambiarColor(Color.WHITE,0.5)
			

	estado=nuevoEstado


func cambiarColor(color,tiempo):
	if tween:
		tween.stop()
	tween=get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", color, tiempo)
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation=="damaged":
		$AnimatedSprite2D.animation="idle"
		$AnimatedSprite2D.play()


func _on_timer_timeout():
	match estado:
		State.DAMAGED:
			cambiarEstado(State.CARGANDO)
		State.MOVING:
			cambiarEstado(State.IDLE)
		State.IDLE:
			cambiarEstado(State.CARGANDO)
		State.CARGANDO:
			cambiarEstado(State.MOVING)
