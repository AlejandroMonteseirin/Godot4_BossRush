extends Node2D


@export var status=false


func _ready():
	if status:
		activate()
	
func activate():
	$GPUParticles2D3.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D.emitting = true
	
	
func deactivate():
	$GPUParticles2D3.emitting = false
	$GPUParticles2D2.emitting = false
	$GPUParticles2D.emitting = false
