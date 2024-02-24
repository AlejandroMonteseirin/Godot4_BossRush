extends Camera2D

# Parámetros de agitación de la cámara
var shake_duration = 0.5  # Duración de la agitación en segundos
var shake_intensity = 10.0  # Intensidad de la agitación

# Variables internas
var shake_timer = 0.0


var zoomInProperty=false
var zoomResetProperty=false

var offsetReset=false


func _ready():
	randomize()


func shake_camera(tiempo,intensidad):
	offsetReset=false
	shake_timer = tiempo
	shake_intensity = intensidad
	
func _process(delta):
	if shake_timer > 0:
		# Agitar la cámara mientras el temporizador esté activo
		offset = Vector2(randf(), randf()) * shake_intensity
		shake_timer -= delta
		print("shaking")
		
	if (offset.x!=0 or offset.y!=0) and shake_timer<=0:
		lerp(offset.x,0.0,delta*3)
		lerp(offset.y,0.0,delta*3)

	
	if zoomInProperty:
		if zoom.x>0.4:
			zoom=zoom-Vector2(0.3,0.3)*delta
		else:
			zoomInProperty=false
			
	if zoomResetProperty:
		lerp(zoom.x,0.5,delta*3)
		lerp(zoom.y,0.5,delta*3)
		if zoom.x==0.5 and zoom.y==0.5:
			zoomResetProperty=false
			

func zoomIn():
	zoomInProperty=true
	
	
func zoomReset():
	zoomInProperty=false
	zoomResetProperty=true
	
