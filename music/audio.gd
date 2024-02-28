extends AudioStreamPlayer


func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.volume_db=(Global.effectVolume / 100) * 80 - 40
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()
	
	
	
func remove_node (instance: AudioStreamPlayer):
	instance.queue_free()
