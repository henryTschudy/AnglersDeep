extends Node2D

func _ready():
	var master_volume_slider = get_node("master")
	var music_volume_slider = get_node("music")
	var sound_fx_volume_slider = get_node("sound_fx")
	
	#load existing volume values into sliders, need to add feature to load values from save data
	master_volume_slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_volume_slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sound_fx_volume_slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound_fx")))
	
func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))
	
func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))

func _on_sound_fx_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundFx"), linear2db(value))
