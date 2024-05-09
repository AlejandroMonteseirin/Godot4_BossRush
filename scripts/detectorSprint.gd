extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var playerIn=null

func _on_body_entered(body):
	if 'player' in body.name and body.ESTADO != Global.State.STATE_DASH:
		playerIn=body
		self._on_timer_timeout()





func _on_body_exited(body):
	if 'player' in body.name and playerIn!=null:
		playerIn=null


func _on_timer_timeout():
	if playerIn != null:
		playerIn.tocado(-1)
		$Timer.start(1)
	else:
		$Timer.stop()
