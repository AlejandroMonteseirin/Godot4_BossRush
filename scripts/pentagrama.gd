extends Sprite2D

var activada=0
func activar():
	activada=activada+1
	if(activada==1):
		var tween:Tween = create_tween()
		tween.tween_property(self, "modulate", Color(0,0,0.8,1),15)
		tween.play()
	if activada==5:
		var tween:Tween = create_tween()
		tween.tween_property(self, "modulate", Color(1,0,0,1),15)
		tween.play()
