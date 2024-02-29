extends AudioStreamPlayer


func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.volume_db=(Global.effectVolume / 100) * 80 - 40
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()
	return instance
	
	
	
func remove_node (instance: AudioStreamPlayer):
	instance.queue_free()

func stop_sound(instance):
	remove_child(instance)
