extends Area2D



func _on_body_entered(body):
	if 'player' in body.name:
		$"../fire1".activate()
		$"../fire2".activate()
		queue_free()
