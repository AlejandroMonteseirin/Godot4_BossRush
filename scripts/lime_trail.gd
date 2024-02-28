extends Line2D



@export var MAX_LENGTH : int
var generandoPuntos=false

func estadoTrail(estado):
	generandoPuntos=estado

func _process(_delta):
	if generandoPuntos:
		add_point(get_parent().global_position)
	if points.size() > MAX_LENGTH or not generandoPuntos:
		if(points.size() >0):
			remove_point(0)


 
 
