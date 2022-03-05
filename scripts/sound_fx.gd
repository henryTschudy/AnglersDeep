extends AudioStreamPlayer
onready var default_sound = load("res://sound/sound_fx/water_splesh.wav")
var new_stream_player = AudioStreamPlayer.new()

func play_sound(sound_name):
	#create new stream player and add it to the scene
	var new_stream_player = AudioStreamPlayer.new()
	add_child(new_stream_player)
	
	#set sound_to_play to default sound in case sound_name isn't correlated with a path
	var sound_to_play = default_sound
	
	#set sound_to_play to the desired sound effect
	match sound_name:
		"splash1":
			sound_to_play = load("res://sound/sound_fx/water_splesh.wav")
	
	new_stream_player.stream = sound_to_play
	new_stream_player.bus = "SoundFx"
	print(new_stream_player.bus)
	new_stream_player.play(0.0)
	
	#delete node once the sample finishes playing
	yield(new_stream_player, "finished")
	new_stream_player.queue_free()
