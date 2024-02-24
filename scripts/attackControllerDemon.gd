extends Node2D

var rotacion=1
var nodos
# Called when the node enters the scene tree for the first time.
func _ready():
	nodos= $particles.get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rotate(rotacion*delta)
	
func ataca():
	var tween = create_tween().set_parallel(true)
	tween.tween_property($particles, "scale",Vector2(1,1),1.0)
	tween.tween_property($impenetrable/colision, "scale",Vector2(1,1),1.0)
	tween.play()
	rotacion=rotacion*-1
	
	for child in nodos:
		for child2 in child.get_children():
			child2.emitting=true
	call_deferred("enableColisionFire")

func dejaAtacar():
	var tween = create_tween().set_parallel(true)
	tween.tween_property($particles, "scale",Vector2(0,0),1.0)
	tween.tween_property($impenetrable/colision, "scale",Vector2(0,0),1.0)
	tween.play()
	
	for child in nodos:
		for child2 in child.get_children():
			child2.emitting=false
	call_deferred("disableColisionFire")

func enableColisionFire():
	$impenetrable/colision.disabled=false
func disableColisionFire():
	$impenetrable/colision.disabled=true
