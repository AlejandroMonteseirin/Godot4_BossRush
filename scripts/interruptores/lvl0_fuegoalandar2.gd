extends Area2D



func _on_body_entered(body):
	if 'player' in body.name:
		$"../fire3".activate()
		$"../fire4".activate()
		queue_free()
