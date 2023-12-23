class_name AudioManager

extends Node

#@export var global_volume : float = 0.0
var sounds = []
var music = []

func _ready():
	for child_node in get_children():
		if child_node.get_name().find("Sfx") > -1:
			sounds.append(child_node)
			#child_node.set_volume_db(global_volume)
		elif child_node.get_name().find("Music") > -1:
			music.append(child_node)
			#child_node.set_volume_db(global_volume)

func play_sound(name: String):
	for sound_node in sounds:
		if sound_node.get_name() == name:
			var sound = sound_node
			if sound.is_playing():
				sound.stop()  # Stop the sound if it's already playing
			sound.play()
			return  # Exit the loop once the sound is found and played
	print("Sound", name, "not found in the list of sounds.")

func play_music(name: String):
	for music_node in music:
		if music_node.get_name() == name:
			var sound = music_node
			if sound.is_playing():
				sound.stop()  # Stop the music if it's already playing
			sound.play()
			return  # Exit the loop once the sound is found and played
	print("Sound", name, "not found in the list of music.")
