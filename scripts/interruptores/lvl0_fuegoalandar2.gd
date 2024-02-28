extends Area2D



func _on_body_entered(body):
	if 'player' in body.name:
		$"../fire3".activate()
		$"../fire4".activate()
		Audio.play_sound(preload("res://audio/otros/248116__robinhood76__05224-fireball-whoosh.wav"))
		queue_free()
