extends Node2D

@export var nivel0:PackedScene
@export var nivel1:PackedScene
@export var nivel2:PackedScene



var nivelActual
# Called when the node enters the scene tree for the first time.
func _ready():
	inicializarNivel(nivel1)
	nivelActual=nivel1

func reiniciarNivel():
	inicializarNivel(nivelActual)
	$player.reiniciar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func inicializarNivel(infoNivel):
	var hijos=self.get_children()
	for i in hijos:
		if i.name != 'player' and i.name!= 'HUD' and i.name != 'audio':
			self.remove_child(i)
	var lvl= infoNivel.instantiate()
	musica(0)
	$player.global_position=Vector2(lvl.infoNivel.posicion[0],lvl.infoNivel.posicion[1])
	self.add_child(lvl)


	
var musicRelax :AudioStream  = load("res://music/Popcorn - Loading Theme - Steven O'Brien (Must Credit, CC-BY, www.steven-obrien.net).mp3")
var musicTensa :AudioStream = load("res://music/Popcorn - Main Loop - Steven O'Brien (Must Credit, CC-BY, www.steven-obrien.net).mp3")
var musicas=[musicRelax,musicTensa]
func musica(track):
	Audio.stop()
	Audio.stream=musicas[track]
	Audio.play()
