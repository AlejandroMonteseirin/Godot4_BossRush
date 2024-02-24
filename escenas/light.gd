extends PointLight2D

var subiendo=true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if subiendo:
		self.energy = self.energy+15*delta
		if self.energy>=16:
			subiendo=false
	else:
		self.energy = self.energy-15*delta
		if self.energy<=0:
			subiendo=true
