extends CanvasLayer

var texturaVidaEntera = preload("res://assets/hud/hud_heartFull.png")
var texturaVidaMedia = preload("res://assets/hud/hud_heartHalf.png")
var texturaVidaVacia = preload("res://assets/hud/hud_heartEmpty.png")

func updateVidas(variacion):
	Global.vidas = Global.vidas + variacion
	print(Global.vidas)
	for i in range(1, 4):  # Suponiendo que tienes un máximo de 3 vidas
		var textura = texturaVidaVacia
		if i <= Global.vidas:
			textura = texturaVidaEntera
		elif i-0.5 == Global.vidas:
			textura = texturaVidaMedia
		var corazon = get_node("MarginContainer/Hud/"+ str(i)) 
		corazon.texture = textura


func _on_accept_dialog_confirmed():
	get_node("/root/odin").reiniciarNivel()
